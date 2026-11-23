// Day 10 - Set 2: Bank Account Balance Guard
// MongoDB Change Stream - Fraud Alerts

const { MongoClient } = require("mongodb");

const uri = "mongodb://localhost:27017";
const client = new MongoClient(uri);

async function watchFraudAlerts() {
    try {
        await client.connect();

        const db = client.db("BankBalanceGuardDB");
        const alerts = db.collection("fraud_alerts");

        console.log("Watching for new fraud alerts...");

        const changeStream = alerts.watch([
            {
                $match: {
                    operationType: "insert"
                }
            }
        ]);

        for await (const change of changeStream) {
            const alert = change.fullDocument;

            console.log("NEW FRAUD ALERT");
            console.log("Alert ID:", alert._id);
            console.log("Account:", alert.account_id);
            console.log("Message:", alert.message);
            console.log("Severity:", alert.severity);
            console.log("Time:", alert.created_at || new Date());
            console.log("----------------------------");
        }
    } catch (error) {
        console.error("Change Stream Error:", error);
    } finally {
        await client.close();
    }
}

watchFraudAlerts();