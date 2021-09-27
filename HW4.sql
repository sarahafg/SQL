-- Assignment Day4 –SQL:  Comprehensive practice

-- Answer following questions

-- What is View? What are the benefits of using views?
-- A view is a virtual table whose contents are defined by a query. 
-- Like a real table, a view consists of a set of named columns and rows of data.
-- The benefits of using views is to simplify data manipulation: Views can simplify 
-- how users work with data. You can define frequently used joins, projections, 
-- UNION queries, and SELECT queries as views so that users do not have to specify 
-- all the conditions and qualifications every time an additional operation is 
-- performed on that data.  

-- Can data be modified through views?
-- You can't directly modify data in views.

-- What is stored procedure and what are the benefits of using it?
-- A stored procedure groups one or more Transact-SQL statements into a logical
-- unit, stored as an object in a SQL Server database.
-- The benefits are increased database security. Using stored procedures provides 
-- increased security for a database by limiting direct access. Stored procedures 
-- generally result in improved performance because the database can optimize the 
-- data access plan used by the procedure and cache it for subsequent reuse.

-- What is the difference between view and stored procedure?
-- View is simple showcasing data stored in the database tables whereas a stored 
-- procedure is a group of statements that can be executed. A view is faster as
-- it displays data from the tables referenced whereas a store procedure 
-- executes sql statements.

-- What is the difference between stored procedure and functions?
-- 1. Usage: Stored procedure used for DML; function for calculations.
-- 2. How to call: Stored procedure must be called by its name, 
-- function inside SELECT/FROM statement.
-- 3. Input: Stored procedure may or maynot take input, function must 
-- have input.
-- 4. Output: Stored procedure may or may not have output, function 
-- must return some values.
-- 5. Stored procedure can call functions, but functions cannot 
-- call store procedure.

-- Can stored procedure return multiple result sets?
-- Most stored procedures return multiple result sets. Such a stored 
-- procedure usually includes one or more select statements. The 
-- consumer needs to consider this inclusion to handle all the result 
-- sets.

-- Can stored procedure be executed as part of SELECT Statement? Why?
-- Stored procedures are typically executed with an EXEC statement. 
-- However, you can execute a stored procedure implicitly from within 
-- a SELECT statement, provided that the stored procedure returns a 
-- result set.

-- What is Trigger? What types of Triggers are there?
-- Triggers are a special type of stored procedure that 
-- get executed (fired) when a specific event happens.
-- Insert trigger, delete trigger, and update trigger.

-- What are the scenarios to use Triggers?
-- 1. Enforce Integrity beyond simple Referential Integrity.
-- 2. Implement business rules.
-- 3. Maintain audit record of changes.
-- 4. Accomplish cascading updates and deletes.

-- What is the difference between Trigger and Stored Procedure?
-- A stored procedure is a user defined piece of code written 
-- in the local version of PL/SQL, which may return a value 
-- (making it a function) that is invoked by calling it 
-- explicitly. A trigger is a stored procedure that runs 
-- automatically when various events happen (eg update,
-- insert, delete).

-- Write queries for following scenarios

-- Use Northwind database. All questions are based on assumptions 
-- described by the Database Diagram sent to you yesterday. 
-- When inserting, make up info if necessary. Write query for each 
-- step. Do not use IDE. BE CAREFUL WHEN DELETING DATA OR DROPPING TABLE.

USE Northwind
GO

-- Create a view named “view_product_order_[your_last_name]”, list all 
-- products and total ordered quantity for that product.

CREATE VIEW view_product_order_fakhry
AS
SELECT p.ProductName, COUNT(od.Quantity) AS "TOTAL QTY"
FROM Products p JOIN [Order Details] od ON p.ProductID = od.ProductID
GROUP BY p.ProductName

SELECT *
FROM view_product_order_fakhry

-- Create a stored procedure “sp_product_order_quantity_[your_last_name]” 
-- that accept product id as an input and total quantities of order as output parameter.
CREATE PROC sp_product_order_quantity_fakhry
@prodid int,
@totqty int out 
AS
BEGIN
(SELECT @totqty = COUNT(Quantity) FROM [Order Details])
END

exec sp_product_order_quantity_fakhry 10, 10

--SELECT *
--FROM sp_product_order_quantity_fakhry


-- Create a stored procedure “sp_product_order_city_[your_last_name]” that accept 
-- product name as an input and top 5 cities that ordered most that product combined 
-- with the total quantity of that product ordered from that city as output.
CREATE PROC sp_product_order_city_fakhry
@prodname varchar(20),
@totqty int out 
AS
BEGIN
SELECT TOP 5 c.City, SUM(od.Quantity) AS "Products TOTAL"
FROM Customers c JOIN Orders o ON c.CustomerID = o.CustomerID JOIN [Order Details] od 
ON o.OrderID = od.OrderID JOIN Products p ON od.ProductID = p.ProductID
GROUP BY c.City
END

-- Create 2 new tables “people_your_last_name” “city_your_last_name”. City table has 
-- two records: {Id:1, City: Seattle}, {Id:2, City: Green Bay}. 
-- People has three records: {id:1, Name: Aaron Rodgers, City: 2}, 
-- {id:2, Name: Russell Wilson, City:1}, {Id: 3, Name: Jody Nelson, City:2}. 
-- Remove city of Seattle. If there was anyone from Seattle, put them into a new city “Madison”. 
-- Create a view “Packers_your_name” lists all people from Green Bay. If any error 
-- occurred, no changes should be made to DB. (after test) Drop both tables and view.

CREATE TABLE city_fakhry(
Id int,
City varchar(20)
)
CREATE TABLE people_fakhry(
Id int,
Name varchar(20),
City int
)
INSERT INTO city_fakhry
VALUES(1, 'Seattle')
INSERT INTO city_fakhry
VALUES(2, 'Green Bay')
INSERT INTO people_fakhry
VALUES(1, 'Aaron Rodgers', 2)
INSERT INTO people_fakhry
VALUES(2, 'Russel Wilson', 1)
INSERT INTO people_fakhry
VALUES(3, 'Jody Nelson', 2)
SELECT *
FROM city_fakhry
SELECT *
FROM people_fakhry

DELETE FROM city_fakhry
WHERE City = 'Seattle'
INSERT INTO city_fakhry VALUES(1, 'Madison')

CREATE VIEW Packers_sarah
AS
SELECT City
FROM city_fakhry
WHERE City = 'Green Bay'

DROP TABLE people_fakhry
DROP TABLE city_fakhry
SELECT *
FROM Packers_sarah


-- Create a stored procedure “sp_birthday_employees_[you_last_name]” that creates a new 
-- table “birthday_employees_your_last_name” and fill it with all employees that have a 
-- birthday on Feb. (Make a screen shot) drop the table. Employee table should not be affected.
create proc sp_birthday_employees_fakhry
AS
BEGIN
CREATE TABLE birthday_employees_fakhry(
FirstName varchar(10),
BirthDate int
)
END

INSERT INTO birthday_employees_fakhry VALUES(SELECT FirstName FROM Employees WHERE BirthDate = 02)

DROP TABLE bbirthday_employees_fakhry


-- Create a stored procedure named “sp_your_last_name_1” that returns all cites that have 
-- at least 2 customers who have bought no or only one kind of product. Create a stored 
-- procedure named “sp_your_last_name_2” that returns the same but using a different 
-- approach. (sub-query and no-sub-query).
CREATE PROC sp_fakhry_1
City varchar(20)
AS
BEGIN
select distinct city from orders o join [order details] od on o.orderid=od.orderid join customers c on c.customerid=o.CustomerID
group by city,ProductID
having COUNT(*)>=2
END

CREATE PROC sp_fakhry_2
City varchar(20)
AS
BEGIN
select city from customers group by city having COUNT(*)>=2
END

-- How do you make sure two tables have the same data?
-- You can use UNION ALL or MINUS.

-- 14.
-- First Name	Last Name	Middle Name
-- John		Green	
-- Mike		White		M

-- Output should be

-- Full Name
-- John Green
-- Mike White M.
CREATE TABLE Names(
Fname varchar(20),
Lname varchar(20),
Mname varchar(2),
@res varchar(20) out
)

INSERT INTO Names
VALUES('John', 'Green', NULL)
INSERT INTO Names
VALUES('Mike', 'White', 'M')

-- Note: There is a dot after M when you output.

-- 15.
-- Student	Marks	Sex
-- Ci		70		F
-- Bob		80		M
-- Li		90		F
-- Mi		95		M

-- Find the top marks of Female students.

-- If there are to students have the max score, only output one.
CREATE TABLE StudMarks(
Student varchar(20),
Marks int,
Sex varchar(1)
)

INSERT INTO StudMarks
VALUES('Ci', 70, 'F')

INSERT INTO StudMarks
VALUES('Bob', 80, 'M')

INSERT INTO StudMarks
VALUES('Li', 90, 'F')

INSERT INTO StudMarks
VALUES('Mi', 95, 'M')

SELECT Student, MAX(Marks) AS TopMarks, Sex
FROM StudMarks
WHERE Sex = 'F'
GROUP BY Student, Sex
-- 16.
-- Student	Marks	Sex
-- Li		90		F
-- Ci		70		F
-- Mi		95		M
-- Bob		80		M

-- How do you output this?
SELECT Student, MAX(Marks) AS TopMarks, Sex
FROM StudMarks
GROUP BY Sex

