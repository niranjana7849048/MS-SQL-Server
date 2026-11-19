
const { MongoClient } = require("mongodb");

const uri = "mongodb://127.0.0.1:27017";
const client = new MongoClient(uri);

async function transferFunds() {
    await client.connect();

    const database = client.db("BankDB");
    const accounts = database.collection("accounts");

    const session = client.startSession();

    try {
        await session.withTransaction(async () => {
            const fromAccount = 101;
            const toAccount = 102;
            const amount = 5000;

            const debit = await accounts.updateOne(
                {
                    accountId: fromAccount,
                    status: "ACTIVE",
                    balance: { $gte: amount }
                },
                {
                    $inc: { balance: -amount }
                },
                { session }
            );

            if (debit.modifiedCount !== 1) {
                throw new Error("Source account inactive or insufficient balance");
            }

            const credit = await accounts.updateOne(
                {
                    accountId: toAccount,
                    status: "ACTIVE"
                },
                {
                    $inc: { balance: amount }
                },
                { session }
            );

            if (credit.modifiedCount !== 1) {
                throw new Error("Destination account inactive or not found");
            }

            console.log("Transfer completed inside transaction.");
        });

        console.log("Transaction committed successfully.");
    } catch (error) {
        console.error("Transaction failed:", error.message);
    } finally {
        await session.endSession();
        await client.close();
    }
}

transferFunds();
