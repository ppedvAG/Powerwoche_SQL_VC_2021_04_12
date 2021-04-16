SELECT Customers.CustomerID, Customers.CompanyName, Customers.ContactName, Customers.ContactTitle, Customers.City, Customers.Country, Orders.OrderID, Orders.OrderDate, Orders.ShippedDate, Orders.Freight, Employees.EmployeeID, Employees.LastName, 
             Employees.FirstName, Employees.Title, Employees.BirthDate, Products.ProductID, Products.UnitPrice, Products.ProductName, [Order Details].Quantity
INTO Test.dbo.KundenUmsatz
FROM    Northwind.dbo.Customers INNER JOIN
             Northwind.dbo.Orders ON  Northwind.dbo.Customers.CustomerID =  Northwind.dbo.Orders.CustomerID INNER JOIN
              Northwind.dbo.Employees ON  Northwind.dbo.Orders.EmployeeID =  Northwind.dbo.Employees.EmployeeID INNER JOIN
              Northwind.dbo.[Order Details] ON  Northwind.dbo.Orders.OrderID =  Northwind.dbo.[Order Details].OrderID INNER JOIN
              Northwind.dbo.Products ON  Northwind.dbo.[Order Details].ProductID =  Northwind.dbo.Products.ProductID