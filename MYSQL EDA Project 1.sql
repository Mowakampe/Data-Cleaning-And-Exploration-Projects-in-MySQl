# EXPLORATORY DATA ANALYSIS
# we are basically going to be using the total_laid_off, the percentage_laid_off and the funds_raised_millions to analyze trends.

SELECT * FROM layoffs_staging2;

SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;

SELECT * 
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC;

SELECT * 
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

-- 1. The following is an exploratory data analysis on total_laid_off.

SELECT company, SUM(total_laid_off) -- syntax to check what company got hit the most during this layoffs
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC; -- 1 here means order by company in DESC order. 2 means order by SUM(total_laid_off) in DESC order.

SELECT MIN(`date`), MAX(`date`) -- we're checking the date ranges for the layoffs. The layoffs took place during the COVID.
FROM layoffs_staging2;

SELECT industry, SUM(total_laid_off) -- syntax to check what industry got hit the most during this layoffs
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;

SELECT * FROM layoffs_staging;

SELECT country, SUM(total_laid_off) -- syntax to check what industry got hit the most during this layoffs
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

SELECT company, location, industry, `date`, country, SUM(total_laid_off) 
FROM layoffs_staging2
GROUP BY company, location, industry, `date`, country
ORDER BY 5 ;

SELECT YEAR(date), SUM(total_laid_off) 
FROM layoffs_staging2
GROUP BY YEAR(date)
ORDER BY 1 DESC;

SELECT stage, SUM(total_laid_off) 
FROM layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC;

-- 2. The following is an exploratory data analysis on percentage_laid_off.

SELECT company, SUM(percentage_laid_off) -- 
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

-- According to Alex Freeberg, doing an exploratory analysis on percentage_laid_off is not necessary.

-- rolling sum of layoffs

SELECT SUBSTRING(`date`, 1, 7) AS `MONTH`, SUM(total_laid_off) -- syntax to find the year and month
FROM layoffs_staging2
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC;

SELECT * FROM layoffs_staging2;

WITH rolling_total AS -- we created a cte to find the total_laid_off per month and its rolling total.
(SELECT SUBSTRING(`date`, 1, 7) AS `MONTH`, SUM(total_laid_off) AS total_off 
FROM layoffs_staging2
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC
)
SELECT `MONTH`, total_off, SUM(total_off) OVER(ORDER BY `MONTH`) AS rolling_total
FROM Rolling_total;

SELECT company, SUM(total_laid_off) 
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

SELECT company, YEAR(`date`), SUM(total_laid_off) 
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY company;

SELECT company, YEAR(`date`), SUM(total_laid_off) -- We want to see the year with the highest laid_off
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC;

# We want to show the year with the highest number of layoffs
