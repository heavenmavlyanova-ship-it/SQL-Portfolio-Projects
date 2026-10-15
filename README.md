# SQL-Portfolio-Projects

# World Layoffs Data Cleaning | SQL Project

## Project Overview

This project focuses on cleaning and preparing global layoffs data using MySQL.

The objective is to improve data quality by identifying duplicate records, standardizing inconsistent values, investigating missing data, and preparing a clean dataset for further analysis.

## Dataset

- **Source:** [World Layoffs Dataset — Kaggle](https://www.kaggle.com/datasets/swaptr/layoffs-2022)
- **Raw Data File:** `layoffs.csv`
- **Database:** MySQL
- **Language:** SQL
- **Project Type:** Data Cleaning

## Tools & Skills

- MySQL
- SQL Data Cleaning
- Duplicate Detection
- Window Functions (`ROW_NUMBER`)
- Data Standardization
- NULL Value Investigation
- Data Validation
- Staging Tables

## Project Workflow

### 1. Data Staging
Created staging tables to preserve the original data and perform cleaning operations separately.

### 2. Duplicate Detection
Used `ROW_NUMBER()` and `PARTITION BY` to identify duplicate records.

### 3. Data Standardization
Used `TRIM()` to remove unnecessary spaces and standardized industry names where appropriate.

### 4. Missing Values
Investigated missing values and checked records with incomplete layoff information.

### 5. Data Validation
Checked the cleaned dataset and compared row counts before and after cleaning.

## Repository Structure

```text
world-layoffs-data-cleaning/
├── README.md
├── layoffs.csv
└── data_cleaning.sql
```

## Key SQL Techniques

- `CREATE TABLE`
- `INSERT INTO ... SELECT`
- `GROUP BY` and `HAVING`
- `ROW_NUMBER()`
- `PARTITION BY`
- `UPDATE`
- `DELETE`
- `TRIM()`
- `IS NULL`

## How to Run

1. Download `layoffs.csv` from Kaggle.
2. Create a MySQL database named `world_layoffs`.
3. Import `layoffs.csv` into a table named `layoffs`.
4. Open `data_cleaning.sql` in MySQL Workbench.
5. Execute the SQL script.
6. Review the cleaned dataset and validate the results.

## Key Learning Outcomes

- Practiced SQL data cleaning on a real-world dataset.
- Identified duplicate records using window functions.
- Standardized text values and investigated missing data.
- Preserved the original dataset by using staging tables.

## Author

Aspiring Data Analyst

## Data Source

[Kaggle — World Layoffs Dataset](https://www.kaggle.com/datasets/swaptr/layoffs-2022)
