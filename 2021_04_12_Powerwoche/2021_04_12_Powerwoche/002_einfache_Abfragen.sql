-- Tabellenabfragen



-- immer �berpr�fen, ob wir in der richtigen Datenbank sind:

USE Northwind;
GO   -- Batch Delimiter




SELECT *
FROM Employees


-- * sollte in der Realit�t NICHT verwendet werden!
-- Die Tabellen k�nnen sich ver�ndern; Spalten k�nnen hinzukommen; es k�nnten Spalten angezeigt werden, die gar nicht erw�nscht sind oder auf die wir keinen Zugriff haben (Fehlermeldung)


SELECT	  EmployeeID, FirstName, LastName
FROM Employees




SELECT	  EmployeeID, 
			FirstName, 
--			LastName
FROM Employees

-- der Fehler ist das Komma nach dem FirstName! Nach der letzten gew�nschten Spalte kein Komma setzen!



-- zwecks Lesbarkeit Spaltennamen untereinander schreiben:

SELECT	  EmployeeID
		, FirstName
--		, LastName
FROM Employees



-- ALIAS (Spalten�berschrift f�r Textausgabe)

SELECT	  EmployeeID AS MitarbeiterID
		, FirstName AS Vorname
		, LastName AS Nachname
FROM Employees




-- AS darf theoretisch weggelassen werden
-- NICHT EMPFEHLENSWERT!!
SELECT	  EmployeeID MitarbeiterID
		, FirstName Vorname
		, LastName Nachname
FROM Employees




-- von Bestellungen Bestellnummer, welcher Kunde (CustomerID), welcher Angestellte (EmployeeID) hat verkauft, in welches Land ist geliefert worden?

SELECT	  OrderID
		, CustomerID
		, EmployeeID
		, ShipCountry
FROM Orders



-- alle Kontaktinformationen von den Kunden:
SELECT	  CustomerID
		, CompanyName
		, ContactName
		, Address
		, City
		, Region
		, Phone
FROM Customers



-- welche Produkte gibt es? Produktinformation?
SELECT	  ProductID
		, ProductName
		, QuantityPerUnit
		, UnitPrice
FROM Products






-- einfache Abfragen

-- Zahl
SELECT 100


-- Text
SELECT 'Testtext'



-- Berechnung
SELECT 100*3 -- 300


-- Achtung: wird als Text ausgegeben (mit Text k�nnen wir nicht rechnen)
SELECT '100*3'



SELECT	  100 AS Zahl
		, 'Testtext' AS Text
		, 100*3 AS Berechnung



-- wenn Leerzeichen im Namen, dann in eckige Klammern setzen:
SELECT Freight * 3 AS [Frachtkosten * 3]
FROM Orders


-- auch bei Spalten- und Tabellennamen in der DB:
SELECT *
FROM [Order Details]



