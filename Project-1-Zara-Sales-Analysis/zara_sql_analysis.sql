SHOW DATABASES;
USE my_database;
select * from my_database.zara_analysis;
-- Which product categories generate the highest sales volume, and what is their contribution percentage to overall sales?
SELECT 
    terms,
    SUM(sales_volume) AS total_sales,
    ROUND(SUM(sales_volume) * 100.0 / 
         (SELECT SUM(sales_volume) FROM zara_analysis), 2) AS contribution_percent
FROM zara_analysis
GROUP BY terms
ORDER BY total_sales DESC;

-- How do promotions impact sales volume—what uplift do we see in units sold for promoted vs. non-promoted products?
SELECT 
    promotion,
    AVG(sales_volume) AS avg_sales_volume,
    SUM(sales_volume) AS total_sales_volume
FROM zara_analysis
GROUP BY promotion;

-- Which product positions drive the highest sales, and how does visibility affect performance?
SELECT 
    product_position,
    SUM(sales_volume) AS total_sales
FROM zara_analysis
GROUP BY product_position
ORDER BY total_sales DESC;

-- Is there a relationship between product price and sales volume—do lower-priced or premium products sell better across categories?
SELECT 
    CASE 
        WHEN price < 50 THEN 'Low Price'
        WHEN price BETWEEN 50 AND 100 THEN 'Mid Price'
        ELSE 'Premium'
    END AS price_range,
    SUM(sales_volume) AS total_sales
FROM zara_analysis
GROUP BY price_range
ORDER BY total_sales DESC;

-- Which categories rely the most on promotions to drive sales, and where can the company reduce discount dependency?
SELECT
    terms,
    SUM(CASE WHEN promotion = '1' THEN sales_volume ELSE 0 END) AS promo_sales,
    SUM(sales_volume) AS total_sales,
    ROUND(
        SUM(CASE WHEN promotion = '1' THEN sales_volume ELSE 0 END) * 100.0 
        / SUM(sales_volume), 2
    ) AS promotion_dependency_percent
FROM zara_analysis
GROUP BY terms
ORDER BY promotion_dependency_percent DESC;