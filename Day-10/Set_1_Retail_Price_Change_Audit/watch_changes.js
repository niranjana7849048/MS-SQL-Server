// Day 10 - Set 1: Retail Price Change Audit
// MongoDB Change Stream

const { MongoClient } = require("mongodb");

const uri = "mongodb://localhost:27017";
const client = new MongoClient(uri);

async function watchPriceChanges() {
    try {
        await client.connect();

        const db = client.db("RetailPriceAuditDB");
        const products = db.collection("products");

        console.log("Watching for product price changes...");

        const changeStream = products.watch([
            {
                $match: {
                    operationType: "update"
                }
            }
        ]);

        for await (const change of changeStream) {
            const updatedFields = change.updateDescription.updatedFields;

            if (updatedFields.price !== undefined) {
                console.log("Product price changed:");
                console.log("Document ID:", change.documentKey._id);
                console.log("New Price:", updatedFields.price);
                console.log("Time:", new Date());
                console.log("----------------------------");
            }
        }
    } catch (error) {
        console.error("Change Stream Error:", error);
    } finally {
        await client.close();
    }
}

watchPriceChanges();