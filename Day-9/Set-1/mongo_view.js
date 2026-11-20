// Select the database
use("RetailOrderDB");

// Create sample orders collection
db.orders.insertMany([
    {
        orderId: 101,
        customerName: "Arun Kumar",
        status: "Pending",
        totalAmount: 46600
    },
    {
        orderId: 102,
        customerName: "Priya Sharma",
        status: "Completed",
        totalAmount: 400
    },
    {
        orderId: 103,
        customerName: "Arun Kumar",
        status: "Pending",
        totalAmount: 800
    },
    {
        orderId: 104,
        customerName: "Priya Sharma",
        status: "Cancelled",
        totalAmount: 1200
    }
]);

// Remove the old view if it exists
db.order_status_summary.drop();

// Create MongoDB view showing order status counts
db.createView(
    "order_status_summary",
    "orders",
    [
        {
            $group: {
                _id: "$status",
                totalOrders: { $sum: 1 }
            }
        },
        {
            $project: {
                _id: 0,
                orderStatus: "$_id",
                totalOrders: 1
            }
        },
        {
            $sort: {
                orderStatus: 1
            }
        }
    ]
);

// Display the view
db.order_status_summary.find();