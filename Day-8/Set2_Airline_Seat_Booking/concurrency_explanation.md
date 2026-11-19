
# Day 8 – Set 2: Airline Seat Booking

## 1. Transaction Overview

A seat booking involves two operations:
- Update the seat status to BOOKED.
- Insert the passenger booking record.

Both operations must succeed together. If either fails, the transaction is rolled back.

## 2. READ COMMITTED Behaviour

- Multiple sessions can initially read the same available seat.
- The conditional UPDATE checks whether the seat is still AVAILABLE.
- Only one session can successfully update the seat.
- The other session waits and then finds no matching available seat.
- The second booking is rejected.

## 3. SERIALIZABLE Behaviour

- SERIALIZABLE provides stronger isolation.
- The seat lookup uses UPDLOCK and HOLDLOCK.
- The first session obtains an update lock.
- The second session waits until the first transaction completes.
- After the first booking commits, the second session sees BOOKED and rejects the request.

## 4. RANK vs DENSE_RANK

| Function | Behaviour |
|---|---|
| RANK() | Skips ranks after tied values |
| DENSE_RANK() | Does not skip ranks after tied values |

Both functions rank passengers separately for each flight using PARTITION BY.

## 5. Running Revenue

SUM(Fare) OVER calculates cumulative revenue for each flight.

The running total increases as each booking is processed.

## 6. MongoDB Transaction

MongoDB uses a session and transaction to:
1. Start a session.
2. Begin a transaction.
3. Update the seat document.
4. Insert the booking document.
5. Commit both operations together.
6. Abort both operations if an error occurs.

## 7. Key Concepts

- BEGIN TRANSACTION
- COMMIT and ROLLBACK
- TRY...CATCH
- READ COMMITTED
- SERIALIZABLE
- RANK and DENSE_RANK
- Common Table Expressions
- SUM() OVER
- MongoDB Sessions and Transactions
