
IF OBJECT_ID('Transactions', 'U') IS NOT NULL
    DROP TABLE Transactions;

CREATE TABLE Transactions (
    TransactionID INT PRIMARY KEY,
    AccountID INT,
    TransactionDate DATE,
    TransactionType VARCHAR(20),
    Amount DECIMAL(12,2),
    BalanceAfter DECIMAL(12,2)
);

INSERT INTO Transactions VALUES
(1, 101, '2026-01-01', 'CREDIT', 10000, 10000),
(2, 101, '2026-01-05', 'DEBIT', 2000, 8000),
(3, 101, '2026-01-10', 'CREDIT', 5000, 13000),
(4, 101, '2026-01-15', 'DEBIT', 3000, 10000),
(5, 102, '2026-01-02', 'CREDIT', 15000, 15000),
(6, 102, '2026-01-08', 'DEBIT', 4000, 11000);

WITH MonthlyStatement AS (
    SELECT
        AccountID,
        TransactionID,
        TransactionDate,
        TransactionType,
        Amount,
        BalanceAfter,
        ROW_NUMBER() OVER (
            PARTITION BY AccountID
            ORDER BY TransactionDate, TransactionID
        ) AS TransactionNumber,
        LAG(BalanceAfter) OVER (
            PARTITION BY AccountID
            ORDER BY TransactionDate, TransactionID
        ) AS PreviousBalance
    FROM Transactions
    WHERE TransactionDate >= '2026-01-01'
      AND TransactionDate < '2026-02-01'
)
SELECT
    AccountID,
    TransactionNumber,
    TransactionID,
    TransactionDate,
    TransactionType,
    Amount,
    PreviousBalance,
    BalanceAfter
FROM MonthlyStatement
ORDER BY AccountID, TransactionNumber;
