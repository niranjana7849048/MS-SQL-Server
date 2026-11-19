
-- Create Sales table

CREATE TABLE Sales (
    SaleID INT PRIMARY KEY,
    ProductID INT,
    ProductName VARCHAR(100),
    CategoryID INT,
    SalesMonth DATE,
    SalesAmount DECIMAL(10,2)
);

-- Insert sample sales

INSERT INTO Sales VALUES
(1, 1, 'Laptop', 1, '2026-01-01', 100000),
(2, 1, 'Laptop', 1, '2026-02-01', 120000),
(3, 1, 'Laptop', 1, '2026-03-01', 110000),
(4, 2, 'Keyboard', 1, '2026-01-01', 30000),
(5, 2, 'Keyboard', 1, '2026-02-01', 35000),
(6, 2, 'Keyboard', 1, '2026-03-01', 40000),
(7, 3, 'Mouse', 1, '2026-01-01', 20000),
(8, 3, 'Mouse', 1, '2026-02-01', 25000),
(9, 4, 'Chair', 2, '2026-01-01', 50000),
(10, 4, 'Chair', 2, '2026-02-01', 60000),
(11, 5, 'Table', 2, '2026-01-01', 70000),
(12, 5, 'Table', 2, '2026-02-01', 75000);

-- CTE: Calculate total sales and rank products

WITH ProductSales AS (
    SELECT
        ProductID,
        ProductName,
        CategoryID,
        SUM(SalesAmount) AS TotalSales
    FROM Sales
    GROUP BY ProductID, ProductName, CategoryID
),
RankedProducts AS (
    SELECT
        ProductID,
        ProductName,
        CategoryID,
        TotalSales,
        ROW_NUMBER() OVER (
            PARTITION BY CategoryID
            ORDER BY TotalSales DESC
        ) AS SalesRank
    FROM ProductSales
)
SELECT *
FROM RankedProducts
WHERE SalesRank <= 3
ORDER BY CategoryID, SalesRank;

-- Monthly sales comparison using LAG and LEAD

WITH MonthlySales AS (
    SELECT
        ProductID,
        ProductName,
        SalesMonth,
        SUM(SalesAmount) AS MonthlySales
    FROM Sales
    GROUP BY ProductID, ProductName, SalesMonth
)
SELECT
    ProductID,
    ProductName,
    SalesMonth,
    MonthlySales,
    LAG(MonthlySales) OVER (
        PARTITION BY ProductID
        ORDER BY SalesMonth
    ) AS PreviousMonthSales,
    LEAD(MonthlySales) OVER (
        PARTITION BY ProductID
        ORDER BY SalesMonth
    ) AS NextMonthSales,
    MonthlySales - LAG(MonthlySales) OVER (
        PARTITION BY ProductID
        ORDER BY SalesMonth
    ) AS SalesChange
FROM MonthlySales
ORDER BY ProductID, SalesMonth;
