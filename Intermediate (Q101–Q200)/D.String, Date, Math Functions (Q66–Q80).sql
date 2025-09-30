-- D. STRING, DATE & MATH FUNCTIONS (Q66–Q80)

-- Q66. Show customer names in uppercase.
SELECT UPPER(CONCAT(first_name," ", last_name)) AS Cust_Name 
FROM customers;

-- Q67. Get email domains from customers.
SELECT SUBSTRING_INDEX(email, '@', -1) AS Email_Domain
FROM customers;

-- Q68. Show first 3 letters of pizza_name.
SELECT SUBSTR(pizza_name, 1, 3) AS Pizza_Prefix
FROM pizzas;

-- Q69. Concatenate customer first_name and last_name.
SELECT CONCAT(first_name," ", last_name) AS Cust_name 
FROM customers;

-- Q70. Show customer names with length of their name.
SELECT CONCAT(first_name," ", last_name) AS Cust_name, 
       LENGTH(CONCAT(first_name," ", last_name)) AS name_length
FROM customers;

-- Q71. Find orders placed in June only.
SELECT * 
FROM orders
WHERE MONTH(order_date) = 6;

-- Q72. Show month of each order_date.
SELECT MONTH(order_date) AS order_month 
FROM orders;

-- Q73. Extract year from join_date.
SELECT YEAR(join_date) AS join_year
FROM customers;

-- Q74. Find difference in days between join_date and first order.
SELECT MIN(o.order_date) AS first_order_date,
    DATEDIFF(MIN(o.order_date), c.join_date) AS days_diff
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_id;

-- Q75. Show total_amount rounded to nearest 100.
SELECT 
    total_amount,
    ROUND(total_amount, -2) AS rounded_total
FROM orders;

-- Q76. Get pizzas with price increased by 10%.
SELECT 
    pizza_id, 
    pizza_name, 
    price, 
    (price + (price * 0.10)) AS increased_price
FROM pizzas;

-- Q77. Find square root of highest pizza price.
SELECT SQRT(MAX(price)) AS square_root
FROM pizzas;

-- Q78. Show customers who joined in 2022.
SELECT * FROM customers
WHERE YEAR(join_date) = 2022;

-- Q79. List pizzas where name contains "Veg".
SELECT *
FROM pizzas
WHERE pizza_name LIKE '%Veg%';

-- Q80. Find orders placed on weekends.
SELECT *
FROM orders
WHERE DAYOFWEEK(order_date) IN (1,7);
