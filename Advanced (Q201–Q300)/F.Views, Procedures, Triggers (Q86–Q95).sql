-- F. Views, Procedures, Triggers (Q86–Q95)

-- Q86. Create a view for customer total spend.
CREATE VIEW customer_total_spend AS
SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.city,
    SUM(p.price * oi.quantity) AS total_spend
FROM customers c
JOIN orders o
    ON o.customer_id = c.customer_id
JOIN order_items oi
    ON oi.order_id = o.order_id
JOIN pizzas p
    ON p.pizza_id = oi.pizza_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name,
    c.city;
    
SELECT * FROM customer_total_spend;

-- Q87. Create a view for monthly revenue.
CREATE OR REPLACE VIEW monthly_revenue AS
SELECT
    YEAR(o.order_date) AS order_year,
    MONTH(o.order_date) AS month_no,
    MONTHNAME(MIN(o.order_date)) AS month_name,
    SUM(oi.quantity * p.price) AS revenue
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN pizzas p
    ON p.pizza_id = oi.pizza_id
GROUP BY
    YEAR(o.order_date),
    MONTH(o.order_date);

SELECT order_year, month_name, revenue
FROM monthly_revenue
ORDER BY order_year, month_no;

-- Q88. Create a view for top 5 pizzas by revenue.
CREATE VIEW top_5_pizzas AS
SELECT
	p.pizza_name,
	SUM(oi.quantity * p.price) AS revenue
FROM pizzas p
JOIN order_items oi
ON oi.pizza_id = p.pizza_id
GROUP BY p.pizza_name;

SELECT * FROM top_5_pizzas
ORDER BY revenue DESC
LIMIT 5;

-- Q89. Write a procedure to get orders by customer_id.
DELIMITER $$

CREATE PROCEDURE get_orders_by_customer (
    IN p_customer_id INT
)
BEGIN
    SELECT
        o.order_id,
        o.order_date,
        o.total_amount
    FROM orders o
    WHERE o.customer_id = p_customer_id
    ORDER BY o.order_date;
END $$

DELIMITER ;

-- Calling
CALL get_orders_by_customer(2);

-- Q90. Write a procedure to insert a new pizza.
DELIMITER $$

CREATE PROCEDURE insert_new_pizza (
    IN p_pizza_id INT,
    IN p_pizza_name VARCHAR(100),
    IN p_category VARCHAR(50),
    IN p_size VARCHAR(20),
    IN p_price DECIMAL(6,2)
)
BEGIN
    INSERT INTO pizzas (
        pizza_id,
        pizza_name,
        category,
        size,
        price
    )
    VALUES (
        p_pizza_id,
        p_pizza_name,
        p_category,
        p_size,
        p_price
    );
END $$

DELIMITER ;

-- Call
CALL insert_new_pizza(101, 'Farmhouse Pizza', 'Veg', 'M', 299.00);
	
-- Q91. Write a procedure to get monthly revenue trend.
-- Q92. Write a trigger to update total_amount when order_items change.
-- Q93. Write a trigger to log cancelled deliveries.
-- Q94. Write a view to show employee performance (deliveries count).
-- Q95. Write a view to show customer loyalty (active vs inactive).
