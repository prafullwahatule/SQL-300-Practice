-- F. SET OPERATIONS (Q91–Q100)

-- Q91. Find all customer_ids who ordered pizzas (UNION with no duplicates).
SELECT customer_id
FROM customers
UNION
SELECT customer_id
FROM orders;

-- Q92. Find customer_ids who ordered Veg pizzas (UNION).
SELECT o.customer_id 
FROM orders o
JOIN order_items oi
ON o.order_id = oi.order_id
JOIN pizzas p
ON oi.pizza_id = p.pizza_id
WHERE p.category = 'Veg'
UNION
SELECT o.customer_id 
FROM orders o
JOIN order_items oi
ON o.order_id = oi.order_id
JOIN pizzas p
ON oi.pizza_id = p.pizza_id
WHERE p.category = 'Veg';

-- OR

SELECT DISTINCT o.customer_id 
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN pizzas p ON oi.pizza_id = p.pizza_id
WHERE p.category = 'Veg';

-- Q93. Find customer_ids who ordered Non-Veg pizzas (UNION).
SELECT o.customer_id 
FROM orders o
JOIN order_items oi
ON o.order_id = oi.order_id
JOIN pizzas p
ON oi.pizza_id = p.pizza_id
WHERE p.category = 'Non-Veg'
UNION
SELECT o.customer_id 
FROM orders o
JOIN order_items oi
ON o.order_id = oi.order_id
JOIN pizzas p
ON oi.pizza_id = p.pizza_id
WHERE p.category = 'Non-Veg';
-- OR

SELECT DISTINCT o.customer_id 
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN pizzas p ON oi.pizza_id = p.pizza_id
WHERE p.category = 'Non-Veg';

-- Q94. Find customer_ids who ordered both Veg AND Non-Veg (INTERSECT).
SELECT DISTINCT o.customer_id
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN pizzas p ON oi.pizza_id = p.pizza_id
WHERE p.category = 'Veg'
INTERSECT
SELECT DISTINCT o.customer_id
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN pizzas p ON oi.pizza_id = p.pizza_id
WHERE p.category = 'Non-Veg';

-- INTERSECT doesn't support my sql

SELECT o.customer_id
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN pizzas p ON oi.pizza_id = p.pizza_id
WHERE p.category IN ('Veg', 'Non-Veg')
GROUP BY o.customer_id
HAVING COUNT(DISTINCT p.category) = 2;

-- Q95. Find customers who ordered Veg but not Non-Veg (EXCEPT).
SELECT DISTINCT o.customer_id
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN pizzas p ON oi.pizza_id = p.pizza_id
WHERE p.category = 'Veg'
EXCEPT  -- EXCEPT not supported by sql
SELECT DISTINCT o.customer_id
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN pizzas p ON oi.pizza_id = p.pizza_id
WHERE p.category = 'Non-Veg';

-- OR

SELECT DISTINCT o.customer_id
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN pizzas p ON oi.pizza_id = p.pizza_id
WHERE p.category = 'Veg'
AND o.customer_id NOT IN (
    SELECT o2.customer_id
    FROM orders o2
    JOIN order_items oi2 ON o2.order_id = oi2.order_id
    JOIN pizzas p2 ON oi2.pizza_id = p2.pizza_id
    WHERE p2.category = 'Non-Veg'
);

-- Q96. Find customers who ordered Non-Veg but not Veg (EXCEPT).
SELECT o.customer_id
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN pizzas p ON oi.pizza_id = p.pizza_id
GROUP BY o.customer_id
HAVING SUM(p.category = 'Non-Veg') > 0
   AND SUM(p.category = 'Veg') = 0;

-- Q97. Get all pizza_ids ordered across all orders (UNION).
SELECT pizza_id FROM order_items
UNION
SELECT pizza_id FROM order_items;

-- Q98. Find common pizzas ordered in June and July (INTERSECT).
SELECT DISTINCT oi.pizza_id
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE MONTH(o.order_date) = 6
AND oi.pizza_id IN (
    SELECT DISTINCT oi2.pizza_id
    FROM orders o2
    JOIN order_items oi2 ON o2.order_id = oi2.order_id
    WHERE MONTH(o2.order_date) = 7
);

-- Q99. Find pizzas ordered in June but not in July (EXCEPT).
SELECT DISTINCT oi.pizza_id
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE MONTH(o.order_date) = 6
AND oi.pizza_id NOT IN (
    SELECT DISTINCT oi2.pizza_id
    FROM orders o2
    JOIN order_items oi2 ON o2.order_id = oi2.order_id
    WHERE MONTH(o2.order_date) = 7
);

-- Q100. Get all distinct pizza categories from pizzas and ordered pizzas (UNION).
SELECT DISTINCT category
FROM pizzas

UNION

SELECT DISTINCT p.category
FROM order_items oi
JOIN pizzas p ON oi.pizza_id = p.pizza_id;