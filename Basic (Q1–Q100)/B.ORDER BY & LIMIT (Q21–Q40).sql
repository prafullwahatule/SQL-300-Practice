-- B. ORDER BY & LIMIT (Q21–Q40)


-- Q21. Show all pizzas ordered by price ascending.
SELECT * FROM pizzas
ORDER BY price ASC;

-- Q22. List customers ordered by join_date descending.
SELECT * FROM customers
ORDER BY join_date DESC;

-- Q23. Show top 3 expensive pizzas.
SELECT * FROM pizzas
ORDER BY price DESC
LIMIT 3;

-- Q24. Show cheapest pizza.
SELECT * FROM pizzas
ORDER BY price ASC
LIMIT 1;

-- Q25. Get last 2 customers who joined.
SELECT * FROM customers
ORDER BY join_date DESC
LIMIT 2;

-- Q26. List orders ordered by total_amount descending.
SELECT * FROM orders
ORDER BY total_amount DESC;

-- Q27. Find customer with earliest join date.
SELECT * FROM customers
ORDER BY join_date ASC
LIMIT 1;

-- Q28. Get most expensive pizza.
SELECT * FROM pizzas
ORDER BY price DESC
LIMIT 1;

-- Q29. Show customers ordered by first_name alphabetically.
SELECT * FROM customers
ORDER BY first_name ASC;

-- Q30. Show latest order from orders.
SELECT * FROM orders
ORDER BY order_date DESC
LIMIT 1;

-- Q31. Get top 5 pizzas by price.
SELECT * FROM pizzas
ORDER BY price DESC
LIMIT 5;

-- Q32. Show customers ordered by city, then first_name.
SELECT * FROM customers
ORDER BY city ASC, first_name ASC;

-- Q33. List orders by order_date ascending.
SELECT * FROM orders
ORDER BY order_date ASC;

-- Q34. Find the smallest order amount.
SELECT * FROM orders
ORDER BY total_amount ASC
LIMIT 1;

-- Q35. Get the largest order amount.
SELECT * FROM orders
ORDER BY total_amount DESC
LIMIT 1;

-- Q36. Show top 2 cities with earliest joiners.
SELECT city FROM customers
ORDER BY join_date ASC
LIMIT 2;

-- Q37. Show pizzas sorted by category then price.
SELECT * FROM pizzas
ORDER BY category ASC, price ASC;

-- Q38. List customers ordered by last_name.
SELECT * FROM customers
ORDER BY last_name ASC;

-- Q39. Find top 3 orders with highest total_amount.
SELECT * FROM orders
ORDER BY total_amount DESC
LIMIT 3;

-- Q40. Show bottom 2 cheapest pizzas.
SELECT * FROM pizzas
ORDER BY price ASC
LIMIT 2;
