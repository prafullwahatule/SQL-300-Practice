-- A. SELECT & WHERE (Q1–Q20)

-- Q1. Show only first_name and city of customers.
SELECT first_name, city FROM customers;

-- Q2. Get all pizzas from the pizzas table.
SELECT * FROM pizzas;

-- Q3. Display only pizza_name and price.
SELECT pizza_name, price FROM pizzas;

-- Q4. Find customers from Mumbai.
SELECT * FROM customers
WHERE city = "Mumbai";

-- Q5. List pizzas that cost more than 300.
SELECT * FROM pizzas
WHERE price > 300;

-- Q6. Show pizzas with category ‘Veg’.
SELECT * FROM pizzas
WHERE category = "Veg";

-- Q7. Find orders placed after ‘2022-06-20’.
SELECT * FROM orders
WHERE order_date > '2022-06-20';

-- Q8. List customers who joined before April 2022.
SELECT * FROM customers
WHERE join_date < '2022-04-1';

-- Q9. Get orders where total_amount > 500.
SELECT * FROM orders
WHERE total_amount > 500;

-- Q10. Find pizzas with size ‘L’.
SELECT * FROM pizzas
WHERE size = "M";

-- Q11. Show all customers whose name starts with ‘A’.
SELECT * FROM customers
WHERE first_name LIKE("A%");

-- Q12. Find pizzas that are not Veg.
SELECT * FROM pizzas
WHERE category != "Veg";

-- Q13. Get customer emails ending with ‘gmail.com’.
SELECT * FROM customers
WHERE email LIKE("%gmail.com");

-- Q14. Show orders placed on 2022-06-21.
SELECT * FROM orders
WHERE order_date = '2022-06-21';

-- Q15. Find pizzas priced between 200 and 400.
SELECT * FROM pizzas
WHERE price BETWEEN 200 AND 400;

-- Q16. List customers from Mumbai or Delhi.
SELECT * FROM customers
WHERE city IN ("Mumbai","Delhi");

-- Q17. Get pizzas not priced at 250.
SELECT * FROM pizzas
WHERE price != 250;

-- Q18. Show customers with customer_id = 3.
SELECT * FROM customers
WHERE customer_id = 3;

-- Q19. Find orders with total_amount < 600.
SELECT * FROM orders
WHERE total_amount < 600;

-- Q20. Show pizzas with category = ‘Classic’.
SELECT * FROM pizzas
WHERE category = "Classic";