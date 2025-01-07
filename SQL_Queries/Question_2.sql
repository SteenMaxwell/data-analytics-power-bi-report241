SELECT 
    d.month,
    SUM(
        CAST(REPLACE(p.product_price, '£', '') AS NUMERIC) * o."Product Quantity"
    ) AS total_revenue
FROM 
    orders_powerbi o
JOIN 
    dim_date d ON 
        EXTRACT(MONTH FROM CAST(o."Order Date" AS DATE)) = d.month
        AND EXTRACT(YEAR FROM CAST(o."Order Date" AS DATE)) = d.year
JOIN 
    dim_products p ON o.product_code = p.product_code
WHERE 
    d.year = 2022
GROUP BY 
    d.month
ORDER BY 
    total_revenue DESC
LIMIT 1;
