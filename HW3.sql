-- Answer following questions
-- In SQL Server, assuming you can find the result by using both joins and subqueries, which one would you prefer to use and why?
-- I would prefer to use join because it is more efficient than subquery.

-- What is CTE and when to use it?
-- CTE is a temporary result set that you can reference within another SELECT, INSERT, UPDATE, or DELETE statement and it can be used in VIEW.

-- What are Table Variables? What is their scope and where are they created in SQL Server?
-- A table variable is a local variable that has some similarities to temp tables. Its scoped to the stored procedure, batch,
-- or user-defined function just like any local variable you create with a DECLARE statement.

-- What is the difference between DELETE and TRUNCATE? Which one will have better performance and why?
-- 1) Truncate reseeds identity values, whereas delete doesn't.
-- 2) Truncate removes all records and doesn't fire triggers.
-- 3) Truncate is faster compared to delete as it makes less use of the transaction log.
-- 4) Truncate is not possible when a table is referenced by a Foreign Key or tables are used in replication or with indexed views.

-- What is Identity column? How does DELETE and TRUNCATE affect it?
-- Identity is a special type of column that is used to automatically generate key values based on a provided seed and increment. 
-- DELETE retains the identity and does not reset it to the seed value.
-- TRUNCATE resets the identity to its seed value.

-- What is difference between “delete from table_name” and “truncate table table_name”?
-- TRUNCATE always removes all the rows from a table, leaving the table empty and the table structure intact whereas DELETE may 
-- remove conditionally if the where clause is used.

-- Write queries for following scenarios
-- All scenarios are based on Database NORTHWND.

USE Northwind
GO 

-- List all cities that have both Employees and Customers.
SELECT DISTINCT e.City
FROM Employees e INNER JOIN Customers c ON e.City = c.City

-- List all cities that have Customers but no Employee.
	-- Use sub-query
	-- Do not use sub-query

SELECT DISTINCT c.City
FROM Customers c JOIN Employees e ON c.CustomerID = e.EmployeeID
WHERE e.City IS NULL

SELECT c.City,
(SELECT City FROM Employees e WHERE e.EmployeeId = c.CustomerID)
FROM Customers c
WHERE 
(SELECT e.City FROM Employees e WHERE e.EmployeeID = c.CustomerID) IS NULL
ORDER BY 1, (SELECT City FROM Employees e WHERE e.EmployeeId = c.CustomerID)


-- List all products and their total order quantities throughout all orders.
SELECT p.ProductName, SUM(od.Quantity) AS "QTY TOTAL"
FROM Products p JOIN [Order Details] od ON p.ProductID = od.ProductID
GROUP BY p.ProductName

-- List all Customer Cities and total products ordered by that city.
SELECT c.City, SUM(od.Quantity) AS "Products TOTAL"
FROM Customers c JOIN Orders o ON c.CustomerID = o.CustomerID JOIN [Order Details] od 
ON o.OrderID = od.OrderID JOIN Products p ON od.ProductID = p.ProductID
GROUP BY c.City

-- List all Customer Cities that have at least two customers.
	-- Use union
	-- Use sub-query and no union
SELECT DISTINCT c.City
FROM Customers c UNION Employees e ON c.CustomerID = e.EmployeeID
WHERE e.City IS NULL

SELECT c.City,
(SELECT City FROM Employees e WHERE e.EmployeeId = c.CustomerID)
FROM Customers c
WHERE 
(SELECT e.City FROM Employees e WHERE e.EmployeeID = c.CustomerID) IS NULL
ORDER BY 1, (SELECT City FROM Employees e WHERE e.EmployeeId = c.CustomerID)


-- List all Customer Cities that have ordered at least two different kinds of products.
SELECT City
FROM Customers
UNION
SELECT Products
FROM Products

-- List all Customers who have ordered products, but have the ‘ship city’ on the order different from their own customer cities.
SELECT c.City, SUM(od.Quantity) AS "Products TOTAL"
FROM Customers c JOIN Orders o ON c.CustomerID = o.CustomerID JOIN [Order Details] od 
ON o.OrderID = od.OrderID JOIN Products p ON od.ProductID = p.ProductID
GROUP BY c.City

-- List 5 most popular products, their average price, and the customer city that ordered most quantity of it.
SELECT TOP 5 c.City, SUM(od.Quantity) AS "Products TOTAL"
FROM Customers c JOIN Orders o ON c.CustomerID = o.CustomerID JOIN [Order Details] od 
ON o.OrderID = od.OrderID JOIN Products p ON od.ProductID = p.ProductID
GROUP BY c.City

-- List all cities that have never ordered something but we have employees there.
	-- Use sub-query
	-- Do not use sub-query

SELECT DISTINCT c.City
FROM Customers c UNION Employees e ON c.CustomerID = e.EmployeeID
WHERE e.City IS NULL

SELECT c.City,
(SELECT City FROM Employees e WHERE e.EmployeeId = c.CustomerID)
FROM Customers c
WHERE 
(SELECT e.City FROM Employees e WHERE e.EmployeeID = c.CustomerID) IS NULL
ORDER BY 1, (SELECT City FROM Employees e WHERE e.EmployeeId = c.CustomerID)

-- List one city, if exists, that is the city from where the employee sold most orders (not the product quantity) is, and also 
-- the city of most total quantity of products ordered from. (tip: join  sub-query)
SELECT c.City, SUM(od.Quantity) AS "Products TOTAL"
FROM Customers c JOIN Orders o ON c.CustomerID = o.CustomerID JOIN [Order Details] od 
ON o.OrderID = od.OrderID JOIN Products p ON od.ProductID = p.ProductID
GROUP BY c.City

-- 11. How do you remove the duplicates record of a table?
-- Using DISTINCT.

-- 12. Sample table to be used for solutions below- 
-- Employee (empid integer, mgrid integer, deptid integer, salary money) 
-- Dept (deptid integer, deptname varchar(20))

 -- Find employees who do not manage anybody.
 SELECT empid
FROM Employee
WHERE mgrid IS NULL

-- 13. Find departments that have maximum number of employees. (solution should consider scenario having more than 1 departments 
-- that have maximum number of employees). Result should only have - deptname, count of employees sorted by deptname.
SELECT d.deptname , COUNT(empid) AS NumOfEmployees
FROM Employees e JOIN Dept d ON e.emid = d.empid
GROUP BY d.deptname

-- 14. Find top 3 employees (salary based) in every department. Result should have deptname, empid, salary sorted by deptname and 
-- then employee with high to low salary.
SELECT TOP 3 d.deptname, e.empid, e.salary
FROM Employees e JOIN Dept d ON e.emid = d.empid
GROUP BY e.salary DESC

SELECT *
FROM Employees