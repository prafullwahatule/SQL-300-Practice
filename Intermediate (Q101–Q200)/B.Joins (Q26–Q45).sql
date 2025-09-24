-- B. JOINS (Q26–Q45)

-- Q26. Show each order with customer details and pizzas.
SELECT o.order_id, CONCAT(c.first_name," ",c.last_name) AS Full_Name, c.email, c.city, p.pizza_name, p.category, p.size 
FROM orders o
JOIN customers c
ON c.customer_id = o.customer_id 
JOIN order_items oi
ON oi.order_id = o.order_id
JOIN pizzas p
ON p.pizza_id = oi.pizza_id;

-- Q27. Find which customers ordered multiple pizza categories.
SELECT CONCAT(c.first_name," ",c.last_name) AS Full_Name, COUNT(DISTINCT p.category) AS Pizaa_Category
FROM customers c
JOIN orders o
ON o.customer_id = c.customer_id
JOIN order_items oi
ON oi.order_id = o.order_id
JOIN pizzas p
ON p.pizza_id = oi.pizza_id
GROUP BY c.first_name, c.last_name;

-- Q28. Show orders where total_amount > sum(price*quantity).
SELECT o.order_id, o.total_amount, SUM(p.price * oi.quantity) AS Total_Revenue
FROM orders o
JOIN order_items oi
ON oi.order_id = o.order_id
JOIN pizzas p
ON p.pizza_id = oi.pizza_id
GROUP BY o.order_id
HAVING o.total_amount > SUM(p.price * oi.quantity);

-- Q29. List customers with their last order date.
SELECT CONCAT(c.first_name," ",c.last_name) AS Full_Name, MAX(o.order_date) AS Last_Order_Date
FROM customers c
JOIN orders o
ON o.customer_id = c.customer_id
GROUP BY c.first_name,c.last_name
ORDER BY MAX(o.order_date) DESC;

-- Q30. Show pizza_name with number of times ordered.
SELECT p.pizza_name, SUM(oi.quantity) AS QuantityOfOrder
FROM pizzas p
JOIN order_items oi
ON oi.pizza_id = p.pizza_id
GROUP BY p.pizza_name;

-- Q31. Find customers who never ordered Veg pizzas.
SELECT 
    c.customer_id, 
    CONCAT(c.first_name, " ", c.last_name) AS Full_Name
FROM customers c
WHERE c.customer_id NOT IN (
    SELECT DISTINCT o.customer_id
    FROM orders o
    JOIN order_items oi 
		ON o.order_id = oi.order_id
    JOIN pizzas p 
		ON oi.pizza_id = p.pizza_id
    WHERE p.category = 'Veg'
);

-- Q32. Show all pizzas with total quantity sold.
SELECT p.pizza_id, p.pizza_name, SUM(oi.quantity) AS Sold_Quantity
FROM pizzas p
JOIN order_items oi 
ON oi.pizza_id = p.pizza_id
GROUP BY p.pizza_name, p.pizza_id
ORDER BY Sold_Quantity DESC;

-- Q33. List customers and total pizzas ordered (even if 0).
SELECT 
    c.customer_id, 
    CONCAT(c.first_name, ' ', c.last_name) AS Full_Name,
    COALESCE(SUM(oi.quantity), 0) AS Total_Order
FROM customers c
LEFT JOIN orders o
    ON o.customer_id = c.customer_id
LEFT JOIN order_items oi
    ON oi.order_id = o.order_id
GROUP BY c.customer_id, c.first_name, c.last_name;

-- Q34. Show pizzas not ordered by anyone.
SELECT 
    p.pizza_id, 
    p.pizza_name
FROM pizzas p
LEFT JOIN order_items oi 
    ON p.pizza_id = oi.pizza_id
WHERE oi.pizza_id IS NULL;

-- Q35. Find customers with no orders using LEFT JOIN.
SELECT 
    c.customer_id, 
    CONCAT(c.first_name, ' ', c.last_name) AS Full_Name
FROM customers c
LEFT JOIN orders o 
ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

-- Q36. Show order details with customer name and city.
SELECT 
    c.customer_id, 
    CONCAT(c.first_name, ' ', c.last_name) AS Full_Name,
    c.city,
    o.order_id,
    o.order_date,
    o.total_amount
FROM orders o
JOIN customers c
ON c.customer_id = o.customer_id;

-- Q37. Find customers who ordered same pizza more than once.
SELECT 
    c.customer_id, 
    CONCAT(c.first_name, ' ', c.last_name) AS Full_Name,
    p.pizza_name,
    SUM(oi.quantity) AS Total_Quantity
FROM customers c
JOIN orders o
ON o.customer_id = c.customer_id
JOIN order_items oi
ON oi.order_id = o.order_id
JOIN pizzas p
ON p.pizza_id = oi.pizza_id
GROUP BY c.customer_id,c.first_name,c.last_name, p.pizza_name
HAVING SUM(oi.quantity) > 1;
    

-- Q38. Show pizzas ordered along with size and customer city.
SELECT p.pizza_id, p.size, c.city
FROM pizzas p
JOIN order_items oi
ON oi.pizza_id = p.pizza_id
JOIN orders o
ON o.order_id = oi.order_id
JOIN customers c
ON c.customer_id = o.customer_id
GROUP BY p.pizza_id, p.size, c.city;

-- Q39. Find customers who ordered both Veg and Non-Veg pizzas.
SELECT 
    c.customer_id, 
    CONCAT(c.first_name, ' ', c.last_name) AS Full_Name,
    p.category
FROM customers c
JOIN orders o
    ON o.customer_id = c.customer_id
JOIN order_items oi
    ON oi.order_id = o.order_id
JOIN pizzas p
    ON p.pizza_id = oi.pizza_id
WHERE p.category IN ("Veg","Non-Veg")
GROUP BY c.customer_id, c.first_name, c.last_name,p.category
HAVING COUNT(DISTINCT p.category) = 2;

-- Q40. Show each order with customer email and pizzas ordered.
SELECT 
    o.order_id, 
    c.email, 
    p.pizza_name
FROM orders o
JOIN customers c
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON oi.order_id = o.order_id
JOIN pizzas p
    ON p.pizza_id = oi.pizza_id;

-- Q41. Find pizza ordered by most unique customers.
SELECT 
    p.pizza_name,
    COUNT(DISTINCT c.customer_id) AS Unique_Customers
FROM customers c
JOIN orders o
    ON o.customer_id = c.customer_id
JOIN order_items oi
    ON oi.order_id = o.order_id
JOIN pizzas p
    ON p.pizza_id = oi.pizza_id
GROUP BY p.pizza_name
ORDER BY Unique_Customers DESC
LIMIT 1;

-- Q42. Show total order value per customer by joining tables.
SELECT 
    c.customer_id, 
    CONCAT(c.first_name, ' ', c.last_name) AS Full_Name,
    SUM(p.price * oi.quantity) AS Total_Value
FROM customers c
JOIN orders o
ON o.customer_id = c.customer_id
JOIN order_items oi
ON oi.order_id = o.order_id
JOIN pizzas p
ON p.pizza_id = oi.pizza_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY Total_Value DESC;

-- Q43. List customers and number of distinct pizzas ordered.
SELECT 
    c.customer_id, 
    CONCAT(c.first_name, ' ', c.last_name) AS Full_Name,
    COUNT(DISTINCT p.pizza_name) AS Unique_Pizza
FROM customers c
JOIN orders o
ON o.customer_id = c.customer_id
JOIN order_items oi
ON oi.order_id = o.order_id
JOIN pizzas p
ON p.pizza_id = oi.pizza_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY Unique_Pizza DESC;

-- Q44. Find customers who only ordered Veg pizzas.
SELECT 
    c.customer_id, 
    CONCAT(c.first_name, ' ', c.last_name) AS Full_Name
FROM customers c
JOIN orders o
    ON o.customer_id = c.customer_id
JOIN order_items oi
    ON oi.order_id = o.order_id
JOIN pizzas p
    ON p.pizza_id = oi.pizza_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(DISTINCT p.category) = 1
   AND MIN(p.category) = 'Veg';
   

SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS Full_Name
FROM customers c
JOIN orders o 
	ON o.customer_id = c.customer_id
JOIN order_items oi 
	ON oi.order_id = o.order_id
JOIN pizzas p 
	ON p.pizza_id = oi.pizza_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(DISTINCT p.category) = 1
   AND MAX(p.category) = 'Veg';

-- Q45. Show customers who placed at least 2 orders on same date.
SELECT 
    o.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS Full_Name,
    o.order_date,
    COUNT(o.order_id) AS total_orders
FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id
GROUP BY o.customer_id, o.order_date
HAVING COUNT(o.order_id) >= 2;

    
    
