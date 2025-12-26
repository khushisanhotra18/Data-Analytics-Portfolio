SELECT * FROM income_statement;
SELECT * FROM balance_sheet;
SELECT * FROM cash_flow;

DESCRIBE income_statement;
DESCRIBE balance_sheet;
DESCRIBE cash_flow;

Create view tata_motors_kpis AS
SELECT i.year, i.sales, b.total_assets, c.cash_from_operating_activity
FROM income_statement i
JOIN balance_sheet b ON i.year = b.year
JOIN cash_flow c ON i.year = c.year;

-- Revenue trend of Tata Motors in last 5 years?
SELECT year, sales, revenue_growth_
FROM income_statement
ORDER BY year;

-- Is Company profitable?
SELECT year, net_profit, net_profit_margin_
FROM income_statement;

-- Is cash being obtained from core operations or not?
SELECT year, cash_from_operating_activity
FROM cash_flow;

-- How strong is cash flow according to sales growth?
SELECT i.year, i.sales, c.cash_from_operating_activity
FROM income_statement i
JOIN cash_flow c ON i.year = c.year;

-- Risk was highest in which year?
SELECT year,
CASE 
 WHEN net_profit_margin_ < 8 THEN 'High Risk'
 WHEN net_profit_margin_ BETWEEN 8 AND 15 THEN 'Medium Risk'
 ELSE 'Low Risk'
END AS risk_level
FROM income_statement;