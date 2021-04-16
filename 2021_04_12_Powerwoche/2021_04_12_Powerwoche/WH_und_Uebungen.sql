-- WH und Übungen

USE Northwind

-- nur die Kunden, die in Frankreich ansässig sind
SELECT *
FROM Customers
WHERE Country = 'France'
-- 11


-- alle Kunden, die in Buenos Aires in Argentinien ansässig sind
SELECT *
FROM Customers
WHERE Country = 'Argentina' AND City = 'Buenos Aires'


-- alle aus Deutschland in Berlin
SELECT *
FROM Customers
WHERE Country = 'Germany' AND City = 'Berlin'

-- Achtung: OR oder AND?
SELECT *
FROM Customers
WHERE Country = 'Germany' OR City = 'Berlin'
-- damit bekommen wir alle Kunden aus Deutschland (und auch die aus Berlin), auch die, die nicht in Berlin ansässig sind
-- gäbe es ein Berlin in einem anderen Land, würden auch diese ausgegeben werden



-- alle portugiesischen und alle spanischen Kunden
SELECT *
FROM Customers
WHERE Country = 'Portugal' OR Country = 'Spain'
-- 7

-- andere Schreibweise:
SELECT *
FROM Customers
WHERE Country IN('Portugal', 'Spain')


-- alle portugiesischen und spanischen Kunden wo eine Region eingetragen ist

-- FALSCH:
SELECT *
FROM Customers
WHERE Country = 'Portugal' OR Country = 'Spain' AND Region IS NOT NULL
-- Achtung: AND wird vorgezogen: WHERE Country = 'Portugal' OR (Country = 'Spain' AND Region IS NOT NULL)


SELECT *
FROM Customers
WHERE (Country = 'Portugal' OR Country = 'Spain') AND Region IS NOT NULL
-- kein Ergebnis, gibt keine, auf die diese Bedingungen zutreffen


SELECT *
FROM Customers
WHERE Country IN ('Portugal', 'Spain') AND Region IS NOT NULL
-- kein Ergebnis, gibt keine, auf die diese Bedingungen zutreffen


SELECT *
FROM Customers
WHERE Country = 'Germany' OR Country = 'USA' AND Region IS NOT NULL
-- wird so interpretiert: WHERE Country = 'Germany' OR (Country = 'USA' AND Region IS NOT NULL)


SELECT *
FROM Customers
WHERE (Country = 'Germany' OR Country = 'USA') AND Region IS NOT NULL
-- 13



SELECT *
FROM Customers
WHERE Country IN ('Germany', 'USA') AND Region IS NOT NULL
-- 13
-- Vorteil vom IN: wir müssen nicht auf die Klammernsetzung achten



-- alle Produkte, von denen mehr als 100 Stück vorrätig sind
SELECT *
FROM Products
WHERE UnitsInStock > 100
-- 10


-- alle Produkte, von denen zwischen 100 und 150 Stück vorrätig sind
SELECT *
FROM Products
WHERE UnitsInStock BETWEEN 100 AND 150
-- 10

-- oder:
SELECT *
FROM Products
WHERE UnitsInStock >= 100 AND UnitsInStock <= 150
-- 10



-- Employees: Name in einer Spalte (Vor- und Nachname)
SELECT	CONCAT(FirstName, ' ', LastName) AS [(Vor- und Nachname)]
FROM Employees



-- Annahme: es sind Fehler passiert, es gibt Namen, die nicht mit Großbuchstabe beginnen und dann klein weitergehen
-- NANcy DAvolio usw.
-- FirstName: erster Buchstabe klein, Rest groß (nANCY), LastName: (Davolio)

--      FirstName              LastName
--       nANCY                   Davolio
--       aNDREW                  Fuller


-- langsam aufbauen:

-- erster Buchstabe:
SELECT LEFT('Leonard', 1)

SELECT RIGHT('Leonard', 6) -- funktioniert nur, wenn alle Namen gleich lang sind

-- unabhängig von Zeichenanzahl:
SELECT RIGHT('Leonard', LEN('Leonard')-1) -- eonard

-- in Kleinbuchstaben ausgeben:
SELECT LOWER(LEFT('Leonard', 1)) -- l

-- in Großbuchstaben ausgeben:
SELECT UPPER(RIGHT('Leonard', LEN('Leonard')-1)) -- EONARD


-- zusammenstückeln:

SELECT CONCAT(LOWER(LEFT('Leonard', 1)), UPPER(RIGHT('Leonard', LEN('Leonard')-1))) -- lEONARD


-- mit DB:
SELECT	  CONCAT(LOWER(LEFT(FirstName, 1)), UPPER(RIGHT(FirstName, LEN(FirstName)-1))) AS FirstName
		, CONCAT(UPPER(LEFT(LastName, 1)), LOWER(RIGHT(LastName, LEN(LastName)-1))) AS LastName
FROM Employees







-- Zusatzübung: ContactName bei Customers: aufsplitten in FirstName und LastName
SELECT LEFT(ContactName, CHARINDEX(' ', ContactName)-1) AS FirstName
		, RIGHT(ContactName, LEN(ContactName)-CHARINDEX(' ', ContactName)) AS LastName
		, RIGHT(ContactName, CHARINDEX(' ', REVERSE(ContactName))-1) -- andere Möglichkeit
FROM Customers





-- alle Kunden (CompanyName) und ihre Frachtkosten 
-- OrderID,... (mehr sinnvolle Spalten sind erlaubt ;) )

SELECT    C.CustomerID
		, C.CompanyName
		, O.OrderID
		, O.Freight
FROM Customers C INNER JOIN Orders O on C.CustomerID = O.CustomerID



-- die Namen der Anbieter (Supplier), die Sauce verkaufen
-- CompanyName, Produktname, Ansprechperson, Telefonnummer
-- Achtung: Wie heißt das Produkt/die Produkte? Mehrere Möglichkeiten?

SELECT    S.SupplierID
		, S.CompanyName
		, S.ContactName
		, S.Phone
		, P.ProductName
FROM Suppliers S INNER JOIN Products P ON S.SupplierID = P.SupplierID
WHERE ProductName LIKE '%sauce%' OR ProductName LIKE '%soße%'



-- Welche Kunden haben Chai-Tee gekauft und wieviel?
-- CompanyName, Quantity 
-- Wie heißt denn das Produkt? 


SELECT	  O.OrderID AS[Bestel.Nr]
		, O.CustomerID AS [Kunde]
		, C.CompanyName AS [Firma Name]
		, OD.Quantity AS [Menge]
		, P.ProductName AS [ProduktName]
FROM Customers C INNER JOIN Orders O ON c.CustomerID= O.customerId
					INNER JOIN [Order Details] OD ON o.OrderID= od.OrderID
						INNER JOIN Products P ON Od.ProductID= P.ProductID
WHERE ProductName LIKE '%chai%'



-- Liste von allen Kontaktpersonen mit Kontaktinformationen
-- CompanyName, ContactName, Phone
-- ID, CompanyName, ContactName, Phone
-- ID, CompanyName, ContactName, Phone, Category (Kunde/Supplier)


SELECT	  CustomerID AS [ID]
		, ContactName AS [Name]
		, Companyname AS [Firma Name]
		, phone As [Telefon]
		, 'Kunde' AS Category
FROM Customers
UNION ALL
SELECT    CAST(SupplierID AS varchar(10))
		, ContactName 
		, Companyname 
		, phone 
		, 'Supplier'
FROM Suppliers
ORDER BY CompanyName
-- 120



-- Alle Regionen von Kunden und Angestellten
-- ID, Region, Kategorie
SELECT    CustomerID AS [ID]
		, Region
		, 'Kunde' AS [Category] --category(kunde/employee)
FROM Customers
WHERE Region IS NOT NULL
UNION ALL
SELECT	  CAST(EmployeeID AS varchar(10)) AS [ID]
		, Region AS [Name]
		, 'Employee'-- category(kunde/employee)
FROM Employees
WHERE Region IS NOT NULL
ORDER BY [ID]
-- 36
-- wenn alle ausgegeben werden, auch die, wo NULL bei Region steht, dann 100




