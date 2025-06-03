

SHOW DATABASES;

mysql> CREATE DATABASE southwind;
--Query OK, 1 row affected (0.03 sec)
   
mysql> DROP DATABASE southwind;
--Query OK, 0 rows affected (0.11 sec)
   
mysql> CREATE DATABASE IF NOT EXISTS southwind;
--Query OK, 1 row affected (0.01 sec)
   
mysql> DROP DATABASE IF EXISTS southwind;
--Query OK, 0 rows affected (0.00 sec)

- Remove the database "southwind", if it exists.
-- Beware that DROP (and DELETE) actions are irreversible and not recoverable!
mysql> DROP DATABASE IF EXISTS southwind;
Query OK, 1 rows affected (0.31 sec)
 
-- Create the database "southwind"
CREATE DATABASE southwind;
Query OK, 1 row affected (0.01 sec)
 
-- Show all the databases in the server
--   to confirm that "southwind" database has been created.
SHOW DATABASES;
+--------------------+
| Database           |
+--------------------+
| southwind          |
| ......             |
 
-- Set "southwind" as the default database so as to reference its table directly.
USE southwind;
Database changed
 
-- Show the current (default) database
SELECT DATABASE();
+------------+
| DATABASE() |
+------------+
| southwind  |
+------------+
 
-- Show all the tables in the current database.
-- "southwind" has no table (empty set).
SHOW TABLES;
--Empty set (0.00 sec)



-- Create the table "products". Read "explanations" below for the column definitions

CREATE TABLE IF NOT EXISTS products (
         productID    INT UNSIGNED  NOT NULL AUTO_INCREMENT,
         productCode  CHAR(3)       NOT NULL DEFAULT '',
         name         VARCHAR(30)   NOT NULL DEFAULT '',
         quantity     INT UNSIGNED  NOT NULL DEFAULT 0,
         price        DECIMAL(7,2)  NOT NULL DEFAULT 99999.99,
         PRIMARY KEY  (productID)
       );

-- Show all the tables to confirm that the "products" table has been created       
SHOW TABLES;

-- Describe the fields (columns) of the "products" table
DESCRIBE products;

-- Show the complete CREATE TABLE statement used by MySQL to create this table
SHOW CREATE TABLE products \G

-- Insert a row with all the column values
INSERT INTO products VALUES (1001, 'PEN', 'Pen Red', 5000, 1.23);

-- Insert multiple rows in one command
-- Inserting NULL to the auto_increment column results in max_value + 1
INSERT INTO products VALUES
         (NULL, 'PEN', 'Pen Blue',  8000, 1.25),(NULL, 'PEN', 'Pen Black', 2000, 1.25);

select * from products;

-- Insert value to selected columns
-- Missing value for the auto_increment column also results in max_value + 1
INSERT INTO products (productCode, name, quantity, price) VALUES
         ('PEC', 'Pencil 2B', 10000, 0.48),
         ('PEC', 'Pencil 2H', 8000, 0.49);

 
select * from products;
 
-- Missing columns get their default values
INSERT INTO products (productCode, name) VALUES ('PEC', 'Pencil HB');

select * from products;

-- 2nd column (productCode) is defined to be NOT NULL
-- INSERT INTO products values (NULL, NULL, NULL, NULL, NULL);

-- Remove the last row
DELETE FROM products WHERE productID = 1006;

select * from products;

-- List all rows for the specified columns
SELECT name, price FROM products;

-- List all rows of ALL the columns. The wildcard * denotes ALL columns
SELECT * FROM products;

-- SELECT without Table
-- You can also issue SELECT without a table. For example, you can SELECT an expression or evaluate a built-in function.
SELECT 1+1;

SELECT NOW();

SELECT 1+1, NOW();

-- Comparison Operators
-- For numbers (INT, DECIMAL, FLOAT), you could use comparison operators: 
-- '=' (equal to), '<>' or '!=' (not equal to), '>' (greater than), '<' (less than), 
-- '>=' (greater than or equal to), '<=' (less than or equal to), to compare two numbers. 
-- For example, price > 1.0, quantity <= 500.

SELECT name, price FROM products WHERE price < 1.0;

SELECT name, price FROM products WHERE productCode = 'PEN'; -- String values are quoted

-- String Pattern Matching - LIKE and NOT LIKE
-- For strings, in addition to full matching using operators like '=' and '<>', 
-- we can perform pattern matching using operator LIKE (or NOT LIKE) with wildcard characters. 
-- The wildcard '_' matches any single character; '%' matches any number of characters (including zero). 

-- For example,

-- 'abc%' matches strings beginning with 'abc';
-- '%xyz' matches strings ending with 'xyz';
-- '%aaa%' matches strings containing 'aaa';
-- '___' matches strings containing exactly three characters; and
-- 'a_b%' matches strings beginning with 'a', followed by any single character, followed by 'b', followed by zero or more characters.

-- "name" begins with 'PENCIL'
SELECT name, price FROM products WHERE name LIKE 'PENCIL%';

-- "name" begins with 'P', followed by any two characters, 
--   followed by space, followed by zero or more characters
SELECT name, price FROM products WHERE name LIKE 'P__ %';


-- Logical Operators - AND, OR, NOT, XOR
-- You can combine multiple conditions with boolean operators AND, OR, XOR. 
-- You can also invert a condition using operator NOT. 

-- For examples,

SELECT * FROM products WHERE quantity >= 5000 AND name LIKE 'Pen %';

SELECT * FROM products WHERE quantity >= 5000 AND price < 1.24 AND name LIKE 'Pen %';

SELECT * FROM products WHERE NOT (quantity >= 5000 AND name LIKE 'Pen %');

-- IN, NOT IN
-- You can select from members of a set with IN (or NOT IN) operator. 
-- This is easier and clearer than the equivalent AND-OR expression.

SELECT * FROM products WHERE name IN ('Pen Red', 'Pen Black');

-- BETWEEN, NOT BETWEEN
-- To check if the value is within a range, you could use BETWEEN ... AND ... operator. 
-- Again, this is easier and clearer than the equivalent AND-OR expression.

SELECT * FROM products
WHERE (price BETWEEN 1.0 AND 2.0) AND (quantity BETWEEN 1000 AND 2000);

-- IS NULL, IS NOT NULL
-- NULL is a special value, which represent "no value", "missing value" or "unknown value". 
-- You can checking if a column contains NULL by IS NULL or IS NOT NULL. 
-- For example,

SELECT * FROM products WHERE productCode IS NULL;

-- Using comparison operator (such as = or <>) to check for NULL is a mistake - a very common mistake. 
-- For example,

SELECT * FROM products WHERE productCode = NULL;
-- This is a common mistake. NULL cannot be compared.

-- ORDER BY Clause
-- You can order the rows selected using ORDER BY clause, with the following syntax:

-- SELECT ... FROM tableName
-- WHERE criteria
-- ORDER BY columnA ASC|DESC, columnB ASC|DESC, ...

-- Order the results by price in descending order
SELECT * FROM products WHERE name LIKE 'Pen %' ORDER BY price DESC;

-- Order by price in descending order, followed by quantity in ascending (default) order
SELECT * FROM products WHERE name LIKE 'Pen %' ORDER BY price DESC, quantity;

-- You can randomize the returned records via function RAND(), e.g.,
SELECT * FROM products ORDER BY RAND();

-- LIMIT Clause
-- A SELECT query on a large database may produce many rows. 
-- You could use the LIMIT clause to limit the number of rows displayed, e.g.,

-- Display the first two rows
SELECT * FROM products ORDER BY price LIMIT 2;

-- To continue to the following records , you could specify the number of rows to be skipped, 
-- followed by the number of rows to be displayed in the LIMIT clause, as follows:
-- Skip the first two rows and display the next 1 row

SELECT * FROM products ORDER BY price LIMIT 2, 1;

-- AS - Alias
-- You could use the keyword AS to define an alias for an identifier (such as column name, table name). 
-- The alias will be used in displaying the name. It can also be used as reference. 
-- For example,

SELECT productID AS ID, productCode AS Code, name AS Description, price AS `Unit Price`  -- Define aliases to be used as display names
       FROM products
       ORDER BY ID;  -- Use alias ID as reference

-- Take note that the identifier "Unit Price" contains a blank and must be back-quoted.

-- Function CONCAT()
-- You can also concatenate a few columns as one (e.g., joining the last name and first name) using function CONCAT(). 
-- For example,

SELECT CONCAT(productCode, ' - ', name) AS `Product Description`, price FROM products;

-- Producing Summary Reports
-- To produce a summary report, we often need to aggregate related rows.

-- DISTINCT
-- A column may have duplicate values, we could use keyword DISTINCT to select only distinct values. We can also apply DISTINCT to several columns to select distinct combinations of these columns. For examples,

-- Without DISTINCT
SELECT price FROM products;

   
-- With DISTINCT on price
SELECT DISTINCT price AS `Distinct Price` FROM products;

-- DISTINCT combination of price and name
SELECT DISTINCT price, name FROM products;

-- GROUP BY Clause
-- The GROUP BY clause allows you to collapse multiple records with a common value into groups. 
-- For example,

SELECT * FROM products ORDER BY productCode, productID;

-- SELECT * FROM products GROUP BY productCode;
-- Only first record in each group is shown

-- GROUP BY by itself is not meaningful. 
-- It is used together with GROUP BY aggregate functions (such as COUNT(), AVG(), SUM()) to produce group summary.

-- GROUP BY Aggregate Functions: COUNT, MAX, MIN, AVG, SUM, STD, GROUP_CONCAT
-- We can apply GROUP BY Aggregate functions to each group to produce group summary report.

-- The function COUNT(*) returns the rows selected; 
-- COUNT(columnName) counts only the non-NULL values of the given column. 
-- For example,

-- Function COUNT(*) returns the number of rows selected
SELECT COUNT(*) AS `Count` FROM products;
-- All rows without GROUP BY clause

SELECT productCode, COUNT(*) FROM products GROUP BY productCode;

-- Order by COUNT - need to define an alias to be used as reference
SELECT productCode, COUNT(*) AS count 
       FROM products 
       GROUP BY productCode
       ORDER BY count DESC;
       
-- Besides COUNT(), there are many other GROUP BY aggregate functions such as AVG(), MAX(), MIN() and SUM(). 
-- For example,

SELECT MAX(price), MIN(price), AVG(price), STD(price), SUM(quantity)
       FROM products;
       -- Without GROUP BY - All rows
       
 SELECT productCode, MAX(price) AS `Highest Price`, MIN(price) AS `Lowest Price`
       FROM products
       GROUP BY productCode;
       
SELECT productCode, MAX(price), MIN(price),
              CAST(AVG(price) AS DECIMAL(7,2)) AS `Average`,
              CAST(STD(price) AS DECIMAL(7,2)) AS `Std Dev`,
              SUM(quantity)
       FROM products
       GROUP BY productCode;
       -- Use CAST(... AS ...) function to format floating-point numbers
       
-- HAVING clause
-- HAVING is similar to WHERE, but it can operate on the GROUP BY aggregate functions; 
-- whereas WHERE operates only on columns.
SELECT productCode AS `Product Code`,
          COUNT(*) AS `Count`,
          CAST(AVG(price) AS DECIMAL(7,2)) AS `Average`
       FROM products 
       GROUP BY productCode
       HAVING Count >=3;
          -- CANNOT use WHERE count >= 3

-- WITH ROLLUP
-- The WITH ROLLUP clause shows the summary of group summary, e.g.,

SELECT 
          productCode, 
          MAX(price), 
          MIN(price), 
          CAST(AVG(price) AS DECIMAL(7,2)) AS `Average`,
          SUM(quantity)
       FROM products
       GROUP BY productCode
       WITH ROLLUP;        -- Apply aggregate functions to all groups
       
-- Modifying Data - UPDATE
-- To modify existing data, use UPDATE ... SET command, with the following syntax:
-- UPDATE tableName SET columnName = {value|NULL|DEFAULT}, ... WHERE criteria
-- For example,

SELECT * FROM products;
-- Increase the price by 10% for all products
UPDATE products SET price = price * 1.1;
SELECT * FROM products;

-- Modify selected rows
UPDATE products SET quantity = quantity - 100 WHERE name = 'Pen Red';
SELECT * FROM products WHERE name = 'Pen Red';

-- You can modify more than one values
UPDATE products SET quantity = quantity + 50, price = 1.23 WHERE name = 'Pen Red';
SELECT * FROM products WHERE name = 'Pen Red';

-- Deleting Rows - DELETE FROM
-- Use the DELETE FROM command to delete row(s) from a table, with the following syntax:

-- Delete all rows from the table. Use with extreme care! Records are NOT recoverable!!!
-- DELETE FROM tableName
-- Delete only row(s) that meets the criteria

-- DELETE FROM tableName WHERE criteria
-- For example,

DELETE FROM products WHERE name LIKE 'Pencil%';

SELECT * FROM products;

-- Use this with extreme care, as the deleted records are irrecoverable!
DELETE FROM products;

   
SELECT * FROM products;

-- Beware that "DELETE FROM tableName" without a WHERE clause deletes ALL records from the table. 
-- Even with a WHERE clause, you might have deleted some records unintentionally. 
-- It is always advisable to issue a SELECT command with the same WHERE clause 
-- to check the result set before issuing the DELETE (and UPDATE).

