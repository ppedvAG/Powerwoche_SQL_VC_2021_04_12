-- CAST, CONVERT, FORMAT



-- Datentypen

/*

		-- String Datentypen

			char(5) .... es müssen exakt 5 sein (Rest wird mit Leerzeichen aufgefüllt)
			varchar(30)  ... es dürfen maximal 30 Zeichen sein

				-- wie oben, aber in UNICODE abgespeichert:
			nchar
			nvarchar


		-- numerische Datentypen

				bit  .... 0, 1, NULL

			-- ganzzahlige Werte
				int  
					(tinyint, smallint, bigint)

			-- Werte mit Nachkommastellen
				float
				decimal(10, 2) -- insgesamt 10 stellige Zahl, davon 8 vor dem Komma, 2 nach dem Komma


				money -- auf 4 Nachkommastellen genau



			boolean, bool - true, false


			-- Datumsdatentypen

				datetime -- ~3-4 ms genau
				datetime2 -- ~100 ns genau

				date
				time





*/

SELECT BirthDate
FROM Employees




-- ************************************** CAST **********************************************

SELECT '123' + 3  -- 126
-- implizite Konvertierung hat im Hintergrund stattgefunden, damit das Rechnen funktioniert


SELECT '123.5' + 3
-- Conversion failed when converting the varchar value '123.5' to data type int.




SELECT CAST('123.5' AS float) + 3 -- 126,5


/*
	-- Microsoft-Dokumentation zum Thema implizite und explizite Konvertierung:
	https://docs.microsoft.com/de-de/sql/t-sql/data-types/data-type-conversion-database-engine?view=sql-server-ver15

*/





-- wir können auch Datumsdatentypen in andere Datentypen umwandeln, aber:
-- mit CAST allein haben wir keinen Einfluss auf das Format

SELECT CAST(SYSDATETIME() AS varchar)  -- 2021-04-13 14:08:01.7773458

SELECT CAST(GETDATE() AS varchar) -- Apr 13 2021  2:08PM




-- Achtung beim Umwandeln! Geht sich die Zeichenanzahl aus?

-- sinnlos!!
SELECT CAST(SYSDATETIME() AS varchar(3)) -- 202

SELECT CAST(GETDATE() AS varchar(10)) -- Apr 13 202



-- keine gute Idee:
SELECT CAST('2021-04-13' AS date) -- Achtung: was ist Tag, was Monat? Systemabhängig.


-- mit DB:
SELECT CAST(HireDate AS varchar)
FROM Employees
-- May  1 1992 12:00AM 
-- kein Einfluss auf Format!




-- ************************************ CONVERT **************************************************
-- konvertieren von Datentypen
-- plus zusätzliche Möglichkeit: Style-Parameter (optional)


/*

	Syntax:

	SELECT CONVERT(data_type[(length)], expression[, style])

	-- Datentyp, in den konvertiert werden soll
	-- Ausdruck, der konvertiert werden soll
	-- optional: Style-Parameter für Datum


*/



SELECT CONVERT(float, '123.5') + 3 -- 126,5



SELECT CONVERT(varchar, SYSDATETIME()) -- 2021-04-13 14:20:03.7289937


-- Achtung mit Zeichenanzahl:
SELECT CONVERT(varchar(3), SYSDATETIME()) -- 202



-- mit Style-Parameter für Datum:
SELECT CONVERT(varchar, SYSDATETIME(), 104) -- 13.04.2021


/*

	Style-Parameter in Microsoft-Dokumentation:
	https://docs.microsoft.com/en-us/sql/t-sql/functions/cast-and-convert-transact-sql?view=sql-server-2017#date-and-time-styles

*/


SELECT	  CONVERT(varchar, SYSDATETIME(), 101) AS US
		, CONVERT(varchar, SYSDATETIME(), 103) AS GB
		, CONVERT(varchar, SYSDATETIME(), 104) AS DE




-- ****************************************** FORMAT ****************************************************
-- Ausgabedatentyp nvarchar


SELECT FORMAT(1234567890, '###-###/## ##') -- 123-456/78 90



-- Achtung Anzahl an Zeichen:
-- von hinten nach vorne formatiert:
SELECT FORMAT(123456789012345, '###-###/## ##') -- 12345678-901/23 45
SELECT FORMAT(123456, '###-###/## ##') --     -12/34 56



-- auch mit Datum mehrere Optionen:

SELECT FORMAT(GETDATE(), 'dd.MM.yyyy') -- 13.04.2021


-- ACHTUNG: FORMAT erkennt mm nicht als Kürzel für Monat!!
SELECT FORMAT(GETDATE(), 'dd.mm.yyyy') -- 13.31.2021
-- mm kleingeschrieben wird fälschlicherweise als Minute interpretiert!!



SELECT FORMAT('2021-04-13', 'dd.MM.yyyy')
-- Argument data type varchar is invalid for argument 1 of format function.


-- mit DB:

SELECT FORMAT(HireDate, 'dd.MM.yyyy') AS HireDate
FROM Employees



SELECT FORMAT(HireDate, 'dd.MM.yyyy hh:mm') AS HireDate
FROM Employees
-- 01.05.1992 12:00


-- speziell fürs Datum:
-- Culture-Parameter
SELECT FORMAT(GETDATE(), 'd', 'de-de')


/*
	Culture-Parameter-Übersicht in der Microsoft-Dokumentation:
	https://docs.microsoft.com/de-de/bingmaps/rest-services/common-parameters-and-types/supported-culture-codes

*/


-- mit d (kleingeschrieben): Datum in Zahlen
SELECT	  FORMAT(GETDATE(), 'd', 'de-de') AS DE
		, FORMAT(GETDATE(), 'd', 'en-us') AS US
		, FORMAT(GETDATE(), 'd', 'en-gb') AS GB
		, FORMAT(GETDATE(), 'd', 'sv') AS Schweden



-- mit D (großgeschrieben): Datum ausgeschrieben (wo möglich)
SELECT	  FORMAT(GETDATE(), 'D', 'de-de') AS DE
		, FORMAT(GETDATE(), 'D', 'en-us') AS US
		, FORMAT(GETDATE(), 'D', 'en-gb') AS GB
		, FORMAT(GETDATE(), 'D', 'sv') AS Schweden





SELECT	  FORMAT(BirthDate, 'D', 'de-de') AS DE  -- (Januar)
		, FORMAT(BirthDate, 'D', 'de-at') AS AT -- (Jänner)
		, FORMAT(BirthDate, 'D', 'en-us') AS US
		, FORMAT(BirthDate, 'D', 'en-gb') AS GB
		, FORMAT(BirthDate, 'D', 'sv') AS Schweden
FROM Employees



-- OrderID, RequiredDate, ShippedDate und Lieferverzögerung
-- deutsche Spaltenüberschriften
SELECT	  OrderID AS Bestellnummer
		, RequiredDate AS Wunschtermin
		, ShippedDate AS Lieferdatum
		, DATEDIFF(dd, RequiredDate, ShippedDate) AS Lieferverzögerung
FROM Orders


-- Achtung: Was ist Start-, was Enddatum? Manchmal auch abhängig von der Formulierung der Aufgabenstellung!
-- OrderID, RequiredDate, ShippedDate und Angabe, wie viele Tage sind noch Zeit, um fristgerecht zu liefern?
SELECT	  OrderID
		, RequiredDate
		, ShippedDate
		, DATEDIFF(dd, ShippedDate, RequiredDate) AS [Tage Zeit]
FROM Orders




-- Mitarbeiternummer, vollständige Name (in einer Spalte), Anrede, Geburtsdatum (ohne Zeitangabe) und Telefonnummer aller Angestellten

SELECT	  EmployeeID AS Mitarbeiternummer
		, CONCAT(FirstName, ' ', LastName) AS [Name]
		, HomePhone AS Telefonnummer
		, FORMAT(BirthDate,'dd.MM.yyyy')AS Geburtstag -- ACHTUNG bei FORMAT: MM unbedingt groß schreiben!!!
FROM Employees


-- andere Schreibweise mit Format (Culture-Parameter):
SELECT	  EmployeeID AS Mitarbeiternummer
		, CONCAT(FirstName, ' ', LastName) AS [Name]
		, HomePhone AS Telefonnummer
		, FORMAT(BirthDate,'d', 'de-de')AS Geburtstag
FROM Employees


-- andere Schreibweise mit CONVERT (Style-Parameter):
SELECT	  EmployeeID AS Mitarbeiternummer
		, CONCAT(FirstName, ' ', LastName) AS [Name]
		, HomePhone AS Telefonnummer
		, CONVERT(varchar, BirthDate, 104) AS Geburtsdatum
FROM Employees






-- Pause:
SELECT DATEADD(mi, 15, GETDATE()) -- 2021-04-13 15:34:26.180