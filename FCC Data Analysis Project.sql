-- Data Analysis on Financial Consumer Complaints Dataset
-- Displaying 17 columns, 75,513 rows in table

-- Defining these column names
/*Complaint_ID: A unique identifier assigned to each individual's complaint 

Date_Submitted: The date on which the complaint was officially submitted or lodged by the customer

Product: The financial product or service being complained about.

Sub-product: This narrows down the complaint to a particular aspect or type of a financial product.

Issue: The primary problem or concern raised by the customer regarding the financial product

Sub-issue: It specifies the exact aspect of the issue that the customer is concerned about.

Company public response: The official statement or reply that the company has made publicly available regarding the complaint.

Company: The financial institution that is the subject of the complaint

State: The U.S State or territory where the customer who lodged the complaint resides.

ZIP code:Postal code associated with the customer's address.

Tags: Labels assigned to a complaint to highlight specific charactersitics or categories of the issue.

Consumer consent provided: This indicates whether the consumer(the person filing the complaint)has given
permission for their complaint narrative or personal details to be shared publicly or with third parties.

Submitted via:The method or channel through which the consumer submitted their complaint.

Date Received:The date when the company received the complaint.
 
Company response to consumer: This describes the type of the response provided by the 
company to the consumer regarding their complaints 

Timely response?:This indicates whether the company responded to 
the consumer's complaint within the required or expected timeframe.

Consumer disputed?:This indicates whether the consumer disagreed with or challenged 
the company's response to their complaint.
*/
-- 
/*1.DATA ACQUISITION: I downloaded the dataset as a CSV file and 
imported into the database 'fiancial'*/
SELECT * FROM `financial consumer complaints`; 
-- I renamed the table name as it was too long for me
RENAME TABLE `financial consumer complaints` TO `fcc`; -- Done
SELECT * FROM fcc;

-- I created a backup table incase of corrupted file or reference
CREATE TABLE IF NOT EXISTS fcc_original
AS SELECT * FROM fcc;

-- 2 DATA CLEANING
-- I fixed the name of the first column as it wasn't written properly
ALTER TABLE fcc
RENAME COLUMN `ï»¿Complaint ID` TO Complaint_ID; -- Done

-- Also fixed the column name of column, 'Date Sumbited'
ALTER TABLE fcc
RENAME COLUMN `Date Sumbited` TO Date_Submitted; -- Done

-- Identify duplicate records and fix them if available.
SELECT Complaint_ID, Date_Submitted, Product, `Sub-product`, Issue, `Sub-issue`, 
`Company public response`, Company, State, `ZIP code`, Tags, 
`Consumer consent provided?`, `Submitted via`, `Date Received`, 
`Company response to consumer`, `Timely response?`, `Consumer disputed?`,
COUNT(*) FROM fcc
GROUP BY Complaint_ID, Date_Submitted, Product, `Sub-product`, Issue, `Sub-issue`, 
`Company public response`, Company, State, `ZIP code`, Tags, 
`Consumer consent provided?`, `Submitted via`, `Date Received`, 
`Company response to consumer`, `Timely response?`, `Consumer disputed?`
HAVING COUNT(*) > 1; -- There are no duplicate records.
 
-- Let's fix the Date Formats
UPDATE fcc SET Date_Submitted
= str_to_date(Date_Submitted, "%m/%d/%Y"); -- there you go, done.
-- Let's fix that of Date Received too

UPDATE fcc SET `Date Received`
= str_to_date(`Date Received`, "%m/%d/%Y"); -- there you go, done.

-- Let's fix the """" values in sub-product column
SELECT * FROM fcc
WHERE `sub-product` = '""""';
UPDATE fcc 
SET `Sub-product` = REPLACE(`Sub-product`, '""""', 'General-purpose' 'credit' 'card' 'or' 'charge' 'card') 
WHERE `Sub-product` LIKE '%""""%'; -- Done wrongly

UPDATE fcc 
SET `Sub-product` = REPLACE(`Sub-product`, 
'General-purposecreditcardorchargecard', 
'General-purpose credit card or charge card') 
WHERE `Sub-product` LIKE '%General-purposecreditcardorchargecard%'; 
-- Done correctly. 19176 rows affected

UPDATE fcc 
SET `Sub-issue` = REPLACE(`Sub-issue`, 
'""', 
'') 
WHERE `Sub-issue` LIKE '%""%'; -- 41539 rows affected

-- I'm not fixing anything in the Sub-issue column since it's not so important

-- Here is a syntax for finding the corresponding names for state identifiers in the U.S
SELECT 
    state_id,
    CASE state_id
        WHEN 'AL' THEN 'Alabama'
        WHEN 'AK' THEN 'Alaska'
        WHEN 'AZ' THEN 'Arizona'
        WHEN 'AR' THEN 'Arkansas'
        WHEN 'CA' THEN 'California'
        WHEN 'CO' THEN 'Colorado'
        WHEN 'CT' THEN 'Connecticut'
        WHEN 'DE' THEN 'Delaware'
        WHEN 'FL' THEN 'Florida'
        WHEN 'GA' THEN 'Georgia'
        WHEN 'HI' THEN 'Hawaii'
        WHEN 'ID' THEN 'Idaho'
        WHEN 'IL' THEN 'Illinois'
        WHEN 'IN' THEN 'Indiana'
        WHEN 'IA' THEN 'Iowa'
        WHEN 'KS' THEN 'Kansas'
        WHEN 'KY' THEN 'Kentucky'
        WHEN 'LA' THEN 'Louisiana'
        WHEN 'ME' THEN 'Maine'
        WHEN 'MD' THEN 'Maryland'
        WHEN 'MA' THEN 'Massachusetts'
        WHEN 'MI' THEN 'Michigan'
        WHEN 'MN' THEN 'Minnesota'
        WHEN 'MS' THEN 'Mississippi'
        WHEN 'MO' THEN 'Missouri'
        WHEN 'MT' THEN 'Montana'
        WHEN 'NE' THEN 'Nebraska'
        WHEN 'NV' THEN 'Nevada'
        WHEN 'NH' THEN 'New Hampshire'
        WHEN 'NJ' THEN 'New Jersey'
        WHEN 'NM' THEN 'New Mexico'
        WHEN 'NY' THEN 'New York'
        WHEN 'NC' THEN 'North Carolina'
        WHEN 'ND' THEN 'North Dakota'
        WHEN 'OH' THEN 'Ohio'
        WHEN 'OK' THEN 'Oklahoma'
        WHEN 'OR' THEN 'Oregon'
        WHEN 'PA' THEN 'Pennsylvania'
        WHEN 'RI' THEN 'Rhode Island'
        WHEN 'SC' THEN 'South Carolina'
        WHEN 'SD' THEN 'South Dakota'
        WHEN 'TN' THEN 'Tennessee'
        WHEN 'TX' THEN 'Texas'
        WHEN 'UT' THEN 'Utah'
        WHEN 'VT' THEN 'Vermont'
        WHEN 'VA' THEN 'Virginia'
        WHEN 'WA' THEN 'Washington'
        WHEN 'WV' THEN 'West Virginia'
        WHEN 'WI' THEN 'Wisconsin'
        WHEN 'WY' THEN 'Wyoming'
        WHEN 'DC' THEN 'District of Columbia'
        WHEN 'AS' THEN 'American Samoa'
        WHEN 'GU' THEN 'Guam'
        WHEN 'MP' THEN 'Northern Mariana Islands'
        WHEN 'PR' THEN 'Puerto Rico'
        WHEN 'VI' THEN 'U.S. Virgin Islands'
        ELSE 'Unknown'
    END AS state_name
FROM your_table_name;

-- I changed the map state identifiers to their corresponding names for easy recognition using a CASE statement
/* Now, note these aren't only states, in the column 'State'.Territories, regions, Island countries, Commonwealth nations
Pacific regions are all included in this column 'State'. */
UPDATE fcc
SET State = CASE 
        WHEN State = 'AL' THEN 'Alabama'
        WHEN State = 'AE' THEN 'Armed Forces Europe'
        WHEN State = 'AK' THEN 'Alaska'
		WHEN State = 'AL' THEN 'Alabama'
		WHEN State = 'AP' THEN 'Armed Forces Pacific'
        WHEN State = 'AZ' THEN 'Arizona'
        WHEN State = 'AR' THEN 'Arkansas'
        WHEN State = 'CA' THEN 'California'
        WHEN State = 'CO' THEN 'Colorado'
        WHEN State = 'CT' THEN 'Connecticut'
        WHEN State = 'DE' THEN 'Delaware'
        WHEN State = 'FL' THEN 'Florida'
		WHEN State = 'FM' THEN 'Federated States of Micronesia'
        WHEN State = 'GA' THEN 'Georgia'
        WHEN State = 'HI' THEN 'Hawaii'
        WHEN State = 'ID' THEN 'Idaho'
        WHEN State = 'IL' THEN 'Illinois'
        WHEN State = 'IN' THEN 'Indiana'
        WHEN State = 'IA' THEN 'Iowa'
        WHEN State = 'KS' THEN 'Kansas'
        WHEN State = 'KY' THEN 'Kentucky'
        WHEN State = 'LA' THEN 'Louisiana'
        WHEN State = 'ME' THEN 'Maine'
        WHEN State = 'MD' THEN 'Maryland'
        WHEN State = 'MA' THEN 'Massachusetts'
        WHEN State = 'MI' THEN 'Michigan'
        WHEN State = 'MN' THEN 'Minnesota'
        WHEN State = 'MS' THEN 'Mississippi'
        WHEN State = 'MO' THEN 'Missouri'
        WHEN State = 'MT' THEN 'Montana'
        WHEN State = 'NE' THEN 'Nebraska'
        WHEN State = 'NV' THEN 'Nevada'
        WHEN State = 'NH' THEN 'New Hampshire'
        WHEN State = 'NJ' THEN 'New Jersey'
        WHEN State = 'NM' THEN 'New Mexico'
        WHEN State = 'NY' THEN 'New York'
        WHEN State = 'NC' THEN 'North Carolina'
        WHEN State = 'ND' THEN 'North Dakota'
        WHEN State = 'OH' THEN 'Ohio'
        WHEN State = 'OK' THEN 'Oklahoma'
        WHEN State = 'OR' THEN 'Oregon'
        WHEN State = 'PA' THEN 'Pennsylvania'
        WHEN State = 'PW' THEN 'Republic of Palau'
        WHEN State = 'RI' THEN 'Rhode Island'
        WHEN State = 'SC' THEN 'South Carolina'
        WHEN State = 'SD' THEN 'South Dakota'
        WHEN State = 'TN' THEN 'Tennessee'
        WHEN State = 'TX' THEN 'Texas'
        WHEN State = 'UT' THEN 'Utah'
        WHEN State = 'VT' THEN 'Vermont'
        WHEN State = 'VA' THEN 'Virginia'
        WHEN State = 'WA' THEN 'Washington'
        WHEN State = 'WV' THEN 'West Virginia'
        WHEN State = 'WI' THEN 'Wisconsin'
        WHEN State = 'WY' THEN 'Wyoming'
        WHEN State = 'DC' THEN 'District of Columbia'
        WHEN State = 'AS' THEN 'American Samoa'
        WHEN State = 'GU' THEN 'Guam'
        WHEN State = 'MP' THEN 'Northern Mariana Islands'
        WHEN State = 'PR' THEN 'Puerto Rico'
        WHEN State = 'VI' THEN 'U.S. Virgin Islands'
        ELSE State
    END; -- Done
    
SELECT DISTINCT State FROM fcc; -- Successful change from State Identifiers to their Corresponding Names

-- Let's fix the blank values in the Company Public Response column
UPDATE fcc SET fcc.`Company public response` 
= nullif(`Company public response`, ""); -- 48178 rows affected

-- Let's fix the blank values in the Tags column
UPDATE fcc SET fcc.Tags 
= nullif(Tags, ""); -- 66560 rows returned

-- Let's fix the blank values in the State column
UPDATE fcc SET fcc.State 
= nullif(State, ""); -- 2893 rows affected

-- Let's fix the blank values in the Zip code column
UPDATE fcc SET fcc.`ZIP code`
= nullif(`ZIP code`, ""); -- 4367 rows affected

-- Let's fix the blank values in the Consumer Consent Provided column
UPDATE fcc SET fcc.`Consumer consent provided?`
= nullif(`Consumer consent provided?`, ""); -- 714 rows affected

-- Let's fix the blank values in the Sub-Issue column
UPDATE fcc SET fcc.`Sub-issue`
= nullif(`Sub-Issue`, ""); -- 41539 rows affected

-- 3.EXPLORATORY DATA ANALYSIS
-- How many columns and row do we have in our datasets?
SELECT COUNT(*) AS row_num from fcc; -- 75513 rows of data
SELECT COUNT(*) AS cols_num FROM information_schema.columns 
WHERE table_name = 'fcc';-- 17 columns returned.

-- Let's select the distinct values
SELECT DISTINCT Date_Submitted FROM fcc; -- 3233 Date Submitted Values returned 
SELECT DISTINCT Product FROM fcc;
/*There are 8 major products being complained about by customers
They are:
- Credit card or prepaid card
- Debt collection
- Bank account or service
- Mortgage
- Credit card
- Checking or savings account
- Student loan
- Vehicle loan or lease
*/

SELECT DISTINCT `Sub-product` FROM fcc; 
-- There are 45 major sub-products people complain about

SELECT DISTINCT LEAST(Product,`Sub-product`) AS Distinct_Product,
GREATEST(Product,`Sub-product`) AS Distinct_Sub_Product FROM fcc;

SELECT DISTINCT Issue FROM fcc; -- 88 issues returned

SELECT DISTINCT `Sub-issue` FROM fcc; -- 171 Sub-issue returned.

SELECT DISTINCT `Company public response` FROM fcc; 
/*There are two major company public response*/

SELECT DISTINCT Company FROM fcc;
/*The name of the company involved in this dataset is Cumulus Financial*/

SELECT DISTINCT State FROM fcc; 
-- There are 62 states where complaints were filed from

SELECT DISTINCT `ZIP code` FROM fcc; -- 10885 rowss returned

SELECT DISTINCT Tags FROM fcc;
/*There are two major tags of the customers making the complaints.
Older American and Service Member 
*/
SELECT DISTINCT `Consumer consent provided?` FROM fcc; 
SELECT DISTINCT `Submitted via` FROM fcc;
/*There are 6 major channels through which complaints were submitted
They are: Web,Referral,Phone,Postal mail,Fax,Email.
*/

SELECT DISTINCT `Date Received` FROM fcc; -- 3117 rows returned

 SELECT DISTINCT `Company response to consumer` FROM fcc;
 /*There are 8 major company responses made to the Customer's Complaints
 They are: Closed with explanation, Closed with monetary relief
Closed with non-monetary relief, Closed without relief
Closed with relief,Closed, In progress, Untimely response*/

SELECT DISTINCT `Timely response?` FROM fcc; -- YES and NO
SELECT DISTINCT `Consumer disputed?` FROM fcc; -- N/A, NO and YES

-- Let's find the highest and lowest of each columns by their count and percentage.
-- For the column 'product'
SELECT product, COUNT(*), ROUND((COUNT(*) / 
(SELECT COUNT(*) FROM fcc)) * 100,1) AS pct 
FROM fcc
GROUP BY 1
ORDER BY 3 DESC; 
/*The highest product being complained about is in this order with 'Credit card'
being the highest with a percentage of 25.4 and 'Vehicle Loan or Lease'
being the lowest wiht a percentage of 1.4.
Credit card
Checking or savings account
Mortgage
Credit card or prepaid card
Bank account or service
Debt collection
Student loan
Vehicle loan or lease
*/
-- For the column 'Sub-product'
SELECT `Sub-product`, COUNT(*), ROUND((COUNT(*) / 
(SELECT COUNT(*) FROM fcc)) * 100,1) AS pct 
FROM fcc
GROUP BY 1
ORDER BY 3 DESC; /*General-purpose credit card or charge card has the 
highest number of complaints in the Sub-product category*/

-- Let's find for Issue
SELECT Issue, COUNT(*), ROUND((COUNT(*) / 
(SELECT COUNT(*) FROM fcc)) * 100,1) AS pct 
FROM fcc
GROUP BY 1
ORDER BY -3 DESC;
/*The highest issue being complained about is Managing an account and the lowest
is closing Your account*/

-- Let's find for Sub-issue
SELECT `Sub-issue`, COUNT(*), ROUND((COUNT(*) / 
(SELECT COUNT(*) FROM fcc)) * 100,1) AS pct 
FROM fcc
GROUP BY 1
ORDER BY 3 DESC;
/*The Highest product sub-issue being complained about is Deposits and Withdrawals with a percentage of 4.4
and the lowest being 'Threatened to turn you in to immigration or deport you' */

-- Let's find for Company public response
SELECT `Company public response`, COUNT(*), ROUND((COUNT(*) / 
(SELECT COUNT(*) FROM fcc)) * 100,1) AS pct 
FROM fcc
GROUP BY 1
ORDER BY 3 DESC;
/*For most of the Product issues being complained about with a percentage of 94, Cumulus Financial has responded to the consumer and the CFPB
(Consumer Financial protection Bureau, a U.S agency created to ensure that consumers are treated fairly
by banks, leaders and other financial institutions) and chooses not to provide a public response*/

-- Let's find for State
SELECT State, COUNT(*), ROUND((COUNT(*) / 
(SELECT COUNT(*) FROM fcc)) * 100,1) AS pct 
FROM fcc
GROUP BY 1
ORDER BY 3 DESC;
/*California had the highest complaint to Cumulus Fiancial, followed by NewYork
and MP-Northern Mariana Islands has the lowest complaint flow*/

-- Let's find for `Consumer consent provided?`
SELECT `Consumer consent provided?`, COUNT(*), ROUND((COUNT(*) / 
(SELECT COUNT(*) FROM fcc)) * 100,1) AS pct 
FROM fcc
GROUP BY 1
ORDER BY 3 DESC;
/*For about 68.1% of the complaints made,cumulus Fiancial didn't need the consumer 
content to use or access their account information.
For a percentage of 22%, consumer consent were not provided to use, access or share
their personal account information.
About 0.2% of the people withdrew their consent and 7.1% of the consumers gave their consent.
*/

-- Let's find the channel of submission that was used the most.
SELECT `Submitted via`, COUNT(*), ROUND((COUNT(*) / 
(SELECT COUNT(*) FROM fcc)) * 100,1) AS pct 
FROM fcc
GROUP BY 1
ORDER BY 3 DESC;
/*The company's website was used the most, followed by referral, Email wasn't used at all.*/

SELECT `Company response to consumer`, COUNT(*), ROUND((COUNT(*) / 
(SELECT COUNT(*) FROM fcc)) * 100,1) AS pct 
FROM fcc
GROUP BY 1
ORDER BY 3 DESC;
/*The major response given to customer's complaint by the company is 'Closed with explanation' with a 72.4%*/

SELECT `Timely response?`, COUNT(*), ROUND((COUNT(*) / 
(SELECT COUNT(*) FROM fcc)) * 100,1) AS pct 
FROM fcc
GROUP BY 1
ORDER BY 3 DESC;
/*The company responded to the consumer's complaint within the required or expected timeframe with a 98.1% 
and NO with a percentage of 1.9*/

SELECT `Consumer disputed?`, COUNT(*), ROUND((COUNT(*) / 
(SELECT COUNT(*) FROM fcc)) * 100,1) AS pct 
FROM fcc
GROUP BY 1
ORDER BY 3 DESC;
/*41.3% of the consumers disagreed with the company's response*/

SELECT `Date_Submitted`, COUNT(*), ROUND((COUNT(*) / 
(SELECT COUNT(*) FROM fcc)) * 100,1) AS pct 
FROM fcc
GROUP BY 1
ORDER BY 3 DESC; 
/*5th of April,2018 has the highest count of complaints lodged with a number of 123, 
folowed by the 6th of April,2018.*/

SELECT `Date Received`, COUNT(*), ROUND((COUNT(*) / 
(SELECT COUNT(*) FROM fcc)) * 100,1) AS pct 
FROM fcc
GROUP BY 1
ORDER BY 3 DESC; 

-- But Generally, which year had the most complaints?
SELECT YEAR(Date_Submitted) AS Year_of_complaint, COUNT(*) AS num_of_complaints
FROM fcc
GROUP BY 1
ORDER BY 2 ASC;
/*Year 2018 had the highest number of complaints being 11450, followed by
Year 2019, 2017, 2014, 2020*. 2011 had the lowest number of complaints*/

-- which year and month had the highest number of complaints?
SELECT YEAR(Date_Submitted) AS Year_of_complaint, MONTHNAME(Date_Submitted) AS month_of_complaint, 
COUNT(*) AS num_of_complaints
FROM fcc
GROUP BY 1,2
ORDER BY 3 DESC; -- 2018 APRIL had the highest year and month of complaints

-- Which year, month, day had the highest number of complaints
SELECT YEAR(Date_Submitted) AS Year_of_complaint, MONTHNAME(Date_Submitted) AS month_of_complaint, 
dayofmonth(Date_Submitted) AS day_of_complaint, COUNT(*) AS num_of_complaints
FROM fcc
GROUP BY 1,2, 3
ORDER BY 4 DESC; -- 2018, April, 5. 123 number of complaints.

SELECT Product, YEAR(Date_Submitted) AS Year_of_complaint, MONTHNAME(Date_Submitted) AS month_of_complaint, 
dayofmonth(Date_Submitted) AS day_of_complaint, COUNT(*) AS num_of_complaints
FROM fcc
GROUP BY 1,2,3,4
ORDER BY 5 DESC;

-- Aggregation
SELECT MIN(Date_Submitted) `earliest dates`, MAX(Date_Submitted) `most recent date`
FROM fcc
WHERE Date_Submitted IS NOT NULL;
-- Most recent date of complaint is 13th of October, 2020

SELECT Product, MAX(Date_Submitted) `most recent date`
FROM fcc
WHERE Date_Submitted IS NOT NULL
GROUP BY 1
ORDER BY 2 desc;
-- Most recent date of complaint is 13th of October, 2020 and the product complained about is Credit Card or Prepaid Card

SELECT State, `Submitted via`, COUNT(*) count
FROM fcc
GROUP BY 1,2
ORDER BY 3 DESC; -- California had the highest number of people who used the company's website


-- 4.INSIGHTS AND RECOMMENDATIONS
-- Insights
/*1. There are 8 major products being complained about by customers
They are:
- Credit card or prepaid card
- Debt collection
- Bank account or service
- Mortgage
- Credit card
- Checking or savings account
- Student loan
- Vehicle loan or lease
*/

-- 2. There are 45 major sub-products people complain about.
-- 3. There are 62 states where complaints were filed from.
/* 4. There are 6 major channels through which complaints were submitted
They are: Web,Referral,Phone,Postal mail,Fax,Email.
*/
/* 5. The highest product being complained about is 'Credit card'
being the highest with a percentage of 25.4 and 'Vehicle Loan or Lease'
being the lowest wiht a percentage of 1.4.*/
/* 6. General-purpose credit card or charge card has the 
highest number of complaints in the Sub-product category*/
-- 7. The highest issue being complained about is Managing an account
-- 8. The Highest product sub-issue being complained about is Deposits and Withdrawals with a percentage of 4.4
/* 9. For most of the Product issues being complained about with a percentage of 94, Cumulus Financial has responded 
to the consumer and the CFPB (Consumer Financial protection Bureau, a U.S agency created to ensure that consumers 
are treated fairly by banks, leaders and other financial institutions) and chooses not to provide a public response*/
/* 10. California had the highest complaint to Cumulus Fiancial, followed by NewYork
and MP-Northern Mariana Islands has the lowest complaint flow*/
-- We need to maybe have a branch in California sice we have more customers there.
/* 11. For about 68.1% of the complaints made,cumulus Fiancial didn't need the consumer 
content to use or access their account information.
For a percentage of 22%, consumer consent were not provided to use, access or share
their personal account information.
About 0.2% of the people withdrew their consent and 7.1% of the consumers gave their consent.
*/
/* 12. The company's website was used the most, followed by referral, Email wasn't used at all.*/
/* 13. The major response given to customer's complaint by the company is 'Closed with explanation' with a percentage of 72.4%*/
/* 14. The company responded to the consumer's complaint within the required or expected timeframe with a 98.1% 
and NO with a percentage of 1.9*/ -- Can do better though
/* 15. 41.3% of the consumers disagreed with the company's response*/ 
-- I think this needs to be looked into
/* 16. 5th of April,2018 has the highest count of complaints lodged with a number of 123, 
folowed by the 6th of April,2018.*/
-- 17.Year 2018 had the highest number of complaints being 11450. We really need to look into the cause.
-- 18. 2018, April, 5 had the highest number of complaints. 123 number of complaints.
-- 19. Most recent date of complaint is 13th of October, 2020 and the product complained about is Credit Card or Prepaid Card

-- #Recommendations
-- We need to maybe have a branch in California sice we have more customers there.
-- We need to work on our website's efficiency to make the work there more seamless with no issues since it's the most used channel
-- We may need to look into the consumers who disagreed with the company's response and hear from them
-- We need to look into this Credit Card issue as people are complaining about it a lot.
-- We need to look into 2018. Why we had so much customer's complaints.