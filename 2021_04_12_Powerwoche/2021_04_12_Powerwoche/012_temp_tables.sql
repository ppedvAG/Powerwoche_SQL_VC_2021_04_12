-- temporäre Tabellen (temporary tables)

/*

	-- lokale temporäre Tabellen
		existiert nur in der aktuellen Session
			#tablename



	-- globale temporäre Tabellen
		Zugriff auch aus anderen Sessions
			##tablename



		Lebensdauer für beide: so lange, wie die Verbindung besteht


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




