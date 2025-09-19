-- Create the customers table
CREATE TABLE customers (
    customerid INT PRIMARY KEY,
    firstname VARCHAR(50),
    lastname VARCHAR(50),
    email VARCHAR(100),
    registration_date DATE
);

-- Insert 5 sample entries
INSERT INTO customers (customerid, firstname, lastname, email, registration_date) VALUES
(101, 'Alice', 'Johnson', 'alice.johnson@example.com', '2025-01-10'),
(102, 'Bob', 'Smith', 'bob.smith@example.com', '2025-02-14'),
(103, 'Carol', 'Lee', 'carol.lee@example.com', '2025-03-22'),
(104, 'David', 'Brown', 'david.brown@example.com', '2025-04-05'),
(105, 'Eva', 'White', 'eva.white@example.com', '2025-05-18');


-- Create the orders table
CREATE TABLE orders (
    orderid INT PRIMARY KEY,
    customerid INT,
    order_date DATE,
    total_amount DECIMAL(10, 2),
    FOREIGN KEY (customerid) REFERENCES customers(customerid)
);

-- Insert 5 sample entries
INSERT INTO orders (orderid, customerid, order_date, total_amount) VALUES
(1, 101, '2025-09-10', 250.75),
(2, 102, '2025-09-12', 120.00),
(3, 103, '2025-09-13', 560.50),
(4, 104, '2025-09-15', 75.25),
(5, 101, '2025-09-17', 310.00);

-- Create the employees table
CREATE TABLE employees (
    employeeid INT PRIMARY KEY,
    firstname VARCHAR(50),
    lastname VARCHAR(50),
    department VARCHAR(100),
    hire_date DATE,
    salary DECIMAL(10, 2)
);

-- Insert 5 sample entries
INSERT INTO employees (employeeid, firstname, lastname, department, hire_date, salary) VALUES
(201, 'John', 'Anderson', 'Sales', '2020-03-15', 55000.00),
(202, 'Maria', 'Gomez', 'HR', '2019-06-01', 60000.00),
(203, 'Liam', 'Wilson', 'Engineering', '2021-01-10', 75000.00),
(204, 'Sophie', 'Turner', 'Marketing', '2022-11-20', 58000.00),
(205, 'Daniel', 'Lee', 'Finance', '2023-04-12', 62000.00);

--inner join: retrieve all orders and customer details where orders exist.
-- select c.firstname, c.

SELECT c.firstname, c.lastname, o.total_amount
FROM orders o INNER JOIN customers c 
ON o.customerid = c.customerid;

--LEFT JOIN: Retrieve all customers and their corresponding orders (if any).
SELECT c.firstname, c.lastname, o.total_amount
FROM orders o LEFT JOIN customers c 
ON o.customerid = c.customerid;

--RIGHT JOIN: Retrieve all orders and their corresponding customers (if any).
SELECT c.firstname, c.lastname, o.total_amount
FROM orders o LEFT JOIN customers c 
ON o.customerid = c.customerid;

--FULL OUTER JOIN: Retrieve all customers and all orders, regardless of matching.
SELECT c.firstname, c.lastname, o.total_amount
FROM orders o LEFT JOIN customers c 
ON o.customerid = c.customerid
UNION
SELECT c.firstname, c.lastname, o.total_amount
FROM orders o LEFT JOIN customers c 
ON o.customerid = c.customerid;

--Subquery to find customers who have placed orders worth more than the average amount.
SELECT customerid from orders where total_amount > (select avg(total_amount) from orders);

--Subquery to find employees with salaries above the average salary.
select employeeid, firstname, lastname, department, salary
from employees where salary > (select avg(salary) from employees);

--Extract the year and month from the OrderDate.
SELECT year(order_date) as orderyear, month(order_date) as ordermonth
from orders;

--Calculate the difference in days between two dates (order date and current date).
SELECT 
    orderid, customerid, order_date,
    CURDATE() AS CurrentDate,DATEDIFF(CURDATE(), order_date) AS DaysDifference
FROM orders;

--Format the OrderDate to a more readable format (e.g., 'DD-MMM-YYYY').
SELECT 
    orderid,
    customerid,
    order_date,
    DATE_FORMAT(order_date, '%d-%b-%Y') AS FormattedDate
FROM orders;

--Concatenate FirstName and LastName to form a full name.
SELECT 
    employeeid,
    CONCAT(firstname, ' ', lastname) AS FullName,
    department,
    salary
FROM employees;

--Replace part of a string (e.g., replace 'John' with 'Jonathan').
update employees set firstname='Jonathan' WHERE employeeid=201;

--Convert FirstName to uppercase and LastName to lowercase.
select UPPER(firstname) as uppercase_name from employees;
select LOWER(lastname) as lowercase_name from employees;

--Trim extra spaces from the Email field.
select TRIM(email) from customers;

--Calculate the running total of TotalAmount for each order.
SELECT 
    order_date,
    customerid,
    order_date,
    total_amount,
    SUM(total_amount) OVER (ORDER BY order_date) AS RunningTotal
FROM orders;

--Rank orders based on TotalAmount using the RANK() function.
SELECT 
    orderid,
    customerid,
    order_date,
    total_amount,
    RANK() OVER (ORDER BY total_amount DESC) AS AmountRank
FROM orders;

--Assign a discount based on TotalAmount in orders (e.g., > 1000: 10% off, > 500: 5% off).
SELECT 
    orderid,
    customerid,
    total_amount,
    CASE 
        WHEN total_amount > 1000 THEN total_amount * 0.10  
        WHEN total_amount > 500 THEN total_amount * 0.05   
        ELSE 0                                           
    END AS DiscountAmount,
    CASE 
        WHEN total_amount > 1000 THEN total_amount * 0.90  
        WHEN total_amount > 500 THEN total_amount * 0.95   
        ELSE total_amount                                 
    END AS FinalAmount
FROM orders;

--Categorize employees' salaries as high, medium, or low.
SELECT max(salary) from employees;

SELECT min(salary) from employees;

SELECT AVG(salary) from employees;