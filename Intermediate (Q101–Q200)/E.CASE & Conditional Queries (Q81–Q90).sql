-- E. CASE & CONDITIONAL QUERIES (Q81–Q90)

-- Q81. Classify pizzas as 'Budget' (<300) or 'Premium' (>=300)
SELECT 
    pizza_id,
    pizza_name,
    price,
    CASE 
        WHEN price < 300 THEN 'Budget'
        ELSE 'Premium'
    END AS category
FROM pizzas;

-- Q82. Show customers labeled as "New" (joined after June 2022) or "Old"
SELECT 
    customer_id,
    CONCAT(first_name, ' ', last_name) AS full_name,
    join_date,
    CASE
        WHEN join_date > '2022-06-01' THEN 'New'
        ELSE 'Old'
    END AS cust_label
FROM customers;

-- Q83. Categorize orders as 'Small' (<500), 'Medium' (500–800), 'Large' (>800)
SELECT 
    order_id,
    order_date,
    total_amount,
    CASE
        WHEN total_amount < 500 THEN 'Small'
        WHEN total_amount BETWEEN 500 AND 800 THEN 'Medium'
        ELSE 'Large'
    END AS order_category
FROM orders;

-- Q84. Show revenue per city with category (Low <1000, High >=1000)
SELECT 
    c.city,
    p.category,
    SUM(p.price * oi.quantity) AS revenue, 
    CASE 
        WHEN SUM(p.price * oi.quantity) < 1000 THEN 'Low'
        ELSE 'High'
    END AS revenue_category
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN pizzas p ON oi.pizza_id = p.pizza_id
GROUP BY c.city, p.category;

-- Q85. Show pizzas categorized as "Small", "Medium", "Large" by size
SELECT 
    pizza_id,
    pizza_name,
    category,
    size,
    price,
    CASE
        WHEN size = 'S' THEN 'Small'
        WHEN size = 'M' THEN 'Medium'
        WHEN size = 'L' THEN 'Large'
        ELSE 'Not Defined'
    END AS pizza_size
FROM pizzas;

-- Q86. Find customers and tag them if they ordered "Non-Veg"
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    CASE
        WHEN SUM(CASE WHEN p.category = 'Non-Veg' THEN 1 ELSE 0 END) > 0 
            THEN 'Tag'
        ELSE 'No Tag'
    END AS tags
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN pizzas p ON oi.pizza_id = p.pizza_id
GROUP BY c.customer_id, customer_name;

-- Q87. Show pizzas and label them "Cheap" (<250) or "Expensive"
SELECT 
    p.pizza_id,
    p.pizza_name,
    p.category,
    p.size,
    p.price,
    CASE
        WHEN p.price < 250 THEN 'Cheap'
        ELSE 'Expensive'
    END AS pizza_label
FROM pizzas p;

-- Q88. Label orders as 'Single Pizza' or 'Multiple Pizza'
SELECT
    o.order_id,
    SUM(oi.quantity) AS total_pizzas,
    CASE 
        WHEN SUM(oi.quantity) = 1 THEN 'Single Pizza'
        ELSE 'Multiple Pizza'
    END AS labels
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY o.order_id;

-- Q89. Show pizzas with remark if ordered more than 5 times
SELECT 
    p.pizza_id,
    p.pizza_name,
    SUM(oi.quantity) AS total_order,
    CASE
        WHEN SUM(oi.quantity) > 5 THEN 'Remark'
        ELSE 'No-Remark'
    END AS remark
FROM pizzas p
JOIN order_items oi ON p.pizza_id = oi.pizza_id
GROUP BY p.pizza_id;

-- Q90. Categorize customers as 'Active' (>2 orders) or 'Inactive'
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    COUNT(o.order_id) AS total_orders,
    CASE 
        WHEN COUNT(o.order_id) > 2 THEN 'Active'
        ELSE 'Inactive'
    END AS status_of_users
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, customer_name;
