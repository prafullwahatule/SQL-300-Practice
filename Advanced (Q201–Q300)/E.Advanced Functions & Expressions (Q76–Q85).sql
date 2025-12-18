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

-- Q81. Replace "Veg" with "Vegetarian" in pizza names.
-- Q82. Show reversed customer names.
-- Q83. Find substring of pizza_name (first 5 chars).
-- Q84. Show orders placed on Friday.
-- Q85. Show orders placed in last 30 days.
