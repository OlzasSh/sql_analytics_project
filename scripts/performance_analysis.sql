/*
===============================================================================
Performance Analysis (Year-over-Year, Month-over-Month)
===============================================================================
Purpose:
    - To measure the performance of products, customers, or regions over time.
    - For benchmarking and identifying high-performing entities.
    - To track yearly trends and growth.
===============================================================================
*/

/* Analyze the yearly performance of products by comparing their sales 
to both the average sales performance of the product and the previous year's sales */

WITH perf AS(
SELECT EXTRACT(YEAR FROM s.order_date) AS year,
	   p.product_name,
	   SUM(s.sales_amount) AS current_sales
FROM gold.fact_sales s
LEFT JOIN gold.dim_product p
ON s.product_key = p.product_key
WHERE order_date IS NOT NULL
GROUP BY EXTRACT(YEAR FROM s.order_date), p.product_name)

SELECT year,
	   product_name,
	   current_sales,
	   ROUND(current_sales - AVG(current_sales) OVER(PARTITION BY product_name)) AS avg_diff,
	   CASE WHEN current_sales - AVG(current_sales) OVER(PARTITION BY product_name) > 0
	   		THEN 'Above average'
			WHEN current_sales - AVG(current_sales) OVER(PARTITION BY product_name) < 0
	   		THEN 'Below average' ELSE 'average'
	   END AS avg_performance,
	    current_sales - LAG(current_sales,1) OVER(PARTITION BY product_name ORDER BY year) AS prev_diff,
		CASE WHEN current_sales - LAG(current_sales,1) OVER(PARTITION BY product_name ORDER BY year) > 0
	   		THEN 'Increasing'
			WHEN current_sales - LAG(current_sales,1) OVER(PARTITION BY product_name ORDER BY year) < 0
	   		THEN 'Decreasing' ELSE 'Doesnt change'
	   END AS prev_performance
FROM perf
