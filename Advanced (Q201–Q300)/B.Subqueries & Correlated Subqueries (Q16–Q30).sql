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
SELECT c.customer_name, c.Cu

-- Q21. Show employees earning more than avg salary in their role.

-- Q22. Find pizzas ordered by customers from Delhi only.

-- Q23. Show orders placed by the customer with max orders.

-- Q24. Find customers who ordered pizza also ordered by Sneha.

-- Q25. Show employees who delivered more orders than employee Suraj.

-- Q26. Find pizzas never ordered by customers from Mumbai.

-- Q27. Show orders containing the highest-priced pizza.

-- Q28. Find customers who placed more orders than average orders per customer.

-- Q29. Show delivery boy with least deliveries.

-- Q30. Find pizzas ordered in all orders by Priya.
