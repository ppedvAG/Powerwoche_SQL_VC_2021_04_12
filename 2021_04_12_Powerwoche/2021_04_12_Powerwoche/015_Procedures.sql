-- Procedures (Prozedur)


-- Variablen
/*
	
	-- @varname

	-- Datentyp?


	-- existiert nur, so lange der Batch läuft
	-- Zugriff nur innerhalb der Session, wo sie erstellt wurde


	DECLARE @varname AS Datentyp

	Bsp.: DECLARE @test AS int = 100



*/


DECLARE @test AS int

SET @test = 100


SELECT @test




CREATE PROC p_AllCustomersCity @City nvarchar(30)
AS 
SELECT *
FROM Customers
WHERE City = @City
GO



EXEC p_AllCustomersCity 'Berlin'


EXEC p_AllCustomersCity 'München'


EXEC p_AllCustomersCity 'Buenos Aires'






CREATE PROC p_AllCustomersCityCountry @City nvarchar(30), @Country nvarchar(30)
AS
SELECT *
FROM Customers
WHERE City = @City AND Country = @Country
GO



EXEC p_AllCustomersCityCountry 'Berlin', 'Germany'



-- bei Procedure mit GO arbeiten!
-- hier ist GO hilfreich:
CREATE PROC p_demo100
AS
SELECT GETDATE()
GO

EXEC p_demo100






-- bei Verwendung von Variablen kann GO auch Probleme verursachen:
DECLARE @var1 int = 1

SELECT @var1
GO 

SELECT @var1 -- hier ist die Variable nicht mehr bekannt!
GO
-- Variable existiert nur innerhalb des Batches, in dem sie erstellt worden ist



-- Procedure erstellen
-- Suchkriterium eingeben
-- beim Ausführen:

-- EXEC p_CustomerSearch 'ALFKI'      --> findet Kunde mit ID 'ALFKI'
-- EXEC p_CustomerSearch 'A'          --> findet alle Kunden, die mit 'A' beginnen
-- EXEC p_CustomerSearch '%'          --> gibt alle Kunden aus
-- EXEC p_CustomerSearch              --> gibt alle Kunden aus


-- Idee:
CREATE PROC p_Customersearch @CustomerID nvarchar(30)
AS
SELECT *
FROM Customers
WHERE CustomerID = @CustomerID
GO



EXEC p_Customersearch 'A' -- keine Ergebnisse


-- neue Idee: mit LIKE
ALTER PROC p_Customersearch @CustomerID nvarchar(30)
AS
SELECT *
FROM Customers
WHERE CustomerID LIKE @CustomerID
GO


EXEC p_Customersearch 'ALFKI'
EXEC p_Customersearch 'A' -- funktioniert nicht


-- neue Idee:
ALTER PROC p_Customersearch @CustomerID nvarchar(30)
AS
SELECT *
FROM Customers
WHERE CustomerID LIKE @CustomerID + '%'
GO


EXEC p_Customersearch 'ALFKI'
EXEC p_Customersearch 'A' -- jetzt funktioniert es

-- im Hintergrund läuft jetzt folgendes SELECT-Statement:
SELECT *
FROM Customers
WHERE CustomerID LIKE 'A' + '%'

-- funktioniert für alle
EXEC p_Customersearch 'FISSA'
EXEC p_Customersearch 'C'


EXEC p_Customersearch '%' -- funktioniert auch, 91 Zeilen (alle Kunden)


EXEC p_Customersearch -- Fehlermeldung, weil erwartet wird, dass ein Parameter übergeben wird


-- neue Idee:
-- richtig:
ALTER PROC p_Customersearch @CustomerID nvarchar(30) = '%'
AS
SELECT *
FROM Customers
WHERE CustomerID LIKE @CustomerID + '%'
GO


-- so funktionieren alle:
EXEC p_Customersearch 'FISSA'
EXEC p_Customersearch 'C'
EXEC p_Customersearch '%'
EXEC p_Customersearch


