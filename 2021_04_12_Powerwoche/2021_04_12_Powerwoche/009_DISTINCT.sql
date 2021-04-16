-- DISTINCT
-- mit Distinct verhindern wir Mehrfachausgaben


-- alle Länder, in denen wir Kunden haben

-- Idee:

-- falsch:
SELECT Country 
FROM Customers
-- 91 Ergebnisse, so viele wie insgesamt Kunden


-- richtig:
SELECT DISTINCT Country
FROM Customers
-- 21 Zeilen (so viele, wie Länder)


-- DISTINCT gilt für alle Spalten im SELECT
-- aber bei eindeutigen Einträgen (wie hier bei der CustomerID) kann nichts mehr weggekürzt werden!
SELECT DISTINCT Country, CustomerID
FROM Customers
-- 91


-- mehrere Spalten sind möglich
-- die mit den meisten Einträgen "gewinnt"
SELECT DISTINCT Country, City
FROM Customers
-- 69 (so viele, wie Cities!)


