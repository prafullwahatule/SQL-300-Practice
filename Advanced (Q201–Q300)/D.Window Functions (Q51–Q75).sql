-- D. Window Functions (Q51–Q75)

-- Q51. Rank customers by total spending.
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    SUM(o.total_amount) AS total_spent,
    RANK() OVER (ORDER BY SUM(o.total_amount) DESC) AS spending_rank
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name;

-- Q52. Show row_number for pizzas ordered.
SELECT
    p.pizza_id,
    p.pizza_name,
    SUM(oi.quantity) AS total_quantity,
    ROW_NUMBER() OVER (ORDER BY SUM(oi.quantity) DESC) AS row_no
FROM pizzas p
JOIN order_items oi
    ON p.pizza_id = oi.pizza_id
GROUP BY p.pizza_id, p.pizza_name;

-- Q53. Show cumulative revenue by order_date.
SELECT
    o.order_date,
    SUM(oi.quantity * p.price) AS daily_revenue,
    SUM(SUM(oi.quantity * p.price)) 
        OVER (ORDER BY o.order_date) AS cumulative_revenue
FROM orders o
JOIN order_items oi
    ON oi.order_id = o.order_id
JOIN pizzas p
    ON p.pizza_id = oi.pizza_id
GROUP BY o.order_date
ORDER BY o.order_date;

-- Q54. Find running total of pizzas sold.
SELECT 
    oi.order_id,
    SUM(oi.quantity) AS total_quantity,
    SUM(SUM(oi.quantity)) OVER (ORDER BY oi.order_id) AS running_total
FROM order_items oi
GROUP BY oi.order_id
ORDER BY oi.order_id;

-- Q55. Show dense_rank of pizzas by price.
SELECT 
    pizza_id,
    pizza_name,
    category,
    size,
    price,
    DENSE_RANK() OVER(ORDER BY price) AS pizza_rank
FROM pizzas
ORDER BY price;

-- Q56. Show lag of order amount per customer.
SELECT 
    o.customer_id,
    o.order_id,
    o.order_date,
    o.total_amount,
    LAG(o.total_amount) 
        OVER(PARTITION BY o.customer_id ORDER BY o.order_date) AS lag_of_amount
FROM orders o
ORDER BY o.customer_id, o.order_date;

-- Q57. Show lead of order amount per customer.
SELECT 
    o.customer_id,
    o.order_id,
    o.order_date,
    o.total_amount,
    LEAD(o.total_amount) 
        OVER(PARTITION BY o.customer_id ORDER BY o.order_date) AS lead_of_amount
FROM orders o
ORDER BY o.customer_id, o.order_date;

-- Q58. Partition orders by city and rank them.
SELECT 
    city,
    customer_id,
    total_orders,
    RANK() OVER (PARTITION BY city ORDER BY total_orders DESC) AS city_rank
FROM (
    SELECT 
        c.city,
        o.customer_id,
        SUM(oi.quantity) AS total_orders
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY c.city, o.customer_id
) AS city_orders
ORDER BY city, city_rank;

-- Q59. Find top 2 pizzas by revenue in each category.
SELECT *
FROM (
    SELECT
        p.category,
        p.pizza_name,
        SUM(oi.quantity * p.price) AS revenue,
        DENSE_RANK() OVER(PARTITION BY p.category ORDER BY SUM(oi.quantity * p.price) DESC) AS cat_rank
    FROM pizzas p
    JOIN order_items oi
        ON oi.pizza_id = p.pizza_id
    GROUP BY p.category, p.pizza_name
) AS ranked_pizza
WHERE cat_rank <= 2
ORDER BY category, cat_rank;

-- Q60. Show revenue percent contribution of each pizza.
SELECT
    p.pizza_name,
    SUM(oi.quantity * p.price) AS revenue,
    ROUND(
        SUM(oi.quantity * p.price) * 100.0 / SUM(SUM(oi.quantity * p.price)) OVER(),
        2
    ) AS percentage
FROM pizzas p
JOIN order_items oi
    ON oi.pizza_id = p.pizza_id
GROUP BY p.pizza_name
ORDER BY percentage DESC;

-- Q61. Show moving average of total_amount per customer.
SELECT
    o.customer_id,
    CONCAT_WS(' ', c.first_name, c.last_name) AS customer_name,
    o.order_id,
    o.order_date,
    o.total_amount,
    AVG(o.total_amount) 
        OVER (
            PARTITION BY o.customer_id 
            ORDER BY o.order_date
            ROWS BETWEEN 1 PRECEDING AND CURRENT ROW
        ) AS moving_avg_amount
FROM orders o
JOIN customers c
    ON c.customer_id = o.customer_id
ORDER BY o.customer_id, o.order_date;

-- Q62. Show customers ranked by order count.
SELECT
    CONCAT_WS(' ', c.first_name, c.last_name) AS customer_name,
    COUNT(DISTINCT o.order_id) AS order_count,
    RANK() OVER (ORDER BY COUNT(DISTINCT o.order_id) DESC) AS rank_by_orders
FROM customers c
JOIN orders o 
    ON o.customer_id = c.customer_id
JOIN order_items oi
    ON oi.order_id = o.order_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY rank_by_orders;

-- Q63. Find nth highest pizza price using window function.
SELECT *
FROM (
    SELECT
        p.pizza_name,
        p.category,
        p.price,
        DENSE_RANK() OVER (ORDER BY p.price DESC) AS nth_rank
    FROM pizzas p
) AS ranked_pizza
WHERE nth_rank = 1;

-- Q64. Show orders with difference from previous order.
SELECT
    order_id,
    order_date,
    total_amount,
    total_amount 
      - LAG(total_amount) OVER (ORDER BY order_date) AS diff_from_prev_order
FROM orders
ORDER BY order_date;

-- Q65. Show average order value per month using partition.
SELECT
    order_id,
    order_date,
    MONTHNAME(order_date) AS month_name,
    total_amount,
    AVG(total_amount) 
        OVER (PARTITION BY MONTH(order_date)) AS avg_order_value_per_month
FROM orders
ORDER BY order_date;

-- Q66. Find repeat customers using row_number.
SELECT
    customer_id,
    customer_name,
    order_id,
    order_date
FROM (
    SELECT
        c.customer_id,
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
        o.order_id,
        o.order_date,
        ROW_NUMBER() 
            OVER (PARTITION BY c.customer_id ORDER BY o.order_date) AS rn
    FROM customers c
    JOIN orders o
        ON o.customer_id = c.customer_id
) t
WHERE rn > 1
ORDER BY customer_id, order_date;

-- Q67. Show orders ranked within each customer.
SELECT
	o.order_id,
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    o.order_date,
    o.total_amount,
    ROW_NUMBER() OVER (
    PARTITION BY c.customer_id 
    ORDER BY o.order_date
) AS cust_rank
FROM orders o
JOIN customers c
ON c.customer_id = o.customer_id;

-- Q68. Show pizzas ranked by revenue per category.
SELECT
	p.pizza_name,
    p.category,
    SUM(p.price * oi.quantity) AS revenue,
    DENSE_RANK() OVER(PARTITION BY p.category
    ORDER BY SUM(p.price * oi.quantity) DESC) AS cat_rank
FROM pizzas p
JOIN order_items oi
ON oi.pizza_id = p.pizza_id
GROUP BY p.pizza_id, p.pizza_name, p.category;

-- Q69. Show cumulative pizzas sold per category.
SELECT
    p.category,
    p.pizza_name,
    SUM(oi.quantity) AS pizzas_sold,
    SUM(SUM(oi.quantity)) OVER (
        PARTITION BY p.category
        ORDER BY p.pizza_name
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_pizzas_sold
FROM pizzas p
JOIN order_items oi
ON oi.pizza_id = p.pizza_id
GROUP BY p.category, p.pizza_name
ORDER BY p.category, p.pizza_name;

-- Q70. Find customers with 2nd highest spend in each city.
SELECT *
FROM (
    SELECT
        c.customer_id,
        CONCAT(c.first_name, ' ', c.last_name) AS cust_name,
        c.city,
        SUM(p.price * oi.quantity) AS total_spend,
        DENSE_RANK() OVER (
            PARTITION BY c.city
            ORDER BY SUM(p.price * oi.quantity) DESC
        ) AS rank_by_city
    FROM customers c
    JOIN orders o
        ON o.customer_id = c.customer_id
    JOIN order_items oi
        ON oi.order_id = o.order_id
    JOIN pizzas p
        ON p.pizza_id = oi.pizza_id
    GROUP BY 
        c.customer_id,
        c.first_name,
        c.last_name,
        c.city
) t
WHERE rank_by_city = 2;

-- Q71. Show percentile rank of pizza prices.
SELECT
    pizza_name,
    price,
    PERCENT_RANK() OVER (ORDER BY price) AS price_percentile
FROM pizzas
ORDER BY price;

-- Q72. Show ntile(4) distribution of customers by spend.
SELECT
    c.customer_id,
    CONCAT(first_name, ' ', last_name) AS cust_name,
    SUM(p.price * oi.quantity) AS total_spend,
    NTILE(4) OVER (ORDER BY SUM(p.price * oi.quantity)) AS quartile
FROM customers c
JOIN orders o
    ON o.customer_id = c.customer_id
JOIN order_items oi
    ON oi.order_id = o.order_id
JOIN pizzas p
    ON p.pizza_id = oi.pizza_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_spend;

-- Q73. Show cumulative salary distribution of employees.
SELECT
    employee_id,
    name,
    role,
    salary,
    SUM(salary) OVER (
        ORDER BY salary
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_salary
FROM employees
ORDER BY salary;
    
-- Q74. Find pizzas with highest order quantity per month.
SELECT
    pizza_name,
    MONTHNAME(STR_TO_DATE(month_num, '%m')) AS month_name,
    total_count
FROM (
    SELECT
        p.pizza_name,
        MONTH(o.order_date) AS month_num,
        SUM(oi.quantity) AS total_count,
        RANK() OVER (
            PARTITION BY MONTH(o.order_date)
            ORDER BY SUM(oi.quantity) DESC
        ) AS rank_in_month
    FROM pizzas p
    JOIN order_items oi
        ON p.pizza_id = oi.pizza_id
    JOIN orders o
        ON o.order_id = oi.order_id
    GROUP BY p.pizza_name, MONTH(o.order_date)
) t
WHERE rank_in_month = 1
ORDER BY month_num;

-- Q75. Show customers’ first and last order dates using window functions.
SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS cust_name,
    MIN(order_date) OVER (PARTITION BY customer_id) AS first_order_date,
    MAX(order_date) OVER (PARTITION BY customer_id) AS last_order_date
FROM orders o
JOIN customers c
    ON c.customer_id = o.customer_id
ORDER BY customer_id;

