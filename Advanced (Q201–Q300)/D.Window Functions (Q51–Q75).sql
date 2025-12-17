-- D. Window Functions (Q51–Q75)

-- Q51. Rank customers by total spending.
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    SUM(o.total_amount) AS total_spent,
    RANK() OVER (ORDER BY SUM(o.total_amount) DESC) AS spending_rank
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name;

-- Q52. Show row_number for pizzas ordered.
-- Q53. Show cumulative revenue by order_date.
-- Q54. Find running total of pizzas sold.
-- Q55. Show dense_rank of pizzas by price.
-- Q56. Show lag of order amount per customer.
-- Q57. Show lead of order amount per customer.
-- Q58. Partition orders by city and rank them.
-- Q59. Find top 2 pizzas by revenue in each category.
-- Q60. Show revenue percent contribution of each pizza.
-- Q61. Show moving average of total_amount per customer.
-- Q62. Show customers ranked by order count.
-- Q63. Find nth highest pizza price using window function.
-- Q64. Show orders with difference from previous order.
-- Q65. Show average order value per month using partition.
-- Q66. Find repeat customers using row_number.
-- Q67. Show orders ranked within each customer.
-- Q68. Show pizzas ranked by revenue per category.
-- Q69. Show cumulative pizzas sold per category.
-- Q70. Find customers with 2nd highest spend in each city.
-- Q71. Show percentile rank of pizza prices.
-- Q72. Show ntile(4) distribution of customers by spend.
-- Q73. Show cumulative salary distribution of employees.
-- Q74. Find pizzas with highest order quantity per month.
-- Q75. Show customers’ first and last order dates using window functions.





