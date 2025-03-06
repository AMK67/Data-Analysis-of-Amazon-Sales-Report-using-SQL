select count(*) from amazon_sales_report; -- Total number of records
describe amazon_sales_report; -- Knowing columns and their data types

#Data Cleaning
#Duplicate Check
WITH duplicate_cte as
(
select *,
ROW_NUMBER() OVER(PARTITION BY `amazon_sales_report`.`index`,
    `amazon_sales_report`.`Order ID`,
    `amazon_sales_report`.`Date`,
    `amazon_sales_report`.`Status`,
    `amazon_sales_report`.`Fulfilment`,
    `amazon_sales_report`.`Sales Channel`,
    `amazon_sales_report`.`ship-service-level`,
    `amazon_sales_report`.`Category`,
    `amazon_sales_report`.`Size`,
    `amazon_sales_report`.`Courier Status`,
    `amazon_sales_report`.`Qty`,
    `amazon_sales_report`.`currency`,
    `amazon_sales_report`.`Amount`,
    `amazon_sales_report`.`ship-city`,
    `amazon_sales_report`.`ship-state`,
    `amazon_sales_report`.`ship-postal-code`,
    `amazon_sales_report`.`ship-country`,
    `amazon_sales_report`.`B2B`,
    `amazon_sales_report`.`fulfilled-by`,
    `amazon_sales_report`.`New`,
    `amazon_sales_report`.`PendingS` ) as row_num
from amazon_sales_report
)
select * from duplicate_cte
where row_num>1;

CREATE TABLE amazon_sales_report2 (
  `index` int DEFAULT NULL,
  `Order ID` text,
  `Date` text,
  `Status` text,
  `Fulfilment` text,
  `Sales Channel` text,
  `ship-service-level` text,
  `Category` text,
  `Size` text,
  `Courier Status` text,
  `Qty` int DEFAULT NULL,
  `currency` text,
  `Amount` double DEFAULT NULL,
  `ship-city` text,
  `ship-state` text,
  `ship-postal-code` int DEFAULT NULL,
  `ship-country` text,
  `B2B` text,
  `fulfilled-by` text,
  `New` text,
  `PendingS` text,
  row_num int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

insert into amazon_sales_report2
select *,
ROW_NUMBER() OVER(PARTITION BY `amazon_sales_report`.`index`,
    `amazon_sales_report`.`Order ID`,
    `amazon_sales_report`.`Date`,
    `amazon_sales_report`.`Status`,
    `amazon_sales_report`.`Fulfilment`,
    `amazon_sales_report`.`Sales Channel`,
    `amazon_sales_report`.`ship-service-level`,
    `amazon_sales_report`.`Category`,
    `amazon_sales_report`.`Size`,
    `amazon_sales_report`.`Courier Status`,
    `amazon_sales_report`.`Qty`,
    `amazon_sales_report`.`currency`,
    `amazon_sales_report`.`Amount`,
    `amazon_sales_report`.`ship-city`,
    `amazon_sales_report`.`ship-state`,
    `amazon_sales_report`.`ship-postal-code`,
    `amazon_sales_report`.`ship-country`,
    `amazon_sales_report`.`B2B`,
    `amazon_sales_report`.`fulfilled-by`,
    `amazon_sales_report`.`New`,
    `amazon_sales_report`.`PendingS` ) as row_num
from amazon_sales_report;
select * from amazon_sales_report2;

-- deleting duplicate records
delete from amazon_sales_report2 where row_num>1;


# Standardising data

-- Remove special characters from city
UPDATE amazon_sales_report2
SET `ship-city` = UPPER(
    TRIM(
        REGEXP_REPLACE(
            `ship-city`,
            '[^a-zA-Z0-9\s]', 
            ''
        )
    )
);

-- Standardized city names
UPDATE amazon_sales_report2
SET `ship-city` = CASE
    WHEN `ship-city` IN ('MUMBAI', 'MUMBAI 400101', 'MUMBAI DADAR WEST', 'MUMBAI 400064', 'MUMBAI 400023', 'MUMBAI MALAD WEST MALVANI', 'MUMBAI 400057') THEN 'MUMBAI'
    WHEN `ship-city` IN ('BENGALURU', 'BANGALORE', 'BANGALORE NORTH', 'BANGALORE KARNATAKA', 'BANGLORE') THEN 'BENGALURU'
    WHEN `ship-city` IN ('NAVI MUMBAI', 'NAVI MUMBAI', 'NAVI MUMBAI THANE') THEN 'NAVI MUMBAI'
    WHEN `ship-city` IN ('PUDUCHERRY', 'PONDYCHERRY') THEN 'PUDUCHERRY'
    WHEN `ship-city` IN ('CHENNAI', 'RAMAPURAM CHENNAI') THEN 'CHENNAI'
    WHEN `ship-city` IN ('NEW DELHI', 'NEW DELHI 110075', 'JOSHI ROAD KAROL BAGH NEW DELHI') THEN 'NEW DELHI'
    WHEN `ship-city` IN ('GURGAON', 'GURUGRAM') THEN 'GURGAON'
    WHEN `ship-city` IN ('KOLKATA', 'NEW TOWN KOLKATA', 'KOLKATA 700034') THEN 'KOLKATA'
    WHEN `ship-city` IN ('Punjab/Mohali/Zirakpur', 'PB') THEN 'PUNJAB'
    WHEN `ship-city` IN ('AR') THEN 'ARUNACHAL PRADESH'
    WHEN `ship-city` IN ('NL') THEN 'NAGALAND'
    WHEN `ship-city` IN ('RJ') THEN 'RAJASTHAN'
    WHEN `ship-city` IN ('DADRA AND NAGAR') THEN 'GUJARAT'
    ELSE `ship-city`
END;

-- Standardized state names
UPDATE amazon_sales_report2
SET `ship-state` = CASE
    WHEN `ship-state` IN ('Punjab/Mohali/Zirakpur', 'PB') THEN 'PUNJAB'
    WHEN `ship-state` IN ('AR') THEN 'ARUNACHAL PRADESH'
    WHEN `ship-state` IN ('NL') THEN 'NAGALAND'
    WHEN `ship-state` IN ('RJ') THEN 'RAJASTHAN'
    WHEN `ship-state` IN ('DADRA AND NAGAR') THEN 'GUJARAT'
    ELSE `ship-state`
END;
UPDATE amazon_sales_report2
SET `ship-state` = UPPER(`ship-state`);

-- Standardise status
UPDATE amazon_sales_report2
SET `Status` = 'Shipped - Delivered to Buyer'
where `Status` = 'Shipped';

-- Changing Data Type
Update amazon_sales_report2
Set `date` = str_to_date(`date`, '%m-%d-%Y');
Alter table amazon_sales_report2
Modify column `date` DATE;

-- Deleting columns which are null more than 50%
Alter table amazon_sales_report2
drop column `fulfilled-by`,
drop column `New`,
drop column `PendingS`,
drop column row_num;
