-- Transactions (Transaktionen)

SELECT *
FROM Produkte


BEGIN TRAN

UPDATE Produkte
SET Preis = 4.99
WHERE ProduktID = 6

ROLLBACK TRAN

COMMIT TRAN



-- erst, wenn wir ein COMMIT gemacht haben, ist die Transaktion abgeschlossen
-- Transaktion wird ganz oder gar nicht ausgeführt

-- Transaction Isolation Levels in der Microsoft-Dokumentation:
-- https://docs.microsoft.com/en-us/sql/t-sql/statements/set-transaction-isolation-level-transact-sql?view=sql-server-ver15






