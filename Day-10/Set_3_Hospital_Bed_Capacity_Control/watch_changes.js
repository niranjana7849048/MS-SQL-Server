// Day 10 - Set 3: Hospital Bed Capacity Control
// MongoDB Change Stream - Critical Ward Alerts

const { MongoClient } = require("mongodb");

const uri = "mongodb://localhost:27017";
const client = new MongoClient(uri);

async function watchWardAlerts() {
    try {
        await client.connect();

        const db = client.db("HospitalBedControlDB");
        const alerts = db.collection("ward_alerts");

        console.log("Watching for critical ward alerts...");

        const changeStream = alerts.watch([
            {
                $match: {
                    operationType: "insert",
                    "fullDocument.severity": "critical"
                }
            }
        ]);

        for await (const change of changeStream) {
            const alert = change.fullDocument;

            console.log("CRITICAL WARD ALERT");
            console.log("Ward:", alert.ward);
            console.log("Time:", alert.time || new Date());
            console.log("Message:", alert.message);
            console.log("----------------------------");
        }
    } catch (error) {
        console.error("Change Stream Error:", error);
    } finally {
        await client.close();
    }
}

watchWardAlerts();