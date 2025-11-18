/*
===============================================================================
Data Segmentation Analysis
===============================================================================
Purpose:
    - To group data into meaningful categories for targeted insights.
    - For customer segmentation, product categorization, or regional analysis.
===============================================================================
*/

/*Segment products into cost ranges and 
count how many products fall into each segment*/

WITH segment AS (
SELECT product_key,
	   product_name,
	   product_cost,
	   CASE WHEN product_cost < 100 THEN 'Below 100'
	   		WHEN product_cost BETWEEN 100 AND 500 THEN '100-500'
			WHEN product_cost BETWEEN 500 AND 1000 THEN '500-1000'
			ELSE 'Above 1000' 
	   END AS cost_range
FROM gold.dim_product)

SELECT cost_range,
	   COUNT(product_key) AS total_products
FROM segment
GROUP BY cost_range
ORDER BY total_products 
  

/*Group customers into three segments based on their spending behavior:
	- VIP: Customers with at least 12 months of history and spending more than €5,000.
	- Regular: Customers with at least 12 months of history but spending €5,000 or less.
	- New: Customers with a lifespan less than 12 months.
And find the total number of customers by each group
*/
  
WITH customers AS (
SELECT c.customer_key,
	   SUM(f.sales_amount) AS total_spending,
	   MIN(order_date) AS first_order,
	   MAX(order_date) AS last_order,
	   CASE 
	   		WHEN SUM(f.sales_amount) > 5000 AND (MAX(order_date) - MIN(order_date))/30 >= 12
				THEN 'VIP'
			WHEN SUM(f.sales_amount) <= 5000 AND (MAX(order_date) - MIN(order_date))/30 >= 12
				THEN 'Regular'
			ELSE 'New'
		END AS customer_segmentation
FROM gold.fact_sales f
LEFT JOIN gold.dim_customer c
USING(customer_key)
GROUP BY c.customer_key)

SELECT customer_segmentation,
	   COUNT(customer_key) AS customer_number
FROM customers
GROUP BY customer_segmentation
ORDER BY customer_number DESC
