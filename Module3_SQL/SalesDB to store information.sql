-- Step 1: Create the Database
CREATE DATABASE SalesDB;
USE SalesDB;

-- Step 2: Create the Sales Table
CREATE TABLE Sales (
    sale_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    customer_name VARCHAR(100),
    quantity INT,
    price_per_unit DECIMAL(10,2),
    sale_date DATE
);

-- Step 3: Insert Sample Data
INSERT INTO Sales (sale_id, product_name, customer_name, quantity, price_per_unit, sale_date)
VALUES
    (1, 'Laptop', 'Alisha', 2, 750.50, '2024-01-01'),
    (2, 'Phone', 'Bella', 5, 300.99, '2024-01-05'),
    (3, 'Tablet', 'Chirag', 3, 450.75, '2024-01-10'),
    (4, 'Monitor', 'Deepika', 1, 200.00, '2024-01-15');

-- A: Aggregate Functions
-- (i) Count total number of sales:
SELECT COUNT(*) AS total_sales FROM Sales;

-- (ii) Calculate total and average revenue:
SELECT SUM(quantity * price_per_unit) AS total_revenue, AVG(quantity * price_per_unit) AS avg_revenue FROM Sales;

-- (iii) Find highest and lowest sale prices:
SELECT MAX(price_per_unit) AS highest_price, MIN(price_per_unit) AS lowest_price FROM Sales;

-- B: String Functions
-- (i) Create a description string:
SELECT CONCAT(product_name, ' sold to ', customer_name) AS sale_description FROM Sales;

-- (ii) Display product names in uppercase and lowercase:
SELECT UPPER(product_name) AS product_uppercase, LOWER(product_name) AS product_lowercase FROM Sales;

-- C: Numeric Functions
-- (i) Round average price to nearest whole number:
SELECT ROUND(AVG(price_per_unit)) AS avg_price_rounded FROM Sales;

-- (ii) Show ceiling and floor of average price:
SELECT CEIL(AVG(price_per_unit)) AS ceil_avg_price, FLOOR(AVG(price_per_unit)) AS floor_avg_price FROM Sales;

-- D: Date/Time Functions
-- (i) Display current date and time:
SELECT NOW() AS `current_date_time` , CURDATE() AS `current_date`;

-- (ii) Add 30 days to sale date:
SELECT DATE_ADD(sale_date, INTERVAL 30 DAY) AS new_date FROM Sales WHERE sale_id = 1;

-- E: Conversion Functions
-- (i) Convert quantity to VARCHAR:
SELECT CAST(quantity AS CHAR) AS quantity_as_string FROM Sales WHERE sale_id = 3;

-- (ii) Convert price_per_unit to CHAR:
SELECT CONVERT(price_per_unit, CHAR) AS price_as_string FROM Sales WHERE sale_id = 4;