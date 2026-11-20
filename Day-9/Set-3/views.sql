USE TelecomDB;
GO

-- TASK 1: Prepaid subscribers only

CREATE OR ALTER VIEW vw_prepaid_subscribers
AS
SELECT
    SubscriberID,
    SubscriberName,
    PhoneNumber,
    Balance,
    ValidityEndDate
FROM Subscribers
WHERE SubscriberType = 'Prepaid'
WITH CHECK OPTION;
GO

-- Display prepaid subscribers

SELECT * FROM vw_prepaid_subscribers;
GO


-- Recharge summary view

CREATE OR ALTER VIEW vw_recharge_summary
AS
SELECT
    s.SubscriberID,
    s.SubscriberName,
    COUNT(r.RechargeID) AS TotalRecharges,
    ISNULL(SUM(r.RechargeAmount), 0) AS TotalRechargeAmount,
    MAX(r.RechargeDate) AS LastRechargeDate
FROM Subscribers s
LEFT JOIN RechargeHistory r
    ON s.SubscriberID = r.SubscriberID
GROUP BY
    s.SubscriberID,
    s.SubscriberName;
GO

-- Display recharge summary

SELECT * FROM vw_recharge_summary;
GO