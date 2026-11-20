USE InsuranceDB;
GO

-- TASK 1: Policies due for renewal within 30 days

CREATE OR ALTER VIEW vw_policy_due
AS
SELECT
    p.PolicyID,
    c.CustomerID,
    c.CustomerName,
    c.Email,
    c.Phone,
    p.PolicyType,
    p.PremiumAmount,
    p.RenewalDate,
    p.PolicyStatus,
    a.AgentName
FROM Policies p
INNER JOIN Customers c
    ON p.CustomerID = c.CustomerID
INNER JOIN Agents a
    ON p.AgentID = a.AgentID
WHERE p.RenewalDate BETWEEN
      CAST(GETDATE() AS DATE)
      AND DATEADD(DAY, 30, CAST(GETDATE() AS DATE))
  AND p.PolicyStatus = 'Active';
GO

-- Display policies due for renewal

SELECT * FROM vw_policy_due;
GO