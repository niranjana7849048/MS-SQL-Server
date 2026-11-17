// Select the database
use("RetailInventory");

// Create reviews collection with JSON Schema validation
db.createCollection("reviews", {
    validator: {
        $jsonSchema: {
            bsonType: "object",
            required: [
                "reviewId",
                "sku",
                "customerName",
                "rating",
                "reviewText",
                "reviewDate",
                "verifiedPurchase"
            ],
            properties: {
                reviewId: {
                    bsonType: "string"
                },
                sku: {
                    bsonType: "string"
                },
                customerName: {
                    bsonType: "string"
                },
                rating: {
                    bsonType: "int",
                    minimum: 1,
                    maximum: 5
                },
                reviewText: {
                    bsonType: "string"
                },
                reviewDate: {
                    bsonType: "date"
                },
                verifiedPurchase: {
                    bsonType: "bool"
                }
            }
        }
    }
});

// Insert 10 product reviews
db.reviews.insertMany([
    {
        reviewId: "R101",
        sku: "P101",
        customerName: "Customer 1",
        rating: 5,
        reviewText: "Excellent laptop with good performance.",
        reviewDate: ISODate("2026-11-01"),
        verifiedPurchase: true
    },
    {
        reviewId: "R102",
        sku: "P102",
        customerName: "Customer 2",
        rating: 4,
        reviewText: "Comfortable office chair.",
        reviewDate: ISODate("2026-11-02"),
        verifiedPurchase: true
    },
    {
        reviewId: "R103",
        sku: "P103",
        customerName: "Customer 3",
        rating: 3,
        reviewText: "Good quality but slightly expensive.",
        reviewDate: ISODate("2026-11-03"),
        verifiedPurchase: false
    },
    {
        reviewId: "R104",
        sku: "P104",
        customerName: "Customer 4",
        rating: 5,
        reviewText: "Very useful book for learning SQL.",
        reviewDate: ISODate("2026-11-04"),
        verifiedPurchase: true
    },
    {
        reviewId: "R105",
        sku: "P105",
        customerName: "Customer 5",
        rating: 4,
        reviewText: "Works well and saves energy.",
        reviewDate: ISODate("2026-11-05"),
        verifiedPurchase: true
    },
    {
        reviewId: "R106",
        sku: "P106",
        customerName: "Customer 6",
        rating: 5,
        reviewText: "Good quality football.",
        reviewDate: ISODate("2026-11-06"),
        verifiedPurchase: true
    },
    {
        reviewId: "R107",
        sku: "P107",
        customerName: "Customer 7",
        rating: 3,
        reviewText: "Average notebook quality.",
        reviewDate: ISODate("2026-11-07"),
        verifiedPurchase: false
    },
    {
        reviewId: "R108",
        sku: "P108",
        customerName: "Customer 8",
        rating: 4,
        reviewText: "Useful smartwatch with good features.",
        reviewDate: ISODate("2026-11-08"),
        verifiedPurchase: true
    },
    {
        reviewId: "R109",
        sku: "P109",
        customerName: "Customer 9",
        rating: 5,
        reviewText: "My child enjoys playing with this toy.",
        reviewDate: ISODate("2026-11-09"),
        verifiedPurchase: true
    },
    {
        reviewId: "R110",
        sku: "P110",
        customerName: "Customer 10",
        rating: 2,
        reviewText: "Product quality needs improvement.",
        reviewDate: ISODate("2026-11-10"),
        verifiedPurchase: false
    }
]);

// Find all reviews
db.reviews.find();

// Find reviews for a specific product
db.reviews.find({ sku: "P101" });

// Update a review
db.reviews.updateOne(
    { reviewId: "R101" },
    {
        $set: {
            rating: 4,
            reviewText: "Good laptop with reliable performance."
        }
    }
);

// Verify updated review
db.reviews.findOne({ reviewId: "R101" });

db.reviews.deleteOne({ reviewId: "R110" });

db.reviews.findOne({ reviewId: "R110" });