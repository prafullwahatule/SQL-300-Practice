-- C. CTEs (Common Table Expressions) (Q31–Q50)

-- Q31. Use CTE to find total pizzas per customer.
WITH total_pizzas_cte AS (
    SELECT 
        o.customer_id,
        SUM(oi.quantity) AS total_pizzas
    FROM orders o
    JOIN order_items oi 
        ON o.order_id = oi.order_id
    GROUP BY o.customer_id
)
SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    t.total_pizzas
FROM total_pizzas_cte t
JOIN customers c 
    ON c.customer_id = t.customer_id;

-- Q32. Find avg order value per month using CTE.
WITH avg_order_value_cte AS (
    SELECT
        YEAR(order_date) AS order_year,
        MONTH(order_date) AS order_month,
        AVG(total_amount) AS avg_order_value
    FROM orders
    GROUP BY YEAR(order_date), MONTH(order_date)
)
SELECT *
FROM avg_order_value_cte;

-- Q33. Show top 3 customers by revenue using CTE.
WITH customer_revenue AS (
    SELECT
        c.customer_id,
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
        SUM(o.total_amount) AS total_revenue
    FROM customers c
    JOIN orders o ON o.customer_id = c.customer_id
    GROUP BY c.customer_id, c.first_name, c.last_name
)
SELECT *
FROM customer_revenue
ORDER BY total_revenue DESC
LIMIT 3;

-- Q34. Find pizza category revenue using CTE.
WITH category_revenue AS (
    SELECT
        p.category,
        SUM(p.price * oi.quantity) AS total_revenue
    FROM pizzas p
    JOIN order_items oi ON oi.pizza_id = p.pizza_id
    GROUP BY p.category
)
SELECT *
FROM category_revenue;

-- Q35. Show employee with max deliveries using CTE.
WITH delivery_count AS (
    SELECT 
        e.employee_id,
        e.name,
        COUNT(d.delivery_id) AS total_deliveries
    FROM employees e
    JOIN deliveries d 
        ON d.employee_id = e.employee_id
    GROUP BY e.employee_id, e.name
),
max_delivery AS (
    SELECT MAX(total_deliveries) AS max_del
    FROM delivery_count
)
SELECT *
FROM delivery_count
WHERE total_deliveries = (SELECT max_del FROM max_delivery);

-- Q36. Use recursive CTE to show hierarchy of employees (Manager → Chef → Delivery Boy).
WITH RECURSIVE emp_hierarchy AS (
    SELECT 
        employee_id,
        name,
        role,
        1 AS lvl
    FROM employees
    WHERE role = 'Manager'

    UNION ALL

    SELECT
        e.employee_id,
        e.name,
        e.role,
        h.lvl + 1
    FROM employees e
    JOIN emp_hierarchy h
        ON (h.role = 'Manager' AND e.role = 'Chef')
        OR (h.role = 'Chef' AND e.role = 'Delivery Boy')
)
SELECT *
FROM emp_hierarchy
ORDER BY lvl;

-- Q37. Find customers who ordered more than 5 pizzas using CTE.
WITH pizza_count AS (
    SELECT
        o.customer_id,
        SUM(oi.quantity) AS total_pizzas
    FROM orders o
    JOIN order_items oi 
        ON oi.order_id = o.order_id
    GROUP BY o.customer_id
)
SELECT
    c.*
FROM customers c
JOIN pizza_count pc
    ON pc.customer_id = c.customer_id
WHERE pc.total_pizzas > 5;

-- Q38. Show revenue per city using CTE.
WITH revenue_per_city AS (
    SELECT
        c.city,
        SUM(oi.quantity * p.price) AS total_revenue
    FROM customers c
    JOIN orders o ON o.customer_id = c.customer_id
    JOIN order_items oi ON oi.order_id = o.order_id
    JOIN pizzas p ON p.pizza_id = oi.pizza_id
    GROUP BY c.city
)
SELECT *
FROM revenue_per_city;

-- Q39. Find most expensive pizza ordered per order using CTE.
WITH most_expensive_pizza_ordered AS (
    SELECT
        oi.order_id,
        MAX(p.price) AS Max_Pizza_Price
    FROM order_items oi
    JOIN pizzas p
        ON p.pizza_id = oi.pizza_id
    GROUP BY oi.order_id
)
SELECT 
    mepo.order_id,
    p.pizza_name,
    p.price
FROM pizzas p
JOIN order_items oi
    ON oi.pizza_id = p.pizza_id
JOIN most_expensive_pizza_ordered mepo
    ON mepo.order_id = oi.order_id
WHERE p.price = mepo.Max_Pizza_Price;

-- Q40. Use CTE to find pizzas,  ordered in June only.
WITH june_orders AS (
    SELECT DISTINCT
        oi.pizza_id
    FROM orders o
    JOIN order_items oi
        ON oi.order_id = o.order_id
    WHERE MONTH(o.order_date) = 6
)
SELECT
    p.pizza_id,
    p.pizza_name,
    p.category,
    p.price
FROM pizzas p
JOIN june_orders jo
    ON jo.pizza_id = p.pizza_id;

-- Q41. Show customers who ordered at least once per month using CTE.
WITH per_month_order AS (
    SELECT 
        MONTH(order_date) AS Order_Month,
        customer_id
    FROM orders
    GROUP BY customer_id, MONTH(order_date)
)
SELECT 
    customer_id
FROM per_month_order
GROUP BY customer_id
HAVING COUNT(*) = (
    SELECT COUNT(DISTINCT MONTH(order_date)) FROM orders
);

-- Q42. Find pizzas with revenue > avg revenue using CTE.
WITH pizza_revenue AS (
    SELECT
        p.pizza_id,
        p.pizza_name,
        SUM(oi.quantity * p.price) AS total_revenue
    FROM pizzas p
    JOIN order_items oi ON oi.pizza_id = p.pizza_id
    GROUP BY p.pizza_id, p.pizza_name
),
avg_revenue_cte AS (
    SELECT AVG(total_revenue) AS avg_revenue
    FROM pizza_revenue
)
SELECT
    pr.pizza_id,
    pr.pizza_name,
    pr.total_revenue
FROM pizza_revenue pr
JOIN avg_revenue_cte ar
WHERE pr.total_revenue > ar.avg_revenue;

-- Q43. Show city with max orders using CTE.
WITH city_order_count AS (
    SELECT
        c.city,
        COUNT(o.order_id) AS total_orders
    FROM customers c
    JOIN orders o ON o.customer_id = c.customer_id
    GROUP BY c.city
),
max_orders_cte AS (
    SELECT MAX(total_orders) AS max_orders
    FROM city_order_count
)
SELECT c.city, c.total_orders
FROM city_order_count c
JOIN max_orders_cte m
WHERE c.total_orders = m.max_orders;

-- Q44. Find order, with highest quantity using CTE.
WITH order_quantity AS (
    SELECT
        order_id,
        SUM(quantity) AS total_quantity
    FROM order_items
    GROUP BY order_id
),
max_order_cte AS (
    SELECT MAX(total_quantity) AS max_quantity
    FROM order_quantity
)
SELECT oq.order_id, oq.total_quantity
FROM order_quantity oq
JOIN max_order_cte m
WHERE oq.total_quantity = m.max_quantity;

-- Q45. Show customers who spent more than avg using CTE.
WITH customer_spending AS (
    SELECT
        c.customer_id,
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
        SUM(o.total_amount) AS total_spent
    FROM customers c
    JOIN orders o ON o.customer_id = c.customer_id
    GROUP BY c.customer_id, c.first_name, c.last_name
),
avg_spending AS (
    SELECT AVG(total_spent) AS avg_spent
    FROM customer_spending
)
SELECT
    cs.customer_id,
    cs.customer_name,
    cs.total_spent
FROM customer_spending cs
JOIN avg_spending a
WHERE cs.total_spent > a.avg_spent;

-- Q46. Use CTE to find employees with more than 3 deliveries.
WITH delivery_count AS (
    SELECT
        e.employee_id,
        e.name,
        COUNT(d.delivery_id) AS total_deliveries
    FROM employees e
    JOIN deliveries d
        ON d.employee_id = e.employee_id
    GROUP BY e.employee_id, e.name
)
SELECT
    e.employee_id,
    e.name,
    e.role,
    e.salary,
    dc.total_deliveries
FROM employees e
JOIN delivery_count dc
    ON dc.employee_id = e.employee_id
WHERE dc.total_deliveries > 3;

-- Q47. Find pizzas ordered by customer Amit using CTE.
WITH order_by_amit AS (
    SELECT
        c.first_name,
        p.pizza_name
    FROM customers c
    JOIN orders o ON o.customer_id = c.customer_id
    JOIN order_items oi ON oi.order_id = o.order_id
    JOIN pizzas p ON p.pizza_id = oi.pizza_id
    WHERE c.first_name = "Amit"
)
SELECT * FROM order_by_amit;

-- Q48. Show monthly revenue trend with CTE.
WITH monthly_trend AS (
    SELECT
        MONTHNAME(o.order_date) AS month_name,
        SUM(oi.quantity * p.price) AS revenue
    FROM orders o
    JOIN order_items oi ON oi.order_id = o.order_id
    JOIN pizzas p ON p.pizza_id = oi.pizza_id
    GROUP BY MONTHNAME(o.order_date)
)
SELECT * FROM monthly_trend;

-- Q49. Find distinct pizzas ordered by Sneha using CTE.
WITH distinct_orders AS(
	SELECT DISTINCT
		p.pizza_name,
		c.first_name
    FROM pizzas p
    JOIN order_items oi
    ON oi.pizza_id = p.pizza_id
    JOIN orders o
    ON o.order_id = oi.order_id
    JOIN customers c
    ON c.customer_id = o.customer_id
    WHERE c.first_name = "Sneha"
    )
SELECT * FROM distinct_orders;

-- Q50. Show employees who delivered more than avg deliveries using CTE.
WITH total_deliveries AS (
    SELECT 
        e.employee_id,
        e.name,
        COUNT(d.delivery_id) AS total_deliveries
    FROM employees e
    JOIN deliveries d
        ON d.employee_id = e.employee_id
    GROUP BY e.employee_id, e.name
),
avg_deliveries AS (
    SELECT 
        AVG(total_deliveries) AS avg_delivery
    FROM total_deliveries
)
SELECT 
    td.employee_id,
    td.name,
    td.total_deliveries
FROM total_deliveries td
JOIN avg_deliveries ad
    ON td.total_deliveries > ad.avg_delivery;








-- Recurcive CTE

-- 1. Display number form 1 to 10 without using any in build functions
WITH RECURSIVE numbers AS (
	SELECT 1 AS n
    UNION
    SELECT n + 1
    FROM numbers
    WHERE n < 10
    )
SELECT * FROM numbers;

-- 2. Find the hierarchy of the employee under a give manager name = "Asha"
CREATE TABLE employees1 (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    manager_id INT NULL,
    salary INT,
    designation VARCHAR(100)
);

INSERT INTO employees1 (id, name, manager_id, salary, designation) VALUES
(1, 'Shripadh', NULL, 10000, 'CEO'),
(2, 'Satya', 5, 1400, 'Software Engineer'),
(3, 'Jia', 5, 500, 'Data Analyst'),
(4, 'David', 5, 1800, 'Data Scientist'),
(5, 'Michael', 7, 3000, 'Manager'),
(6, 'Arvind', 7, 2400, 'Architect'),
(7, 'Asha', 1, 4200, 'CTO'),
(8, 'Maryam', 1, 3500, 'Manager'),
(9, 'Reshma', 8, 2000, 'Business Analyst'),
(10, 'Akshay', 8, 2500, 'Java Developer');

WITH RECURSIVE emp_hierarchy AS (
    -- Anchor member (start point)
    SELECT id, name, manager_id, designation, 1 as lvl
    FROM employees1
    WHERE name = 'Asha'

    UNION

    -- Recursive member (move upward to manager)
    SELECT e.id, e.name, e.manager_id, e.designation, h.lvl + 1 as lvl  -- (Leval)
    FROM employees1 e
    JOIN emp_hierarchy h
        ON h.id = e.manager_id
)
SELECT * FROM emp_hierarchy;


-- Find the hierarchy of manager for given employee "David"

WITH RECURSIVE emp_hierarchy AS (
    -- Anchor member (start point)
    SELECT id, name, manager_id, designation, 1 as lvl
    FROM employees1
    WHERE name = 'David'

    UNION

    -- Recursive member (move upward to manager)
    SELECT e.id, e.name, e.manager_id, e.designation, h.lvl + 1 as lvl  -- (Leval)
    FROM employees1 e
    JOIN emp_hierarchy h
        ON h.manager_id = e.id
)
SELECT * FROM emp_hierarchy;