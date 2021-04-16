-- MAXDOP
-- Max Degree of Parallelism

--> Server Rechtsklick --> Advanced
--> Parallelism
-- Max Degree of Parallelism 0 = alle dürfen verwendet werden!
-- Cost Threshold = ab welchen geschätzten Kosten dürfte Parallelismus verwendet werden

SET STATISTICS IO, TIME ON

SELECT CompanyName, SUM(UnitPrice*Quantity)
FROM KU4
WHERE CompanyName LIKE 'C%'
GROUP BY CompanyName

-- degree of parallelism: 4
-- estimated subtree cost 34.269
-- CPU time = 579 ms,  elapsed time = 887 ms


SELECT CompanyName, SUM(UnitPrice*Quantity)
FROM KU4
WHERE CompanyName LIKE 'C%'
GROUP BY CompanyName
-- degree of parallelism: 2
--  CPU time = 672 ms,  elapsed time = 1339 ms.


--> Missing Index erstellt
SELECT CompanyName, SUM(UnitPrice*Quantity)
FROM KU4
WHERE CompanyName LIKE 'C%'
GROUP BY CompanyName
-- degree of parallelism: 1
-- CPU time = 15 ms,  elapsed time = 76 ms.


