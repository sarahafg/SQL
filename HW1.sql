USE AdventureWorks2019
GO

-- Write a query that retrieves the columns ProductID, Name, Color and ListPrice from the Production.Product table, with no filter. 
SELECT ProductID, Name, Color, ListPrice 
FROM Production.Product

-- Write a query that retrieves the columns ProductID, Name, Color and ListPrice from the Production.Product table, excludes the rows that ListPrice is 0.
SELECT ProductID, Name, Color, ListPrice 
FROM Production.Product
WHERE ListPrice != 0

-- Write a query that retrieves the columns ProductID, Name, Color and ListPrice from the Production.Product table, the rows that are rows that are NULL for the Color column.
SELECT ProductID, Name, Color, ListPrice 
FROM Production.Product
WHERE Color is Null

-- Write a query that retrieves the columns ProductID, Name, Color and ListPrice from the Production.Product table, the rows that are not NULL for the Color column.
SELECT ProductID, Name, Color, ListPrice 
FROM Production.Product
WHERE Color is NOT Null

-- Write a query that retrieves the columns ProductID, Name, Color and ListPrice from the Production.Product table, the rows that are not NULL for the column Color, and the column ListPrice has a value greater than zero.
SELECT ProductID, Name, Color, ListPrice 
FROM Production.Product
WHERE Color is NOT Null AND ListPrice > 0

-- Write a query that concatenates the columns Name and Color from the Production.Product table by excluding the rows that are null for color.
SELECT Name + ' ' + 'and' + ' ' + Color AS "Name and Color"
FROM Production.Product
WHERE Color is NOT Null

-- Write a query that generates the following result set  from Production.Product:
SELECT 'NAME: ' + Name + '  --  ' + 'COLOR: ' + Color AS "Name And Color"
FROM Production.Product
WHERE Color is NOT Null

--Name And Color
--------------------------------------------------
--NAME: LL Crankarm  --  COLOR: Black
--NAME: ML Crankarm  --  COLOR: Black
--NAME: HL Crankarm  --  COLOR: Black
--NAME: Chainring Bolts  --  COLOR: Silver
--NAME: Chainring Nut  --  COLOR: Silver
--NAME: Chainring  --  COLOR: Black
--    ………
-- Write a query to retrieve the to the columns ProductID and Name from the Production.Product table filtered by ProductID from 400 to 500
SELECT ProductID, Name
FROM Production.Product
WHERE ProductID BETWEEN 400 AND 500

-- Write a query to retrieve the to the columns  ProductID, Name and color from the Production.Product table restricted to the colors black and blue
SELECT ProductID, Name, Color
FROM Production.Product
--WHERE Color = 'black' OR Color = 'blue'
WHERE Color IN ('black','blue') 

-- Write a query to generate a report on products that begins with the letter S. 
SELECT Name AS "Products"
FROM Production.Product
WHERE Name LIKE 'S%'

-- Write a query that retrieves the columns Name and ListPrice from the Production.Product table. Your result set should look something like the following. Order the result set by the Name column. 
SELECT Name, ListPrice 
FROM Production.Product
WHERE Name LIKE 'S%' 
ORDER BY 2, 1

--Name                                               ListPrice
-------------------------------------------------- -----------
--Seat Lug                                           0,00
--Seat Post                                          0,00
--Seat Stays                                         0,00
--Seat Tube                                          0,00
--Short-Sleeve Classic Jersey, L                     53,99
--Short-Sleeve Classic Jersey, M                     53,99
 

-- Write a query that retrieves the columns Name and ListPrice from the Production.Product table. Your result set should look something 
-- like the following. Order the result set by the Name column. The products name should start with either 'A' or 'S'
SELECT Name, ListPrice 
FROM Production.Product
WHERE Name LIKE 'A%' OR Name LIKE 'S%' 
ORDER BY 1, 2

--Name                                               ListPrice
-------------------------------------------------- ----------
--Adjustable Race                                    0,00
--All-Purpose Bike Stand                             159,00
--AWC Logo Cap                                       8,99
--Seat Lug                                           0,00
--Seat Post                                          0,00
--               ………

-- Write a query so you retrieve rows that have a Name that begins with the letters SPO, but is then not followed by the letter K. 
-- After this zero or more letters can exists. Order the result set by the Name column.
SELECT Name, ListPrice 
FROM Production.Product
WHERE Name LIKE 'SPO[^K]%' 
ORDER BY 1, 2

-- Write a query that retrieves unique colors from the table Production.Product. Order the results  in descending  manner
SELECT DISTINCT Color
FROM Production.Product 
ORDER BY 1 DESC

-- Write a query that retrieves the unique combination of columns ProductSubcategoryID and Color from the Production.Product table.
-- Format and sort so the result set accordingly to the following. We do not want any rows that are NULL.in any of the two columns in the result.
SELECT DISTINCT ProductSubcategoryID, Color
FROM Production.Product
WHERE ProductSubcategoryID is NOT NULL AND Color is NOT NULL

-- Something is “wrong” with the WHERE clause in the following query. 
-- We do not want any Red or Black products from any SubCategory than those with the value of 1 in column ProductSubCategoryID, 
-- unless they cost between 1000 and 2000.
 

-- Hint:
-- Make some changes on logical operators.
 
 
SELECT ProductSubCategoryID
      , LEFT([Name],35) AS [Name]
      , Color, ListPrice 
FROM Production.Product
WHERE Color IN ('Red','Black') 
      AND ListPrice BETWEEN 1000 AND 2000 
      AND ProductSubCategoryID = 1
ORDER BY ProductID
