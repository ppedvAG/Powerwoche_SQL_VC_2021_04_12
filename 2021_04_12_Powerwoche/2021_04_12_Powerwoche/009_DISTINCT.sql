-- DISTINCT
-- mit Distinct verhindern wir Mehrfachausgaben


-- alle L�nder, in denen wir Kunden haben

-- Idee:

-- falsch:
SELECT Country 
FROM Customers
-- 91 Ergebnisse, so viele wie insgesamt Kunden


-- richtig:
SELECT DISTINCT Country
FROM Customers
-- 21 Zeilen (so viele, wie L�nder)


-- DISTINCT gilt f�r alle Spalten im SELECT
-- aber bei eindeutigen Eintr�gen (wie hier bei der CustomerID) kann nichts mehr weggek�rzt werden!
SELECT DISTINCT Country, CustomerID
FROM Customers
-- 91


-- mehrere Spalten sind m�glich
-- die mit den meisten Eintr�gen "gewinnt"
SELECT DISTINCT Country, City
FROM Customers
-- 69 (so viele, wie Cities!)


