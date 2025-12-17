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
-- Q62. Show customers ranked by order count.
-- Q63. Find nth highest pizza price using window function.
-- Q64. Show orders with difference from previous order.
-- Q65. Show average order value per month using partition.
-- Q66. Find repeat customers using row_number.
-- Q67. Show orders ranked within each customer.
-- Q68. Show pizzas ranked by revenue per category.
-- Q69. Show cumulative pizzas sold per category.
-- Q70. Find customers with 2nd highest spend in each city.
-- Q71. Show percentile rank of pizza prices.
-- Q72. Show ntile(4) distribution of customers by spend.
-- Q73. Show cumulative salary distribution of employees.
-- Q74. Find pizzas with highest order quantity per month.
-- Q75. Show customers’ first and last order dates using window functions.
