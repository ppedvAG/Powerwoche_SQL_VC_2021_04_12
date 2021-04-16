-- Datenbankerstellung

-- Datentypen beachten


--          char(5) .... es müssen exakt 5 sein (Rest wird mit Leerzeichen aufgefüllt)
--			varchar(30)  ... es dürfen maximal 30 Zeichen sein


-- Angenommen Nachname = varchar(10)
-- varchar(10)
-- Berg -----> passt in das Feld
-- nicht alle zulässigen Zeichen ausgenutzt

-- bei varchar:
-- Bergxxxxxxxxxx          --> mann (geht sich bei update nicht mehr aus, wird auf Extra-Seite verschoben)



-- bei char(10)
-- B e r g _ _ _ _ _ _  
-- B e r g m a n n _ _

--> für jede Spalte überlegen: wie wahrscheinlich ist es, dass sich die Information ändert? Wie oft?



SELECT *
FROM Customers c FULL OUTER JOIN Orders o ON c.CustomerID = o.CustomerID


-- Normalformen


-- sollen Redundanz vermeiden
-- sollen Inkonsistenzen vermeiden
-- Kunde soll nicht weggelöscht werden, wenn wir eine Bestellung weglöschen (oder umgekehrt)



-- aber: NF können bewusst gebrochen werden, um Abfragen schneller zu machen (weniger Datensätze lesen)


/*
		1 MIO Kunden ............. jeder hat im Durchschnitt 3 Bestellungen getätigt

		3 MIO Orders ............. im Durchschnitt 4 Rechnungsposten

		12 MIO Rechnungsposten (Order Details)




		1 .... JOIN 3 ..... JOIN 12 --> 16 MIO Datensätze

		1 Spalte "Rechnungssumme" in Orders würde bedeuten: statt 16 MIO DS nur 4!


*/





-- DROP DATABASE Test
-- Achtung! Nur beim Üben/Testen! DROP löscht gesamte DB inklusive Inhalt!
CREATE DATABASE Test

USE Test



CREATE TABLE Produkte (
							ProduktID int identity(1, 1) PRIMARY KEY,
							ProduktName nvarchar(30),
							Preis money
							-- ....
							--- ....

						)


-- Identity macht auch ein UNIQUE und NOT NULL


-- DROP TABLE Produkte



SELECT *
FROM Produkte


-- nicht schön:
INSERT INTO Produkte
VALUES ('Spaghetti', 1.99)


-- besser:
INSERT INTO Produkte (Preis, ProduktName)
VALUES (1.99, 'Spaghetti')
-- dazuschreiben, in welcher Reihenfolge die Informationen in die Spalten eingegeben werden



INSERT INTO Produkte (ProduktName, Preis)
VALUES  ('Tiramisu', 4.99),
		( 'Profiterols', 4.89),
		('Limoncello', 3.99)



-- Werte verändern mit UPDATE
-- UPDATE IMMER mit WHERE einschränken!!
-- sonst haben alle Produkte diesen Preis!

UPDATE Produkte
SET Preis = 5.39
WHERE ProduktID = 5




-- DROP TABLE tablename löscht komplette Tabelle inklusive Inhalt
-- DELETE FROM tablename löscht gesamten Inhalt der Tabelle (Tabelle selbst bleibt erhalten)
-- DELETE IMMER mit WHERE einschränken, um bestimmte Einträge zu löschen


DELETE FROM Produkte
WHERE ProduktID = 3


DELETE FROM Produkte
WHERE ProduktID IN(7, 8, 9)


SELECT *
FROM Produkte


-- Tabelle verändern mit ALTER TABLE
ALTER TABLE Produkte
ALTER COLUMN ProduktName nvarchar(50)


ALTER TABLE Produkte
ADD Email nvarchar(50)


-- ups, Fehler, Email Spalte sollte nicht zu Produkten...
ALTER TABLE Produkte
DROP COLUMN Email


SELECT *
FROM Produkte



SELECT *
INTO Test.dbo.TestCustomers
FROM Northwind.dbo.Customers


SELECT *
FROM TestCustomers



SELECT *
INTO Test.dbo.TestOrders
FROM Northwind.dbo.Orders



-- Schlüsselfelder
-- Primary Key (Hauptschlüssel)
-- Foreign Key (Fremdschlüssel)



ALTER TABLE TestCustomers
ADD CONSTRAINT PK_TestCustomers PRIMARY KEY (CustomerID)


ALTER TABLE TestOrders
ADD CONSTRAINT PK_TestOrders PRIMARY KEY (OrderID)


ALTER TABLE TestOrders
ADD CONSTRAINT FK_TestOrders_TestCustomer FOREIGN KEY (CustomerID) REFERENCES TestCustomers(CustomerID)
