-- VIEWS  (Sichten)


CREATE VIEW v_Test
AS
SELECT	  CustomerID
		, CompanyName
FROM Customers
GO -- Batch-Delimiter



SELECT *
FROM v_Test



SELECT *
FROM v_Test
WHERE CustomerID LIKE 'A%'



CREATE VIEW v_Customers_Bills_DE
AS
SELECT	  c.CustomerID
		, c.CompanyName
		, c.Address
		, c.ContactName
		, c.City
		, c.Country
		, c.PostalCode
		, o.OrderID
		, o.ShippedDate
		, o.Freight
		, od.Quantity
		, od.Discount
		, p.ProductID
		, p.ProductName
		, p.UnitPrice
FROM Customers c INNER JOIN Orders o ON c.CustomerID = o.CustomerID
					INNER JOIN [Order Details] od ON o.OrderID = od.OrderID
						INNER JOIN Products p ON od.ProductID = p.ProductID
WHERE Country IN('Germany', 'Austria', 'Switzerland')
GO



-- wir können auch nur bestimmte Spalten abfragen:
SELECT Freight, UnitPrice
FROM v_Customers_Bills_DE
