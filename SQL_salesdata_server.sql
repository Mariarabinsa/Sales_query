create database SALES;
use SALES

CREATE TABLE Sales_data (
    transaction_id INT IDENTITY(1,1)PRIMARY KEY,
    sale_date DATE NOT NULL,
    sale_time TIME NOT NULL,
    customer_id INT NOT NULL,
    gender VARCHAR(100) NOT NULL CHECK (GENDER IN ('Male', 'Female', 'Other') ),
    age INT NOT NULL,
    category VARCHAR(100) NOT NULL,
    quantity INT NOT NULL,
    price_per_unit DECIMAL(10,2) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    total_sales DECIMAL(10,2) NOT NULL
);


INSERT INTO Sales_data (sale_date, sale_time, customer_id, gender, age, category, quantity, price_per_unit, cogs, total_sales) VALUES
('2024-03-10', '14:30:00', 101, 'Male', 30, 'Electronics', 2, 500.00, 800.00, 1000.00),
('2024-03-11', '16:45:00', 102, 'Female', 27, 'Clothing', 1, 200.00, 150.00, 200.00),
('2024-03-12', '12:15:00', 103, 'Other', 35, 'Groceries', 5, 50.00, 200.00, 250.00),
('2024-03-13', '10:00:00', 104, 'Male', 40, 'Furniture', 1, 1500.00, 1200.00, 1500.00),
('2024-03-14', '18:30:00', 105, 'Female', 22, 'Cosmetics', 3, 75.00, 150.00, 225.00),
('2024-03-15', '09:45:00', 106, 'Male', 50, 'Sports', 2, 300.00, 400.00, 600.00),
('2024-03-16', '11:20:00', 107, 'Female', 33, 'Home Appliances', 1, 700.00, 550.00, 700.00),
('2024-03-17', '20:00:00', 108, 'Other', 29, 'Toys', 4, 40.00, 100.00, 160.00),
('2024-03-18', '13:55:00', 109, 'Male', 45, 'Books', 6, 20.00, 90.00, 120.00),
('2024-03-19', '15:10:00', 110, 'Female', 28, 'Jewelry', 1, 1200.00, 900.00, 1200.00),
('2024-03-20', '17:25:00', 111, 'Male', 38, 'Automobile', 1, 2500.00, 2000.00, 2500.00),
('2024-03-21', '08:05:00', 112, 'Female', 31, 'Groceries', 10, 20.00, 150.00, 200.00),
('2024-03-22', '19:40:00', 113, 'Male', 36, 'Gaming', 1, 600.00, 450.00, 600.00),
('2024-03-23', '14:10:00', 114, 'Female', 25, 'Shoes', 2, 250.00, 350.00, 500.00),
('2024-03-24', '12:00:00', 115, 'Other', 42, 'Furniture', 1, 1800.00, 1400.00, 1800.00),
('2024-03-25', '21:30:00', 116, 'Male', 29, 'Cosmetics', 5, 50.00, 180.00, 250.00),
('2024-03-26', '16:50:00', 117, 'Female', 34, 'Clothing', 3, 150.00, 350.00, 450.00),
('2024-03-27', '10:30:00', 118, 'Male', 27, 'Electronics', 1, 1200.00, 950.00, 1200.00),
('2024-03-28', '18:15:00', 119, 'Female', 40, 'Books', 8, 25.00, 140.00, 200.00),
('2024-03-29', '20:45:00', 120, 'Other', 30, 'Groceries', 7, 30.00, 180.00, 210.00);

SELECT*FROM Sales_data;

-- Feature engineering:

ALTER TABLE sales_data
ADD profit DECIMAL(10,2);

ALTER TABLE sales_data
ADD sales_shift VARCHAR(40);

ALTER TABLE sales_data
ADD month_name VARCHAR(40);

ALTER TABLE sales_data
ADD day_name VARCHAR(40);

ALTER TABLE sales_data
ADD age_group VARCHAR(40);

ALTER TABLE sales_data
ADD high_sale_value INT;


UPDATE sales_data
SET
   profit = total_sales - cogs,
   sales_shift = CASE
         WHEN DATEPART(HOUR,sale_time) < 12 THEN'Morning'
         WHEN DATEPART(HOUR,sale_time) BETWEEN 12 AND 17 THEN 'AFTERNOON'
         ELSE 'EVENING'
END,
month_name = DATENAME(MONTH,sale_date),
day_name = DATENAME(WEEKDAY,sale_date);

UPDATE sales_data
SET high_sale_value = CASE 
    WHEN total_sales >= 1000 THEN 1 
    ELSE 0 
END;

SELECT*FROM Sales_data;

UPDATE Sales_data
SET 
    age_group = CASE
    WHEN age < 18 THEN 'TEEN'
    WHEN age BETWEEN 18 AND 45 THEN 'ADULT'
    ELSE 'SENIOR'
END;

SELECT*FROM Sales_data;

ALTER TABLE sales_data
ADD basket_size DECIMAL(10,2);

ALTER TABLE sales_data
ADD price_category VARCHAR(30);

ALTER TABLE sales_data
ADD season VARCHAR(30);

ALTER TABLE sales_data
ADD profit_margin_percentage DECIMAL(10,2);

ALTER TABLE sales_data
ADD is_repeat_customer INT;

ALTER TABLE sales_data
ADD return_risk_flag INT;

ALTER TABLE sales_data
DROP COLUMN price_categorty;

ALTER TABLE sales_data
DROP COLUMN retyurn_risk_flag;

UPDATE sales_data
SET 
  basket_size = total_sales / quantity,
  price_category = CASE
      WHEN price_per_unit < 50 THEN 'LOW'
      WHEN price_per_unit BETWEEN 50 AND 150 THEN 'MEDIUM'
      ELSE 'HIGH'
  END;

  UPDATE sales_data
SET price_category = CASE
    WHEN price_per_unit < 50 THEN 'LOW'
    WHEN price_per_unit BETWEEN 50 AND 150 THEN 'MEDIUM'
    ELSE 'HIGH'
END;

UPDATE sales_data
SET season = CASE 
    WHEN MONTH(sale_date) IN (12, 1, 2) THEN 'Winter'
    WHEN MONTH(sale_date) IN (3, 4, 5) THEN 'Spring'
    WHEN MONTH(sale_date) IN (6, 7, 8) THEN 'Summer'
    WHEN MONTH(sale_date) IN (9, 10, 11) THEN 'Autumn'
    ELSE 'Unknown'
END;

UPDATE sales_data
SET profit_margin_percentage = 
    CASE 
        WHEN total_sales = 0 THEN 0
        ELSE ((total_sales - cogs) / total_sales) * 100
    END;

UPDATE sales_data
SET is_repeat_customer = CASE 
    WHEN customer_id IN (
        SELECT customer_id
        FROM sales_data
        GROUP BY customer_id
        HAVING COUNT(*) > 1
    ) THEN 1
    ELSE 0
END;

UPDATE sales_data
SET return_risk_flag = CASE 
    WHEN quantity >= 5 AND profit_margin_percentage < 10 THEN 1
    ELSE 0
END;

SELECT*FROM Sales_data;

--1 Retrieve all columns for sales made on ‘2024-03-19’.

create procedure get_column_sales
AS
BEGIN
    SELECT * FROM Sales_data
    WHERE sale_date = '2024-03-19';
end;

exec get_column_sales;

--2. Total sales for Each category wise

create procedure get_each_category
AS
BEGIN
SELECT category,
    SUM(total_sales) AS total_sales_per_category
FROM Sales_data
GROUP BY category
ORDER BY total_sales_per_category DESC;
END;

exec  get_each_category;

--3. Average age of customers who purchased items from the “cosmatics”.

create procedure get_cosmatics
AS
BEGIN
SELECT 
    AVG(age) AS average_age
FROM Sales_data
WHERE category = 'COSMETICS';
end;

exec get_cosmatics;

--4. Query to find all transactions where the total sales is greater than 1000

create procedure greater_1000
AS
BEGIN
    SELECT*FROM Sales_data
    WHERE total_sales > 1000
end;

exec greater_1000;

--5. Query to find the total number of transactions made by each gender in each category

create procedure get_totalnumber
AS
BEGIN
SELECT gender,category,
    COUNT(*) AS total_transactions
FROM Sales_data
GROUP BY gender, category
ORDER BY gender, category
end;

exec get_totalnumber;

--6. Query to retrieve all the transactions where the category is”Clothing” and quantity sold is more than 4 in Month of March – 24

create procedure get_cosmatics_sold
AS
BEGIN
    SELECT * FROM Sales_data
    WHERE 
    category = 'COSMETICS'
    AND quantity > 4
    AND MONTH(sale_date) = 3
    AND YEAR(sale_date) = 2024
end;

exec get_cosmatics_sold;

-- 7. Query to find the number of unique customers who purchased items from each category

create procedure get_unique_customer
AS
BEGIN
SELECT category,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM Sales_data
GROUP BY category
ORDER BY unique_customers DESC
end;

exec get_unique_customer;

-- 8. Query to create each shift and number of orders (Example Morning &lt; 12, Aftrnoon Between 12 &amp; 17, Evening &gt; 17)

create procedure get_shift_order
AS
BEGIN
SELECT 
    CASE 
        WHEN DATEPART(HOUR, sale_time) < 12 THEN 'Morning'
        WHEN DATEPART(HOUR, sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS sales_shift,
    COUNT(*) AS number_of_orders
FROM 
    Sales_data
GROUP BY 
    CASE 
        WHEN DATEPART(HOUR, sale_time) < 12 THEN 'Morning'
        WHEN DATEPART(HOUR, sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END
ORDER BY sales_shift
end;

exec get_shift_order;

 -- 1. Record Count

create procedure get_count
AS
BEGIN
     SELECT COUNT(*) AS record_count
     FROM sales_data;
end;

exec get_count; 


--2. Customer Count

create procedure get_customer_count
AS
BEGIN
    SELECT COUNT(DISTINCT customer_id) AS customer_count
    FROM sales_data;
end;

exec  get_customer_count;

--3. Category Count

create procedure get_category_count
AS
BEGIN
    SELECT COUNT(DISTINCT category) AS category_count
    FROM sales_data;
end;

exec get_category_count;




