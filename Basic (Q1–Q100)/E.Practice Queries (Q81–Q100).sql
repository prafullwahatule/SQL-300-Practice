-- E. Practice Queries (Q81–Q100)

-- Q81. Get distinct cities from customers.
SELECT DISTINCT city FROM customers;

-- Q82. Find distinct categories from pizzas.
SELECT DISTINCT category FROM pizzas;

-- Q83. Show total number of unique pizzas ordered.
SELECT COUNT(DISTINCT pizza_name) AS 
Unique_Pizza FROM pizzas;

-- Q84. Find unique order dates.
SELECT DISTINCT order_date FROM orders;

-- Q85. Show pizzas never ordered.
SELECT pizza_id, pizza_name
FROM pizzas
WHERE pizza_id NOT IN (SELECT pizza_id FROM order_items);

-- Q86. Find customers who never placed an order.
SELECT * 
FROM customers
WHERE customer_id NOT IN (
    SELECT customer_id 
    FROM orders
);

-- Q87. Show orders with more than 1 item.
SELECT * FROM order_items
WHERE quantity > 1;

-- Q88. Get customers who placed multiple orders.
SELECT c.customer_id, c.first_name
FROM customers c
JOIN (
    SELECT customer_id
    FROM orders
    GROUP BY customer_id
    HAVING COUNT(order_id) > 1
) o ON c.customer_id = o.customer_id;

-- Q89. Find total orders per city.
SELECT 
c.city,
COUNT(o.order_id)  AS Total_Order_Per_City
FROM customers c
JOIN orders o 
ON c.customer_id = o.customer_id
GROUP BY c.city; 

-- Q90. Get avg price of Veg pizzas.
SELECT AVG(price) FROM  pizzas
WHERE category = 'Veg';

-- Q91. Find revenue from Non-Veg pizzas.
SELECT SUM(p.price * oi.quantity) AS Total_Revenue
FROM pizzas p
JOIN order_items oi
ON oi.pizza_id = p.pizza_id
WHERE category = 'Non-Veg';

-- Q92. Show pizzas ordered by Priya.
SELECT p.pizza_name, p.category, CONCAT(c.first_name, ' ', c.last_name) AS Name
FROM pizzas p
JOIN order_items oi
ON oi.pizza_id = p.pizza_id
JOIN  orders o
ON o.order_id = oi.order_id
JOIN customers c
ON c.customer_id = o.customer_id
WHERE first_name = 'Priya';

-- Q93. Find orders placed in June.
SELECT * FROM orders
WHERE MONTH(order_date) = 6;

-- Q94. Show all pizzas ordered by customer Arjun.
SELECT p.pizza_name, p.category, CONCAT(c.first_name, ' ', c.last_name) AS FullName
FROM pizzas p
JOIN order_items oi
ON oi.pizza_id = p.pizza_id
JOIN  orders o
ON o.order_id = oi.order_id
JOIN customers c
ON c.customer_id = o.customer_id
WHERE first_name = 'Arjun';

-- Q95. List orders where total_amount equals pizza price*quantity.
SELECT 
    o.order_id, 
    o.total_amount, 
    SUM(p.price * oi.quantity) AS Total_Amount
FROM orders o
JOIN order_items oi 
	ON o.order_id = oi.order_id
JOIN pizzas p 
	ON p.pizza_id = oi.pizza_id
GROUP BY o.order_id, o.total_amount
	HAVING o.total_amount = SUM(p.price * oi.quantity);

-- Q96. Show max quantity of pizza ordered in single order.
SELECT order_id, SUM(quantity) AS total_pizzas
FROM order_items
GROUP BY order_id
ORDER BY total_pizzas DESC
LIMIT 1;

-- Q97. Find customers who ordered Paneer Tikka.
SELECT DISTINCT
    CONCAT(c.first_name, ' ', c.last_name) AS FullName, 
    p.pizza_name, 
    p.category
FROM customers c
JOIN orders o 
	ON o.customer_id = c.customer_id
JOIN order_items oi 
	ON oi.order_id = o.order_id
JOIN pizzas p 
	ON p.pizza_id = oi.pizza_id
WHERE p.pizza_name = 'Paneer Tikka';

-- Q98. Show orders with more than 500 amount.
SELECT * FROM orders
WHERE total_amount > 500;

-- Q99. List all pizzas with price divisible by 100.
SELECT * FROM pizzas
WHERE price / 100 = 0;

-- Q100. Find customers whose last name is ‘Singh’.
SELECT * FROM customers
WHERE last_name = 'Singh';