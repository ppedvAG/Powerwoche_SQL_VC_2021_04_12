-- Wildcards


/*
		%   ................ beliebig viele unbekannte Zeichen (0 - n)
		_   ................ genau 1 unbekanntes Zeichen
		[]  ................ genau 1 unbekanntes Zeichen aus einem bestimmten Wertebereich
		^   ................ NOT (innerhalb von eckigen Klammern)
		|   ................ (pipe) OR (innerhalb von eckigen Klammern)


*/


-- ***********************************************  % ************************************************+
-- Suche mit beliebig vielen unbekannten Zeichen:


SELECT * 
FROM Customers
WHERE CustomerID LIKE 'ALF%'

/*

	mögliche Treffer:

		ALF
		ALFXX
		ALFKI


*/




-- alle Länder, die mit A beginnen
SELECT *
FROM Customers
WHERE Country LIKE 'A%'



-- Customers, der mit MI endet
SELECT *
FROM Customers
WHERE CustomerID LIKE '%MI'
-- COMMI



-- Customers, deren CompanyName "kiste" enthält
SELECT *
FROM Customers
WHERE CompanyName LIKE '%kiste%'




-- ************************************************ _ **************************************************
-- Suche mit genau 1 unbekannten Zeichen


-- Annahme: letzte Stelle der Telefonnummer ist immer eine andere Durchwahl

SELECT *
FROM Customers
WHERE Phone LIKE '(5) 555-472_'



-- ****************************************** [] ********************************************
-- Wertebereich abfragen mit []


-- Kunden, die mit a, b oder c beginnen
SELECT *
FROM Customers
WHERE CustomerID LIKE 'a%' OR CustomerID LIKE 'b%' OR CustomerID LIKE 'c%'
-- 16


-- oder:
SELECT *
FROM Customers
WHERE CustomerID LIKE '[a-c]%'
-- 16



-- oder, wenn nicht zusammenhängend:
-- alle, die mit a, f oder m beginnen
SELECT *
FROM Customers
WHERE CustomerID LIKE '[afm]%'



-- beginnt mit abc
SELECT *
FROM Customers
WHERE CustomerID LIKE 'abc%'
-- kein Kunde vorhanden, der mit abc beginnt



-- Suche nach CompanyName, der ein %-Zeichen im Namen hat??
SELECT *
FROM Customers
WHERE CompanyName LIKE '%[%]%'  -- in eckige Klammern setzen, denn %-Zeichen hat schon eine andere Bedeutung!



-- oder mit ESCAPE-Character:
SELECT *
FROM Customers
WHERE CompanyName LIKE '%!%%' ESCAPE '!'



-- Hochkomma im Namen gesucht
SELECT *
FROM Customers
WHERE CompanyName LIKE '%''%' -- Trick/Ausnahme: '', nicht '
-- 6 Kunden mit ' im Companyname



-- alle Kunden, die mit a beginnen und mit e enden
SELECT *
FROM Customers
WHERE CompanyName LIKE 'a%e'
-- 1



-- ******************************************** NOT ******************************************
-- alle, die NICHT mit a-c beginnen:
SELECT *
FROM Customers
WHERE CompanyName LIKE '[^a-c]%'


-- gleiche Abfrage positiv formuliert:
SELECT *
FROM Customers
WHERE CompanyName LIKE '[d-z]%'



-- *************************** OR innerhalb [] ***********************
-- alle, die mit a-c oder e-g enden
SELECT *
FROM Customers
WHERE CompanyName LIKE '%[a-c]' OR CompanyName LIKE '%[e-g]'
-- 22


SELECT *
FROM Customers
WHERE CompanyName LIKE '%[a-c | e-g]'




-- alle Produkte, die mit L beginnen
SELECT *
FROM Products
WHERE ProductName LIKE 'L%'
-- 5



-- alle Produkte, deren Name mit coffee endet
SELECT *
FROM Products
WHERE ProductName LIKE '%coffee'
-- 1


-- alle Produkte, die ein 'ost' im Namen haben
SELECT *
FROM Products
WHERE ProductName LIKE '%ost%'




-- alle Produkte, deren Name mit D-L beginnt und mit a, b, c, d oder m, n, o enden


SELECT *
FROM Products
WHERE ProductName LIKE '[d-l]%' AND (ProductName LIKE '%[a-d]' OR ProductName LIKE '%[m-o]')
-- 8
-- Klammer setzen, sonst "gewinnt" das AND vor dem OR


-- oder:
SELECT *
FROM Products
WHERE ProductName LIKE '[d-l]%' AND ProductName LIKE '%[a-d | m-o]'



-- oder:
SELECT *
FROM Products
WHERE ProductName LIKE '[d-l]%[a-d | m-o]'






-- Annahme: falsche Einträge in CustomerID
-- ALFKI
-- AL$KI
-- alle finden, wo die CustomerID nicht aus 5 Buchstaben besteht

SELECT *
FROM Customers
WHERE CustomerID NOT LIKE '[a-z][a-z][a-z][a-z][a-z]'




-- alle Kunden, deren Companyname mit d, e oder f beginnen, der letzte Buchstabe ist ein L und der DRITTLETZTE Buchstabe ist ein d
SELECT *
FROM Customers
WHERE CompanyName LIKE '[d-f]%d_l'


/*

			[d-f]%d_l

			edel
			fidel
			edxl
			dxxxxxxxxxxxxxxxxxxxxxxxxxxdxl

			Ernst Handel (Northwind DB)
			e........d.l

*/





