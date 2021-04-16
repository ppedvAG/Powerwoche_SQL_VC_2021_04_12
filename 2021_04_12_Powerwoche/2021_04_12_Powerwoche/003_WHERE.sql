-- WHERE clause; WHERE-Klausel; WHERE-Bedingung
-- Bedingungen, die die Ergebnismenge einschr�nken




/*

	-- WHERE Operatoren

			=, <, >, <=, >=

			!=, <>    ........................... darf NICHT einem bestimmten Wert entsprechen

				-- wenn m�glich, positiv formulieren (NOT ist langsamer!)
				-- positive Formulierung macht Abfrage schneller, weil wir uns die �berpr�fung im Hintergrund sparen (es m�ssen nicht mehr alle Seiten gelesen werden)


			-- mehr als eine Bedingung abfragen

				AND .................. beide m�ssen zwingend zutreffen
				OR  .................. mindesten eine der Bedingungen muss zutreffen (es d�rfen auch beide zutreffen)

			
			BETWEEN, IN


			-- bei NULL:
					IS NULL | IS NOT NULL





*/



-- nur die Kunden aus Deutschland:
SELECT *
FROM Customers
WHERE Country = 'Germany'



-- * durch gew�nschte Spalten ersetzen!
SELECT	  CustomerID
		, CompanyName
--		, Country -- zum Testen
FROM Customers
WHERE Country = 'Germany'




-- mehr als eine Bedingung abfragen
SELECT	  CustomerID
		, CompanyName
		, Country -- zum Testen
FROM Customers
WHERE Country = 'Germany' AND City = 'Berlin'




-- alle Kunden aus den deutschsprachigen L�ndern:
SELECT	  CustomerID
		, CompanyName
		, Country -- zum Testen
FROM Customers
WHERE Country = 'Germany' OR Country = 'Austria' OR Country = 'Switzerland'
-- 15



-- ein bestimmter Wert darf NICHT zutreffen:
SELECT *
FROM Orders
WHERE Freight != 148.33



-- Bereiche abdecken:
SELECT *
FROM Orders
WHERE Freight < 100



-- alle Frachtkosten zwischen 100 und 200 (inklusive)

SELECT *
FROM Orders
WHERE Freight >= 100 AND Freight <= 200
-- 114


-- oder mit BETWEEN:

SELECT *
FROM Orders
WHERE Freight BETWEEN 100 AND 200
-- 114




-- mehrere Werte abdecken:

-- alle Kunden aus den deutschsprachigen L�ndern:
SELECT	  CustomerID
		, CompanyName
		, Country -- zum Testen
FROM Customers
WHERE Country = 'Germany' OR Country = 'Austria' OR Country = 'Switzerland'
-- 15

-- oder mit IN:
SELECT	  CustomerID
		, CompanyName
		, Country -- zum Testen
FROM Customers
WHERE Country IN('Germany', 'Austria', 'Switzerland')
-- 15



-- nur die Employees, bei denen eine Region eingetragen ist

-- ACHTUNG: FALSCH!!!
SELECT *
FROM Employees
WHERE Region != NULL
-- kein Ergebnis; es wird keine Fehlermeldung angezeigt, aber die Abfrage ist falsch!


-- RICHTIG:
SELECT *
FROM Employees
WHERE Region IS NOT NULL
-- IS NULL oder IS NOT NULL muss ausgeschrieben werden
-- wir k�nnen keine mathematischen Operationen mit NULL ausf�hren





-- alle Produkte, die von den Anbietern 2, 7 und 15 geliefert werden:
SELECT *
FROM Products
WHERE SupplierID IN(2, 7, 15)
-- 12


-- oder:
SELECT *
FROM Products
WHERE SupplierID = 2 OR SupplierID = 7 OR SupplierID = 15
-- hier muss Spaltenname jedes Mal dazugeschrieben werden (es k�nnen auch Spalten abgefragt werden, die nichts miteinander zu tun haben!)



-- Annahme: Frachtkosten in DB sind Nettofrachtkosten
-- Frachtkosten netto, Frachtkosten brutto, MwSt   


SELECT Freight AS Netto
	, Freight*119/100  AS Brutto
	, Freight/100*19 AS MwSt
FROM Orders


-- oder:
SELECT Freight AS Netto
	, Freight * 1.19 AS Brutto
	, Freight * 0.19 AS MwSt
FROM Orders



-- alle Produkte von ProduktID 10 - 15 (inklusive)
SELECT *
FROM Products
WHERE ProductID BETWEEN 10 AND 15
-- 6




-- alle Produkte, die von Anbietern 5, 10 oder 15 stammen, von denen mehr als 10 St�ck vorr�tig sind und deren St�ckpreis unter 100 liegt
-- sinnvolle Spalten ausw�hlen
SELECT *
FROM Products
WHERE (SupplierID = 5 OR SupplierID = 10 OR SupplierID = 15) AND UnitsInStock > 10 AND UnitPrice < 100
-- Achtung: wenn man AND und OR verwendet: Klammern setzen!!


-- oder:
SELECT *
FROM Products
WHERE SupplierID IN(5, 10, 15) AND UnitsInStock > 10 AND UnitPrice < 100
-- 6 Ergebnisse

