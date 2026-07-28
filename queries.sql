SELECT * FROM ecommerce_sales
LIMIT 50;

--   Step 1  --  
                 -- Data verification --

-- Total rows count --

SELECT COUNT(*) AS total_rows
FROM ecommerce_sales;     -- Total Rows = 541909

-- First 10 rows views

SELECT * FROM ecommerce_sales
LIMIT 10;				  

-- Checking how many records are NULL in dataset and how many records are negative returns? --

SELECT COUNT(*) FILTER(WHERE invoice_no IS NULL) AS missing_invoice,
	   COUNT(*) FILTER(WHERE stock_code IS NULL) AS missing_stock_code,
	   COUNT(*) FILTER(WHERE description IS NULL) AS empty_description,
	   COUNT(*) FILTER(WHERE quantity IS NULL) AS missing_quantity,
	   COUNT(*) FILTER(WHERE invoice_date IS NULL) AS missing_date,
	   COUNT(*) FILTER(WHERE unit_price IS NULL) AS missing_unit_price,
	   COUNT(*) FILTER(WHERE customer_id IS NULL) AS missing_customers,
	   COUNT(*) FILTER(WHERE country IS NULL) AS missing_country,
	   COUNT(*) FILTER(WHERE quantity<0) AS total_negative_returns
FROM ecommerce_sales;					-- Missing Customers = 135080,  Total_returns = 10624



--   Step 2 --
               -- Key Business Analytics Tasks --

-- 1. Revenue Trends --



SELECT SUM(quantity*unit_price) AS total_revenue,
       COUNT(DISTINCT CASE WHEN invoice_no NOT LIKE 'C%' AND quantity>0 THEN invoice_no END) AS total_valid_orders,
	   ROUND(SUM(quantity*unit_price)/
       COUNT(DISTINCT CASE WHEN invoice_no NOT LIKE 'C%' AND quantity>0 THEN invoice_no END),2) AS avg_order_value
FROM ecommerce_sales;       --  Total Revenue = 9747747.93,  Total Unique Orders = 20728, avg_order_value = 470.27



-- Step 3

         --  Month-on-Month Revenue Growth

SELECT TO_CHAR(invoice_date,'YYYY-MM') AS month,
       SUM(quantity*unit_price) AS total_revenue,
	   COUNT(DISTINCT invoice_no)
FROM ecommerce_sales
GROUP BY 1
ORDER BY 1 ;



-- Top 10 Products who generated most revenue.

SELECT description,
       SUM(quantity) AS total_quantity_sold,
	   SUM(quantity*unit_price) AS total_revenue
FROM ecommerce_sales
WHERE description IS NOT NULL
GROUP BY 1
ORDER BY 3 DESC
LIMIT 10;


-- Top 10 High value customers whose spend most.

SELECT customer_id,
       COUNT(DISTINCT invoice_no) AS total_orders,
	   ROUND(SUM(quantity*unit_price),2) AS total_spent
FROM ecommerce_sales
WHERE customer_id IS NOT NULL
GROUP BY 1
ORDER BY 3 DESC
LIMIT 10;


-- Which top 10 countries produce most of the revenue?

SELECT country,
       SUM(quantity*unit_price) AS total_revenue
FROM ecommerce_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;



--Create view



CREATE VIEW vw_ecommerce_clean AS
  SELECT 
	    invoice_no, stock_code, description,
		quantity, invoice_date, unit_price,
		customer_id,country,(quantity*unit_price) AS net_amount
FROM ecommerce_sales;

SELECT * FROM vw_ecommerce_clean
LIMIT 10;
