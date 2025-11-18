/*
===============================================================================
Part-to-Whole Analysis
===============================================================================
Purpose:
    - To compare performance or metrics across dimensions or time periods.
    - To evaluate differences between categories.
    - Useful for A/B testing or regional comparisons.
===============================================================================
*/

-- Which categories contribute the most to overall sales?

SELECT category,
		SUM(sales_amount) AS total_sales,
	   round(100.0*SUM(sales_amount)/(select sum(sales_amount)
	   							from gold.fact_sales),2)::TEXT || ' %' AS overall_sales
FROM gold.fact_sales f
LEFT JOIN gold.dim_product p
ON f.product_key = p.product_key
GROUP BY category
ORDER BY total_sales DESC
