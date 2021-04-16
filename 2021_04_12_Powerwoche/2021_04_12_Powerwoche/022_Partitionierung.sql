-- Partitionierung

-- ********************************* partitioned view (partitionierte Sicht) ****************************


-- Testtabellen erstellen:
CREATE TABLE Orders (
						OrderID int NOT NULL,
						CountryCode char(3) NOT NULL,
						OrderDate date NULL,
						OrderYear int NOT NULL,
						CONSTRAINT PK_Orders PRIMARY KEY (OrderID, OrderYear)
					)

					

CREATE TABLE Orders_2020 (
						OrderID int NOT NULL,
						CountryCode char(3) NOT NULL,
						OrderDate date NULL,
						OrderYear int NOT NULL,
						CONSTRAINT PK_Orders_2020 PRIMARY KEY (OrderID, OrderYear)
					)

					

CREATE TABLE Orders_2019 (
						OrderID int NOT NULL,
						CountryCode char(3) NOT NULL,
						OrderDate date NULL,
						OrderYear int NOT NULL,
						CONSTRAINT PK_Orders_2019 PRIMARY KEY (OrderID, OrderYear)
					)


-- Testdaten einfügen:

-- in Orders einfügen:
INSERT INTO Orders (OrderID, CountryCode, OrderDate, OrderYear)
VALUES    (202101, 'AUT', '2021-04-01', 2021)
		, (202102, 'AUT', '2021-04-02', 2021)


-- in Orders_2020 einfügen:
INSERT INTO Orders_2020(OrderID, CountryCode, OrderDate, OrderYear)
VALUES    (202001, 'AUT', '2020-04-01', 2020)
		, (202002, 'AUT', '2020-04-02', 2020)

-- in Orders_2019 einfügen:
INSERT INTO Orders_2019(OrderID, CountryCode, OrderDate, OrderYear)
VALUES    (201901, 'AUT', '2019-04-01', 2019)
		, (201902, 'AUT', '2019-04-02', 2019)






-- VIEW erstellen:

CREATE VIEW v_OrdersYear
AS
SELECT OrderID, CountryCode, OrderDate, OrderYear
FROM Orders
UNION ALL
SELECT OrderID, CountryCode, OrderDate, OrderYear
FROM Orders_2020
UNION ALL
SELECT OrderID, CountryCode, OrderDate, OrderYear
FROM Orders_2019
GO


SELECT *
FROM v_OrdersYear




SELECT *
FROM v_OrdersYear
WHERE OrderYear = 2019
--> Execution Plan zeigt, dass wir alle drei Tabellen absuchen müssen


--> Lösung: CHECK CONSTRAINT für partitionierte Sicht erstellen:

ALTER TABLE Orders
ADD CONSTRAINT CK_Orders CHECK (OrderYear >= 2021)
GO

ALTER TABLE Orders_2020
ADD CONSTRAINT CK_Orders_2020 CHECK (OrderYear = 2020)
GO

ALTER TABLE Orders_2019
ADD CONSTRAINT CK_Orders_2019 CHECK (OrderYear = 2019)
GO


-- gleiche Abfrage noch einmal ausführen:
SELECT *
FROM v_OrdersYear
WHERE OrderYear = 2019
--> Execution Plan zeigt: wir müssen nun nicht mehr alle 3 Tabellen lesen, sondern nur noch die Orders_2019



-- über VIEW Daten einfügen:

INSERT INTO v_OrdersYear (OrderID, CountryCode, OrderDate, OrderYear)
VALUES    (202103, 'GER', GETDATE(), 2021)
		, (202003, 'GER', '2020-04-16', 2020)
		, (201903, 'GER', '2019-04-16', 2019)

-- view zeigt natürlich alle 9 Einträge
SELECT *
FROM v_OrdersYear


-- zum Überprüfen die einzelnen Tabellen abfragen:
SELECT *
FROM Orders


SELECT *
FROM Orders_2020


SELECT *
FROM Orders_2019


-- Nachteile von partitioned view:
-- nächstes Jahr müssen wir eine neue Tabelle anlegen
-- und jedes Mal, wenn eine neue Tabelle hinzukommt, muss die View angepasst werden





-- *************************************************************************************************
-- *************************************************************************************************

-- Partition

-- Partitionierung funktioniert auch ohne zusätzliche Filegroups (Dateigruppen)
-- aber die Wahrscheinlichkeit ist hoch, dass wir welche erstellen werden




-- Daten einteilen



-- ----------------- 1000] -------------------------- 5000] -------------------------------------------
--        1                           2                                         3


-- bis1000                         bis5000                              Rest



--> Filegroups erstellen
--> bis1000, bis5000, Rest

--> feststellen, welche Filegroups für unsere DB zur Verfügung stehen:

SELECT Name FROM sys.filegroups


-- Partition function und Partition Scheme erstellen

-- Partition function:

CREATE PARTITION FUNCTION f_zahl(int)
AS
RANGE LEFT FOR VALUES(1000, 5000) -- wir könnten auch RIGHT verwenden (Werte "auf der rechten Seite von...")


-- Funktion testen, ob das so funktioniert, wie wir uns das vorstellen:
-- abfragen, in welchem Teil der Wert liegen würde:

SELECT $partition.f_zahl(117) -- 1
SELECT $partition.f_zahl(1000) -- 1
SELECT $partition.f_zahl(1001) -- 2
SELECT $partition.f_zahl(5000) -- 2
SELECT $partition.f_zahl(5001) -- 3
SELECT $partition.f_zahl(1000000) -- 3



-- Partitionsschema (partition scheme)

CREATE PARTITION SCHEME sch_zahl
AS
PARTITION f_zahl TO (bis1000, bis5000, Rest) -- Reihenfolge wichtig!



CREATE TABLE [dbo].[PartitionTest](
	[CustomerID] [nchar](5) NOT NULL,
	[CompanyName] [nvarchar](40) NOT NULL,
	[ContactName] [nvarchar](30) NULL,
	[ContactTitle] [nvarchar](30) NULL,
	[City] [nvarchar](15) NULL,
	[Country] [nvarchar](15) NULL,
	[OrderID] [int] NOT NULL,
	[OrderDate] [datetime] NULL,
	[ShippedDate] [datetime] NULL,
	[Freight] [money] NULL,
	[EmployeeID] [int] NOT NULL,
	[LastName] [nvarchar](20) NOT NULL,
	[FirstName] [nvarchar](10) NOT NULL,
	[Title] [nvarchar](30) NULL,
	[BirthDate] [datetime] NULL,
	[ProductID] [int] NOT NULL,
	[UnitPrice] [money] NULL,
	[ProductName] [nvarchar](40) NOT NULL,
	[Quantity] [smallint] NOT NULL,
	[ID] [int] NOT NULL
) ON sch_zahl(ID)
GO

SELECT *
FROM PartitionTest

INSERT INTO PartitionTest
SELECT * FROM KU1


SET STATISTICS IO, TIME ON

SELECT *
INTO KU4
FROM KU1


SELECT *
FROM KU4
WHERE ID = 117
-- logical reads 44508



SELECT *
FROM PartitionTest
WHERE ID = 117
-- logical reads 41



SELECT *
FROM PartitionTest
WHERE ID = 3214
-- logical reads 162


-- neue Grenze einfügen?

---------1000] -----------------------5000] ------------------------- 16000] --------------------------
--  1                      2                             3                                 4


--> zuerst Filegroup anlegen!

-- bis16000

-- neue Grenze bei 16000

--> Partition scheme ändern:

ALTER PARTITION SCHEME sch_zahl NEXT USED bis16000



-- überprüfen, welche Datensätze stehen in welcher Partition drin:
SELECT    $partition.f_zahl(id) AS [Partition]
		, MIN(id) AS von
		, MAX(id) AS bis
		, COUNT(*) AS Anzahl
FROM PartitionTest
GROUP BY $partition.f_zahl(Id)
-- bis jetzt noch keine Änderung; es sind immer noch drei Gruppen


-- Daten verteilen mit Partition function: (--> 16000)

ALTER PARTITION FUNCTION f_zahl() SPLIT RANGE (16000)

-- überprüfen, welche Datensätze stehen in welcher Partition drin:
SELECT    $partition.f_zahl(id) AS [Partition]
		, MIN(id) AS von
		, MAX(id) AS bis
		, COUNT(*) AS Anzahl
FROM PartitionTest
GROUP BY $partition.f_zahl(Id)




SELECT $partition.f_zahl(117) -- 1
SELECT $partition.f_zahl(1000) -- 1
SELECT $partition.f_zahl(1001) -- 2
SELECT $partition.f_zahl(5000) -- 2
SELECT $partition.f_zahl(5001) -- 3
SELECT $partition.f_zahl(11569) -- 3
SELECT $partition.f_zahl(17569) -- 4




-- Grenze 1000 entfernen:


----------X1000X--------------------5000]----------------------------16000] -----------------------------------
--                   1                                2                                   3




-- dafür müssen wir nur die Funktion anpassen (Schema brauchen wir nicht anzupassen)

ALTER PARTITION FUNCTION f_zahl() MERGE RANGE(1000)


-- überprüfen, welche Datensätze stehen in welcher Partition drin:
SELECT    $partition.f_zahl(id) AS [Partition]
		, MIN(id) AS von
		, MAX(id) AS bis
		, COUNT(*) AS Anzahl
FROM PartitionTest
GROUP BY $partition.f_zahl(Id)



-- FileName, Daten in MB, Filegroupname ausgeben:
SELECT sdf.name AS [FileName],
size*8/1024 AS [Size_in_MB],
fg.name AS [File_Group_Name]
FROM sys.database_files sdf
INNER JOIN
sys.filegroups fg
ON sdf.data_space_id=fg.data_space_id




-- Analysen "ausborgen" und an eigene Bedürfnisse anpassen:
SELECT
    so.name as [Tabelle],
    stat.row_count AS [Rows],
    p.partition_number AS [Partition #],
    pf.name as [Partition Function],
    CASE pf.boundary_value_on_right
        WHEN 1 then 'Right / Lower'
        ELSE 'Left / Upper'
    END as [Boundary Type],
    prv.value as [Boundary Point],
    fg.name as [Filegroup]
FROM sys.partition_functions AS pf
JOIN sys.partition_schemes as ps on ps.function_id=pf.function_id
JOIN sys.indexes as si on si.data_space_id=ps.data_space_id
JOIN sys.objects as so on si.object_id = so.object_id
JOIN sys.schemas as sc on so.schema_id = sc.schema_id
JOIN sys.partitions as p on 
    si.object_id=p.object_id 
    and si.index_id=p.index_id
LEFT JOIN sys.partition_range_values as prv on prv.function_id=pf.function_id
    and p.partition_number= 
        CASE pf.boundary_value_on_right WHEN 1
            THEN prv.boundary_id + 1
        ELSE prv.boundary_id
        END
        /* For left-based functions, partition_number = boundary_id, 
           for right-based functions we need to add 1 */
JOIN sys.dm_db_partition_stats as stat on stat.object_id=p.object_id
    and stat.index_id=p.index_id
    and stat.index_id=p.index_id and stat.partition_id=p.partition_id
    and stat.partition_number=p.partition_number
JOIN sys.allocation_units as au on au.container_id = p.hobt_id
    and au.type_desc ='IN_ROW_DATA' 
        /* Avoiding double rows for columnstore indexes. */
        /* We can pick up LOB page count from partition_stats */
JOIN sys.filegroups as fg on fg.data_space_id = au.data_space_id
ORDER BY [Tabelle], [Partition Function], [Partition #];
GO




CREATE TABLE [dbo].[Archivtabelle](
	[CustomerID] [nchar](5) NOT NULL,
	[CompanyName] [nvarchar](40) NOT NULL,
	[ContactName] [nvarchar](30) NULL,
	[ContactTitle] [nvarchar](30) NULL,
	[City] [nvarchar](15) NULL,
	[Country] [nvarchar](15) NULL,
	[OrderID] [int] NOT NULL,
	[OrderDate] [datetime] NULL,
	[ShippedDate] [datetime] NULL,
	[Freight] [money] NULL,
	[EmployeeID] [int] NOT NULL,
	[LastName] [nvarchar](20) NOT NULL,
	[FirstName] [nvarchar](10) NOT NULL,
	[Title] [nvarchar](30) NULL,
	[BirthDate] [datetime] NULL,
	[ProductID] [int] NOT NULL,
	[UnitPrice] [money] NULL,
	[ProductName] [nvarchar](40) NOT NULL,
	[Quantity] [smallint] NOT NULL,
	[ID] [int] NOT NULL -- kein Identity!
) ON bis5000  -- Archivtabelle muss das selbe Schema verwenden wie Originaltabelle 
GO


-- ursprüngliche Tabelle verändern:
-- Daten einer Partition sollen in Archivtabelle geschrieben werden


ALTER TABLE PartitionTest SWITCH PARTITION 1 TO Archivtabelle

-- testen:
SELECT *
FROM Archivtabelle
ORDER BY ID




SELECT *
FROM PartitionTest
WHERE ID = 2345
-- kein Ergebnis - die Daten sind jetzt in der Archivtabelle drin und nicht mehr in der ursprünglichen Tabelle!



-- überprüfen, welche Datensätze stehen in welcher Partition drin:
SELECT    $partition.f_zahl(id) AS [Partition]
		, MIN(id) AS von
		, MAX(id) AS bis
		, COUNT(*) AS Anzahl
FROM PartitionTest
GROUP BY $partition.f_zahl(Id)



-- FileName, Daten in MB, Filegroupname ausgeben:
SELECT sdf.name AS [FileName],
size/128 AS [Size_in_MB],
fg.name AS [File_Group_Name]
FROM sys.database_files sdf
INNER JOIN
sys.filegroups fg
ON sdf.data_space_id=fg.data_space_id





-- Jahresweise aufteilen?

CREATE PARTITION FUNCTION f_year(datetime)
AS
RANGE LEFT FOR VALUES ('2019-12-31 23:59:59.996') -- Vorsicht... wo genau liegt jetzt die Grenze?



-- nach Alphabet geordnet?

-- A------------------------------M/N---------------------------------R----------------------------------Z

-- M
-- MARIA > M


CREATE PARTITION FUNCTION f_alphabet(nvarchar(50))
AS
RANGE LEFT FOR VALUES('N', 'S')
-- Vorsicht... MA ist größer als M --> wo Grenzen setzen?










