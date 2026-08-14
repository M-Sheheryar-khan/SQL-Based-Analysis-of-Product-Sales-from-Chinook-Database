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

--Genre-per-Country Ranking
SELECT 
    Customer.Country,
    Genre.Name AS Genre,
    SUM(InvoiceLine.Quantity) AS Total_Sold,
RANK() OVER (PARTITION BY Customer.Country ORDER BY SUM(InvoiceLine.Quantity) DESC) AS Genre_RANK
FROM InvoiceLine
JOIN Track ON InvoiceLine.TrackId = Track.TrackId
JOIN Genre ON Track.GenreId = Genre.GenreId
JOIN Invoice ON InvoiceLine.InvoiceId = Invoice.InvoiceId 
Join Customer ON Invoice.CustomerId = Customer.CustomerId
Group By Genre.Name , Customer.Country
ORDER BY Customer.Country, Genre_Rank;


WITH genre_country_sales AS (
    SELECT 
        Customer.Country,
        Genre.Name AS Genre,
        SUM(InvoiceLine.Quantity) AS Total_Sold
    FROM InvoiceLine
    JOIN Track ON InvoiceLine.TrackId = Track.TrackId
    JOIN Genre ON Track.GenreId = Genre.GenreId
    JOIN Invoice ON InvoiceLine.InvoiceId = Invoice.InvoiceId
    JOIN Customer ON Invoice.CustomerId = Customer.CustomerId
    GROUP BY Customer.Country, Genre.Name
)
SELECT *,
    RANK() OVER (PARTITION BY Country ORDER BY Total_Sold DESC) AS Genre_Rank
FROM genre_country_sales
ORDER BY Country, Genre_Rank;


--Month-over-Month Revenue Growth
WITH monthly_revenue AS(
    SELECT 
        strftime('%Y-%m', Invoice.InvoiceDate) AS Month,
        SUM(InvoiceLine.UnitPrice * InvoiceLine.Quantity) AS Total_Revenue
    FROM Invoice
    JOIN InvoiceLine ON Invoice.InvoiceId = InvoiceLine.InvoiceId
    GROUP BY Month
)
SELECT 
    Month,
    LAG(TOTAL_Revenue) OVER (ORDER BY Month) AS Prev_Month_Revenue,
    Round(
        (Total_Revenue - LAG(Total_Revenue) OVER (ORDER BY Month)) * 100.0
        / LAG(Total_Revenue) OVER (ORDER BY Month), 2
    ) AS MoM_Growth_Percent
FROM monthly_revenue 
ORDER BY Month;


--Cumulative Revenue Over Time
SELECT 
    strftime('%Y-%m', Invoice.InvoiceDate) AS Month,
    SUM(InvoiceLine.UnitPrice * InvoiceLine.Quantity) AS Monthly_Revenue,
    SUM(SUM(InvoiceLine.UnitPrice * InvoiceLine.Quantity)) OVER (ORDER BY strftime('%Y-%m', Invoice.InvoiceDate)) AS Running_Total_Revenue
FROM Invoice
JOIN InvoiceLine ON Invoice.InvoiceId = InvoiceLine.InvoiceId
GROUP BY Month
ORDER BY Month;


--Customer RFM Segmentation
WITH customer_rfm AS (
   SELECT 
       Customer.CustomerId,
       Customer.FirstName || ' ' || Customer.LastName AS CustomerName,
       julianday('2013-12-31') - julianday(MAX(Invoice.InvoiceDate)) AS Recency_Days,
       COUNT(DISTINCT Invoice.InvoiceId) AS Frequency,
       SUM(InvoiceLine.UnitPrice * InvoiceLine.Quantity) AS Monetary
   FROM Customer
   JOIN Invoice ON Customer.CustomerId = Invoice.CustomerId 
   Join InvoiceLine ON Invoice.InvoiceId = InvoiceLine.InvoiceId
   GROUP BY Customer.CustomerId, CustomerName 
)
SELECT 
   CustomerId,
   CustomerName,
   ROUND(Recency_Days) AS Recency_Days,
   Frequency,
   ROUND(Monetary, 2) AS Monetary,
   NTILE(4) OVER (ORDER BY Recency_Days ASC) AS Recency_Score,
   NTILE(4) OVER (ORDER BY Frequency DESC) AS Frequency_Score,
   NTILE(4) OVER (ORDER BY Monetary DESC) AS Monetary_Score
FROM customer_rfm 
ORDER BY Monetary DESC;


--Unsold Catalog Tracks
SELECT 
    Track.TrackId,
    Track.Name,
    Track.GenreId
FROM Track
LEFT JOIN InvoiceLine ON Track.TrackId = InvoiceLine.TrackId
WHERE InvoiceLine.TrackId IS NULL;


--Sales Rep Performance
SELECT 
    Employee.EmployeeId,
    Employee.FirstName || ' ' || Employee.LastName AS RepName,
    COUNT(DISTINCT Invoice.InvoiceId) AS Total_Orders,
    ROUND(SUM(InvoiceLine.UnitPrice * InvoiceLine.Quantity), 2) AS Total_Revenue,
    RANK() OVER (ORDER BY SUM(InvoiceLine.UnitPrice * InvoiceLine.Quantity) DESC) AS Rep_Rank
FROM Employee
JOIN Customer ON Employee.EmployeeId = Customer.SupportRepId
JOIN Invoice ON Customer.CustomerId = Invoice.CustomerId
JOIN InvoiceLine ON Invoice.InvoiceId = InvoiceLine.InvoiceId
GROUP BY Employee.EmployeeId, RepName
ORDER BY Rep_Rank;
