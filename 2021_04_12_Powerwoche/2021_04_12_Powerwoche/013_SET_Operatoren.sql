-- SET-Operatoren


/*
		UNION
		UNION ALL
		INTERSECT
		EXCEPT
*/


-- ************************************** UNION ********************************

SELECT 'Testtext1'
UNION
SELECT 'Testtext2'




-- Achtung: muss gleiche Anzahl an Spalten haben!
SELECT 'Testtext1', 'Testtext3'
UNION
SELECT 'Testtext2'




-- darf mit NULL aufgefüllt werden; Sinn? Von Fall zu Fall entscheiden!
SELECT 'Testtext1', 'Testtext3'
UNION
SELECT 'Testtext2', NULL



-- Achtung: eine Spalte muss gleiche/kompatible/implizit konvertierbare Datentypen enthalten
SELECT 123, 'Testtext1'
UNION
SELECT 'Testtext2', 'Testtext3'


-- explizite Konvertierung ist möglich
SELECT CAST(123 AS varchar(10)), 'Testtext1'
UNION
SELECT 'Testtext2', 'Testtext3'
-- Sinn? Von Fall zu Fall entscheiden!



-- Negativbeispiel:
-- CustomerID und EmployeeID sind unterschiedliche Datentypen!
-- funktioniert NICHT:
SELECT CustomerID, ContactName
FROM Customers
UNION
SELECT EmployeeID, LastName
FROM Employees




-- explizit konvertieren möglich:
SELECT CustomerID, ContactName
FROM Customers
UNION
SELECT CAST(EmployeeID AS varchar(10)), LastName
FROM Employees


-- mit ALIAS: 
SELECT    CustomerID AS [ID]
		, ContactName AS [Name]
FROM Customers
UNION
SELECT CAST(EmployeeID AS varchar(10)), LastName
FROM Employees



-- mit CONCAT werden zwei Spalten zu einer zusammengezogen (somit kommen wir wieder auf die gleiche Anzahl an Spalten)
SELECT    CustomerID AS [ID]
		, ContactName AS [Name]
FROM Customers
UNION
SELECT    CAST(EmployeeID AS varchar(10))
		, CONCAT(FirstName, ' ', LastName)
FROM Employees




-- Möglich, aber Sinn? Von Fall zu Fall entscheiden:
SELECT CustomerID, ContactName
FROM Customers
UNION
SELECT NULL, LastName
FROM Employees


-- Möglich, aber Sinn? Von Fall zu Fall entscheiden:
SELECT CustomerID, ContactName
FROM Customers
UNION
SELECT 'blabla', LastName
FROM Employees



-- ACHTUNG: UNION macht auch ein DISTINCT!


SELECT 'Testtext'
UNION
SELECT 'Testtext'
-- Testtext





--> wenn man alle ausgeben möchte: UNION ALL
SELECT 'Testtext'
UNION ALL
SELECT 'Testtext'
-- Testtext
-- Testtext




SELECT 'Testtext'
INTERSECT
SELECT 'Testtext'
-- Testtext


SELECT 'Testtext1'
EXCEPT
SELECT 'Testtext2'
-- Testtext1


SELECT 'Testtext2'
EXCEPT
SELECT 'Testtext1'
-- Testtext2
