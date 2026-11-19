
# Retail Inventory Reservation

## 1. Transaction Overview
A transaction ensures that inventory updates and order creation happen together.

If the order succeeds, the transaction commits.
If stock is insufficient, the transaction rolls back.

## 2. Stock Validation
The UPDATE statement checks whether sufficient stock exists before reducing inventory.

If no product row is updated, the transaction throws an error and rolls back.

## 3. Correlated Subquery
The correlated subquery compares each product's stock with the average stock of products in the same category.

It identifies products with below-average inventory.

## 4. CTE and ROW_NUMBER
A CTE calculates total sales for each product.

ROW_NUMBER ranks products separately within each category.
The report displays the top three products in each category.

## 5. LAG and LEAD
LAG retrieves the previous month's sales.
LEAD retrieves the next month's sales.

SalesChange shows the difference between current and previous month sales.

## 6. MongoDB Atomic Update
MongoDB uses $inc to decrease stock atomically within one product document.

The stock condition ensures that inventory cannot become negative.

## 7. When Are MongoDB Transactions Required?
A single-document update is atomic, so a transaction is not required for this stock update.

Multi-document transactions are useful when multiple product documents, order documents, and order-item documents must be updated together.

## 8. Key Concepts
- BEGIN TRANSACTION
- COMMIT and ROLLBACK
- TRY and CATCH
- Correlated Subqueries
- Common Table Expressions
- ROW_NUMBER
- PARTITION BY
- LAG and LEAD
- MongoDB $inc
- Atomic Updates
