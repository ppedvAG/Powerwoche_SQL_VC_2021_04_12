-- JOINS

-- Informationen aus mehreren Tabellen abfragen



-- INNER JOIN



-- OUTER JOIN (LEFT JOIN, RIGHT JOIN) (LEFT OUTER JOIN, RIGHT OUTER JOIN)




-- *********************************************************************************************************
-- ***************************************** INNER JOIN ****************************************************
-- *********************************************************************************************************

SELECT *
FROM Customers INNER JOIN Orders ON Customers.CustomerID = Orders.CustomerID


-- Spalten einschränken
-- Bestellnr und wer hat bestellt
SELECT	  Customers.CustomerID -- wenn Spaltenname in beiden Tabellen vorkommt, MÜSSEN wir dazusagen, woher Info kommt
		, CompanyName
		, OrderID
FROM Customers INNER JOIN Orders ON Customers.CustomerID = Orders.CustomerID


-- bei den anderen SOLLTEN wir es dazusagen:
SELECT	  Customers.CustomerID 
		, Customers.CompanyName
		, Orders.OrderID
FROM Customers INNER JOIN Orders ON Customers.CustomerID = Orders.CustomerID


-- etwas kürzere Schreibweise:
-- mit Tabellen-ALIAS
SELECT	  c.CustomerID
		, c.CompanyName
		, o.OrderID
FROM Customers AS c INNER JOIN Orders AS o ON c.CustomerID = o.CustomerID


-- ein bisschen kürzer gehts noch:
-- wir dürfen das AS weglassen:
SELECT	  c.CustomerID
		, c.CompanyName
		, o.OrderID
FROM Customers c INNER JOIN Orders o ON c.CustomerID = o.CustomerID



-- Kontaktdaten von Kunden
-- welche Bestellungen
-- wann?
-- Kunden aus Deutschland
SELECT    C.CustomerID
		, C.ContactName
		, C.CompanyName
		, O.OrderID
		, O.OrderDate
FROM Customers C INNER JOIN Orders O on C.CustomerID = O.CustomerID
WHERE C.Country = 'Germany'
-- 122



/*

	Angenommen, es gab bei bestimmten Bestellungen (mit Bestellnr. 10251, 10280, 10990, 11000) Beschwerden.
	Welche Angestellte haben diese Bestellungen bearbeitet? (Bestellnr., Vorname, Nachname)

*/

SELECT	  E.EmployeeID
		, E.Lastname
		, E.Firstname
		, O.OrderID
		, O.OrderDate
FROM Employees E INNER JOIN Orders O on E.EmployeeID = O.EmployeeID
WHERE O.OrderID = '10251' OR O.OrderID = '10280' OR O.OrderID = '10990' OR O.OrderID = '11000'
-- 4

-- etwas kürzer schreiben:
SELECT	  E.EmployeeID
		, E.Lastname
		, E.Firstname
		, O.OrderID
		, O.OrderDate
FROM Employees E INNER JOIN Orders O on E.EmployeeID = O.EmployeeID
WHERE O.OrderID IN(10251, 10280, 10990, 11000)







-- mehr als zwei Tabellen miteinander verjoinen:

SELECT *
FROM Customers c INNER JOIN Orders o ON c.CustomerID = o.CustomerID
					INNER JOIN Employees e ON e.EmployeeID = o.EmployeeID






-- voriges Beispiel mit Customers
SELECT	  E.EmployeeID
		, E.Lastname
		, E.Firstname
		, O.OrderID
		, O.OrderDate
		, C.CustomerID
		, C.CompanyName
		, C.Phone
FROM Employees E INNER JOIN Orders O ON E.EmployeeID = O.EmployeeID
					INNER JOIN Customers C ON C.CustomerID = O.CustomerID
WHERE O.OrderID IN(10251, 10280, 10990, 11000)






-- Alle Bestellungen, bei denen Bier verkauft worden ist.
-- Welcher Kunde? Wieviel? Welches Bier?
-- Wie heißt das Produkt? --> Produktname darf "Bier" oder "Lager" enthalten oder mit "ale" enden


SELECT	  o.OrderID
		, c.CustomerID
		, c.CompanyName
		, od.Quantity
		, p.ProductName
FROM Customers c INNER JOIN Orders o ON c.CustomerID = o.CustomerID
					INNER JOIN [Order Details] od ON o.OrderID = od.OrderID
						INNER JOIN Products p ON od.ProductID = p.ProductID
WHERE ProductName LIKE '%bier%' OR ProductName LIKE '%lager%' OR ProductName LIKE '%ale'




-- PAUSE:
SELECT DATEADD(MINUTE, 15, GETDATE()) -- 2021-04-14 10:42:14.843





-- ... die Sache mit NULL......


SELECT *
FROM Customers



-- alle, bei denen KEINE Region eingetragen ist
SELECT		CustomerID
		, CompanyName
		, Region
FROM Customers
WHERE Region IS NULL


-- nur die, bei denen eine Region eingetragen ist:
SELECT		CustomerID
		, CompanyName
		, Region
FROM Customers
WHERE Region IS NOT NULL





-- wie bekommen wir die Kunden, die noch nichts bestellt haben?
-- erste Idee:

-- FALSCH!
SELECT	  c.CustomerID
		, c.CompanyName
		, o.OrderID
		, o.OrderDate
FROM Customers c INNER JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE OrderID IS NULL



------>

-- OUTER JOINS

-- Vergleich INNER JOIN/RIGHT JOIN/LEFT JOIN

-- INNER JOIN
SELECT	  c.CustomerID
		, c.CompanyName
		, o.OrderID
		, o.OrderDate
FROM Customers c INNER JOIN Orders o ON c.CustomerID = o.CustomerID
-- 830 (Bestellungen)
-- hier bekommen wir nur die Kunden heraus, die auch etwas bestellt haben (INNER JOIN)


-- RIGHT JOIN
SELECT	  c.CustomerID
		, c.CompanyName
		, o.OrderID
		, o.OrderDate
FROM Customers c RIGHT JOIN Orders o ON c.CustomerID = o.CustomerID
-- 830
-- hier bekommen wir alle Kunden raus, die auch in der Orders-Tabelle drinstehen (also in diesem Fall wieder nur die, die schon etwas bestellt haben)




-- LEFT JOIN 
SELECT	  c.CustomerID
		, c.CompanyName
		, o.OrderID
		, o.OrderDate
FROM Customers c LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
-- 832
-- alle Information aus der Customers-Tabelle (also auch die Kunden, die noch nichts bestellt haben) plus die Übereinstimmungen aus der Orders-Tabelle






--> die Kunden, die noch nichts bestellt haben, bekommen wir, wenn wir mit einem OUTER JOIN arbeiten!

SELECT	  c.CustomerID
		, c.CompanyName
--		, o.OrderID
--		, o.OrderDate
		, c.ContactName
		, c.Phone
FROM Customers c LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE o.OrderID IS NULL




-- von welchem Frachtunternehmen wurden Bestellungen an Kunden geliefert?
-- 10251, 10280, 10990, 11000

SELECT	  o.OrderID
		, c.CustomerID
		, c.CompanyName
		, s.ShipperID
		, s.CompanyName
FROM Customers c INNER JOIN Orders o ON c.CustomerID = o.CustomerID
					INNER JOIN Shippers s ON o.ShipVia = s.ShipperID
WHERE o.OrderID IN(10251, 10280, 10990, 11000)





-- Sonderfälle: SELF JOIN

/*

	Leo  -   Hugo
	Leo  -   Fritz
	Leo  -   Anna
	Hugo -   Leo
	Hugo -   Fritz
	Hugo -   Anna



*/


-- Liste von Mitfahrgelegenheiten: wer wohnt in der gleichen Stadt?

--  Name    City    Name2    Kontrollfeld(City)

--  Leo      Wien   Hugo      Wien



-- Idee:
SELECT    ContactName
		, City
		, ContactName
		, City
FROM Customers
-- FALSCH!!!


--> SELFJOIN - Tabelle mit sich selbst verjoinen
SELECT    c1.ContactName
		, c1.City
		, c2.ContactName
--		, c2.City AS Kontrollfeld
FROM Customers c1 INNER JOIN Customers c2 ON c1.City = c2.City
WHERE c1.CustomerID != c2.CustomerID




-- wer ist der Chef von wem?
-- Name Angestellte   EmpID     Name Chef    ChefID (Kontrollfeld)

SELECT    emp.EmployeeID
--		, emp.ReportsTo
		, emp.LastName
		, emp.FirstName
--		, boss.EmployeeID
		, boss.LastName
		, boss.FirstName
FROM Employees emp INNER JOIN Employees boss ON emp.ReportsTo = boss.EmployeeID



-- wenn wir auch den Chef selbst dabei haben möchten (oder alle, die keinen Chef haben)
SELECT    emp.EmployeeID
		, emp.LastName
		, emp.FirstName
		, boss.LastName
		, boss.FirstName
FROM Employees emp LEFT JOIN Employees boss ON emp.ReportsTo = boss.EmployeeID





-- Vor- und Nachname in einem Feld:
SELECT    emp.EmployeeID
		, CONCAT(emp.LastName, ' ', emp.FirstName) AS EmpName
		, CONCAT(boss.LastName, ' ', boss.FirstName) AS BossName
		, ISNULL(CAST(boss.EmployeeID AS varchar), 'das ist der Chef')
FROM Employees emp LEFT JOIN Employees boss ON emp.ReportsTo = boss.EmployeeID

