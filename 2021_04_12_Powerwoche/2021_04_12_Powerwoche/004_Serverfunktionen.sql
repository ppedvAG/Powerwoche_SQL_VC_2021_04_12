-- Serverfunktionen


-- *********************************** Stringfunktionen ****************************************



-- ***************************** TRIM, LEN, DATALENGTH *****************************************


SELECT 'Test'


SELECT '     Test'


SELECT LEN('Test') 
-- 4 Zeichen



SELECT LEN('Test     ') 
-- 4! LEN zählt Leerzeichen am Ende nicht mit!
-- dabei handelt es sich im Normalfall um Leerzeichen, die automatisch ergänzt wurden


SELECT LEN('     Test') 
-- 9 Leerzeichen davor werden mitgezählt


SELECT LEN('     Test text') 
-- 14 (Leerzeichen in der Mitte werden auch mitgezählt)


SELECT DATALENGTH('Test')
-- 4


SELECT DATALENGTH('Test     ')
-- 9 (zählt auch Leerzeichen am Ende mit)


SELECT LEN(CustomerID)
FROM Customers




SELECT DATALENGTH(CustomerID)
FROM Customers




-- Vorsicht: Wenn ein Datentyp verwendet wurde, der in UNICODE abspeichert, gibt DATALENGTH doppelt so viel zurück, wie Zeichen drin stehen
SELECT	  LEN(CompanyName) AS [LEN]
		, DATALENGTH(CompanyName) AS [DATALENGTH]
FROM Customers




SELECT TRIM('Test     ')


SELECT LEN(TRIM('Test     '))
-- 4
-- bringt nix: wir würden nicht sehen, ob das Wegschneiden funktioniert hat, weil LEN Leerzeichen am Ende nicht mitzählt


SELECT DATALENGTH(TRIM('Test     '))
-- 4


SELECT RTRIM('Test     ') -- Leerzeichen rechts wegschneiden

SELECT LTRIM('     Test') -- Leerzeichen links wegtrimmen

SELECT TRIM('     Test      ') -- Leerzeichen auf beiden Seiten wegschneiden




-- ************************************* REVERSE *******************************************

SELECT REVERSE('REITTIER')

SELECT REVERSE('Trug Tim eine so helle Hose nie mit Gurt?')



-- *********************************** Zeichen ausschneiden ************************************
-- ************************** LEFT, RIGHT, SUBSTRING *******************************************

SELECT LEFT('Testtext', 4)
-- Test



SELECT RIGHT('Testtext', 4)
-- text


SELECT SUBSTRING('Testtext', 4, 2) -- tt
-- beginnend bei Stelle 4
-- 2 Zeichen ausschneiden



-- **************************************** STUFF **************************************************
-- etwas einfügen oder ersetzen

-- einfügen:
SELECT STUFF('Testtext', 5, 0, '_Hallo_')


-- ersetzen:
SELECT STUFF('Testtext', 4, 2, '_Hallo_')
-- Tes_Hallo_ext


-- von welchem Text möchte ich etwas einfügen oder ersetzen
-- von welcher Stelle ausgehend (4)
-- wie viele Zeichen sollen gelöscht werden; 0, wenn nichts gelöscht werden soll
-- was soll eingefügt werden



-- ********************************************* CONCAT ****************************************************

SELECT CONCAT('Test', 'text') -- Testtext

SELECT CONCAT('abc', 'def', 'ghi', 'jkl', 'mno', 'pqr', 'stu', 'vwx', 'yz')
-- abcdefghijklmnopqrstuvwxyz


SELECT CONCAT('Ich weiß, ', 'dass ich', ' nichts weiß.') AS Zitat

SELECT CONCAT('James', 'Bond')


-- mit DB:
SELECT CONCAT(FirstName, ' ', LastName) AS EmpName
FROM Employees



SELECT CONCAT(FirstName, ' ', LastName) AS [Name Angestellte]
FROM Employees




-- die letzten 3 Zeichen der Telefonnummer sollen mit x ersetzt werden
-- 1234567890  --> 1234567xxx


-- Möglichkeit 1:
SELECT STUFF('1234567890', 8, 3, 'xxx')
-- funktioniert nur mit fixer Anzahl an Zeichen


-- Möglichkeit 2:
SELECT LEFT('1234567890', 7) + 'xxx'

-- oder:
SELECT CONCAT(LEFT('1234567890', 7), 'xxx')
-- funktioniert nur mit fixer Anzahl an Zeichen


-- Möglichkeit 3:
-- langsam:

SELECT REVERSE('1234567890')
-- 0987654321

SELECT STUFF('0987654321', 1, 3, 'xxx')

-->
SELECT STUFF(REVERSE('1234567890'), 1, 3, 'xxx')

-->
SELECT REVERSE(STUFF(REVERSE('1234567890'), 1, 3, 'xxx'))

-- mit DB:
SELECT REVERSE(STUFF(REVERSE(Phone), 1, 3, 'xxx'))
FROM Customers



-- Möglichkeit 4:
SELECT STUFF('1234567890', 8, 3, 'xxx')

-- wie kommen wir auf 8?
-- insgesamt sind es 10, davon ziehen wir 2 ab


-- wie viele sind es insgesamt?
SELECT LEN('1234567890') -- 10

--> Berechnung einsetzen:
SELECT STUFF('1234567890', LEN('1234567890')-2, 3, 'xxx')

--> mit DB:
SELECT STUFF(Phone, LEN(Phone)-2, 3, 'xxx')
FROM Customers
-- funktioniert auch unabhängig von der Länge des Eintrags




-- Möglichkeit 5:

-- Berechnung:
-- wie kommen wir auf 7?
-- wie viele sind es insgesamt - 3 (nur die letzten 3 Zeichen sollen gelöscht/mit x ersetzt werden)

SELECT LEN('1234567890')-3


SELECT LEFT('1234567890', LEN('1234567890')-3) + 'xxx'


--> mit DB:
SELECT LEFT(Phone, LEN(Phone)-3) + 'xxx'
FROM Customers



SELECT CONCAT(LEFT(Phone, LEN(Phone)-3), 'xxx')
FROM Customers

-- funktioniert wieder unabhängig von der Anzahl an Zeichen in der TelNr.



-- ************************************ REPLICATE ************************************************

SELECT REPLICATE('?', 5) -- ?????

SELECT REPLICATE('x', 3) -- xxx


-- funktioniert auch mit Zeichenfolgen

SELECT REPLICATE('abc', 3) -- abcabcabc




-- *********************************** Groß-/Kleinschreibung bei Textausgabe ***************************

SELECT UPPER('test') -- TEST (uppercase)

SELECT LOWER('TEST') -- test (lowercase)


SELECT UPPER(FirstName)
FROM Employees




-- ****************************** REPLACE *******************************************

SELECT REPLACE('Hallo!', 'a', 'e') -- Hello!  

-- mehrere Zeichen ersetzen (verschachteln)

SELECT REPLACE(REPLACE('Hallo!', 'a', 'e'), '!', '?') -- Hello?


SELECT REPLACE(REPLACE(REPLACE('Hallo!', 'a', 'e'), '!', '?'), 'H', 'B') -- Bello?





SELECT REPLACE('Hallotestatexta!', 'a', 'e') -- Hellotestetexte!





-- ********************************************* CHARINDEX **************************************
-- gibt die Stelle zurück, an der sich das gesuchte Zeichen (oder Zeichenfolge) befindet


SELECT CHARINDEX('a', 'Leo') -- 0 (wenn es nicht vorkommt, dann 0)


SELECT CHARINDEX('e', 'Leo') -- 2 


SELECT CHARINDEX(' ', 'James Bond') -- 6


SELECT CHARINDEX('$', '450$') -- 4

SELECT CHARINDEX('%', '50%') -- 3



SELECT CHARINDEX('schnecke', 'Zuckerschnecke') -- 7


-- mit DB:

SELECT CHARINDEX(' ', ContactName)
FROM Customers



SELECT CHARINDEX(' ', 'Wolfgang Amadeus Mozart') -- 9



-- wie bekommen wir die Stelle, an der sich das letzte Leerzeichen befindet?

-- langsam:

-- umdrehen:
SELECT REVERSE('Wolfgang Amadeus Mozart') -- trazoM suedamA gnagloW


-- wie viele Zeichen gibt es insgesamt:
SELECT LEN('Wolfgang Amadeus Mozart') -- 23


-- erstes Leerzeichen im umgedrehten Text:
SELECT CHARINDEX(' ', 'trazoM suedamA gnagloW') -- 7


-- 23 -7 = 16

-- 23 - 7 + 1 = richtige Stelle


-- einsetzen:

SELECT LEN('Wolfgang Amadeus Mozart') - CHARINDEX(' ', REVERSE('Wolfgang Amadeus Mozart')) + 1  -- 17



-- nicht von fixer Zeichenanzahl abhängig:

SELECT LEN('Georg Friedrich Händel') - CHARINDEX(' ', REVERSE('Georg Friedrich Händel')) + 1 -- 16



-- mit DB:
SELECT LEN(ContactName) - CHARINDEX(' ', REVERSE(ContactName)) + 1, ContactName
FROM Customers





-- 1234567890 --> *******890
-- zuerst mit 1234567890
-- dann unabhängig von Länge mit Phone aus Customers-Tabelle
-- nur letzte drei Zeichen anzeigen, andere mit x oder * ersetzen



-- langsam aufbauen:
-- Teil 1:
SELECT STUFF('1234567890', 1, 7,'*******')


-- mehrere Zeichen einfügen:
SELECT REPLICATE('*', 7)


-- Replicate in STUFF einsetzen:
SELECT STUFF('1234567890', 1, 7, REPLICATE('*', 7))


-- wie viele Zeichen sind es insgesamt?
SELECT LEN('1234567890') -- 10


-- wie kommen wir auf 7?
SELECT LEN('1234567890') - 3


--> einsetzen: 7 durch Berechnung ersetzen:
SELECT STUFF('1234567890', 1, LEN('1234567890') - 3, REPLICATE('*', LEN('1234567890') - 3))



-- mit DB:
-- 1234567890 durch "Phone" ersetzen:
SELECT	  STUFF(Phone, 1, LEN(Phone) - 3, REPLICATE('*', LEN(Phone) - 3))
		, Phone
FROM Customers


-- andere Möglichkeit:
-- letzte 3 Zeichen ausschneiden:
SELECT RIGHT('1234567890', 3) -- 890


SELECT CONCAT('*******', RIGHT('1234567890', 3)) -- *******890



SELECT CONCAT(REPLICATE('*', LEN('1234567890') - 3), RIGHT('1234567890', 3))


--> mit DB:
SELECT CONCAT(REPLICATE('*', LEN(Phone) - 3), RIGHT(Phone, 3))
FROM Customers








-- mathematische Funktionen

SELECT PI() -- 3,14159265358979

SELECT SQUARE(5) -- 25

SELECT SQRT(25) -- 5 ..... sqrt = squareroot (Wurzel)



-- runden:

SELECT ROUND(12.3456789, 2) -- 12.3500000

SELECT FLOOR(12.9456789) -- 12

SELECT CEILING(12.3456789) -- 13













