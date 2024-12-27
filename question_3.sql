SELECT
s.store_type AS german_store_type,
SUM(
CAST(REPLACE(p.product_price, '£', '') AS NUMERIC) * o."Product Quantity"
) AS total_revenue
FROM
orders_powerbi o
JOIN
dim_date d ON EXTRACT(YEAR FROM CAST(o."Order Date" AS DATE)) = d.year
JOIN
dim_products p ON o.product_code = p.product_code
JOIN
dim_stores s ON o."Store Code" = s."store code"
WHERE
s.country_code = 'DE' AND d.year = 2022
GROUP BY
s.store_type
ORDER BY
total_revenue DESC
LIMIT 1;