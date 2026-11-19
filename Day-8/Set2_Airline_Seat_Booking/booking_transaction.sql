
IF OBJECT_ID('Bookings', 'U') IS NOT NULL
    DROP TABLE Bookings;

IF OBJECT_ID('FlightSeats', 'U') IS NOT NULL
    DROP TABLE FlightSeats;

CREATE TABLE FlightSeats (
    FlightID INT,
    SeatNumber VARCHAR(10),
    SeatStatus VARCHAR(20),
    PRIMARY KEY (FlightID, SeatNumber)
);

CREATE TABLE Bookings (
    BookingID INT IDENTITY(1,1) PRIMARY KEY,
    FlightID INT,
    SeatNumber VARCHAR(10),
    PassengerName VARCHAR(100),
    Fare DECIMAL(10,2),
    BookingDate DATETIME DEFAULT GETDATE(),
    CONSTRAINT UQ_FlightSeat UNIQUE (FlightID, SeatNumber)
);

INSERT INTO FlightSeats VALUES
(101, 'A1', 'AVAILABLE'),
(101, 'A2', 'AVAILABLE'),
(101, 'A3', 'AVAILABLE'),
(102, 'B1', 'AVAILABLE');

DECLARE @FlightID INT = 101;
DECLARE @SeatNumber VARCHAR(10) = 'A1';
DECLARE @PassengerName VARCHAR(100) = 'Arun';
DECLARE @Fare DECIMAL(10,2) = 4500;

BEGIN TRY
    BEGIN TRANSACTION;

    DECLARE @CurrentStatus VARCHAR(20);

    SELECT @CurrentStatus = SeatStatus
    FROM FlightSeats WITH (UPDLOCK, HOLDLOCK)
    WHERE FlightID = @FlightID
      AND SeatNumber = @SeatNumber;

    IF @CurrentStatus IS NULL
        THROW 50001, 'Seat does not exist.', 1;

    IF @CurrentStatus <> 'AVAILABLE'
        THROW 50002, 'Seat is already booked.', 1;

    UPDATE FlightSeats
    SET SeatStatus = 'BOOKED'
    WHERE FlightID = @FlightID
      AND SeatNumber = @SeatNumber
      AND SeatStatus = 'AVAILABLE';

    IF @@ROWCOUNT <> 1
        THROW 50003, 'Seat reservation failed.', 1;

    INSERT INTO Bookings (
        FlightID,
        SeatNumber,
        PassengerName,
        Fare
    )
    VALUES (
        @FlightID,
        @SeatNumber,
        @PassengerName,
        @Fare
    );

    COMMIT TRANSACTION;

    PRINT 'Booking completed successfully.';
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0
        ROLLBACK TRANSACTION;

    PRINT 'Booking failed: ' + ERROR_MESSAGE();
END CATCH;

SELECT * FROM FlightSeats;
SELECT * FROM Bookings;
