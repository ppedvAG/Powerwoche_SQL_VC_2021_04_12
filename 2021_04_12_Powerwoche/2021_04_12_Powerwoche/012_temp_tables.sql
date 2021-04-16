-- tempor�re Tabellen (temporary tables)

/*

	-- lokale tempor�re Tabellen
		existiert nur in der aktuellen Session
			#tablename



	-- globale tempor�re Tabellen
		Zugriff auch aus anderen Sessions
			##tablename



		Lebensdauer f�r beide: so lange, wie die Verbindung besteht


*/


SELECT CustomerID, Freight
INTO #t1
FROM Orders


SELECT *
FROM #t1


SELECT OrderID, OrderDate
INTO ##t2
FROM Orders

SELECT *
FROM ##t2




