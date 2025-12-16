-- B.Subqueries & Correlated Subqueries (Q16–Q30)

-- Q16. Find customers who ordered more than average order amount.
SELECT c.customer_id,
       CONCAT(c.first_name, ' ', c.last_name) AS FullName,
       c.email,
       c.city,
       c.join_date,
       o.total_amount
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
WHERE o.total_amount > (SELECT AVG(total_amount) FROM orders);

-- Q17. Show pizzas more expensive than average pizza price in their category.
SELECT 
    p.pizza_id,
    p.pizza_name,
    p.category,
    p.size,
    p.price
FROM pizzas p
WHERE p.price > (
    SELECT AVG(p2.price)
    FROM pizzas p2
    WHERE p2.category = p.category
);

-- Q18. Find customers whose total spend is more than customer Arjun’s spend.
SELECT 
    c.first_name,
    c.last_name,
    SUM(o.total_amount) AS total_spend
FROM customers c
JOIN orders o 
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING SUM(o.total_amount) > (
    SELECT SUM(o.total_amount)
    FROM customers c
    JOIN orders o 
        ON c.customer_id = o.customer_id
    WHERE c.first_name = 'Arjun'
);

-- Q19. List orders containing pizzas not ordered by Priya
SELECT DISTINCT 
    o.order_id,
    c.first_name AS customer_name,
    p.pizza_name
FROM orders o
JOIN order_items oi 
    ON o.order_id = oi.order_id
JOIN pizzas p 
    ON oi.pizza_id = p.pizza_id
JOIN customers c
    ON o.customer_id = c.customer_id
WHERE p.pizza_id NOT IN (
    SELECT DISTINCT oi2.pizza_id
    FROM orders o2
    JOIN order_items oi2 
        ON o2.order_id = oi2.order_id
    JOIN customers c2 
        ON o2.customer_id = c2.customer_id
    WHERE c2.first_name = 'Priya'
);

-- Q20. Find customers who never ordered the cheapest pizza.
SELECT c.customer_id, CONCAT(c.first_name,' ', c.last_name)
FROM customers c
WHERE c.customer_id NOT IN(
	SELECT o.customer_id
    FROM orders o
    JOIN order_items oi
    ON oi.order_id = o.order_id
    JOIN pizzas p
    ON p.pizza_id = oi.pizza_id
    WHERE p.price = (SELECT MIN(price) FROM pizzas));

-- Q21. Show employees earning more than avg salary in their role.
SELECT *
FROM employees e1
WHERE salary > (
    SELECT AVG(salary)
    FROM employees e2
    WHERE e2.role = e1.role
);

-- Q22. Find pizzas ordered by customers from Delhi only.
SELECT pizza_name FROM pizzas p
WHERE pizza_id IN (
	SELECT p2.pizza_id FROM pizzas p2
    JOIN order_items oi
    ON oi.pizza_id = p2.pizza_id
    JOIN orders o
    ON o.order_id = oi.order_id
    JOIN customers c
    ON c.customer_id = o.customer_id
    WHERE c.city = "Delhi");

-- Without Subquery 
SELECT DISTINCT p.pizza_name
FROM pizzas p
JOIN order_items oi ON oi.pizza_id = p.pizza_id
JOIN orders o ON o.order_id = oi.order_id
JOIN customers c ON c.customer_id = o.customer_id
WHERE c.city = 'Delhi';

-- Q23. Show orders placed by the customer with max orders.
SELECT *
FROM orders
WHERE customer_id = (
    SELECT customer_id
    FROM orders
    GROUP BY customer_id
    ORDER BY COUNT(*) DESC
    LIMIT 1
);

-- Q24. Find customers who ordered pizza also ordered by Sneha.
SELECT DISTINCT c.customer_id, c.first_name
FROM customers c
JOIN orders o ON o.customer_id = c.customer_id
JOIN order_items oi ON oi.order_id = o.order_id
WHERE oi.pizza_id IN (
    SELECT oi2.pizza_id
    FROM orders o2
    JOIN order_items oi2 ON oi2.order_id = o2.order_id
    JOIN customers c2 ON c2.customer_id = o2.customer_id
    WHERE c2.first_name = 'Sneha'
);

-- Q25. Show employees who delivered more orders than employee Suraj.
SELECT e.employee_id, e.name
FROM employees e
JOIN deliveries d ON d.employee_id = e.employee_id
GROUP BY e.employee_id, e.name
HAVING COUNT(*) > (
    SELECT COUNT(*)
    FROM deliveries d2
    JOIN employees e2 ON e2.employee_id = d2.employee_id
    WHERE e2.name = 'Suraj'
);

-- Q26. Find pizzas never ordered by customers from Mumbai.
SELECT pizza_name
FROM pizzas
WHERE pizza_id NOT IN (
    SELECT oi.pizza_id
    FROM customers c
    JOIN orders o ON o.customer_id = c.customer_id
    JOIN order_items oi ON oi.order_id = o.order_id
    WHERE c.city = 'Mumbai'
);

-- Q27. Show orders containing the highest-priced pizza.
SELECT DISTINCT o.*
FROM orders o
JOIN order_items oi ON oi.order_id = o.order_id
JOIN pizzas p ON p.pizza_id = oi.pizza_id
WHERE p.price = (SELECT MAX(price) FROM pizzas);

-- Q28. Find customers who placed more orders than average orders per customer.
SELECT customer_id
FROM orders
GROUP BY customer_id
HAVING COUNT(*) > (
    SELECT AVG(order_count)
    FROM (
        SELECT COUNT(*) AS order_count
        FROM orders
        GROUP BY customer_id
    ) t
);

-- Q29. Show delivery boy with least deliveries.
SELECT e.employee_id, e.name
FROM employees e
JOIN deliveries d ON d.employee_id = e.employee_id
WHERE e.role = 'Delivery Boy'
GROUP BY e.employee_id, e.name
ORDER BY COUNT(*) ASC
LIMIT 1;

-- Q30. Find pizzas ordered in all orders by Priya.
SELECT p.pizza_name
FROM pizzas p
JOIN order_items oi ON oi.pizza_id = p.pizza_id
JOIN orders o ON o.order_id = oi.order_id
JOIN customers c ON c.customer_id = o.customer_id
WHERE c.first_name = 'Priya'
GROUP BY p.pizza_id, p.pizza_name
HAVING COUNT(DISTINCT o.order_id) = (
    SELECT COUNT(*)
    FROM orders o2
    JOIN customers c2 ON c2.customer_id = o2.customer_id
    WHERE c2.first_name = 'Priya'
);
