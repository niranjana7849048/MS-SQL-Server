
IF OBJECT_ID('PassengerBookings', 'U') IS NOT NULL
    DROP TABLE PassengerBookings;

CREATE TABLE PassengerBookings (
    BookingID INT PRIMARY KEY,
    FlightID INT,
    PassengerName VARCHAR(100),
    Fare DECIMAL(10,2)
);

INSERT INTO PassengerBookings VALUES
(1, 101, 'Arun', 8000),
(2, 101, 'Priya', 10000),
(3, 101, 'Kumar', 10000),
(4, 101, 'Meena', 6000),
(5, 102, 'Ravi', 12000),
(6, 102, 'Divya', 9000),
(7, 102, 'John', 9000),
(8, 102, 'Anu', 7000);

PRINT 'RANK AND DENSE_RANK';

SELECT
    FlightID,
    PassengerName,
    Fare,
    RANK() OVER (
        PARTITION BY FlightID
        ORDER BY Fare DESC
    ) AS FareRank,
    DENSE_RANK() OVER (
        PARTITION BY FlightID
        ORDER BY Fare DESC
    ) AS DenseFareRank
FROM PassengerBookings
ORDER BY FlightID, Fare DESC;

PRINT 'CTE WITH RUNNING REVENUE';

WITH FlightRevenue AS (
    SELECT
        BookingID,
        FlightID,
        PassengerName,
        Fare,
        RANK() OVER (
            PARTITION BY FlightID
            ORDER BY Fare DESC
        ) AS FareRank,
        DENSE_RANK() OVER (
            PARTITION BY FlightID
            ORDER BY Fare DESC
        ) AS DenseFareRank,
        SUM(Fare) OVER (
            PARTITION BY FlightID
            ORDER BY BookingID
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS RunningRevenue
    FROM PassengerBookings
)
SELECT
    FlightID,
    PassengerName,
    Fare,
    FareRank,
    DenseFareRank,
    RunningRevenue
FROM FlightRevenue
ORDER BY FlightID, BookingID;
