-- Data Cleaning 


SELECT *
FROM customers;

-- 1. Remove Duplicates
-- 2. Standardize the Data
-- 3. Null Values or Blank Values
-- 4. Remove any Columns

-- Create a staging Table to Work on

CREATE TABLE customers_staging
LIKE customers;


SELECT *
FROM customers_staging;

INSERT customers_staging
SELECT *
FROM customers;

-- REMOVE DUPLICATES

SELECT *
FROM customers_staging;


SELECT *,
ROW_NUMBER() OVER(
PARTITION BY customerNumber, phone, customerName) AS row_num
FROM customers_staging;

WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY customerNumber, phone, customerName) AS row_num
FROM customers_staging
)
SELECT *
FROM duplicate_cte 
WHERE row_num > 1;
-- There are no duplicates

-- 2. Standardizing Data

UPDATE customers_staging
SET 
    customerNumber = TRIM(customerNumber),
    customerName = TRIM(customerName),
    contactLastName = TRIM(contactLastName),
    contactFirstName = TRIM(contactFirstName),
    phone = TRIM(phone),
    addressLine1 = TRIM(addressLine1),
    addressLine2 = TRIM(addressLine2),
    city = TRIM(city),
    state = TRIM(state),
    postalCode = TRIM(postalCode),
    country = TRIM(country),
    salesRepEmployeeNUmber = TRIM(salesRepEmployeeNUmber),
    creditLimit = TRIM(creditLimit);
    -- Removed leading and trailing white spaces
SELECT *
FROM customers_staging; 

SELECT DISTINCT city
FROM customers_staging
WHERE state IS NULL OR state = ''
ORDER BY city;

-- A are alot of countries with null
-- The countries with null states are not part of the United States

UPDATE customers_staging
SET state = CASE
    WHEN city = 'Aachen' THEN 'N/A'
    WHEN city = 'Amsterdam' THEN 'N/A'
    WHEN city = 'Auckland' THEN 'N/A'
    WHEN city = 'Barcelona' THEN 'N/A'
    WHEN city = 'Bergamo' THEN 'N/A'
    WHEN city = 'Bergen' THEN 'N/A'
    WHEN city = 'Berlin' THEN 'N/A'
    WHEN city = 'Bern' THEN 'N/A'
    WHEN city = 'Brandenburg' THEN 'N/A'
    WHEN city = 'Bruxelles' THEN 'N/A'
    WHEN city = 'Bräcke' THEN 'N/A'
    WHEN city = 'Central Hong Kong' THEN 'N/A'
    WHEN city = 'Charleroi' THEN 'N/A'
    WHEN city = 'Cunewalde' THEN 'N/A'
    WHEN city = 'Dublin' THEN 'N/A'
    WHEN city = 'Espoo' THEN 'N/A'
    WHEN city = 'Frankfurt' THEN 'N/A'
    WHEN city = 'Fribourg' THEN 'N/A'
    WHEN city = 'Genève' THEN 'N/A'
    WHEN city = 'Graz' THEN 'N/A'
    WHEN city = 'Helsinki' THEN 'N/A'
    WHEN city = 'Herzlia' THEN 'N/A'
    WHEN city = 'Kobenhavn' THEN 'N/A'
    WHEN city = 'Köln' THEN 'N/A'
    WHEN city = 'Leipzig' THEN 'N/A'
    WHEN city = 'Lille' THEN 'N/A'
    WHEN city = 'London' THEN 'N/A'
    WHEN city = 'Lyon' THEN 'N/A'
    WHEN city = 'Madrid' THEN 'N/A'
    WHEN city = 'Makati City' THEN 'N/A'
    WHEN city = 'Manchester' THEN 'N/A'
    WHEN city = 'Marseille' THEN 'N/A'
    WHEN city = 'Milano' THEN 'N/A'
    WHEN city = 'Montréal' THEN 'N/A'
    WHEN city = 'München' THEN 'N/A'
    WHEN city = 'Nantes' THEN 'N/A'
    WHEN city = 'Osaka' THEN 'N/A'
    WHEN city = 'Oslo' THEN 'N/A'
    WHEN city = 'Paris' THEN 'N/A'
    WHEN city = 'Reims' THEN 'N/A'
    WHEN city = 'Reykjavík' THEN 'N/A'
    WHEN city = 'Roma' THEN 'N/A'
    WHEN city = 'Salzburg' THEN 'N/A'
    WHEN city = 'Sevilla' THEN 'N/A'
    WHEN city = 'Singapore' THEN 'N/A'
    WHEN city = 'Stuttgart' THEN 'N/A'
    WHEN city = 'Sydney' THEN 'N/A'
    WHEN city = 'Tel Aviv' THEN 'N/A'
    WHEN city = 'Tokyo' THEN 'N/A'
    WHEN city = 'Torino' THEN 'N/A'
    WHEN city = 'Toulouse' THEN 'N/A'
    WHEN city = 'Vancouver' THEN 'N/A'
    WHEN city = 'Versailles' THEN 'N/A'
    WHEN city = 'Wien' THEN 'N/A'
    WHEN city = 'Zürich' THEN 'N/A'
    ELSE state
END
WHERE state IS NULL OR state = '';

SELECT *
FROM customers_staging;

      
UPDATE customers_staging
SET state = CASE
    WHEN city = 'Lisboa'      THEN 'N/A'
    WHEN city = 'Liverpool'   THEN 'N/A'
    WHEN city = 'Luleå'       THEN 'N/A'
    WHEN city = 'Mannheim'    THEN 'N/A'
    WHEN city = 'Milan'       THEN 'N/A'
    WHEN city = 'Munich'      THEN 'N/A'
    WHEN city = 'Münster'     THEN 'N/A'
    WHEN city = 'Oulu'        THEN 'N/A'
    WHEN city = 'Reggio Emilia' THEN 'N/A'
    WHEN city = 'Saint Petersburg' THEN 'N/A'
    WHEN city = 'Stavern'  THEN 'N/A'
    WHEN city = 'Strasbourg'  THEN 'N/A'
    WHEN city = 'Warszawa' THEN 'N/A'
    WHEN city = 'Wellington' THEN 'N/A'
    WHEN city = 'Århus' THEN 'N/A'
    ELSE state
END
WHERE state IS NULL OR state = '';   
   
SELECT DISTINCT city
FROM customers_staging
WHERE state IS NULL OR state = ''
ORDER BY city;  

-- The states that are not part of the United states were updated with N/A
 
 SELECT DISTINCT country
 FROM customers_staging
 ORDER BY 1;

SELECT *
FROM customers_staging
WHERE country LIKE 'USA%';

UPDATE customers_staging
SET country = 'United States'
WHERE country LIKE 'USA%';
-- USA was updated to United States


SELECT *
FROM customers_staging
WHERE country LIKE 'UK%';

UPDATE customers_staging
SET country = 'United Kingdom'
WHERE country LIKE 'UK%';
-- UK was updated to United Kingdom

SELECT DISTINCT city, state, country
FROM customers_staging
ORDER BY 1;

SELECT *
FROM customers_staging
WHERE city LIKE 'Brickhaven%';
    
UPDATE customers_staging
SET city = 'Brookhaven',
    state = 'GA'
WHERE city = 'Brickhaven' AND state = 'MA';

-- Brookhaven was misspelt as Brickhaven with incorrect state MA
-- It was updated to Brookhaven and GA

SELECT DISTINCT city, state, country
FROM customers_staging
ORDER BY 1;

UPDATE customers_staging
SET city = 'Brookhaven'
WHERE city = 'brookhaven';
-- Updated by using a capital letter

SELECT *
FROM customers_staging
WHERE city LIKE 'Central Hong Kong%';

UPDATE customers_staging
SET city = 'Hong Kong City'
WHERE city = 'Central Hong Kong';
-- Updated the name of city from Central Hong Kong to Hong Kong City


UPDATE customers_staging
SET state = 'N/A'
WHERE state = 'Co. Cork';
-- Updated state

SELECT *
FROM customers_staging
WHERE city LIKE 'Cunewalde%';

DELETE FROM customers_staging
WHERE city = 'Cunewalde';
-- Customer was deleted because there are no information like credit limit for orders

SELECT *
FROM customers_staging
WHERE city LIKE 'Hatfield%';

DELETE FROM customers_staging
WHERE city = 'Hatfield';
-- Customer was deleted because there are no information like credit limit for orders

SELECT *
FROM customers_staging
WHERE city LIKE 'Minato-ku%';

-- UPDATE customers_staging
UPDATE customers_staging
SET city = 'Tokyo',
    state = 'N/A'
WHERE city = 'Minato-ku' AND state = 'Tokyo';
-- Updated city to Tokyo

SELECT *
FROM customers_staging
WHERE city LIKE 'Melbourne%';

UPDATE customers_staging
SET state = 'N/A'
WHERE state = 'Victoria';
-- Updated state to N/A

SELECT *
FROM customers_staging
WHERE city LIKE 'Montréal%';

UPDATE customers_staging
SET state = 'N/A'
WHERE state = 'Québec';
-- Updated the state for the city Montreal

SELECT *
FROM customers_staging
WHERE city LIKE 'North Sydney%';

UPDATE customers_staging
SET state = 'N/A'
WHERE state = 'NSW';
-- Updated the state to N/A

SELECT *
FROM customers_staging
WHERE city LIKE 'NYC%';

UPDATE customers_staging
SET city = 'New York City'
WHERE city = 'NYC';
-- Updated  city from NYC to New York City

SELECT *
FROM customers_staging
WHERE city LIKE 'South Brisbane%';

-- UPDATE customers_staging
UPDATE customers_staging
SET city = 'Brisbane',
    state = 'N/A'
WHERE city = 'South Brisbane' AND state = 'Queensland';
-- Updated the city to Brisbane and state N/A

SELECT *
FROM customers_staging
WHERE city LIKE 'Tsawassen%';

-- UPDATE customers_staging
UPDATE customers_staging
SET city = 'City of Delta',
    state = 'N/A'
WHERE city = 'Tsawassen' AND state = 'BC';
-- Updated the city to City of Delta from Tsawassen

SELECT *
FROM customers_staging
WHERE state LIKE 'BC%';

-- UPDATE customers_staging
UPDATE customers_staging
SET state = 'N/A'
WHERE state = 'BC';
-- Updated the state to N/A

SELECT *
FROM customers_staging
WHERE city LIKE 'Kita-ku%';

-- UPDATE customers_staging
UPDATE customers_staging
SET city = 'Osaka',
    state = 'N/A'
WHERE city = 'Kita-ku' AND state = 'Osaka';
-- Updated the city from kita-ku to Osaka

SELECT contactFirstName, contactLastName
FROM customers_staging; 
-- Columns looks okay

SELECT *
FROM customers_staging
WHERE customerNumber IS NULL; 

DELETE
FROM customers_staging
WHERE customerNumber IS NULL;


SELECT *
FROM customers_staging;

-- Alter table names

ALTER TABLE customers_staging
RENAME COLUMN customerNumber TO customer_number;

ALTER TABLE customers_staging
RENAME COLUMN  customerName TO customer_name;

ALTER TABLE customers_staging
RENAME COLUMN contactLastName TO contact_last_name;

ALTER TABLE customers_staging
RENAME COLUMN contactFirstName TO contact_first_name;

ALTER TABLE customers_staging
RENAME COLUMN addressLine1 TO address_line_1;

ALTER TABLE customers_staging
RENAME COLUMN addressLine2 TO address_line_2;

ALTER TABLE customers_staging
RENAME COLUMN salesRepEmployeeNumber TO sales_rep_employee_number;

ALTER TABLE customers_staging
RENAME COLUMN postalCode TO postalcode;
-- Some of the column names were renamed to be more readable

-- Alter table to remove the phone column
ALTER TABLE customers_staging
DROP COLUMN phone;
-- Removed column because it had incomplete numbers, not very usful

SELECT *
FROM customers_staging;


-- Add a full address column by joining address_line_1 and address_line_2

ALTER TABLE customers_staging
ADD COLUMN new_address VARCHAR(255);

UPDATE customers_staging
SET new_address = TRIM(
    CONCAT_WS(', ',
        CONCAT(
            -- Extract number first
            REGEXP_SUBSTR(address_line_1, '[0-9]+'),
            ' ',
            -- Remove number and standardize abbreviations
            REPLACE(
            REPLACE(
            REPLACE(
            REPLACE(
            REPLACE(
            REPLACE(
            REPLACE(
                TRIM(REGEXP_REPLACE(address_line_1, '[0-9]+', '')),
                ' St.', ' Street'
            ),
                ' Str.', ' Street'
            ),
                ' Rd', ' Road'
            ),
                ' Ave', ' Avenue'
            ),
                ' Rue', ' Street'
            ),
                'ul.', 'Street'
            ),
                'C/', 'Street'
            )
        ),
        -- Append address2 if exists
        IF(address_line_2 IS NULL OR address_line_2 = '', NULL, address_line_2)
    )
);

-- Join address_line_1 and address_line_2
-- Places numbers to the start of the address
-- Standardize the abbreviations 

DELETE FROM customers_staging
WHERE customer_number IS NULL;
-- There is a null roww that needs to be deleted
-- The delete statement did not work


SELECT *
FROM customers_staging;

SELECT *
FROM employees;

-- Clean the employees table
-- Create a staging table

CREATE TABLE employees_staging
LIKE employees;

SELECT *
FROM employees_staging;

INSERT employees_staging
SELECT *
FROM employees;

SELECT firstName, lastName, email
FROM employees_staging;

-- corect the email address for Mary Patterson

SELECT *
FROM employees_staging
WHERE email LIKE 'mpatterso%';

UPDATE employees_staging
SET email = 'mpatterson@classicmodelcars.com'
WHERE email = 'mpatterso@classicmodelcars.com';

SELECT *
FROM employees_staging;

 -- Alter column names
 
 ALTER TABLE employees_staging
RENAME COLUMN employeeNumber TO employee_number;

ALTER TABLE employees_staging
RENAME COLUMN lastName TO last_name;

ALTER TABLE employees_staging
RENAME COLUMN firstName TO first_name;

ALTER TABLE employees_staging
RENAME COLUMN officeCode TO office_code;

ALTER TABLE employees_staging
RENAME COLUMN reportsTo TO reports_to;

ALTER TABLE employees_staging
RENAME COLUMN jobTitle TO job_title;


SELECT *
FROM employees_staging
WHERE employee_number IS NULL;

DELETE FROM employees_staging
WHERE employee_number IS NULL;
-- Run query to delete null row
-- It did not work

SELECT *
FROM employees_staging;

SELECT * 
FROM offices;

-- Create a staging office table
CREATE TABLE offices_staging
LIKE offices;

SELECT *
FROM offices_staging;

INSERT offices_staging
SELECT *
FROM offices;

-- Rename column 
ALTER TABLE offices_staging
RENAME COLUMN officeCode TO office_code;

ALTER TABLE offices_staging
RENAME COLUMN addressLine1 TO address_line_1;

ALTER TABLE offices_staging
RENAME COLUMN addressLine2 TO address_line_2;

ALTER TABLE offices_staging
RENAME COLUMN postalCode TO postal_code;

-- Correct spelling form NYC to Nw York City
SELECT *
FROM offices_staging
WHERE city LIKE 'NYC%';

UPDATE customers_staging
SET city = 'New York City'
WHERE city = 'NYC';

UPDATE offices_staging
SET city = 'New York City'
WHERE city = 'NYC';

SELECT *
FROM offices_staging;

SELECT *
FROM orderdetails;

-- Create orderdetails staging table 

CREATE TABLE orderdetails_staging
LIKE orderdetails;

SELECT *
FROM orderdetails_staging;

INSERT orderdetails_staging
SELECT *
FROM orderdetails;

ALTER TABLE orderdetails_staging
RENAME COLUMN orderNumber TO order_number;

ALTER TABLE orderdetails_staging
RENAME COLUMN productCode TO product_code;

ALTER TABLE orderdetails_staging
RENAME COLUMN quantityOrdered TO quantity_ordered;

ALTER TABLE orderdetails_staging
RENAME COLUMN priceEach TO price_each;

ALTER TABLE orderdetails_staging
RENAME COLUMN orderLineNumber TO order_line_number;

SELECT *
FROM orderdetails_staging;

SELECT *
FROM orders;
-- Create a orders staging table

CREATE TABLE orders_staging
LIKE orders;

SELECT *
FROM orders_staging;

INSERT orders_staging
SELECT *
FROM orders;

-- Rename column names

ALTER TABLE orders_staging
RENAME COLUMN orderNumber TO order_number;

ALTER TABLE orders_staging
RENAME COLUMN orderDate TO order_date;

ALTER TABLE orders_staging
RENAME COLUMN requiredDate TO required_date;

ALTER TABLE orders_staging
RENAME COLUMN shippedDate TO shipped_date;

ALTER TABLE orders_staging
RENAME COLUMN customerNumber TO customer_number;


SELECT *
FROM payments;

-- Create a payments staging table
CREATE TABLE payments_staging
LIKE payments;

SELECT *
FROM payments_staging;

INSERT payments_staging
SELECT *
FROM payments;

-- Rename columns
ALTER TABLE payments_staging
RENAME COLUMN customerNumber TO customer_number;

ALTER TABLE payments_staging
RENAME COLUMN checkNumber TO check_number;

ALTER TABLE payments_staging
RENAME COLUMN paymentDate TO payment_date;

SELECT * 
FROM productlines;

-- Create productlines staging table

CREATE TABLE productlines_staging
LIKE productlines;

SELECT *
FROM productlines_staging;

INSERT productlines_staging
SELECT *
FROM productlines;

-- Rename columns
ALTER TABLE productlines_staging
RENAME COLUMN productLine TO product_line;

ALTER TABLE productlines_staging
RENAME COLUMN textDescription TO text_description;

SELECT *
FROM products;

-- Create products staging table

CREATE TABLE products_staging
LIKE products;

SELECT *
FROM products_staging;

INSERT products_staging
SELECT *
FROM products;

-- Remane columns
ALTER TABLE products_staging
RENAME COLUMN productCode TO product_code;

ALTER TABLE products_staging
RENAME COLUMN productName TO product_name;

ALTER TABLE products_staging
RENAME COLUMN productLine TO product_line;

ALTER TABLE products_staging
RENAME COLUMN productScale TO product_scale;

ALTER TABLE products_staging
RENAME COLUMN productVendor TO product_vendor;

ALTER TABLE products_staging
RENAME COLUMN productDescription TO product_description;

ALTER TABLE products_staging
RENAME COLUMN quantityInStock TO quantity_in_stock;

ALTER TABLE products_staging
RENAME COLUMN warehouseCode TO warehouse_code;

ALTER TABLE products_staging
RENAME COLUMN buyPrice TO buy_price;

SELECT *
FROM warehouses;

-- Create warehouses staging table
CREATE TABLE warehouses_staging
LIKE warehouses;

SELECT *
FROM warehouses_staging;

INSERT warehouses_staging
SELECT *
FROM warehouses;

-- Rename columns

ALTER TABLE warehouses_staging
RENAME COLUMN warehouseCode TO warehouse_code;

ALTER TABLE warehouses_staging
RENAME COLUMN warehouseName TO warehouse_name_code;

ALTER TABLE warehouses_staging
RENAME COLUMN warehousePctCap TO warehouse_pct_cap;















