-- Create Database
CREATE DATABASE PizzaDB;
USE PizzaDB;

-- Customers Table
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100) UNIQUE,
    city VARCHAR(50),
    join_date DATE
);

INSERT INTO customers (customer_id, first_name, last_name, email, city, join_date) VALUES
(1, 'Amit', 'Sharma', 'amit@gmail.com', 'Mumbai', '2022-01-10'),
(2, 'Priya', 'Iyer', 'priya@gmail.com', 'Delhi', '2022-02-15'),
(3, 'Rohan', 'Singh', 'rohan@gmail.com', 'Pune', '2022-03-20'),
(4, 'Sneha', 'Patil', 'sneha@gmail.com', 'Mumbai', '2022-05-05'),
(5, 'Arjun', 'Mehta', 'arjun@gmail.com', 'Bangalore', '2022-06-18');

-- Pizzas Table
CREATE TABLE pizzas (
    pizza_id INT PRIMARY KEY,
    pizza_name VARCHAR(100),
    category VARCHAR(50),
    size CHAR(2),
    price DECIMAL(10,2)
);

INSERT INTO pizzas (pizza_id, pizza_name, category, size, price) VALUES
(1, 'Margherita', 'Classic', 'M', 250),
(2, 'Pepperoni', 'Classic', 'L', 450),
(3, 'Veggie Supreme', 'Veg', 'M', 300),
(4, 'Chicken Delight', 'Non-Veg', 'L', 500),
(5, 'Paneer Tikka', 'Veg', 'S', 200);

-- Orders Table
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

INSERT INTO orders (order_id, customer_id, order_date, total_amount) VALUES
(101, 1, '2022-06-20', 500),
(102, 2, '2022-06-21', 950),
(103, 3, '2022-06-22', 250),
(104, 4, '2022-06-25', 700),
(105, 5, '2022-07-01', 200);

-- Order Items Table
CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY,
    order_id INT,
    pizza_id INT,
    quantity INT,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (pizza_id) REFERENCES pizzas(pizza_id)
);

INSERT INTO order_items (order_item_id, order_id, pizza_id, quantity) VALUES
(1, 101, 1, 2),
(2, 102, 2, 1),
(3, 102, 3, 2),
(4, 103, 1, 1),
(5, 104, 4, 1),
(6, 105, 5, 1);

-- Employees Table
CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    name VARCHAR(100),
    role VARCHAR(50),
    salary DECIMAL(10,2),
    hire_date DATE
);

INSERT INTO employees (employee_id, name, role, salary, hire_date) VALUES
(1, 'Rajesh', 'Manager', 60000, '2020-01-15'),
(2, 'Anjali', 'Cashier', 25000, '2021-03-10'),
(3, 'Mohan', 'Chef', 40000, '2021-07-20'),
(4, 'Kavita', 'Delivery Boy', 18000, '2022-02-12'),
(5, 'Suraj', 'Chef', 42000, '2022-05-30');

-- Deliveries Table
CREATE TABLE deliveries (
    delivery_id INT PRIMARY KEY,
    order_id INT,
    employee_id INT,
    delivery_time DATE,
    status VARCHAR(50),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);

INSERT INTO deliveries (delivery_id, order_id, employee_id, delivery_time, status) VALUES
(1, 101, 4, '2022-06-20', 'Delivered'),
(2, 102, 4, '2022-06-21', 'Delivered'),
(3, 103, 4, '2022-06-22', 'Cancelled'),
(4, 104, 4, '2022-06-25', 'Delivered'),
(5, 105, 4, '2022-07-01', 'Delivered');


