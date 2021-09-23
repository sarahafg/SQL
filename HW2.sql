-- Answer following questions
-- What is a result set?
-- An object that represents a set of data returned from a data source, usually as the result of a query.

-- What is the difference between Union and Union All?
-- 1) Union combines records but doesn't include duplicate values, UNION ALL combines but includes duplicate values.
-- 2) UNION: values for the first column will be sorted automatically.
-- 3) UNION cannot be used in recursive cte, UNION ALL can.

-- What are the other Set Operators SQL Server has?
-- UNION, UNION ALL, INTERSECT, and EXCEPT.

-- What is the difference between Union and Join?
-- Join is used to combine columns from different tables, union is used to combine rows.

-- What is the difference between INNER JOIN and FULL JOIN?
-- INNER JOIN only joins the records that are both the same, FULL JOIN combines everything.

-- What is difference between left join and outer join?
-- LEFT JOIN returns all rows from the left table, and the matching rows from the right table. OUTER JOIN combines all records from the left and right records that are not the same.

-- What is cross join?
-- Cross join combines each row from the first table with each row from the second table.

-- What is the difference between WHERE clause and HAVING clause?
-- 1) HAVING is applied to groups as a whole, WHERE is applied to individual rows.
-- 2) WHERE goes before aggregations, HAVING goes after aggregations.
-- 3) WHERE can be used with SELECT and UPDATE, HAVING can be used with only SELECT.

-- Can there be multiple group by columns?
-- Yes, but costs a lot.

USE AdventureWorks2019
GO

-- Write queries for following scenarios

-- How many products can you find in the Production.Product table?
SELECT COUNT(*)
FROM Production.Product

-- Write a query that retrieves the number of products in the Production.Product table that are included in a subcategory. 
-- The rows that have NULL in column ProductSubcategoryID are considered to not be a part of any subcategory.
SELECT COUNT(*) AS "Number of Products"
FROM Production.Product
WHERE ProductSubcategoryID IS NOT NULL


-- How many Products reside in each SubCategory? Write a query to display the results with the following titles.
SELECT ProductSubcategoryID, COUNT(ProductID) AS "CountedProducts"
FROM Production.Product
GROUP BY ProductSubcategoryID

-- ProductSubcategoryID CountedProducts
-- -------------------- ---------------


-- How many products that do not have a product subcategory. 
SELECT COUNT(ProductID) AS "CountedProducts"
FROM Production.Product
WHERE (ProductSubcategoryID) IS NULL

SELECT ProductID, ProductSubcategoryID
FROM Production.Product
ORDER BY 1, 2


-- Write a query to list the sum of products quantity in the Production.ProductInventory table.
SELECT ProductID, SUM(Quantity) AS "Sum"
FROM Production.ProductInventory
GROUP BY ProductID
ORDER BY 1, 2

--Write a query to list the sum of products in the Production.ProductInventory table and LocationID set to 40 and 
-- limit the result to include just summarized quantities less than 100.
SELECT ProductID, SUM(Quantity) AS "TheSum"
FROM Production.ProductInventory
WHERE Quantity < 100 AND LocationID = 40
GROUP BY ProductID
ORDER BY 1, 2

-- ProductID    TheSum
-- -----------  ----------


-- Write a query to list the sum of products with the shelf information in the Production.ProductInventory table and 
-- LocationID set to 40 and limit the result to include just summarized quantities less than 100
SELECT Shelf, ProductID, SUM(ProductID) AS "TheSum"
FROM Production.ProductInventory
WHERE Quantity < 100 AND LocationID = 40 AND Shelf != 'N/A'
GROUP BY Shelf, ProductID
ORDER BY 1, 2

-- Shelf      ProductID    TheSum
-- ---------- -----------  -----------


-- Write the query to list the average quantity for products where column LocationID has the value of 10 from the 
-- table Production.ProductInventory table.
SELECT ProductID, AVG(Quantity) AS "TheAVG"
FROM Production.ProductInventory
WHERE LocationID = 10
GROUP BY ProductID
ORDER BY 1, 2

-- Write query  to see the average quantity  of  products by shelf  from the table Production.ProductInventory
SELECT ProductID, Shelf, AVG(Quantity) AS "TheAvg"
FROM Production.ProductInventory
WHERE LocationID = 10
GROUP BY ProductID, Shelf
ORDER BY 1, 2

-- ProductID   Shelf      TheAvg
-- ----------- ---------- -----------


-- Write query  to see the average quantity  of  products by shelf excluding rows that has the value of N/A in 
-- the column Shelf from the table Production.ProductInventory
SELECT ProductID, Shelf, AVG(Quantity) AS "TheAvg"
FROM Production.ProductInventory
WHERE LocationID = 10 AND Shelf != 'N/A'
GROUP BY ProductID, Shelf
ORDER BY 1, 2

--  ProductID   Shelf      TheAvg
--  ----------- ---------- -----------


-- List the members (rows) and average list price in the Production.Product table. This should be grouped independently
-- over the Color and the Class column. Exclude the rows where Color or Class are null.
SELECT Color, Class, COUNT(rowguid) AS "TheCount", AVG(ListPrice) AS "AvgPrice"
FROM Production.Product
WHERE Color IS NOT NULL AND Class IS NOT NULL
GROUP BY Color, Class
ORDER BY 1, 2

-- Color           	Class 	TheCount   	 AvgPrice
-- --------------	------ 	-----------  ---------------------


-- Joins:

-- Write a query that lists the country and province names from person. CountryRegion and person. StateProvince tables.
-- Join them and produce a result set similar to the following. 
SELECT c.CountryRegion, c.StateProvince
FROM [Person.CountryRegion] od JOIN CountryRegion c ON od.OrderID = o.OrderID JOIN Customers c ON c.CustomerID = o.CustomerID
GROUP BY c.ContactName
ORDER BY AvgRevenue DESC

-- Country                        Province
-- ---------                      ----------------------


-- Write a query that lists the country and province names from person. CountryRegion and person. StateProvince tables 
-- and list the countries filter them by Germany and Canada. Join them and produce a result set similar to the following.
SELECT c.CountryRegion, c.StateProvince
FROM [Person.CountryRegion] od JOIN CountryRegion c ON od.OrderID = o.OrderID JOIN Customers c ON c.CustomerID = o.CustomerID
GROUP BY c.ContactName
ORDER BY AvgRevenue DESC

-- Country                        Province
-- ---------                      ----------------------
SELECT c.CountryRegion, c.StateProvince
FROM [Person.CountryRegion] od JOIN CountryRegion c ON od.OrderID = o.OrderID JOIN Customers c ON c.CustomerID = o.CustomerID
GROUP BY c.ContactName
ORDER BY AvgRevenue DESC

--        Using Northwnd Database: (Use aliases for all the Joins)
USE Northwind
GO

-- List all Products that has been sold at least once in last 25 years.
SELECT DISTINCT o1.CustomerID, YEAR(o1.OrderDate) AS Year1, YEAR(o2.OrderDate) AS Year2, YEAR(o3.OrderDate) AS Year3
FROM Orders o1, Orders o2, Orders o3
WHERE Year(o1.OrderDate) = Year(o2.OrderDate) - 1 AND Year(o1.OrderDate) = Year(o3.OrderDate) - 2 AND o1.CustomerID = o2.CustomerID AND o1.CustomerID = o3.CustomerID
ORDER BY o1.CustomerID, Year1

-- List top 5 locations (Zip Code) where the products sold most.
SELECT ProductName, UnitPrice
FROM Products

-- List top 5 locations (Zip Code) where the products sold most in last 25 years.
SELECT ProductName, UnitPrice
FROM Products

-- List all city names and number of customers in that city.     
SELECT ContactName, City
FROM Customers
ORDER BY 1

-- List city names which have more than 2 customers, and number of customers in that city 
SELECT ContactName, City
FROM Customers
ORDER BY 1

-- List the names of customers who placed orders after 1/1/98 with order date.
SELECT ContactName, City
FROM Customers
ORDER BY 1

-- List the names of all customers with most recent order dates 
SELECT ContactName, City
FROM Customers
ORDER BY 1

-- Display the names of all customers  along with the  count of products they bought 
SELECT ContactName, City
FROM Customers
ORDER BY 1

-- Display the customer ids who bought more than 100 Products with count of products.
SELECT ContactName, City
FROM Customers
ORDER BY 1

-- List all of the possible ways that suppliers can ship their products. Display the results as below
SELECT ContactName, City
FROM Customers
ORDER BY 1

-- Supplier Company Name   	Shipping Company Name
-- ---------------------    ----------------------


-- Display the products order each day. Show Order date and Product Name.
SELECT ContactName, City
FROM Customers
ORDER BY 1

-- Displays pairs of employees who have the same job title.
SELECT ContactName, City
FROM Customers
ORDER BY 1

-- Display all the Managers who have more than 2 employees reporting to them.
SELECT ContactName, City
FROM Customers
ORDER BY 1

-- Display the customers and suppliers by city. The results should have the following columns
SELECT ContactName, City
FROM Customers
ORDER BY 1

-- City 
-- Name 
-- Contact Name,
-- Type (Customer or Supplier)
