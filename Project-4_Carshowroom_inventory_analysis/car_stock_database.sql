select * from car_showroom.cars_inventory;
SELECT COUNT(*) AS total_rows FROM cars_inventory;
SELECT 
  SUM(CASE WHEN price IS NULL THEN 1 ELSE 0 END) AS price_nulls,
  SUM(CASE WHEN stock_qty IS NULL THEN 1 ELSE 0 END) AS stock_nulls
FROM cars_inventory;

CREATE VIEW price_stock AS
SELECT
  CASE 
    WHEN price < 30000 THEN 'Budget'
     WHEN price BETWEEN 30000 AND 60000 THEN 'Mid Range'
    ELSE 'Premium'
  END AS price_band,
  SUM(stock_qty) AS stock
FROM cars_inventory
GROUP BY price_band;

CREATE VIEW brand_stock AS
SELECT 
  brand,
  SUM(stock_qty) AS total_stock
FROM cars_inventory
GROUP BY brand
ORDER BY total_stock DESC;

CREATE VIEW cars_status AS
SELECT 
  status,
  COUNT(car_id) AS cars
FROM cars_inventory
GROUP BY status;

CREATE VIEW old_stock AS
SELECT 
  brand,
  model,
  year,
  stock_qty
FROM cars_inventory
WHERE year <= 2019
  AND stock_qty > 0
ORDER BY stock_qty DESC;

SELECT 
  brand,
  model,
  year,
  price,
  stock_qty
FROM cars_inventory
WHERE stock_level = 'Low in stock'
   OR stock_level = 'Out of Stock'
ORDER BY stock_qty;

CREATE VIEW total_inventory AS
SELECT 
  stock_level,
  COUNT(car_id) AS total_cars
FROM cars_inventory
GROUP BY stock_level;

CREATE VIEW band_stock_percent AS
SELECT 
  brand,
  SUM(stock_qty) AS total_stock,
  ROUND(
    SUM(stock_qty) * 100.0 / SUM(SUM(stock_qty)) OVER (),
    2
  ) AS stock_percentage
FROM cars_inventory
GROUP BY brand;

WITH inventory_cte AS (
  SELECT 
    car_id,
    brand,
    model,
    year,
    price,
    stock_qty,
    CASE 
      WHEN stock_qty = 0 THEN 'Out of Stock'
      WHEN stock_qty BETWEEN 1 AND 5 THEN 'Low in stock'
      ELSE 'In Stock'
    END AS stock_level
  FROM cars_inventory
)
SELECT stock_level, COUNT(*) AS total_cars
FROM inventory_cte
GROUP BY stock_level;
