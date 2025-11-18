/*
===============================================================================
Cumulative Analysis
===============================================================================
Purpose:
    - To calculate running totals or moving averages for key metrics.
    - To track performance over time cumulatively.
    - Useful for growth analysis or identifying long-term trends.
===============================================================================
*/
-- Calculate the total sales per month 
-- and the running total of sales over time 

WITH total_sale AS (
SELECT DATE_TRUNC('year', order_date) AS year_month,
	   SUM(sales_amount) AS total_sales,
	   AVG(SUM(sales_amount)) AS avg_price
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATE_TRUNC('year', order_date))

SELECT year_month, 
	   total_sales,
	   SUM(total_sales) OVER(ORDER BY year_month) AS running_total_sales,
	   ROUND(AVG(avg_price) OVER(ORDER BY year_month)) AS moving_average
FROM total_sale
