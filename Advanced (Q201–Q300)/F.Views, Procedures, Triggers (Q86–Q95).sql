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
DELIMITER $$

CREATE PROCEDURE monthly_revenue()
BEGIN 
	SELECT
		MONTHNAME(o.order_date) AS Month_Name,
        SUM(oi.quantity * p.price) AS Revenue
	FROM orders o
    JOIN order_items oi
    ON o.order_id = oi.order_id
    JOIN pizzas p
    ON p.pizza_id = oi.pizza_id
    GROUP BY MONTHNAME(o.order_date);
    
END $$

DELIMITER ;

-- Call
CALL monthly_revenue();

-- Q92. Write a trigger to update total_amount when order_items change.
DELIMITER $$

CREATE TRIGGER trg_order_items_insert
AFTER INSERT ON order_items
FOR EACH ROW
BEGIN
    UPDATE orders o
    SET o.total_amount = (
        SELECT SUM(oi.quantity * p.price)
        FROM order_items oi
        JOIN pizzas p ON oi.pizza_id = p.pizza_id
        WHERE oi.order_id = NEW.order_id
    )
    WHERE o.order_id = NEW.order_id;
END $$

DELIMITER ;

-- Q93. Write a trigger to log cancelled deliveries.
DELIMITER $$

CREATE TRIGGER trg_cancelled_deliveries
AFTER UPDATE ON deliveries
FOR EACH ROW
BEGIN
    IF NEW.status = 'Cancelled' AND OLD.status <> 'Cancelled' THEN
        INSERT INTO cancelled_delivery_log (
            delivery_id,
            order_id
        )
        VALUES (
            NEW.delivery_id,
            NEW.order_id
        );
    END IF;
END $$

DELIMITER ;

-- Q94. Write a view to show employee performance (deliveries count).
CREATE VIEW emp_performance AS
SELECT
    e.employee_id,
    e.name,
    COUNT(d.delivery_id) AS deliverie_count
FROM employees e
JOIN deliveries d
    ON d.employee_id = e.employee_id
GROUP BY e.employee_id, e.name;

SELECT * 
FROM emp_performance
ORDER BY deliverie_count DESC;

-- Q95. Write a view to show customer loyalty (active vs inactive).
CREATE VIEW cust_loyalty AS
SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    COUNT(o.order_id) AS total_orders,
    CASE
        WHEN COUNT(o.order_id) >= 1 THEN 'Active'
        ELSE 'Inactive'
    END AS loyalty_status
FROM customers c
LEFT JOIN orders o
    ON o.customer_id = c.customer_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name;
    
SELECT * FROM cust_loyalty;

    