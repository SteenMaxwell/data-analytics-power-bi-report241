CREATE VIEW store_sales_summary_view AS
WITH sales_summary AS (
    SELECT 
        s.store_type,
        SUM(CAST(REPLACE(p.product_price, '£', '') AS NUMERIC) * o."Product Quantity") AS total_sales,
        COUNT(o."User ID") AS order_count
    FROM 
        orders_powerbi o
    JOIN 
        dim_stores s ON o."Store Code" = s."store code"
    JOIN 
        dim_products p ON o.product_code = p.product_code
    GROUP BY 
        s.store_type
)
SELECT 
    store_type,
    total_sales,
    ROUND(total_sales * 100.0 / SUM(total_sales) OVER (), 2) AS percentage_of_total_sales,
    order_count
FROM 
    sales_summary;
