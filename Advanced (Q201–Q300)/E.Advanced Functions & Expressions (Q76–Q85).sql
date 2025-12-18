-- E. Advanced Functions & Expressions (Q76–Q85)

-- Q76. Show orders where total_amount is odd/even.
SELECT
    order_id,
    total_amount,
    CASE
        WHEN MOD(total_amount, 2) = 0 THEN 'Even'
        ELSE 'Odd'
    END AS amount_type
FROM orders;

-- Q77. Find pizzas where name length > 10.
SELECT
    *,
    LENGTH(pizza_name) AS pizza_name_length
FROM pizzas
WHERE LENGTH(pizza_name) > 10;

-- Q78. Show revenue in words (CAST/CONVERT if supported).
SELECT
    p.pizza_id,
    p.pizza_name,
    SUM(oi.quantity * p.price) AS revenue,
    CAST(SUM(oi.quantity * p.price) AS CHAR) AS revenue_text
FROM pizzas p
JOIN order_items oi
    ON p.pizza_id = oi.pizza_id
GROUP BY p.pizza_id, p.pizza_name;

-- Q79. Show month name of order_date.
SELECT
    order_id,
    customer_id,
    order_date,
    total_amount,
    MONTHNAME(order_date) AS month_name
FROM orders;

-- Q80. Find difference in salary between max and min in employees.
SELECT
    MAX(salary) - MIN(salary) AS salary_difference
FROM employees;

-- based on employees role

SELECT
    role,
    MAX(salary) - MIN(salary) AS salary_diff_per_role
FROM employees
GROUP BY role;


-- Q81. Replace "Veg" with "Vegetarian" in pizza names.
-- Enable safe updates mode
SET SQL_SAFE_UPDATES = 1;

-- Disable safe updates mode
SET SQL_SAFE_UPDATES = 0;

UPDATE pizzas
SET pizza_name = "Vegetarian"
WHERE pizza_name = "Veg";

-- Q82. Show reversed customer names.
SELECT
    first_name,
    last_name,
    CONCAT(REVERSE(first_name), '-', REVERSE(last_name)) AS reversed_name
FROM customers;

-- Q83. Find substring of pizza_name (first 5 chars).
SELECT
	pizza_name,
    LEFT(pizza_name,5) AS first_5_char
FROM pizzas;

-- Alternative Version Using SUBSTRING

SELECT
    pizza_name,
    SUBSTRING(pizza_name, 1, 5) AS first_5_char
FROM pizzas;

-- Q84. Show orders placed on Friday.
SELECT
    order_id,
    order_date,
    DAYNAME(order_date) AS day_name
FROM orders
WHERE DAYNAME(order_date) = 'Friday';

-- Q85. Show orders placed in last 30 days.
SELECT *
FROM orders
WHERE order_date >= DATE_SUB(CURRENT_DATE(), INTERVAL 30 DAY);
