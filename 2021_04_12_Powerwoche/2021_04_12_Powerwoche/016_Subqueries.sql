-- Subqueries (Unterabfragen, Subselect)
-- verschachtelte Abfragen


-- Subquery wie eine Spalte verwenden
-- darf nur einen Wert ergeben
SELECT	  'Text'
		, 123
		, Freight
		, (SELECT TOP 1 Freight FROM Orders ORDER BY Freight)
FROM Orders


-- Subquery als Datenquelle verwenden (wie eine Tabelle)
SELECT *
FROM -- Tabelle?
		(SELECT OrderID, Freight FROM Orders WHERE EmployeeID = 3) t1
WHERE t1.Freight > 100



-- Subquery im WHERE
-- Alle Bestellungen, wo die Frachtkosten größer sind als die durchschnittlichen Frachtkosten
SELECT *
FROM Orders
WHERE Freight > (SELECT AVG(Freight) FROM Orders)
-- im WHERE können wir nicht mit einem Wert vergleichen, der erst durch eine Aggregatfunktion berechnet wird... außer, wir verwenden eine Unterabfrage 





-- SupplierID, CompanyName, Kontaktinformation, Land von allen Suppliers, die aus dem gleichen Land sind, wie der Supplier mit der ID 2

-- in welchem Land ist Supplier #2?
SELECT Country
FROM Suppliers
WHERE SupplierID = 2
-- USA


SELECT	  SupplierID
		, CompanyName
		, ContactName
		, Phone
		, Country
FROM Suppliers
WHERE Country = (SELECT Country FROM Suppliers WHERE SupplierID = 2)
-- 4



-- alle Angestellten, die im gleichen Jahr eingestellt wurden wie Mr. Robert King
-- (Name überprüfen)
-- Uhrzeit soll nicht mit ausgegeben werden


-- in welchem Jahr ist Robert King eingestellt worden?

SELECT YEAR(HireDate)
FROM Employees
WHERE FirstName = 'Robert' AND LastName = 'King'
-- 1994




SELECT	  EmployeeID
		, CONCAT(FirstName, ' ', LastName) AS EmpName
		, FORMAT(HireDate, 'd', 'de-de') AS HireDate
FROM Employees
WHERE YEAR(HireDate) = (SELECT YEAR(HireDate) FROM Employees WHERE FirstName = 'Robert' AND LastName = 'King')



-- wenn Robert King selbst NICHT mit ausgegeben werden soll:

SELECT	  EmployeeID
		, CONCAT(FirstName, ' ', LastName) AS EmpName
		, FORMAT(HireDate, 'd', 'de-de') AS HireDate
FROM Employees
WHERE YEAR(HireDate) = (SELECT YEAR(HireDate) FROM Employees WHERE FirstName = 'Robert' AND LastName = 'King') AND FirstName <> 'Robert' AND LastName <> 'King'
