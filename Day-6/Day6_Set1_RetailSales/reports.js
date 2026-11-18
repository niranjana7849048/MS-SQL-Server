
use("RetailSalesReporting");

// =========================================
// 1. CREATE COLLECTIONS
// =========================================

db.createCollection("customers");
db.createCollection("products");
db.createCollection("orders");
db.createCollection("order_items");

// =========================================
// 2. INSERT SAMPLE DATA
// =========================================

db.customers.insertMany([
    { customerId: 1, customerName: "Arun Kumar", city: "Chennai" },
    { customerId: 2, customerName: "Priya Sharma", city: "Bangalore" },
    { customerId: 3, customerName: "Rahul Verma", city: "Chennai" },
    { customerId: 4, customerName: "Sneha Raj", city: "Mumbai" },
    { customerId: 5, customerName: "Karthik S", city: "Bangalore" },
    { customerId: 6, customerName: "Divya Nair", city: "Hyderabad" },
    { customerId: 7, customerName: "Vikram Rao", city: "Mumbai" }
]);

db.products.insertMany([
    { productId: 101, productName: "Laptop", category: "Electronics" },
    { productId: 102, productName: "Smartphone", category: "Electronics" },
    { productId: 103, productName: "Headphones", category: "Accessories" },
    { productId: 104, productName: "Keyboard", category: "Accessories" },
    { productId: 105, productName: "Office Chair", category: "Furniture" },
    { productId: 106, productName: "Desk", category: "Furniture" }
]);

db.orders.insertMany([
    { orderId: 1001, customerId: 1, orderDate: ISODate("2026-01-05") },
    { orderId: 1002, customerId: 1, orderDate: ISODate("2026-01-15") },
    { orderId: 1003, customerId: 1, orderDate: ISODate("2026-02-10") },
    { orderId: 1004, customerId: 1, orderDate: ISODate("2026-03-12") },
    { orderId: 1005, customerId: 2, orderDate: ISODate("2026-01-20") },
    { orderId: 1006, customerId: 2, orderDate: ISODate("2026-02-18") },
    { orderId: 1007, customerId: 2, orderDate: ISODate("2026-03-22") },
    { orderId: 1008, customerId: 3, orderDate: ISODate("2026-02-05") },
    { orderId: 1009, customerId: 3, orderDate: ISODate("2026-03-08") },
    { orderId: 1010, customerId: 4, orderDate: ISODate("2026-01-25") },
    { orderId: 1011, customerId: 4, orderDate: ISODate("2026-03-15") },
    { orderId: 1012, customerId: 5, orderDate: ISODate("2026-02-28") },
    { orderId: 1013, customerId: 6, orderDate: ISODate("2026-03-25") }
]);

db.order_items.insertMany([
    { orderId: 1001, productId: 101, quantity: 1, unitPrice: 55000 },
    { orderId: 1001, productId: 103, quantity: 2, unitPrice: 2000 },
    { orderId: 1002, productId: 102, quantity: 1, unitPrice: 25000 },
    { orderId: 1003, productId: 104, quantity: 2, unitPrice: 1500 },
    { orderId: 1004, productId: 101, quantity: 1, unitPrice: 55000 },
    { orderId: 1004, productId: 105, quantity: 1, unitPrice: 8000 },
    { orderId: 1005, productId: 102, quantity: 2, unitPrice: 25000 },
    { orderId: 1006, productId: 103, quantity: 3, unitPrice: 2000 },
    { orderId: 1007, productId: 106, quantity: 1, unitPrice: 12000 },
    { orderId: 1008, productId: 101, quantity: 1, unitPrice: 55000 },
    { orderId: 1008, productId: 104, quantity: 1, unitPrice: 1500 },
    { orderId: 1009, productId: 102, quantity: 1, unitPrice: 25000 },
    { orderId: 1010, productId: 105, quantity: 2, unitPrice: 8000 },
    { orderId: 1011, productId: 106, quantity: 1, unitPrice: 12000 },
    { orderId: 1012, productId: 103, quantity: 2, unitPrice: 2000 },
    { orderId: 1013, productId: 104, quantity: 3, unitPrice: 1500 }
]);

// =========================================
// 3. PIPELINE 1: MONTH-WISE SALES
// =========================================

print("MONTH-WISE SALES");

db.orders.aggregate([
    {
        $lookup: {
            from: "order_items",
            localField: "orderId",
            foreignField: "orderId",
            as: "items"
        }
    },
    { $unwind: "$items" },
    {
        $group: {
            _id: {
                year: { $year: "$orderDate" },
                month: { $month: "$orderDate" }
            },
            monthlyRevenue: {
                $sum: {
                    $multiply: ["$items.quantity", "$items.unitPrice"]
                }
            }
        }
    },
    { $sort: { "_id.year": 1, "_id.month": 1 } }
]).forEach(printjson);

// =========================================
// 4. PIPELINE 2: TOP 5 PRODUCTS BY REVENUE
// =========================================

print("TOP 5 PRODUCTS BY REVENUE");

db.order_items.aggregate([
    {
        $group: {
            _id: "$productId",
            totalRevenue: {
                $sum: {
                    $multiply: ["$quantity", "$unitPrice"]
                }
            }
        }
    },
    {
        $lookup: {
            from: "products",
            localField: "_id",
            foreignField: "productId",
            as: "product"
        }
    },
    { $unwind: "$product" },
    {
        $project: {
            _id: 0,
            productName: "$product.productName",
            totalRevenue: 1
        }
    },
    { $sort: { totalRevenue: -1 } },
    { $limit: 5 }
]).forEach(printjson);

// =========================================
// 5. PIPELINE 3: AVERAGE BASKET VALUE BY CITY
// =========================================

print("AVERAGE BASKET VALUE BY CITY");

db.orders.aggregate([
    {
        $lookup: {
            from: "order_items",
            localField: "orderId",
            foreignField: "orderId",
            as: "items"
        }
    },
    { $unwind: "$items" },
    {
        $group: {
            _id: {
                orderId: "$orderId",
                customerId: "$customerId"
            },
            orderValue: {
                $sum: {
                    $multiply: ["$items.quantity", "$items.unitPrice"]
                }
            }
        }
    },
    {
        $lookup: {
            from: "customers",
            localField: "_id.customerId",
            foreignField: "customerId",
            as: "customer"
        }
    },
    { $unwind: "$customer" },
    {
        $group: {
            _id: "$customer.city",
            averageBasketValue: { $avg: "$orderValue" }
        }
    },
    { $sort: { averageBasketValue: -1 } }
]).forEach(printjson);
