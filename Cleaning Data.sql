# World Layoffs Data Cleaning | SQL Project
## Project Overview
This project focuses on cleaning and preparing global layoffs data using MySQL.
The goal is to improve data quality by identifying duplicate records, standardizing inconsistent values, investigating missing data, and preparing a clean dataset for further analysis.

## Dataset

- Source: [World Layoffs Dataset — Kaggle](https://www.kaggle.com/datasets/swaptr/layoffs-2022)
- Database: MySQL
- Project Type: Data Cleaning
- Language: SQL

## Project Workflow

### 1. Data Staging
Created staging tables to preserve the original dataset and perform cleaning operations on copies.
### 2. Duplicate Detection
Used `ROW_NUMBER()` and `PARTITION BY` to identify duplicate records.
### 3. Data Standardization
Applied `TRIM()` to remove unnecessary spaces and standardized industry names where appropriate.
### 4. Missing Values
Investigated NULL values and identified records with missing layoff information.
### 5. Data Validation
Checked the cleaned dataset and compared row counts before and after cleaning.

USE world_layoffs;

SELECT *
FROM layoffs;

SELECT COUNT(*) AS original_row_count
FROM layoffs;

-- STEP 2: CREATE STAGING TABLES
-- Preserve the original dataset

DROP TABLE IF EXISTS layoffs_staging;
DROP TABLE IF EXISTS layoffs_staging2;

CREATE TABLE layoffs_staging LIKE layoffs;

INSERT INTO layoffs_staging
SELECT *
FROM layoffs;

SELECT COUNT(*) AS staging_row_count
FROM layoffs_staging;

-- STEP 3: IDENTIFY DUPLICATES

SELECT
    company,
    location,
    industry,
    total_laid_off,
    percentage_laid_off,
    `date`,
    stage,
    country,
    funds_raised_millions,
    COUNT(*) AS duplicate_count
FROM layoffs_staging
GROUP BY
    company,
    location,
    industry,
    total_laid_off,
    percentage_laid_off,
    `date`,
    stage,
    country,
    funds_raised_millions
HAVING COUNT(*) > 1;

-- STEP 4: CREATE ROW NUMBERS

CREATE TABLE layoffs_staging2 AS
SELECT
    company,
    location,
    industry,
    total_laid_off,
    percentage_laid_off,
    `date`,
    stage,
    country,
    funds_raised_millions,
    ROW_NUMBER() OVER (
        PARTITION BY
            company,
            location,
            industry,
            total_laid_off,
            percentage_laid_off,
            `date`,
            stage,
            country,
            funds_raised_millions
        ORDER BY company
    ) AS row_num
FROM layoffs_staging;

-- Review duplicate records before deletion

SELECT *
FROM layoffs_staging2
WHERE row_num > 1;

-- STEP 5: REMOVE DUPLICATES

DELETE FROM layoffs_staging2
WHERE row_num > 1;

-- Verify duplicate removal

SELECT *
FROM layoffs_staging2
WHERE row_num > 1;

-- Remove the helper column

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;

-- STEP 6: STANDARDIZE TEXT DATA


UPDATE layoffs_staging2
SET company = TRIM(company);

UPDATE layoffs_staging2
SET location = TRIM(location);

UPDATE layoffs_staging2
SET industry = TRIM(industry);

UPDATE layoffs_staging2
SET country = TRIM(country);

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

-- Review industry values

SELECT DISTINCT industry
FROM layoffs_staging2
ORDER BY industry;


-- Review country values

SELECT DISTINCT country
FROM layoffs_staging2
ORDER BY country;


-- STEP 7: INVESTIGATE NULL VALUES

SELECT *
FROM layoffs_staging2
WHERE company IS NULL
   OR industry IS NULL
   OR total_laid_off IS NULL
   OR percentage_laid_off IS NULL;

SELECT *
FROM layoffs_staging2
WHERE industry IS NULL
   OR TRIM(industry) = '';

-- Check rows missing both layoff measures

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
  AND percentage_laid_off IS NULL;

-- STEP 8: HANDLE MISSING INDUSTRY VALUES

UPDATE layoffs_staging2 AS t1
JOIN layoffs_staging2 AS t2
    ON t1.company = t2.company
   AND t1.location = t2.location
SET t1.industry = t2.industry
WHERE (t1.industry IS NULL OR TRIM(t1.industry) = '')
  AND t2.industry IS NOT NULL
  AND TRIM(t2.industry) <> '';

-- Verify remaining missing industry values

SELECT *
FROM layoffs_staging2
WHERE industry IS NULL
   OR TRIM(industry) = '';

-- STEP 9: REVIEW DATE VALUES
-- Check the existing data type before conversion

DESCRIBE layoffs_staging2;

SELECT `date`
FROM layoffs_staging2
LIMIT 20;

-- STEP 10: REVIEW RECORDS WITH NO LAYOFF INFORMATION

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
  AND percentage_laid_off IS NULL;

-- STEP 11: FINAL DATA VALIDATION

SELECT *
FROM layoffs_staging2;


-- Count cleaned records

SELECT COUNT(*) AS cleaned_row_count
FROM layoffs_staging2;

SELECT
    company,
    location,
    industry,
    total_laid_off,
    percentage_laid_off,
    `date`,
    stage,
    country,
    funds_raised_millions,
    COUNT(*) AS duplicate_count
FROM layoffs_staging2
GROUP BY
    company,
    location,
    industry,
    total_laid_off,
    percentage_laid_off,
    `date`,
    stage,
    country,
    funds_raised_millions
HAVING COUNT(*) > 1;




