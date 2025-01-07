SELECT 
    SUM("staff numbers") AS total_staff_in_UK
FROM 
    dim_stores
WHERE 
    country_code = 'GB';
