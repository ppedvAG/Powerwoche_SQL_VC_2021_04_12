-- Datumsfunktionen



/*
	-- Datumsintervalle:

		year, yyyy, yy    .................... Jahr
		quarter, qq, q    .................... Quartal
		month, MM, M      .................... Monat
		week, ww, wk      .................... Woche
		day, dd, d		  .................... Tag
		hour, hh		  .................... Stunde
		minute, mi, n	  .................... Minute
		second, ss, s     .................... Sekunde
		millisecond, ms   .................... Millisekunde
		nanosecond, ns	  .................... Nanosekunde

		weekday, dw, w	  .................... Wochentag
		dayofyear, dy, y  .................... Tag des Jahres


*/


-- ************************************* aktuelles Datum abfragen ******************************

-- datetime (ms)
SELECT GETDATE()
-- 2021-04-13 11:41:50.897



-- datetime2 (ns)
SELECT SYSDATETIME()
-- 2021-04-13 11:43:05.3519034




-- *********************************** DATEADD *******************************************
-- Datumsberechnungen: zum Datum etwas hinzu- oder wegrechnen


SELECT DATEADD(hh, 10, '2021-04-13')
-- 2021-04-13 10:00:00.000


SELECT DATEADD(hh, 10, '2021-04-13 11:46')
-- 2021-04-13 21:46:00.000



-- Achtung: welche Systemsprache wird verwendet?
SELECT DATEADD(hh, 10, '13.04.2021')
-- The conversion of a varchar data type to a datetime data type resulted in an out-of-range value.

-- was ist denn die Systemsprache?
SELECT @@LANGUAGE
-- us_english


SELECT DATEADD(hh, 10, GETDATE())
-- 2021-04-13 21:49:21.213


-- abziehen auch mit DATEADD: negatives Vorzeichen verwenden
-- wie spät war es vor 10 Stunden:
SELECT DATEADD(hh, -10, GETDATE())
-- 2021-04-13 01:56:46.987



-- ************************************** DATEDIFF ***********************************************

SELECT DATEDIFF(dd, '2021-04-12', '2021-04-13') -- 1


-- was ist Startdatum, was Enddatum?
SELECT DATEDIFF(dd, '2021-04-13', '2021-04-12') -- -1






-- wie viele Tage bis zum nächsten Feiertag?
SELECT DATEDIFF(dd, '2021-04-13', '2021-05-01') -- 18 

SELECT DATEDIFF(dd, GETDATE(), '2021-05-01') -- 18



-- ********************************** DATEPART *******************************************

SELECT DATEPART(dd, '2021-04-13')
-- 13 (Integerwert - kein Datum mehr)


SELECT DATEPART(month, '2021-04-13')
-- 4


SELECT DATEPART(month, GETDATE())
-- 4


SELECT DATEPART(yyyy, GETDATE())
-- 2021


-- DAY, MONTH, YEAR
SELECT YEAR(GETDATE()) -- 2021
SELECT MONTH(GETDATE()) -- 4
SELECT DAY(GETDATE()) -- 13



SELECT YEAR(BirthDate)
FROM Employees



-- ************************************* DATENAME *************************************

-- bringt nicht viel, Ausgabe wie bei DATEPART:
SELECT DATENAME(dd, '2021-04-13') -- 13


-- Datename macht eigentlich nur für zwei Datumsintervalle Sinn: Month und Dayofweek (das, was als Text ausgeschrieben werden kann)

SELECT DATENAME(dw, '2021-04-13') -- Tuesday
SELECT DATENAME(month, '2021-04-13') -- April






-- Welcher Wochentag war der eigene Geburtstag?

SELECT DATENAME(dw, '1981-04-22') -- Wednesday






-- Welches Datum haben wir in 38 Tagen?

SELECT DATEADD(dd, 38, '2021-04-13')
SELECT DATEADD(dd, 38, GETDATE())
-- 2021-05-21 12:15:06.007


-- Vor wie vielen Jahren kam der erste Star Wars Film in die Kinos? (25. Mai 1977)

SELECT DATEDIFF(yyyy, '1977-05-25', GETDATE()) -- 44


-- eigentlich reicht es hier, nur das Jahr anzugeben
SELECT DATEDIFF(yyyy, '1977', GETDATE()) -- 44



-- wie alt sind unsere Northwind-Mitarbeiter?
Select   FLOOR(DATEDIFF(dd, BirthDate, GETDATE())/365.25) AS Age
		, BirthDate
		, LastName
		, Firstname
FRom Employees


