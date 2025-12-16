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
-- Q37. Find customers who ordered more than 5 pizzas using CTE.
-- Q38. Show revenue per city using CTE.
-- Q39. Find most expensive pizza ordered per order using CTE.
-- Q40. Use CTE to find pizzas ordered in June only.
-- Q41. Show customers who ordered at least once per month using CTE.
-- Q42. Find pizzas with revenue > avg revenue using CTE.
-- Q43. Show city with max orders using CTE.
-- Q44. Find order with highest quantity using CTE.
-- Q45. Show customers who spent more than avg using CTE.
-- Q46. Use CTE to find employees with more than 3 deliveries.
-- Q47. Find pizzas ordered by customer Amit using CTE.
-- Q48. Show monthly revenue trend with CTE.
-- Q49. Find distinct pizzas ordered by Sneha using CTE.
-- Q50. Show employees who delivered more than avg deliveries using CTE.
