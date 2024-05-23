USE AdventureWorks2022;
GO

-- CTE for get sales by year, month and sales person
WITH cte_Sales AS (
    SELECT 
        YEAR(soh.OrderDate) AS [Year]
        , MONTH(soh.OrderDate) AS [Month]
        , CONCAT(prs.FirstName, ' ', prs.LastName) AS [Sales Person]
        , SUM(TotalDue) AS [Total]
    FROM Sales.SalesOrderHeader AS soh
    INNER JOIN Sales.SalesPerson AS slp
        INNER JOIN Person.Person AS prs ON slp.BusinessEntityID = prs.BusinessEntityID
    ON soh.SalesPersonID = slp.BusinessEntityID
    GROUP BY YEAR(soh.OrderDate), MONTH(soh.OrderDate), CONCAT(prs.FirstName, ' ', prs.LastName)
)
-- CTE for get only max sales by year and month from previous cte
, cte_Sales_Max AS (
    SELECT
        sal.[Year]
        , sal.[Month]
        , MAX(sal.[Total]) AS [MaxTotal]
    FROM cte_Sales AS sal
    GROUP BY sal.[Year], sal.[Month]
)

SELECT
    sal.[Year]
    , sal.[Month]
    , sal.[Sales Person]
    , sal.[Total]
FROM cte_Sales AS sal
INNER JOIN cte_Sales_Max AS smx ON smx.[Year] = sal.[Year] AND smx.[Month]= sal.[Month] AND smx.[MaxTotal] = sal.[Total]
ORDER BY sal.[Year] ASC, sal.[Month] ASC
