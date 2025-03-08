#Exploratory Data Analysis
select max(`Amount`) from amazon_sales_report2;
-- The highest transaction amount (`Amount`)= 5584 in the dataset represents the maximum sales value recorded.

select min(`date`), max(`date`) from amazon_sales_report2;
-- The dataset spans from the March 31 2022 to the May 31 2022, providing a clear time range for analysis.


# Overall Sales Summary
SELECT 
  COUNT(DISTINCT `Order ID`) AS order_count,
  SUM(Amount) AS total_sales
FROM amazon_sales_report2
ORDER BY total_sales DESC;
-- A total of 60,945 orders were placed over two months.
-- Total sales amounted to approximately 41.8 million, reflecting strong performance.


#State-Wise Spending
select `ship-state`, sum(`Amount`)
from amazon_sales_report2
group by  `ship-state`
order by 2 desc;
-- Maharashtra has the highest total spending, making it the top-performing state.
-- Pondicherry has the lowest spending, indicating minimal customer activity.


#City-Wise Spending
select `ship-city`, sum(`Amount`)
from amazon_sales_report2
group by  `ship-city`
order by 2 desc;
-- Major metropolitan cities like Bengaluru, Hyderabad, Mumbai, New Delhi, Chennai, Pune, and Kolkata dominate sales.
-- These cities are key markets for e-commerce growth.


#Product Performance
SELECT 
  Category,
  SUM(Qty) AS total_quantity_sold,
  SUM(Amount) AS total_sales,
  COUNT(DISTINCT `Order ID`) AS order_count
FROM amazon_sales_report2
GROUP BY Category
ORDER BY total_sales DESC
LIMIT 10;
-- T-shirts are the top-selling product category, contributing significantly to total sales.
-- Shoes are the least popular category and may require a strategic review.


#Order Status Distribution
SELECT 
  Status,
  COUNT(DISTINCT `Order ID`) AS order_count,
  SUM(Amount) AS total_sales,
  (COUNT(DISTINCT `Order ID`) * 100.0 / (SELECT COUNT(DISTINCT `Order ID`) FROM amazon_sales_report2)) AS percentage
FROM amazon_sales_report2
GROUP BY Status
ORDER BY order_count DESC;
-- 89.06% of the orders were successfully delevered to the buyer 
-- 8.9% of the orders were cancelled
-- 1% of the orders were returned to the seller


SELECT 
  `ship-service-level`,
  COUNT(DISTINCT `Order ID`) AS order_count,
  SUM(Amount) AS total_sales,
  AVG(Amount) AS average_order_value
FROM amazon_sales_report2
GROUP BY `ship-service-level`
ORDER BY total_sales DESC;
-- Expedited shipping is the most preferred option, with nearly double the orders compared to standard shipping.


SELECT 
  Fulfilment,
  COUNT(DISTINCT `Order ID`) AS order_count,
  SUM(Amount) AS total_sales,
  AVG(Amount) AS average_order_value
FROM amazon_sales_report2
GROUP BY Fulfilment;
-- Amazon fulfills 67.7% of orders, while merchants handle 32.3%.
-- Amazon's fulfillment services dominate but merchant fulfillment remains significant


#B2B VS B2C
SELECT 
  B2B,
  COUNT(DISTINCT `Order ID`) AS order_count,
  SUM(Amount) AS total_sales,
  AVG(Amount) AS average_order_value
FROM amazon_sales_report2
GROUP BY B2B;
-- The majority of sales are Business-to-Consumer (B2C), with less than 1% attributed to Business-to-Business (B2B) transactions.


#Monthly Sales trend
SELECT 
  DATE_FORMAT(date, '%Y-%m-31') AS month,
  SUM(Amount) AS monthly_sales,
  COUNT(DISTINCT `Order ID`) AS order_count
FROM amazon_sales_report2
GROUP BY DATE_FORMAT(date, '%Y-%m-31')
ORDER BY month;
-- April recorded the highest sales during the analyzed period.
