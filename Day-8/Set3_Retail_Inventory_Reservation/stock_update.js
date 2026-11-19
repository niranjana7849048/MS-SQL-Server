
const { MongoClient } = require("mongodb");

const uri = "mongodb://127.0.0.1:27017";
const client = new MongoClient(uri);

async function reserveStock() {
    try {
        await client.connect();

        const db = client.db("RetailDB");
        const products = db.collection("products");

        // Insert sample product if it does not exist
        await products.updateOne(
            { productId: 101 },
            {
                $setOnInsert: {
                    productId: 101,
                    productName: "Laptop",
                    stock: 20
                }
            },
            { upsert: true }
        );

        const quantity = 5;

        // Atomically decrease stock only if sufficient stock exists
        const result = await products.updateOne(
            {
                productId: 101,
                stock: { $gte: quantity }
            },
            {
                $inc: { stock: -quantity }
            }
        );

        if (result.modifiedCount === 1) {
            console.log("Stock reserved successfully.");
        } else {
            console.log("Insufficient stock.");
        }

        const product = await products.findOne({ productId: 101 });
        console.log("Remaining stock:", product.stock);

    } catch (error) {
        console.error("Error:", error.message);
    } finally {
        await client.close();
    }
}

reserveStock();
