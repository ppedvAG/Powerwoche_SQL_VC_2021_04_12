-- HAVING 

-- Wie viele Kunden gibt es pro Land?

-- nur die, wo mehr als 5 Kunden pro Land vorhanden sind
-- Anzahl, Country
-- meiste Kunden zuerst


-- erste Idee:
SELECT	  Country
		, COUNT(CustomerID) AS [Anzahl Kunden]
FROM Customers
WHERE COUNT(CustomerID) > 5
GROUP BY Country
-- funktioniert nicht!

--> HAVING
SELECT	  Country
		, COUNT(CustomerID) AS [Anzahl Kunden]
FROM Customers
GROUP BY Country
HAVING COUNT(CustomerID) > 5
ORDER BY [Anzahl Kunden] DESC


-- warum funktioniert das nicht...?
SELECT	  Country
		, COUNT(CustomerID) AS [Anzahl Kunden]
FROM Customers
GROUP BY Country
HAVING [Anzahl Kunden] > 5
ORDER BY [Anzahl Kunden] DESC
-- Fehlermeldung: Invalid column name 'Anzahl Kunden'.
-- "Anzahl Kunden" ist im HAVING noch nicht bekannt! Ausführungsreihenfolge! HAVING kommt vor dem SELECT
-- Im ORDER BY funktioniert es, denn ORDER BY kommt nach dem SELECT.





/*

	-- in der Reihenfolge schreiben wir Abfragen:

		SELECT 
		FROM 
		WHERE
		GROUP BY
		HAVING
		ORDER BY



	-- in dieser Reihenfolge werden Abfragen ausgeführt:

		FROM
		WHERE
		GROUP BY
		HAVING
		SELECT
		ORDER BY


*/



-- alle Angestellten, die mehr als 70 Bestellungen bearbeitet haben
-- inklusive vollständiger Name (in einer Spalte), EmployeeID, Anzahl bearbeitete Bestellungen

SELECT    E.EmployeeID
		, CONCAT(E.lastname, ' ', E.FirstName) AS [Name]
		, Count (O.OrderID) AS [Bearbeitet Bestelungen]
FROM Employees E INNER JOIN Orders O ON E.employeeID = O.EmployeeID
GROUP BY E.EmployeeID, E.LastName, E.FirstName
HAVING COUNT (O.OrderId) > 70


-- alle Bestellungen, bei denen die Rechnungssumme größer ist als 500


SELECT    o.OrderID
		, SUM(UnitPrice * Quantity) AS Rechnungssumme
FROM [Order Details] od INNER JOIN Orders o ON od.OrderID = o.OrderID
GROUP BY o.OrderID, Freight
HAVING SUM(UnitPrice * Quantity) > 500
ORDER BY Rechnungssumme

-- oder etwas genauer:
SELECT    o.OrderID
		, CAST(SUM(UnitPrice * Quantity*(1-od.Discount))+Freight AS money) AS Rechnungssumme
FROM [Order Details] od INNER JOIN Orders o ON od.OrderID = o.OrderID
GROUP BY o.OrderID, Freight
HAVING CAST(SUM(UnitPrice * Quantity*(1-od.Discount))+Freight AS money) > 500
ORDER BY Rechnungssumme

-- oder mit view (Order Subtotals):
SELECT * FROM [Order Subtotals] WHERE Subtotal > 500