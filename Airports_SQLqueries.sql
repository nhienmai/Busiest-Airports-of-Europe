-- Create and import table `aiports` to pgAdmin 4 
CREATE TABLE airports (
    rank2021 INTEGER,
    airport TEXT,
    city_served TEXT,
    country TEXT,
    passengers_2021 INTEGER,
    passengers_2020 TEXT,
    change_2021_2020_num INTEGER,
    change_2021_2020_percent TEXT
)

COPY airports FROM '/Users/ash/Portfolio_Projects/Data Exploration /Busiest_Airports/Busiest-European-Airports-2021.csv'  DELIMITER ',' CSV HEADER;

-- Select the table
SELECT * FROM airports

-- DATA CLEANING

-- Change datatype 
ALTER TABLE airports
ALTER COLUMN passengers_2020 TYPE INTEGER USING REPLACE(passengers_2020, ',00', '')::INTEGER,
ALTER COLUMN change_2021_2020_percent TYPE NUMERIC USING REPLACE(REPLACE(change_2021_2020_percent, '%', ''), ',', '.')::NUMERIC;
-- Note: The change of `change_2021_2020` column will present the percentage as whole numbers without converting them to fraction.

-- Remove outliers
DELETE FROM airports
WHERE passengers_2020 = 1 

-- DATA EXPLORATION 

-- 1. Which 5 airports saw the highest percentage increase in passenger volumes from 2020 to 2021?
SELECT airport, change_2021_2020_percent FROM airports
GROUP BY airport, change_2021_2020_percent 
ORDER BY change_2021_2020_percent DESC LIMIT 5

-- 2. How many airports experienced a growth in passengers (positive change) from 2020 to 2021?
SELECT COUNT(*) FROM airports 
WHERE change_2021_2020_num > 0 

-- 3. Which airports experienced a drop in passengers (negative change) from 2020 to 2021?
SELECT * FROM airports 
WHERE change_2021_2020_num < 0 

-- 4. Which are the 5 highest traffic cities in 2021?
SELECT city_served, country, passengers_2021 FROM airports 
GROUP BY city_served, country, passengers_2021 
ORDER BY passengers_2021 DESC LIMIT 5

-- 5.  Which are the 5 lowest traffic cities in 2021?
SELECT city_served, country, passengers_2021 FROM airports 
GROUP BY city_served, country, passengers_2021 
ORDER BY passengers_2021 ASC LIMIT 5

-- 6. Which cities were in the top 5 highest traffic in both 2020 and 2021?
WITH ranked_cities AS (
    SELECT city_served,
           RANK() OVER (ORDER BY "passengers_2021" DESC) AS rank2021,
           RANK() OVER (ORDER BY "passengers_2020" DESC) AS rank2020
    FROM airports
)
SELECT city_served
FROM ranked_cities
WHERE rank2021 <= 5 AND rank2020 <= 5


