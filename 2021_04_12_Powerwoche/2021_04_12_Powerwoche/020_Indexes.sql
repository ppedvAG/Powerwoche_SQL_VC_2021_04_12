-- indexes (Indizes, Indices, Indexes)


-- data pages
-- 8kB
-- 8 pages --> Block (64kB)



-- ohne Index: HEAP

-- clustered Index (gruppierter Index)


-- nonclustered Index (nicht-gruppierter Index)

		-- unique Index (eindeutiger Index)
		-- multicolumn index (zusammengesetzter Index)
		-- index with included columns (Index mit eingeschlossenen Spalten)
		-- covering index (abdeckender Index)
		-- filtered index (gefilterter Index) -- beinhaltet eine WHERE-Clause

		-- missing index/hypothetisch realer Index...



	-- Columnstore Index --> Big Data; Data Warehouse; Archivdaten
	-- CI wartet mit Update/Komprimierung bis 1 MIO Datensätze erreicht werden (oder bis 140000 am Stück reinkommen)
	--> die Abfragen werden bei kleinen Datenmengen langsamer, weil ausgelagerte Daten gesucht werden müssen




SELECT *
INTO Orders1
FROM Northwind.dbo.Orders



SET STATISTICS IO, TIME ON


SELECT *
FROM Orders1
WHERE OrderID = 11000

-- Table Scan
-- = alle pages werden gelesen = langsam
-- CPU time 0, elapsed time 39-60 ms
-- logical reads 20


ALTER TABLE Orders1
ADD CONSTRAINT PK_Orders1 PRIMARY KEY (OrderID)


SELECT *
FROM Orders1
WHERE OrderID = 11000
-- Clustered Index Seek
-- logical reads 2



ALTER TABLE Orders1
ADD CONSTRAINT PK_Orders1 PRIMARY KEY NONCLUSTERED (OrderID)


SELECT *
FROM Orders1
WHERE OrderID = 11000
-- logical reads 3




-- neue Abfrage:

SELECT AVG(Freight) FROM Orders1 -- 78,2442


SELECT * FROM Orders1 WHERE Freight < 1 -- 50%
SELECT * FROM Orders1 WHERE Freight > 100 -- 50%



SELECT * FROM Orders1 WHERE Freight < 1 -- 78%
SELECT TOP 24 * FROM Orders1 WHERE Freight > 100 -- 22%  
-- wenn wir keinen Index haben "gewinnt" der TOP-Befehl


-- Index
-- NIX_Freight_including_all

SELECT * FROM Orders1 WHERE Freight < 1 -- 34%
SELECT * FROM Orders1 WHERE Freight > 100  -- 66%



SELECT * FROM Orders1 WHERE Freight < 1 -- 47%
SELECT TOP 24 * FROM Orders1 WHERE Freight > 100 -- 53%
-- mit Index "gewinnt" die Abfrage ohne Top; beim TOP haben wir noch einen zusätzlichen Schritt dabei 




CREATE CLUSTERED INDEX CIX_Orders1
ON Orders1 (OrderID)


SELECT ShipCountry, ShipCity
FROM Orders1
WHERE ShipCountry = 'Germany' AND ShipCity = 'Berlin'




SELECT	  ShipCountry
		, ShipCity
		, OrderID
		, Freight
FROM Orders1
WHERE ShipCountry = 'Germany' AND ShipCity = 'Berlin'



-- index physical stats
--> wie viele Ebenen müssen wir durchwandern, um an die Informationen zu kommen (index_depth)
SELECT index_id, index_type_desc, index_depth, index_level, page_count
FROM sys.dm_db_index_physical_stats(db_id(), object_id('Orders1'), NULL, NULL, 'limited')


-- wann sind welche Indizes zuletzt verwendet worden
-- scan oder seek?
select    iu.object_id
		, type_desc
		, name
		, iu.index_id
		, user_seeks
		, user_scans
		, last_user_scan
		, last_user_seek		
from sys.indexes si Inner join sys.dm_db_index_usage_stats iu on si.index_id = iu.index_id
where name like '%ix%'



