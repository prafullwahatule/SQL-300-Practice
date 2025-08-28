-- C. Aggregate Functions (Q41–Q60)

-- Q41. Count total customers.
SELECT COUNT(*) AS total_customers
FROM customers;

-- Q42. Count total pizzas.
SELECT COUNT(*) AS total_pizzas
FROM pizzas;

-- Q43. Count total orders.
SELECT COUNT(*) AS total_orders
FROM orders;

-- Q44. Find max pizza price.
SELECT MAX(price) AS max_price
FROM pizzas;

-- Q45. Find min pizza price.
SELECT MIN(price) AS min_price
FROM pizzas;

-- Q46. Find avg pizza price.
SELECT AVG(price) AS avg_price
FROM pizzas;

-- Q47. Find total revenue (sum of total_amount).
SELECT SUM(total_amount) AS total_revenue
FROM orders;

-- Q48. Find total pizzas sold (from order_items).
SELECT SUM(quantity) AS total_pizzas_sold
FROM order_items;

-- Q49. Find avg order value.
SELECT AVG(total_amount) AS avg_order_value
FROM orders;

-- Q50. Count pizzas in Veg category.
SELECT COUNT(pizza_id) AS veg_pizzas
FROM pizzas
WHERE category = 'Veg';

-- Q51. Count customers from Mumbai.
SELECT COUNT(customer_id) AS mumbai_customers
FROM customers
WHERE city = 'Mumbai';

-- Q52. Find sum of total_amount for June orders.
SELECT SUM(total_amount) AS total_june_amount
FROM orders
WHERE order_date BETWEEN '2022-06-01' AND '2022-06-30';

-- Q53. Get number of orders per customer.
SELECT customer_id, COUNT(order_id) AS total_orders
FROM orders
GROUP BY customer_id;

-- Q54. Find avg quantity of pizzas ordered.
SELECT AVG(quantity) AS avg_quantity
FROM order_items;

-- Q55. Show how many pizzas per category.
SELECT category, COUNT(pizza_id) AS total_pizzas
FROM pizzas
GROUP BY category;

-- Q56. Find max quantity in an order.
SELECT MAX(quantity) AS max_quantity
FROM order_items;

-- Q57. Find min quantity in an order.
SELECT MIN(quantity) AS min_quantity
FROM order_items;

-- Q58. Get total number of Gmail users.
SELECT COUNT(*) AS gmail_users
FROM customers
WHERE email LIKE '%@gmail.com';

-- Q59. Find avg total_amount of orders in July.
SELECT AVG(total_amount) AS avg_july_order_value
FROM orders
WHERE order_date BETWEEN '2022-07-01' AND '2022-07-31';

-- Q60. Show total revenue per city.
SELECT c.city, SUM(o.total_amount) AS total_revenue
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.city;
