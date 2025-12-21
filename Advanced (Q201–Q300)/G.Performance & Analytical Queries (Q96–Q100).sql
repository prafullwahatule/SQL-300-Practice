-- G. Performance & Analytical Queries (Q96–Q100)

-- Q96. Show customers who ordered all categories of pizzas.
SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name
FROM customers c
JOIN orders o
    ON o.customer_id = c.customer_id
JOIN order_items oi
    ON oi.order_id = o.order_id
JOIN pizzas p
    ON p.pizza_id = oi.pizza_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(DISTINCT p.category) = (
    SELECT COUNT(DISTINCT category)
    FROM pizzas
);

-- Q97. Find pizzas never delivered (but ordered).
SELECT DISTINCT
    p.pizza_id,
    p.pizza_name
FROM pizzas p
JOIN order_items oi
    ON p.pizza_id = oi.pizza_id
JOIN orders o
    ON o.order_id = oi.order_id
LEFT JOIN deliveries d
    ON d.order_id = o.order_id
WHERE d.delivery_id IS NULL;

-- Q98. Show most cancelled orders by city.
SELECT
    c.city,
    COUNT(o.order_id) AS cancelled_orders
FROM customers c
JOIN orders o
    ON o.customer_id = c.customer_id
JOIN deliveries d
    ON d.order_id = o.order_id
WHERE d.status = 'Cancelled'
GROUP BY c.city
ORDER BY cancelled_orders DESC;

-- Q99. Find customer who ordered maximum unique pizzas.
SELECT
    customer_id,
    customer_name,
    unique_pizzas
FROM (
    SELECT
        c.customer_id,
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
        COUNT(DISTINCT oi.pizza_id) AS unique_pizzas,
        RANK() OVER (ORDER BY COUNT(DISTINCT oi.pizza_id) DESC) AS rnk
    FROM customers c
    JOIN orders o
        ON o.customer_id = c.customer_id
    JOIN order_items oi
        ON oi.order_id = o.order_id
    GROUP BY c.customer_id, c.first_name, c.last_name
) t
WHERE rnk = 1;

-- Q100. Show top 3 customers contributing to 50% of revenue.
WITH customer_revenue AS (
    SELECT
        c.customer_id,
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
        SUM(oi.quantity * p.price) AS revenue
    FROM customers c
    JOIN orders o
        ON o.customer_id = c.customer_id
    JOIN order_items oi
        ON oi.order_id = o.order_id
    JOIN pizzas p
        ON p.pizza_id = oi.pizza_id
    GROUP BY c.customer_id, c.first_name, c.last_name
),
revenue_distribution AS (
    SELECT
        *,
        SUM(revenue) OVER () AS total_revenue,
        SUM(revenue) OVER (ORDER BY revenue DESC) AS cumulative_revenue
    FROM customer_revenue
)
SELECT
    customer_id,
    customer_name,
    revenue,
    ROUND((cumulative_revenue / total_revenue) * 100, 2) AS cumulative_percentage
FROM revenue_distribution
WHERE (cumulative_revenue / total_revenue) <= 0.50
ORDER BY revenue DESC
LIMIT 3;

