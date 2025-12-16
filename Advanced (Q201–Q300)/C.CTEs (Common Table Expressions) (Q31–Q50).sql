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
-- Q33. Show top 3 customers by revenue using CTE.
-- Q34. Find pizza category revenue using CTE.
-- Q35. Show employee with max deliveries using CTE.
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
