USE AdventureWorks2022;
GO

-- CTE to filter only current employees by TODAY
WITH cte_CurrentEmployees AS (
    SELECT BusinessEntityID
      , DepartmentID
    FROM HumanResources.EmployeeDepartmentHistory AS edp 
    WHERE edp.StartDate <= GETDATE()
    AND (edp.EndDate IS NULL OR edp.EndDate >= GETDATE())
)
-- CTE to count number of current employees by department
, cte_NumberOfEmployeesByDepartment AS (
    SELECT cem.DepartmentID
        , COUNT(cem.BusinessEntityID) AS NumberEmployees
    FROM cte_CurrentEmployees AS cem
    GROUP BY cem.DepartmentID
)

SELECT 
    dep.DepartmentID
    , dep.Name AS [Department Name]
    , emp.BusinessEntityID
    , emp.NationalIDNumber
    , emp.LoginID
    , emp.JobTitle
    , emp.BirthDate
    , emp.Gender
FROM HumanResources.Employee AS emp
INNER JOIN cte_CurrentEmployees AS cem 
    INNER JOIN cte_NumberOfEmployeesByDepartment AS ned 
        INNER JOIN HumanResources.Department AS dep ON ned.DepartmentID = dep.DepartmentID
    ON cem.DepartmentID = ned.DepartmentID
ON emp.BusinessEntityID = cem.BusinessEntityID
WHERE ned.NumberEmployees >= 5
ORDER BY dep.DepartmentID, emp.BusinessEntityID