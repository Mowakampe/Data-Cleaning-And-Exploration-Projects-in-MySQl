-- Real World Fake Data 
-- Call Center Cleaning and EDA Project.

-- 1. Downloaded the dataset
-- 2. created a database called real_world_fake_data
CREATE DATABASE real_world_fake_data;
-- 3.Created a table called call_center_db to contain the csv file i want to import

CREATE TABLE call_center_db(
id CHAR(50), 
customer_name CHAR(20), 
sentiment CHAR(20), 
csat_score INT, 
call_timestamp CHAR(20), 
reason CHAR(20), 
city CHAR(20), 
state CHAR(20), 
`channel` CHAR(20), 
response_time CHAR(20), 
`call duration in minutes` INT, 
call_center CHAR(20)
);

-- 4. Loaded the dataset into call_center_db using the Table Data Import Wizard
SELECT * FROM call_center_db; -- 23665 rows returned

-- 5. identify duplicate records
SELECT id, customer_name, sentiment, csat_score, call_timestamp, reason, 
city, state, `channel`, response_time, `call duration in minutes`, call_center,
COUNT(*)
FROM call_center_db
GROUP BY id, customer_name, sentiment, csat_score, call_timestamp, reason, 
city, state, `channel`, response_time, `call duration in minutes`, call_center
HAVING COUNT(*) > 1; -- There are no duplicate records

-- 6. Next, i fix the call timestamp format to date.
UPDATE call_center_db SET call_timestamp 
= str_to_date(call_timestamp, "%m/%d/%Y"); -- there you go, done.

-- 7. Let's fix the csat_score column that has blank values
UPDATE call_center_db SET csat_score 
= nullif(csat_score, ""); -- Done. 14835 rows affected.

-- Exploratory Data Analysis on Call Center Data.
-- 1. How many columns and row do we have in our datasets.
SELECT COUNT(*) AS row_num from call_center_db; -- 23665 rows of data
SELECT COUNT(*) AS cols_num FROM information_schema.columns 
WHERE table_name = 'call_center_db';-- 12 columns returned.

-- 2. Let's select the distinct values
SELECT DISTINCT sentiment FROM call_center_db; 
-- 5 kinds of sentiments received from people.
SELECT AVG(DISTINCT csat_score) FROM call_center_db; 
-- 5.5, This means customers are satisfied averagely.
SELECT sentiment, AVG(DISTINCT csat_score) FROM call_center_db
GROUP BY sentiment
ORDER BY AVG(DISTINCT csat_score); 
-- They have neutral feelings towards the call center
SELECT DISTINCT call_timestamp FROM call_center_db; 
SELECT DISTINCT reason FROM call_center_db;
-- People were calling for three major reasons, Billing question, Service outage and Payments
SELECT DISTINCT city FROM call_center_db; -- 461 cities
SELECT DISTINCT state FROM call_center_db; -- 51 States
SELECT DISTINCT `channel`FROM call_center_db;
/*There are four major channels of communication in the call center.
call-center, chatbot, Email, Web.*/
SELECT DISTINCT response_time FROM call_center_db;
SELECT DISTINCT `call duration in minutes`FROM call_center_db;

SELECT DISTINCT call_center FROM call_center_db; -- there are four major call_centers

-- 3. Let's find the count and percentage from total of each of the distinct values we got.
SELECT sentiment, COUNT(*), ROUND((COUNT(*) / 
(SELECT COUNT(*) FROM call_center_db)) * 100,1) AS pct 
FROM call_center_db
GROUP BY 1
ORDER BY 3 DESC; 
/*So, according to this result, 
- About 33% of the customers 
had negative feelings towards the call center.
- 27% of the people had neutral feelings towards the call center
- and only 9.7% of the people with a number of 2304 had very positive feelings.
*/

SELECT csat_score, COUNT(*), ROUND((COUNT(*) / 
(SELECT COUNT(*) FROM call_center_db)) * 100,1) AS pct 
FROM call_center_db
GROUP BY 1
ORDER BY 3 DESC; 
/*A larger percentage of the people being 62.7% didn't give their csat_score.
And only 1.7% of the customers being 407 and 402 people has a csat_score of 10 
and 1 respectively.*/

SELECT AVG(csat_score) FROM call_center_db; -- The average csat_score is 5.5

SELECT reason, COUNT(*), ROUND((COUNT(*) / 
(SELECT COUNT(*) FROM call_center_db)) * 100,1) AS pct 
FROM call_center_db
GROUP BY 1
ORDER BY 3 DESC; 
/* 71% of the people were calling to make enquiries about the billing of calls.
This makes the Billing Question the highest reason they were calling.*/
SELECT city, COUNT(*), ROUND((COUNT(*) / 
(SELECT COUNT(*) FROM call_center_db)) * 100,1) AS pct 
FROM call_center_db
GROUP BY 1
ORDER BY 3 DESC; -- 3.55 of the people being the highest were calling from Washington DC.

SELECT state, COUNT(*), ROUND((COUNT(*) / 
(SELECT COUNT(*) FROM call_center_db)) * 100,1) AS pct 
FROM call_center_db
GROUP BY 1
ORDER BY 3 DESC; --  11.1% of the people being the highest were calling from California 

SELECT channel, COUNT(*), ROUND((COUNT(*) / 
(SELECT COUNT(*) FROM call_center_db)) * 100,1) AS pct 
FROM call_center_db
GROUP BY 1
ORDER BY 3 DESC; 
/* The call-center is the most used channel customers use to reach out.
people also used the chatbot and Email but the website was the least used channel*/

SELECT response_time, COUNT(*), ROUND((COUNT(*) / 
(SELECT COUNT(*) FROM call_center_db)) * 100,1) AS pct 
FROM call_center_db
GROUP BY 1
ORDER BY 3 DESC; /*This means that about 62.6% of customer's issues or enquiries 
were answered within the stipulated time as per service level agreement.*/

SELECT `call duration in minutes`, COUNT(*), ROUND((COUNT(*) / 
(SELECT COUNT(*) FROM call_center_db)) * 100,1) AS pct 
FROM call_center_db
GROUP BY 1
ORDER BY 3 DESC; /*About 2.7% of the call duration were 29 minutes long and for what reason?
Most probably the Billing Question. Let's find out.*/ 

SELECT `call_center`, COUNT(*), ROUND((COUNT(*) / 
(SELECT COUNT(*) FROM call_center_db)) * 100,1) AS pct 
FROM call_center_db
GROUP BY 1
ORDER BY 3 DESC;
-- 41.9 % of the people called the Los Angeles/CA center as the most called center in the US.

-- But Generally, which day had the most calls?
SELECT DAYNAME(call_timestamp) AS Day_of_call, COUNT(*) AS num_of_calls
FROM call_center_db
GROUP BY 1
ORDER BY 2; -- Sunday with a number of 3085 calls with Thursday being the least day of calls.

-- 4. Aggregations
 SELECT MIN(csat_score) min_csat_score, MAX(csat_score) max_csat_score, 
 ROUND(AVG(csat_score), 0) avg_csat_score
 FROM call_center_db
 WHERE csat_score IS NOT NULL;
 /*The maximum, minimum and the average csat_score is 9,1, and 6 respectively.*/
 
 SELECT MIN(`call duration in minutes`) max_call_duration, 
 MAX(`call duration in minutes`) min_call_duration, 
 ROUND(AVG(`call duration in minutes`), 0) avg_call_duration
 FROM call_center_db;
 /*The maximum, minimum and the average call duration in minutes is 
 45,5, and 25 respectively.*/
 
 SELECT MIN(call_timestamp) `earliest dates`, MAX(call_timestamp) most_recent_time
 FROM call_center_db;
 
 SELECT call_center, response_time, COUNT(*) count
 FROM call_center_db
 GROUP BY 1,2
 ORDER BY 1,2,3;
 
 SELECT call_center, ROUND(AVG(`call duration in minutes`),0)
 FROM call_center_db
 GROUP BY 1
 ORDER BY 2; -- Average call duration for each call center is 25 minutes.
 
 SELECT reason, ROUND(AVG(`call duration in minutes`),0)
 FROM call_center_db
 GROUP BY 1
 ORDER BY 2; -- Average call duration for each reason is 25 minutes.
 
 SELECT state, COUNT(*) FROM call_center_db
 GROUP BY 1
 ORDER BY 2 desc; -- California had the highest reason for calling
 -- Vertmont had the lowest reason for calling
 
 SELECT state, reason, COUNT(*) FROM call_center_db
 GROUP BY 1,2
 ORDER BY 1,2,3 desc;
 
 SELECT state, sentiment, COUNT(*) FROM call_center_db
 GROUP BY 1,2
 ORDER BY 1,2,3 desc;
 
 SELECT state, AVG(csat_score) avg_csat_score FROM call_center_db
 WHERE csat_score IS NOT NULL
 GROUP BY 1
 ORDER BY 2 desc; -- Maine had the lowest average csat_score and North_Dakota had the highest
 
 SELECT sentiment, AVG(`call duration in minutes`) avg_call_duration
 FROM call_center_db
 GROUP BY 1
 ORDER BY 2 DESC; /*The highest average call duration by 
 sentiment is 25.3 with a negative feeling*/
 
SELECT call_timestamp, MAX(`call duration in minutes`)
OVER(PARTITION BY call_timestamp) AS max_call_duration
FROM call_center_db
GROUP BY 1
ORDER BY 1,2 DESC;
 
 

