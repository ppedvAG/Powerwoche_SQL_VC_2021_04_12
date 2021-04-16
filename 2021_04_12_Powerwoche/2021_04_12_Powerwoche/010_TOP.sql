-- TOP
-- ORDER BY unbedingt notwendig!!
-- Anzahl der ausgegebenen Zeilen einschränken



-- erste Zeile ausgeben:

SELECT TOP 1 *
FROM Customers
-- ALFKI


-- aber WAS ist die erste Zeile??
-- abhängig von ORDER BY
-- und abhängig von Einschränkungen im WHERE


-- auch das WHERE kann beeinflussen, was in der ersten Zeile steht
-- ALFKI ist nicht aus "Austria", also kann er jetzt auch nicht mehr in der ersten Zeile aufscheinen
SELECT TOP 1 *
FROM Customers
WHERE Country = 'Austria'
-- ERNSH


SELECT TOP 1 *
FROM Customers
ORDER BY City
-- DRACD


SELECT TOP 1 *
FROM Customers
ORDER BY Country
-- CACTU



SELECT TOP 1 *
FROM Customers
ORDER BY Phone -- (Sinn? ;) )
-- MAISD



-- mit Spaltenangabe:

SELECT TOP 1
				  CustomerID
				, CompanyName
				, Phone
FROM Customers
WHERE Country = 'Argentina'
ORDER BY CustomerID
-- wir dürfen auch nach CustomerID ordnen - aber dann haben wir das entschieden, und nicht der zur Ausführung der Abfrage verwendete Index!




SELECT TOP 1
				  CustomerID
				, CompanyName
				, Phone
FROM Customers
WHERE Country = 'Argentina'
ORDER BY City -- wir dürfen auch nach Spalten ordnen, die im SELECT nicht vorkommen. Sinn? Von Fall zu Fall entscheiden.
-- OCEAN





SELECT TOP 1
				  CustomerID
				, CompanyName
				, Phone
FROM Customers
WHERE Region IS NOT NULL
ORDER BY City
-- RATTC



-- ersten 10 Zeilen
SELECT TOP 10
				  CustomerID
				, CompanyName
				, Phone
FROM Customers
WHERE Region IS NOT NULL
ORDER BY City


-- ersten 100 Zeilen
SELECT TOP 100
				  CustomerID
				, CompanyName
				, Phone
FROM Customers
WHERE Region IS NOT NULL
ORDER BY City
-- 31 Ergebnisse - (alle, bei denen eine Region eingetragen ist)
-- wenn die Ergebnismenge nicht so viele hergibt, wie im TOP-Befehl verlangt, macht das nichts; dann werden einfach entsprechend weniger ausgegeben



-- Prozentsatz der Datenmenge ausgeben mit TOP
-- Percent muss ausgeschrieben werden, % funktioniert nicht!

SELECT TOP 10 PERCENT
				  CustomerID
				, CompanyName
				, Phone
FROM Customers
ORDER BY CustomerID
-- 10 Ergebnisse! (9.1 wird auf den nächsten int-Wert aufgerundet!)



--  **************************************** ORDER BY ********************************

SELECT TOP 5
				  CustomerID
				, CompanyName
				, Phone
FROM Customers
ORDER BY CustomerID ASC -- (ascending = aufsteigend, vom kleinsten zum größten Wert geordnet = Default)


-- wie bekommen wir die letzten 5 Einträge?
-- vom größten zum kleinsten Wert ordnen:
SELECT TOP 5
				  CustomerID
				, CompanyName
				, Phone
FROM Customers
ORDER BY CustomerID DESC -- (descending = absteigend, vom größten zum kleinsten Wert geordnet)




-- ORDER BY ist auch mit mehreren Spalten möglich

SELECT    CustomerID
		, CompanyName
		, Country
		, City
		, Phone
FROM Customers
ORDER BY Country, City, CustomerID




-- Top 10% der Produkte mit den größten Verkaufsmengen
-- ProductName, Quantity
-- größte zuerst

Select top 10 percent
			  p.ProductID
			, p.ProductName
--			, p.Unitsinstock
--			, p.UnitsOnOrder
			, OD.Quantity
From Products P inner join [Order Details] OD on p.ProductID= Od.ProductId
order by Quantity DESC
-- 216

-- ausschließen von Mehrfacheinträgen:
SELECT DISTINCT TOP 10 PERCENT
			  p.ProductID
			, p.ProductName
--			, p.Unitsinstock
--			, p.UnitsOnOrder
			, OD.Quantity
FROM Products P INNER JOIN [Order Details] OD ON p.ProductID= Od.ProductId
ORDER BY Quantity DESC




-- was ist das teuerste Produkt? (mit TOP-Befehl lösen)
-- ID, Name, Preis

SELECT DISTINCT TOP 1
				  ProductID
				, ProductName
				, UnitPrice
FROM Products
ORDER BY UnitPrice DESC
-- Côte de Blaye, 263,50


-- was ist das günstigste Produkt
SELECT DISTINCT TOP 1
				  ProductID
				, ProductName
				, UnitPrice
FROM Products
ORDER BY UnitPrice
-- Geitost	2,50



-- die 3 Mitarbeiter, die schon am längsten im Unternehmen sind
-- mit TOP-Befehl gelöst
-- Name in einer Spalte
-- Datum ohne Uhrzeit
-- Name   HireDate  (weitere sinnvolle Spalten auswählen)

SELECT TOP 3
		  CONCAT(LastName, ' ', FirstName) AS EmpName
		, CONVERT(varchar, HireDate, 104) AS HireDate
FROM Employees
ORDER BY HireDate



SELECT TOP 3
		  FLOOR(DATEDIFF (dd, HireDate, GETDATE())/365.25) AS [YEARS IN COMPANY]
		, CONCAT(LastName, ' ', FirstName) AS EmpName
		, HireDate
FROM Employees
ORDER BY [YEARS IN COMPANY] DESC



SELECT TOP 3
		  FLOOR(DATEDIFF (dd, HireDate, GETDATE())/365.25) AS [YEARS IN COMPANY]
		, CONCAT(LastName, ' ', FirstName) AS EmpName
		, FORMAT(HireDate, 'dd.MM.yyyy') AS HireDate
FROM Employees
ORDER BY [YEARS IN COMPANY] DESC


SELECT TOP 3
		  FLOOR(DATEDIFF (dd, HireDate, GETDATE())/365.25) AS [YEARS IN COMPANY]
		, CONCAT(LastName, ' ', FirstName) AS EmpName
		, FORMAT(HireDate, 'd', 'de-de') AS HireDate
FROM Employees
ORDER BY [YEARS IN COMPANY] DESC





-- WITH TIES

SELECT TOP 17 WITH TIES  
					  Freight
					, OrderID
			--		, ....
FROM Orders
ORDER BY Freight


-- top 10 Produkte mit den größten Verkaufsmengen with ties

SELECT TOP 10 PERCENT WITH TIES
			  p.ProductID
			, p.ProductName
--			, p.Unitsinstock
--			, p.UnitsOnOrder
			, OD.Quantity
FROM Products P INNER JOIN [Order Details] OD ON p.ProductID= Od.ProductId
ORDER BY Quantity DESC
-- 234 Zeilen (statt 216)

