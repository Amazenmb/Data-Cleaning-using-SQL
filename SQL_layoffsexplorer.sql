-- Data Cleaning
USE world_layoffs;
Select * 
From layoffs;

-- Steps
-- 1. Remove Duplicates
-- 2. Standardize Data
-- 3. Null Values or Blank values
-- 4. Remove Any Columns


-- Creating a copy table to work on
CREATE TABLE layoffs_staging
LIKE layoffs;

SELECT * 
FROM layoffs_staging;

INSERT layoffs_staging
SELECT *
FROM layoffs;


-- Removing duplicates
WITH duplicate_cte AS
(SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions)
AS ROW_NUM
FROM layoffs_staging
)
SELECT *
FROM duplicate_cte
WHERE ROW_NUM >1;


CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `ROW_NUM` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


SELECT * 
FROM layoffs_staging2;

INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions)
AS ROW_NUM
FROM layoffs;

-- Deleting duplicates
DELETE 
FROM layoffs_staging2
WHERE ROW_NUM>1;

-- Verifying duplicates
SELECT * 
FROM layoffs_staging2
WHERE ROW_NUM>1;

-- Standardizing data

SELECT DISTINCT(TRIM(company))
FROM layoffs_staging2;

-- Removed white spaces from left

UPDATE layoffs_staging2
SET company=TRIM(company);

-- updating industries
SELECT DISTINCT(industry)
FROm layoffs_staging2
Order by 1;

-- for crypto
UPDATE layoffs_staging2
SET industry='Crypto'
WHERE industry LIKE 'Crypto%';

-- for country
SELECT DISTINCT(country)
FROM layoffs_staging2
ORDER BY 1;

UPDATE layoffs_staging2
SET country='United States'
WHERE country LIKE 'United States%';

-- for date
UPDATE layoffs_staging2
SET `date`=STR_TO_DATE(`date`,'%m/%d/%Y');

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

-- for industry update where NULL
UPDATE layoffs_staging2
SET industry = NULL
WHERE industry ='';

UPDATE layoffs_staging2 t1
JOIN layoffs_Staging2 t2
ON t1.company=t2.company
SET t1.industry=t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL; 

SELECT company,industry
FROM layoffs_staging2
WHERE industry IS NULL;

DELETE 
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- Drop Row Num
ALTER TABLE layoffs_staging2
DROP COLUMN ROW_NUM;

