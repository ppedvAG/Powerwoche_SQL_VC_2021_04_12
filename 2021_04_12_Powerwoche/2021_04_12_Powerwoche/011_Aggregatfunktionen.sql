-- Aggregatfunktionen (aggregate functions)

/*
		COUNT
		SUM
		AVG
		MIN
		MAX


*/


-- in welchen Ländern haben wir Kunden?
SELECT Country
FROM Customers
-- 91 alle Kunden


SELECT DISTINCT Country
FROM Customers
-- insgesamt 21 Länder



SELECT COUNT(*)
FROM Customers
-- 91 Einträge in Customers-Tabelle



SELECT COUNT(Region)
FROM Customers
-- 31 (bei wie vielen Kunden ist eine Region eingetragen - NICHT wie viele Regionen gibt es!)
-- hier gibt es weniger, als insgesamt Kunden, weil es NULL-Werte in der Region gibt


SELECT COUNT(DISTINCT Region)
FROM Customers
-- 18 (wie viele unterschiedliche Regionen gibt es?)




--> im Fall vom Country gilt das Gleiche:


SELECT COUNT(Country)
FROM Customers
-- 91 (so viele, wie Kunden, weil bei jedem Kunden ein Eintrag in der Country-Spalte dabeisteht)




SELECT COUNT(DISTINCT Country) AS [Anzahl Länder]
FROM Customers
-- 21 --> wie viele unterschiedliche Länder




-- wie viele Produkte haben wir?
-- wenn wir eindeutige Werte abzählen wollen (z.B. eine ID), dann OHNE DISTINCT! (langsamer, wegen Überprüfung)
SELECT COUNT(ProductID)
FROM Products
-- 77



-- Durchschnittswert berechnen mit AVG (average)
SELECT AVG(UnitPrice)
FROM Products
-- 28,8663


-- Summe bilden mit SUM
SELECT SUM(Freight) AS [Summe aller Frachtkosten]
FROM Orders
-- 64942,69


-- kleinster/größter Wert
-- teuerstes Produkt
SELECT MAX(UnitPrice)
FROM Products

-- günstigstes Produkt
SELECT MIN(UnitPrice)
FROM Products


-- **********************************************************************************************
-- ************************************** GROUP BY **********************************************

-- Summe der Frachtkosten pro Kunde
SELECT	  SUM(Freight) AS [Summe Frachtkosten]
		, CustomerID
FROM Orders
GROUP BY CustomerID



-- bringt nix!
-- wegen OrderID... Summe der Frachtkosten pro Bestellung = Frachtkosten
SELECT	  SUM(Freight) AS [Summe Frachtkosten]
		, Freight
		, CustomerID
		, OrderID
FROM Orders
GROUP BY CustomerID, OrderID, Freight



-- mehrere Spalten sind zulässig, aber überlegen: macht es Sinn?
-- Summe der Frachtkosten pro Stadt im jeweiligen Land:
SELECT	  SUM(Freight) AS [Summe Frachtkosten]
		, ShipCountry
		, ShipCity
FROM Orders
GROUP BY ShipCountry, ShipCity
ORDER BY ShipCity



/*
	die Reihenfolge, in der wir unser SELECT-Statement schreiben:

		SELECT
		FROM
		WHERE
		GROUP BY
		HAVING
		ORDER BY

*/




-- durchschnittliche Frachtkosten (Freight) pro Frachtunternehmen (Shippers)?

SELECT    AVG(Freight) AS [Freight/Shipper]
		, ShipVia
FROM Orders
GROUP BY ShipVia



-- mit Name Frachtunternehmen:
SELECT    AVG(o.Freight) AS [Freight/Shipper]
		, o.ShipVia
		, s.CompanyName
FROM Orders o INNER JOIN Shippers s ON o.ShipVia = s.ShipperID
GROUP BY o.ShipVia, s.CompanyName



-- Summe von Bierbestellungen pro Kunde
SELECT	  
		  c.CustomerID
		, c.CompanyName
		, SUM(od.Quantity)
		, p.ProductName
FROM Customers c INNER JOIN Orders o ON c.CustomerID = o.CustomerID
					INNER JOIN [Order Details] od ON o.OrderID = od.OrderID
						INNER JOIN Products p ON od.ProductID = p.ProductID
WHERE ProductName LIKE '%bier%' OR ProductName LIKE '%lager%' OR ProductName LIKE '%ale'
GROUP BY c.CustomerID, c.CompanyName, p.ProductName
ORDER BY c.CustomerID



-- Summe Frachtkosten pro Kunde im jeweiligen Land aus dem Jahr 1996
-- mit Spaltenüberschrift
-- geordnet nach Summe der Frachtkosten (Freight) absteigend

SELECT	  SUM(o.Freight) AS [Freight/Customer]
		, o.CustomerID
		, c.CompanyName
		, c.Country
FROM Orders o INNER JOIN Customers c ON o.CustomerID = c.CustomerID
WHERE YEAR(ShippedDate) = 1996
GROUP BY o.CustomerID, c.Country, c.CompanyName
ORDER BY [Freight/Customer] DESC

