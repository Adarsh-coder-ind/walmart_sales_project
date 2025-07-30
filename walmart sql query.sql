create database walmart;
show databases;
use walmart;

select *from walmart;


select distinct payment_method from walmart;

SELECT 
  payment_method, 
  COUNT(*) AS total_count
FROM walmart
GROUP BY payment_method;


select count(distinct branch) from walmart;

select max(quantity) from walmart;

#Business Problems

#Find different payment method and number of transactions , number of qty sold

SELECT
  payment_method,
  COUNT(*) AS total_transactions,
  SUM(quantity) AS total_quantity
FROM walmart
GROUP BY payment_method;

#Identify the highest-rated category in each branch displaying the branch , category, avg rating

SELECT *
FROM (
  SELECT
    branch,
    category,
    AVG(rating) AS avg_rating,
    RANK() OVER (
      PARTITION BY branch
      ORDER BY AVG(rating) DESC
    ) AS category_rank
  FROM walmart
  GROUP BY branch, category
) AS ranked_categories
WHERE category_rank = 1;

#identify the busiest day for each branch based on the number of transactions 

SELECT
  date,
  DATE_FORMAT(STR_TO_DATE(date, '%d/%m/%y'), '%Y-%m-%d') AS formated_date
FROM walmart
LIMIT 1000;

SELECT
  date,
  DAYNAME(STR_TO_DATE(date, '%d/%m/%y')) AS day_name
FROM walmart
LIMIT 1000;

SELECT branch, day_name, no_transactions
FROM (
  SELECT
    branch,
    DAYNAME(STR_TO_DATE(date, '%d/%m/%y')) AS day_name,
    COUNT(*) AS no_transactions,
    RANK() OVER (PARTITION BY branch ORDER BY COUNT(*) DESC) AS rnk
  FROM walmart
  GROUP BY branch, day_name
) AS ranked
WHERE rnk = 1;

#calculate the total quantity of item sold per payment method list payment method and total_quantity,
select 
payment_method,
count(*) as no_payments,
sum(quantity) as no_qty_sold
from walmart
group by payment_method;

#Determine the average , minimum and maximum rating of category for each city
#list the city , average_rating , min_rating and max_rating,
select
city,
category,
min(rating) as min_rating,
max(rating) as max_rating,
avg(rating) as avg_rating
from walmart
group by city , category;

#calcualate the total profit for each category by considering total_profit as (unit_price *quantity * profit_margin)
#list category and total_profit , ordered from highest to lowest profit

select
category,
sum(total) as total_revenue,
sum(total * profit_margin) as profit
from walmart
group by category;

#Determine the most common payment method for each branch
#Display branch and the prefered_payment_method.
WITH cte AS (
  SELECT
    branch,
    payment_method,
    total_trans,
    RANK() OVER (PARTITION BY branch ORDER BY total_trans DESC) AS rnk
  FROM (
    SELECT
      branch,
      payment_method,
      COUNT(*) AS total_trans
    FROM walmart
    GROUP BY branch, payment_method
  ) AS sub  -- ○ Alias added here
)
SELECT
  branch,
  payment_method,
  total_trans,
  rnk
FROM cte
WHERE rnk = 1;




