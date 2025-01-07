SELECT
    s.country_region,
    p.category AS product_category,
    SUM(
        CAST(REPLACE(p.product_price, '£', '') AS NUMERIC) * o."Product Quantity"
    ) AS total_profit
FROM
    orders_powerbi o
JOIN
    dim_date d ON EXTRACT(YEAR FROM CAST(o."Order Date" AS DATE)) = d.year
JOIN
    dim_products p ON o.product_code = p.product_code
JOIN
    dim_stores s ON o."Store Code" = s."store code"
WHERE
    d.year = 2021 
    AND s.country_code = 'GB'
    AND s.country_region = 'Wiltshire'
GROUP BY
    p.category, 
    country_region
ORDER BY
    total_profit
LIMIT 1;
