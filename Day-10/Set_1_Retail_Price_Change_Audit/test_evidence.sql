-- Day 10 - Set 1: Retail Price Change Audit
-- Test Evidence

USE RetailPriceAuditDB;
GO

-- TEST 1: View initial product prices
SELECT * FROM dbo.product_price;
GO

-- TEST 2: Single-row valid price update
UPDATE dbo.product_price
SET selling_price = 47000
WHERE product_id = 1;
GO

-- Verify successful update and audit entry
SELECT * FROM dbo.product_price WHERE product_id = 1;
SELECT * FROM dbo.price_audit;
GO

-- TEST 3: Single-row rejected price update
-- Laptop cost is 40000; attempted price is 35000.
UPDATE dbo.product_price
SET selling_price = 35000
WHERE product_id = 1;
GO

-- Verify price remains unchanged and rejection is logged
SELECT * FROM dbo.product_price WHERE product_id = 1;
SELECT * FROM dbo.rejected_price_attempt;
GO

-- TEST 4: Multi-row update
-- Products 2 and 3 receive valid prices.
UPDATE dbo.product_price
SET selling_price =
    CASE
        WHEN product_id = 2 THEN 800
        WHEN product_id = 3 THEN 400
    END
WHERE product_id IN (2, 3);
GO

-- Verify both successful updates and audit entries
SELECT * FROM dbo.product_price
WHERE product_id IN (2, 3);

SELECT * FROM dbo.price_audit;
GO

-- TEST 5: Multi-row update with one rejected row
-- Product 4: 10000 is valid (cost 8000).
-- Product 5: 900 is invalid (cost 1000).
UPDATE dbo.product_price
SET selling_price =
    CASE
        WHEN product_id = 4 THEN 10000
        WHEN product_id = 5 THEN 900
    END
WHERE product_id IN (4, 5);
GO

-- Verify product 4 updated and product 5 unchanged
SELECT * FROM dbo.product_price
WHERE product_id IN (4, 5);

-- Verify successful price change was audited
SELECT * FROM dbo.price_audit
ORDER BY audit_id;

-- Verify rejected attempt was logged
SELECT * FROM dbo.rejected_price_attempt
ORDER BY attempt_id;
GO
