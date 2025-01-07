create database Zomato_analytics_project;


use Zomato_analytics_project;


-- Extracting opening_date column from zomato table to calender table

CREATE TABLE zomato_analytics_project.calender AS
SELECT opening_date
FROM zomato_analytics_project.zomato;

-- ---------------------------------------Calender Table---------------------------------------------------------------------------------					
-- ADD COLUMNS TO THE CALENDER TABLE

ALTER TABLE CALENDER
CHANGE COLUMN `FINANCIALQUARTER` `FINANCIAL_QUARTER` CHAR(20);

ALTER TABLE CALENDER
ADD COLUMN OPENING_YEAR INT,
ADD COLUMN QTR VARCHAR(10),
ADD COLUMN MONTH_NAME CHAR(20),
ADD COLUMN MONTH_NUMBER INT,
ADD COLUMN YEARMONTH VARCHAR(50),
ADD COLUMN WEEKDAY_NO INT,
ADD COLUMN WEEKDAY_NAME CHAR(20),
ADD COLUMN FINANCIAL_MONTH VARCHAR(20),
ADD COLUMN FINANCIAL_QUARTER VARCHAR(20);

-- Extracting Year, Quarter, MonthName, MonthNumber, Year-Month, WeekdayNo, WeekdayName, 
-- Financia Month, Financial Quarter from Opening_date column in calender table.

-- EXTRACTING YEAR
UPDATE CALENDER 
SET OPENING_YEAR = YEAR(OPENING_DATE);

-- EXTRACTING QUARTER
UPDATE CALENDER
SET QTR = quarter(OPENING_DATE);

-- EXTRACTING MONTH_NAME
UPDATE CALENDER
SET MONTH_NAME = monthname(OPENING_DATE);

-- EXTRACTING MONTH_NUMBER
UPDATE CALENDER
SET MONTH_NUMBER = month(OPENING_DATE);

-- EXTRACTING YEARMONTH
UPDATE CALENDER
SET YEARMONTH = date_format(OPENING_DATE,"%Y-%M");

-- EXTRACTING WEEKDAY_NO
UPDATE CALENDER
SET WEEKDAY_NO = weekday(OPENING_DATE);

-- EXTRACTING WEEKDAY_NAME
UPDATE CALENDER
SET WEEKDAY_NAME = dayname(OPENING_DATE);

-- EXTRACTING FINANCIAL_MONTH
UPDATE CALENDER
SET FINANCIAL_MONTH = CASE
					WHEN month(OPENING_DATE) >= 4 THEN CONCAT('FM-', MONTH(OPENING_DATE)-3)
                    ELSE concat('FM',MONTH(OPENING_DATE)+9)
                    END;

-- EXTRACTING FINANCIAL_QUARTER
UPDATE CALENDER
SET FINANCIAL_QUARTER = CASE
					WHEN month(OPENING_DATE) IN (4, 5, 6) THEN 'FQ-1'
                    WHEN month(OPENING_DATE) IN (7, 8, 9) THEN 'FQ-2'
                    WHEN month(OPENING_DATE) IN (10, 11, 12) THEN 'FQ-3'
                    ELSE 'FA-4'
                    END;
                    
                    
SELECT * FROM CALENDER;

SELECT * FROM ZOMATO;

DESC ZOMATO;

-- -----------------------------------CREATING COUNTRY TABLE ------------------------------------------------------------------
CREATE TABLE zomato_analytics_project.COUNTRY AS
SELECT *
FROM zomato_analytics.COUNTRY;

-- -----------------------------------CREATING CURRENCY TABLE ------------------------------------------------------------------
CREATE TABLE zomato_analytics_project.CURRENCY AS
SELECT *
FROM zomato_analytics.CURRENCY;

-- -----------------------------------------------------------------------------------------------------------------------------
-- SQL TASKS
-- 1. Convert the Average cost for 2 column into USD dollars (currently the Average cost for 2 in local currencies
ALTER TABLE ZOMATO 
ADD COLUMN AVERAGE_COST_IN_USD DECIMAL(10,1)
AS (ROUND(AVERAGE_COST_FOR_TWO * 0.012,1)) STORED
AFTER AVERAGE_COST_FOR_TWO;

-- -------------------------------Find the Numbers of Restaurants based on City and Country-------------------------------------------------
SELECT countryname, city, count(*) as 'No.of Restaurants'
from zomato z left join country c
on z.countrycode = c.countryid
group by city, countryname
order by countryname, city;

select * from zomato;
select * from country;

-- ------------------------------ Numbers of Restaurants opening based on Year, Quarter , Month --------------------------------------------
-- YEAR WISE
SELECT `YEAR OPENING` AS YEAR_OPENING, COUNT(*) AS 'NO.OF RESTAURANTS'
FROM ZOMATO 
GROUP BY YEAR_OPENING
ORDER BY YEAR_OPENING;

-- QUARTER WISE
SELECT concat("QTR-",quarter(OPENING_DATE)) AS OPENING_QUARTER, COUNT(*) AS 'NO.OF RESTAURANTS'
FROM ZOMATO 
GROUP BY OPENING_QUARTER
ORDER BY OPENING_QUARTER;

-- MONTH WISE
SELECT MONTH(opening_date) AS MONTH_NO, monthname(OPENING_DATE) AS OPENING_MONTH, COUNT(*) AS 'NO.OF RESTAURANTS'
FROM zomato
GROUP BY OPENING_MONTH,MONTH_NO
ORDER BY MONTH_NO;

-- YEAR , QUARTER & MONTH WISE
SELECT year(OPENING_DATE) AS 'OPENING_YEAR', 
		concat("QTR-",QUARTER(OPENING_DATE)) AS 'OPENING_QUARTER',
		monthname(OPENING_DATE) AS 'OPENING_MONTH',
        COUNT(*) AS 'NO.OF RESTAURANTS'
FROM ZOMATO 
GROUP BY OPENING_YEAR, OPENING_QUARTER, month(OPENING_DATE),OPENING_MONTH
ORDER BY OPENING_YEAR, OPENING_QUARTER,month(OPENING_DATE);
        
-- ------------------------------ Count of Restaurants based on Average Ratings -------------------------------------------------------------
SELECT RATING, COUNT(*) AS 'NO.OF RESTAURANTS'
FROM ZOMATO 
GROUP BY RATING
ORDER BY RATING;

-- ----------------------------- Create buckets based on Average Price of reasonable size ---------------------------------------------------
-- ------------------------------and find out how many restaurants falls in each bucket  ----------------------------------------------------
SELECT
	CASE
		WHEN AVERAGE_COST_FOR_TWO BETWEEN 0 AND 10 THEN '1. 0-10'
        WHEN AVERAGE_COST_FOR_TWO BETWEEN 11 AND 100 THEN '2. 11-100'
        WHEN AVERAGE_COST_FOR_TWO BETWEEN 101 AND 1000 THEN '3. 101-1K'
        WHEN AVERAGE_COST_FOR_TWO BETWEEN 1001 AND 10000 THEN '4. 1K-10K'
        ELSE '5. ABOVE 10K'
	END AS 'COST_BUCKETS',
    COUNT(*) AS 'NO.OF RESTAURANTS'
FROM ZOMATO 
GROUP BY COST_BUCKETS
ORDER BY COST_BUCKETS;
        
-- ----------------------------- Percentage of Restaurants based on "Has_Table_booking ------------------------------------------------------
SELECT COUNT(*) AS 'NO.OF RESTAURANTS',
		HAS_TABLE_BOOKING,
        CONCAT(ROUND(COUNT(*)/100,2),"%") AS 'PERCENTAGE'
FROM ZOMATO 
GROUP BY HAS_TABLE_BOOKING
ORDER BY HAS_TABLE_BOOKING DESC;

-- ------------------------------ Percentage of Restaurants based on "Has_Online_delivery ----------------------------------------------------
SELECT COUNT(*) AS 'NO.OF RESTAURANTS',
		HAS_ONLINE_DELIVERY,
        CONCAT(ROUND(COUNT(*)/100,2),"%") AS 'PERCENTAGE'
FROM ZOMATO 
GROUP BY HAS_ONLINE_DELIVERY
ORDER BY HAS_ONLINE_DELIVERY DESC;

-- --------------------------------- Develop Charts based on Cusines, City, Ratings ----------------------------------------------------------
-- ----------------------------- 1. Table for Number of Restaurants by Cuisine ------------------------------------------------------------------
SELECT CUISINES, COUNT(*) AS 'NO.OF RESTAURANTS'
FROM zomato
GROUP BY  CUISINES
ORDER BY COUNT(*) DESC;

-- ------------------------------2. Table for Number of Restaurants by City ---------------------------------------------------------------------
SELECT CITY, COUNT(*) AS 'NO.OF RESTAURANTS'
FROM ZOMATO 
GROUP BY CITY
ORDER BY COUNT(*) DESC;

-- ------------------------------3. Average Cost for Two by City ---------------------------------------------------------------------------------
SELECT CITY, ROUND(AVG(AVERAGE_COST_FOR_TWO),2) AS 'AVERAGE_COST'
FROM zomato
GROUP BY CITY
ORDER BY AVERAGE_COST DESC;

-- ---------------------------------------------------------THANK YOU ----------------------------------------------------------------------------



