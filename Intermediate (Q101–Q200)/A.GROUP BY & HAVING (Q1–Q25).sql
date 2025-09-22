-- A. GROUP BY & HAVING (Q1–Q25)

-- Q1. Show total revenue per customer.
SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    SUM(o.total_amount) AS total_revenue
FROM customers c
JOIN orders o 
ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name;

-- Q2. Find number of orders per city.
SELECT 
    c.city, 
    COUNT(o.order_id) AS Total_Orders
FROM customers c
JOIN orders o 
ON o.customer_id = c.customer_id
GROUP BY c.city;

-- Q3. Show avg pizza price per category.
SELECT 
	category, 
    AVG(price) AS Avg_Price 
FROM pizzas
GROUP BY category; 

-- Q4. Find total pizzas sold per category.
SELECT 
	p.category, 
	SUM(oi.quantity) AS Total_Sold
FROM pizzas p
JOIN order_items oi 
ON oi.pizza_id = p.pizza_id
GROUP BY p.category;

-- Q5. List customers who placed more than 1 order.
SELECT 
	CONCAT(c.first_name, " ", c.last_name) AS Cust_Name, 
	COUNT(o.order_id) AS Total_Orders
FROM customers c
JOIN orders o 
ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(o.order_id) > 1;

-- Q6. Find total amount spent by customers from Mumbai.
SELECT 
	CONCAT(c.first_name, " ", c.last_name) AS Cust_Name, 
	c.city,
	SUM(o.total_amount)
FROM customers c 
JOIN orders o
ON o.customer_id = c.customer_id
WHERE city = "Mumbai"
GROUP BY c.first_name,c.last_name,c.city;

-- Q7. Show count of orders per month.
SELECT 
	COUNT(order_id) AS Total_Orders,
    MONTH(order_date) AS MonthOfOrder
FROM  orders
GROUP BY MONTH(order_date) ;

-- Q8. Find avg quantity ordered per pizza.
SELECT 
	AVG(oi.quantity) AS Avg_Quantity, 
    p.pizza_name
FROM order_items oi
JOIN pizzas p
ON p.pizza_id = oi.pizza_id
GROUP BY p.pizza_name;

-- Q9. Get total revenue per pizza size.
SELECT 
	p.size, 
    SUM(p.price * oi.quantity) AS Total_Revenue 
FROM pizzas p
JOIN order_items oi
ON oi.pizza_id = p.pizza_id
GROUP BY p.size;

-- Q10. Find category with highest avg price.
SELECT 
	category, 
    AVG(price) AS Avg_Price
FROM pizzas
GROUP BY category
ORDER BY Avg_Price DESC
LIMIT 1;

-- Q11. Show top 2 customers by order count.
SELECT 
    CONCAT(c.first_name, " ", c.last_name) AS Cust_Name,
    COUNT(o.order_id) AS Order_Count
FROM customers c
JOIN orders o 
ON o.customer_id = c.customer_id
GROUP BY c.customer_id
ORDER BY Order_Count DESC
LIMIT 2;

-- Q12. Find customers who spent more than 800 total.
SELECT 
    CONCAT(c.first_name, " ", c.last_name) AS Cust_Name,
    SUM(o.total_amount) Total_Spend
FROM customers c
JOIN orders o
ON o.customer_id = c.customer_id
GROUP BY c.first_name,c.last_name
HAVING SUM(o.total_amount) > 800;

-- Q13. Show total pizzas ordered per customer.
SELECT 
    CONCAT(c.first_name, " ", c.last_name) AS Cust_Name,
    SUM(oi.quantity) AS Total_Pizzas
FROM customers c
JOIN orders o
    ON o.customer_id = c.customer_id
JOIN order_items oi
    ON oi.order_id = o.order_id
JOIN pizzas p
    ON p.pizza_id = oi.pizza_id
GROUP BY c.customer_id, c.first_name, c.last_name;

-- Q14. Find which pizza generated highest revenue.
SELECT 
	p.pizza_name, 
	SUM(p.price * oi.quantity) AS Total_Revenue
FROM pizzas p
JOIN order_items oi
ON oi.pizza_id = p.pizza_id 
GROUP BY p.pizza_name
ORDER BY Total_Revenue DESC
LIMIT 1;

-- Q15. Show avg order amount per city.
SELECT 
	c.city, 
    AVG(o.total_amount) AS Avg_Amount
FROM customers c
JOIN orders o
ON o.customer_id = c.customer_id
GROUP BY c.city;

-- Q16. Find number of unique pizzas ordered per category.
SELECT 
    p.category, 
    COUNT(DISTINCT p.pizza_id) AS Unique_Pizzas_Ordered
FROM pizzas p
JOIN order_items oi 
    ON oi.pizza_id = p.pizza_id
GROUP BY p.category;

-- Q17. Show revenue per pizza category.
SELECT 
    p.category, 
    SUM(p.price * oi.quantity) AS Total_Revenue
FROM pizzas p
JOIN order_items oi 
    ON oi.pizza_id = p.pizza_id 
GROUP BY p.category;

-- Q18. Find customers who ordered more than 3 pizzas in total.
SELECT 
    CONCAT(c.first_name, " ", c.last_name) AS Cust_Name,
    SUM(oi.quantity) AS Total_Pizza
FROM customers c
JOIN orders o ON o.customer_id = c.customer_id
JOIN order_items oi ON oi.order_id = o.order_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING SUM(oi.quantity) > 3;

-- Q19. List customers who ordered in more than 1 month.
SELECT 
    CONCAT(c.first_name, " ", c.last_name) AS Cust_Name,
    COUNT(DISTINCT MONTH(o.order_date)) AS Count_Of_Month
FROM customers c
JOIN orders o ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(DISTINCT MONTH(o.order_date)) > 1;

-- Q20. Show total revenue per customer city.
SELECT 
	c.city, 
    SUM(p.price * oi.quantity) AS Total_Revenue
FROM customers c
JOIN orders o
ON o.customer_id = c.customer_id
JOIN order_items oi
ON oi.order_id = o.order_id
JOIN pizzas p
ON p.pizza_id = oi.pizza_id
GROUP BY c.city;

-- Q21. Find cities with total revenue > 1000.
SELECT 
	c.city, 
	SUM(p.price * oi.quantity) AS Total_Revenue
FROM customers c
JOIN orders o
ON o.customer_id = c.customer_id
JOIN order_items oi
ON oi.order_id = o.order_id
JOIN pizzas p
ON p.pizza_id = oi.pizza_id
GROUP BY c.city
HAVING SUM(p.price * oi.quantity) > 1000;

-- Q22. Show pizza category with max total quantity sold.
SELECT 
	p.category, 
    SUM(oi.quantity) AS Total_Quantity_Sold
FROM pizzas p
JOIN order_items oi ON oi.pizza_id = p.pizza_id
GROUP BY p.category
ORDER BY Total_Quantity_Sold DESC
LIMIT 1;

-- Q23. Find order_id with max items.
SELECT 
    o.order_id, 
    SUM(oi.quantity) AS Total_Order
FROM orders o
JOIN order_items oi 
ON oi.order_id = o.order_id
GROUP BY o.order_id
ORDER BY Total_Order DESC
LIMIT 1;

-- Q24. Get month-wise total revenue.
SELECT 
	MONTH(o.order_date) AS MonthWiseRevenue, 
	SUM(p.price * oi.quantity) AS Total_Revenue
FROM orders o
JOIN order_items oi
ON oi.order_id = o.order_id
JOIN pizzas p
ON p.pizza_id = oi.pizza_id
GROUP BY  MONTH(o.order_date);

-- Q25. Find customer who ordered most distinct pizzas.
SELECT 
    CONCAT(c.first_name, " ", c.last_name) AS Cust_Name,
    COUNT(DISTINCT p.pizza_name) AS Count_Of_Distinct_Pizza
FROM customers c
JOIN orders o
ON o.customer_id = c.customer_id
JOIN order_items oi
ON oi.order_id = o.order_id
JOIN pizzas p
ON p.pizza_id = oi.pizza_id
GROUP BY c.first_name,c.last_name
ORDER BY Count_Of_Distinct_Pizza DESC
LIMIT 1;
