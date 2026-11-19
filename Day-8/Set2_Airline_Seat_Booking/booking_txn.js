
const { MongoClient } = require("mongodb");

const uri = "mongodb://127.0.0.1:27017/?replicaSet=rs0";
const client = new MongoClient(uri);

async function bookSeat() {
    await client.connect();

    const db = client.db("AirlineDB");
    const seats = db.collection("seats");
    const bookings = db.collection("bookings");

    const session = client.startSession();

    try {
        await session.withTransaction(async () => {
            const flightId = 101;
            const seatNumber = "A1";
            const passengerName = "Arun";
            const fare = 4500;

            const seatUpdate = await seats.updateOne(
                {
                    flightId: flightId,
                    seatNumber: seatNumber,
                    status: "AVAILABLE"
                },
                {
                    $set: {
                        status: "BOOKED",
                        passengerName: passengerName
                    }
                },
                { session }
            );

            if (seatUpdate.modifiedCount !== 1) {
                throw new Error("Seat is unavailable or does not exist.");
            }

            await bookings.insertOne(
                {
                    flightId: flightId,
                    seatNumber: seatNumber,
                    passengerName: passengerName,
                    fare: fare,
                    bookingStatus: "CONFIRMED",
                    bookingDate: new Date()
                },
                { session }
            );
        });

        console.log("Seat booked successfully.");
        console.log("Booking transaction committed.");
    } catch (error) {
        console.error("Booking failed:", error.message);
        console.log("Transaction rolled back.");
    } finally {
        await session.endSession();
        await client.close();
    }
}

bookSeat();
