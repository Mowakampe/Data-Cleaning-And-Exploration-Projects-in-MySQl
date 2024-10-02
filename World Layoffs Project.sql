-- Data Cleaning

SELECT * FROM layoffs;
-- 1. Remove Duplicates
-- 2. Standardize the Data
-- 3. Populating Null values or blank values
-- 4. Remove Any irrelevant columns

#The following columns are the relevant columns for the analysis.
-- company, location, industry, date, country.

CREATE TABLE layoffs_staging -- this is a backup table which should be worked upon instead of the raw data.
LIKE layoffs;

SELECT * FROM layoffs_staging;

INSERT layoffs_staging
SELECT * FROM layoffs;

-- 1. Removing duplicates.

SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, 'date', stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging;

WITH duplicate_cte AS
(SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, 'date', stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging
)
SELECT * FROM duplicate_cte
WHERE row_num > 1;

SELECT * 
FROM layoffs_staging
WHERE company = 'Casper';

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
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, 'date', stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging;

SELECT * 
FROM layoffs_staging2
WHERE row_num > 1;

DELETE -- This will delete the duplicates in the rows
FROM layoffs_staging2
WHERE row_num > 1;

SELECT * 
FROM layoffs_staging2
WHERE row_num > 1;

SELECT * FROM layoffs_staging2;

-- 2. Standardizing Data; This simply means finding issues in your data and fixing it.

SELECT company FROM layoffs_staging2;

SELECT DISTINCT(company) 
FROM layoffs_staging2;

SELECT DISTINCT(TRIM(company))
FROM layoffs_staging2;

SELECT company, TRIM(company)
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company = TRIM(company);

SELECT company, TRIM(company)
FROM layoffs_staging2;

SELECT industry FROM layoffs_staging2;

SELECT DISTINCT(industry) 
FROM layoffs_staging2;

SELECT DISTINCT(industry) 
FROM layoffs_staging2
ORDER BY 1;

SELECT *
FROM layoffs_staging2
WHERE industry LIKE '%Crypto%';

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE '%Crypto%';

SELECT DISTINCT(industry) 
FROM layoffs_staging2;

SELECT DISTINCT(TRIM(industry))
FROM layoffs_staging2;

SELECT industry, TRIM(industry)
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET industry = TRIM(industry);

SELECT DISTINCT location
FROM layoffs_staging2
ORDER BY 1;

SELECT DISTINCT country
FROM layoffs_staging2
ORDER BY 1;

SELECT *
FROM layoffs_staging2
WHERE country LIKE '%United%';

UPDATE layoffs_staging2
SET country = 'United States'
WHERE country LIKE '%United States%';

SELECT DISTINCT country
FROM layoffs_staging2
ORDER BY 1;

SELECT country
FROM layoffs_staging2
ORDER BY 1;

SELECT `date`, -- syntax: we want to change this to its proper format -- day/month/year
STR_TO_DATE(`date`, '%m/%d/%Y') AS correct_date
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

SELECT `date` FROM layoffs_staging2;

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

SELECT  * FROM layoffs_staging2;

-- 3. POPULATING OR FILLING NULLS AND BLANK VALUES.

SELECT  * 
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

UPDATE layoffs_staging2
SET industry = null
WHERE industry = '';

SELECT *
FROM layoffs_staging2
WHERE industry IS NULL
OR industry = '';

SELECT *
FROM layoffs_staging2
WHERE company = 'Airbnb';

SELECT t1.industry, t2.industry -- syntax to check if there are non_blank values and update the blank values with the non_blank vlaues
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;

UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE (t1.industry IS NULL)
AND t2.industry IS NOT NULL;

SELECT *
FROM layoffs_staging2
WHERE company like '%Bally%'; -- to check if that's the only column for bally. if there was another column
-- that had its industry specified, we would use it to populate this one. but since there's no other column,
-- there's nothing that can be done.

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

DELETE
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL; -- Why are we deleting? we are deleting this because we can't trust the data
-- and it's useless.

SELECT * FROM layoffs_staging2;

ALTER TABLE layoffs_staging2 -- syntax to drop a column.
DROP COLUMN row_num;