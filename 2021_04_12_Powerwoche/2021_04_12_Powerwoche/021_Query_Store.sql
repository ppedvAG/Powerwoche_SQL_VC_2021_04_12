

--> wir brauchen eine gr��ere Datenmenge, um etwas analysieren zu k�nnen
--> KundenUmsatz-Tabelle --> Daten k�nstlich aufbl�hen


INSERT INTO KundenUmsatz
SELECT * FROM KundenUmsatz
GO 9

--> ergibt > 1 MIO Datens�tze in KundenUmsatz-Tabelle



-- Kopien erstellen 
SELECT *
INTO KU1
FROM KundenUmsatz


dbcc showcontig('ku1')

SELECT *
FROM KU1
-- logical reads 43970

SET STATISTICS IO, TIME ON

ALTER TABLE KU1 
ADD ID int identity


SELECT *
FROM KU1

-- logical reads 58104???
-- > ID Spalte wurde ausgelagert!



select    page_count
		, record_count
		, forwarded_record_count
from sys.dm_db_index_physical_stats(db_id(), object_id('ku1'), NULL, NULL, 'detailed')


-- NULL : bestimmten Index zeigen
-- NULL: bestimmte Partition zeigen

--> zusammenf�hren: mit CLUSTERED INDEX
--> kein forwarded_record_count mehr, solange cl ix


SELECT *
INTO KU2
FROM KU1




select    page_count
		, record_count
		, forwarded_record_count
from sys.dm_db_index_physical_stats(db_id(), object_id('ku2'), NULL, NULL, 'detailed')







-- f�r Query Store: Kompatibilit�tsgrad von >120 (ab SQL Server 2016)
--> 130 (sql server 2016), 140 (2017), 150 (2019) sind notwendig, damit Query Store funktioniert

-- RML Utilities: viele Abfragen von mehreren Usern im Hintergrund simulieren
-- ostress -S. -Q"select * from KU1 where id < 2" -dtest -n5 -r5 -q
/*
-S. k�nnten wir auch weglassen
-Q Abfrage
-d Datenbank
-n Anzahl User
-r Anzahl Wiederholungen
-q quiet - keine Ausgabe hier machen
*/

SELECT * FROM KU2 WHERE ID < 2


SELECT * FROM KU2 WHERE ID < 100000

SELECT * FROM KU2 WHERE ID < 1000000



ALTER PROC gpdemo01 @par1 int
AS
SELECT * FROM KU1 WHERE ID < @par1
GO




EXEC gpdemo01 1000000


DBCC freeproccache
-- Vorsicht: l�scht gesamten Proc Cache des Servers


EXEC gpdemo01 2



