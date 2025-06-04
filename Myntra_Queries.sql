
-- Myntra Dashboard SQL Queries
-- This script includes structured and commented queries for Power BI dashboard insights.

-- 1. List all customers and their cities
SELECT name, city FROM customer;

-- 2. Show all products in the 'Kids' category
SELECT * FROM products WHERE category = 'Kids';

-- 3. Get all completed orders
SELECT * FROM orders WHERE orderstatus = 'Completed';

-- 4. Total amount spent by each customer
SELECT customerid, SUM(totalamount) AS total_spend FROM orders GROUP BY customerid;

-- 5. Top 5 most expensive products
SELECT * FROM products ORDER BY price DESC LIMIT 5;

-- 6. Average rating per product
SELECT productid, ROUND(AVG(rating), 2) AS rating FROM productreviews GROUP BY productid;

-- 7. Orders with their delivery status
SELECT o.orderid, o.orderdate, d.deliverydate, d.deliverystatus
FROM orders o
JOIN delivery d ON o.orderid = d.orderid;

-- 8. Top 3 customers by total spending
SELECT c.customerid, c.name, SUM(o.totalamount) AS total_spending
FROM orders o
JOIN customer c ON o.customerid = c.customerid
GROUP BY c.customerid, c.name
ORDER BY total_spending DESC
LIMIT 3;

-- 9. Products that were never ordered
SELECT p.productid, p.productname
FROM products p
LEFT JOIN orderdetails od ON p.productid = od.productid
WHERE od.productid IS NULL;

-- 10. Customers who gave a rating of 5
SELECT DISTINCT c.customerid, c.name
FROM customer c
JOIN productreviews p ON c.customerid = p.customerid
WHERE p.rating = 5;

-- 11. Monthly Sales Trend
SELECT DATE_TRUNC('month', orderdate)::date AS month, SUM(totalamount) AS total_sales
FROM orders
GROUP BY month
ORDER BY month;

-- 12. Top 5 Cities by Number of Customers
SELECT city, COUNT(*) AS totalcustomer
FROM customer
GROUP BY city
ORDER BY totalcustomer DESC
LIMIT 5;

-- 13. Product Category Performance
SELECT p.category, COUNT(DISTINCT od.productid) AS productsold, SUM(od.finalamount) AS revenue
FROM orderdetails od
JOIN products p ON od.productid = p.productid
GROUP BY p.category
ORDER BY revenue DESC;

-- 14. Average Delivery Time (in days)
SELECT ROUND(AVG(deliverydate - dispatchdate), 2) AS avg_delivery_days
FROM delivery
WHERE deliverystatus = 'Delivered';

-- 15. Customers with Repeat Purchases
SELECT customerid, COUNT(*) AS repeat_orders
FROM orders
GROUP BY customerid
HAVING COUNT(*) > 1;

-- 16. Revenue per Customer Gender
SELECT c.gender, SUM(o.totalamount) AS revenue
FROM orders o
JOIN customer c ON o.customerid = c.customerid
GROUP BY c.gender;

-- 17. Monthly Sales Growth Rate
WITH monthlysales AS (
  SELECT DATE_TRUNC('month', orderdate)::date AS month, SUM(totalamount) AS totalsales
  FROM orders
  GROUP BY month
)
SELECT month, totalsales,
       LAG(totalsales) OVER (ORDER BY month) AS previousmonth,
       ROUND(100 * (totalsales - LAG(totalsales) OVER (ORDER BY month)) / 
             NULLIF(LAG(totalsales) OVER (ORDER BY month), 0), 2) AS growthratepercent
FROM monthlysales;
