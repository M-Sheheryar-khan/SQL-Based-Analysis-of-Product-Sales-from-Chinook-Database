-- Top Selling Products
SELECT Track.Name, SUM(InvoiceLine.Quantity) AS Total_Sold, RANK() OVER (ORDER BY SUM(InvoiceLine.Quantity) DESC) AS Sales_Rank
FROM InvoiceLine
JOIN Track ON InvoiceLine.TrackId = Track.TrackId
GROUP BY Track.Name
ORDER BY Sales_Rank
LIMIT 10;

-- Revenue per Region
SELECT Customer.Country, SUM(InvoiceLine.Quantity * InvoiceLine.UnitPrice) AS Total_Revenue
FROM Invoice
JOIN Customer ON Invoice.CustomerId = Customer.CustomerId
JOIN InvoiceLine ON Invoice.InvoiceId = InvoiceLine.InvoiceId
GROUP BY Customer.Country
ORDER BY Total_Revenue DESC;

-- Monthly Performance
SELECT strftime('%Y-%m', Invoice.InvoiceDate) AS Month, SUM(InvoiceLine.UnitPrice * InvoiceLine.Quantity) AS Total_Revenue,RANK() OVER (ORDER BY SUM(InvoiceLine.UnitPrice * InvoiceLine.Quantity) DESC) AS Month_Rank
FROM Invoice
JOIN InvoiceLine ON Invoice.InvoiceId = InvoiceLine.InvoiceId
GROUP BY Month
ORDER BY Month;

--Top Selling Genres
SELECT Genre.Name AS Genre, SUM(InvoiceLine.Quantity) AS Total_Sold
FROM InvoiceLine
JOIN Track ON InvoiceLine.TrackId = Track.TrackId
JOIN Genre ON Track.GenreId = Genre.GenreId
GROUP BY Genre.Name
ORDER BY Total_Sold DESC;
