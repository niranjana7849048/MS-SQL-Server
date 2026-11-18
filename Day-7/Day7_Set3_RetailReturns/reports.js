
// =========================================
// DAY 7 - SET 3: RETAIL RETURNS AND REFUNDS
// MongoDB Reports using $lookup
// =========================================

// Select database
use("RetailReturnsReporting");

// Clear existing collections
db.customers.deleteMany({});
db.employees.deleteMany({});
db.products.deleteMany({});
db.orders.deleteMany({});
db.orderItems.deleteMany({});
db.returns.deleteMany({});
db.refunds.deleteMany({});

// =========================================
// 1. INSERT SAMPLE DATA
// =========================================

db.customers.insertMany([
    { customerId: 1, customerName: "Arun Kumar", city: "Chennai" },
    { customerId: 2, customerName: "Priya Sharma", city: "Bangalore" },
    { customerId: 3, customerName: "Rahul Das", city: "Mumbai" },
    { customerId: 4, customerName: "Divya Nair", city: "Hyderabad" },
    { customerId: 5, customerName: "Karthik Raj", city: "Chennai" },
    { customerId: 6, customerName: "Meena Iyer", city: "Coimbatore" }
]);

db.employees.insertMany([
    { employeeId: 101, employeeName: "Ramesh", managerId: null },
    { employeeId: 102, employeeName: "Suresh", managerId: 101 },
    { employeeId: 103, employeeName: "Anitha", managerId: 101 },
    { employeeId: 104, employeeName: "Kavitha", managerId: 102 },
    { employeeId: 105, employeeName: "Vijay", managerId: 102 }
]);

db.products.insertMany([
    { productId: 201, productName: "Laptop", category: "Electronics", price: 60000 },
    { productId: 202, productName: "Smartphone", category: "Electronics", price: 30000 },
    { productId: 203, productName: "Headphones", category: "Accessories", price: 2500 },
    { productId: 204, productName: "Office Chair", category: "Furniture", price: 8000 },
    { productId: 205, productName: "Keyboard", category: "Accessories", price: 1500 },
    { productId: 206, productName: "Monitor", category: "Electronics", price: 12000 },
    { productId: 207, productName: "Desk", category: "Furniture", price: 15000 }
]);

db.orders.insertMany([
    { orderId: 1001, customerId: 1, orderDate: ISODate("2026-01-05") },
    { orderId: 1002, customerId: 2, orderDate: ISODate("2026-01-08") },
    { orderId: 1003, customerId: 3, orderDate: ISODate("2026-01-12") },
    { orderId: 1004, customerId: 1, orderDate: ISODate("2026-02-02") },
    { orderId: 1005, customerId: 4, orderDate: ISODate("2026-02-10") },
    { orderId: 1006, customerId: 5, orderDate: ISODate("2026-02-15") },
    { orderId: 1007, customerId: 2, orderDate: ISODate("2026-03-01") },
    { orderId: 1008, customerId: 6, orderDate: ISODate("2026-03-05") },
    { orderId: 1009, customerId: 3, orderDate: ISODate("2026-03-12") },
    { orderId: 1010, customerId: 4, orderDate: ISODate("2026-03-18") }
]);

db.orderItems.insertMany([
    { orderItemId: 1, orderId: 1001, productId: 201, quantity: 1, unitPrice: 60000 },
    { orderItemId: 2, orderId: 1001, productId: 203, quantity: 2, unitPrice: 2500 },
    { orderItemId: 3, orderId: 1002, productId: 202, quantity: 1, unitPrice: 30000 },
    { orderItemId: 4, orderId: 1002, productId: 205, quantity: 1, unitPrice: 1500 },
    { orderItemId: 5, orderId: 1003, productId: 204, quantity: 1, unitPrice: 8000 },
    { orderItemId: 6, orderId: 1004, productId: 206, quantity: 1, unitPrice: 12000 },
    { orderItemId: 7, orderId: 1004, productId: 203, quantity: 1, unitPrice: 2500 },
    { orderItemId: 8, orderId: 1005, productId: 201, quantity: 1, unitPrice: 60000 },
    { orderItemId: 9, orderId: 1006, productId: 205, quantity: 2, unitPrice: 1500 },
    { orderItemId: 10, orderId: 1007, productId: 202, quantity: 1, unitPrice: 30000 },
    { orderItemId: 11, orderId: 1007, productId: 204, quantity: 1, unitPrice: 8000 },
    { orderItemId: 12, orderId: 1008, productId: 207, quantity: 1, unitPrice: 15000 },
    { orderItemId: 13, orderId: 1009, productId: 203, quantity: 2, unitPrice: 2500 },
    { orderItemId: 14, orderId: 1010, productId: 206, quantity: 1, unitPrice: 12000 },
    { orderItemId: 15, orderId: 1010, productId: 205, quantity: 1, unitPrice: 1500 }
]);

db.returns.insertMany([
    { returnId: 501, orderItemId: 1, returnDate: ISODate("2026-01-10"), returnQuantity: 1, returnReason: "Damaged product", processedBy: 102 },
    { returnId: 502, orderItemId: 2, returnDate: ISODate("2026-01-11"), returnQuantity: 1, returnReason: "Wrong item", processedBy: 103 },
    { returnId: 503, orderItemId: 3, returnDate: ISODate("2026-01-15"), returnQuantity: 1, returnReason: "Defective product", processedBy: 104 },
    { returnId: 504, orderItemId: 5, returnDate: ISODate("2026-01-20"), returnQuantity: 1, returnReason: "Changed mind", processedBy: 102 },
    { returnId: 505, orderItemId: 6, returnDate: ISODate("2026-02-08"), returnQuantity: 1, returnReason: "Damaged product", processedBy: 105 },
    { returnId: 506, orderItemId: 8, returnDate: ISODate("2026-02-18"), returnQuantity: 1, returnReason: "Defective product", processedBy: 103 },
    { returnId: 507, orderItemId: 10, returnDate: ISODate("2026-03-05"), returnQuantity: 1, returnReason: "Wrong item", processedBy: 104 },
    { returnId: 508, orderItemId: 13, returnDate: ISODate("2026-03-16"), returnQuantity: 1, returnReason: "Damaged product", processedBy: 105 },
    { returnId: 509, orderItemId: 15, returnDate: ISODate("2026-03-20"), returnQuantity: 1, returnReason: "Changed mind", processedBy: 102 }
]);

db.refunds.insertMany([
    { refundId: 701, returnId: 501, refundAmount: 60000, refundDate: ISODate("2026-01-12"), refundStatus: "Completed" },
    { refundId: 702, returnId: 502, refundAmount: 2500, refundDate: ISODate("2026-01-13"), refundStatus: "Completed" },
    { refundId: 703, returnId: 503, refundAmount: 30000, refundDate: ISODate("2026-01-18"), refundStatus: "Completed" },
    { refundId: 704, returnId: 504, refundAmount: 8000, refundDate: ISODate("2026-01-22"), refundStatus: "Pending" },
    { refundId: 705, returnId: 505, refundAmount: 12000, refundDate: ISODate("2026-02-10"), refundStatus: "Completed" },
    { refundId: 706, returnId: 506, refundAmount: 60000, refundDate: ISODate("2026-02-20"), refundStatus: "Completed" },
    { refundId: 707, returnId: 507, refundAmount: 30000, refundDate: ISODate("2026-03-08"), refundStatus: "Pending" },
    { refundId: 708, returnId: 508, refundAmount: 5000, refundDate: ISODate("2026-03-18"), refundStatus: "Completed" }
]);

// =========================================
// REPORT 1: Return details using $lookup
// =========================================

print("\nREPORT 1: Return Details");

db.returns.aggregate([
    {
        $lookup: {
            from: "orderItems",
            localField: "orderItemId",
            foreignField: "orderItemId",
            as: "item"
        }
    },
    { $unwind: "$item" },
    {
        $lookup: {
            from: "orders",
            localField: "item.orderId",
            foreignField: "orderId",
            as: "order"
        }
    },
    { $unwind: "$order" },
    {
        $lookup: {
            from: "customers",
            localField: "order.customerId",
            foreignField: "customerId",
            as: "customer"
        }
    },
    { $unwind: "$customer" },
    {
        $lookup: {
            from: "products",
            localField: "item.productId",
            foreignField: "productId",
            as: "product"
        }
    },
    { $unwind: "$product" },
    {
        $lookup: {
            from: "employees",
            localField: "processedBy",
            foreignField: "employeeId",
            as: "employee"
        }
    },
    { $unwind: "$employee" },
    {
        $project: {
            _id: 0,
            returnId: 1,
            customerName: "$customer.customerName",
            orderId: "$order.orderId",
            productName: "$product.productName",
            returnQuantity: 1,
            returnReason: 1,
            employeeName: "$employee.employeeName"
        }
    },
    { $sort: { returnId: 1 } }
]).forEach(printjson);

// =========================================
// REPORT 2: Employee and manager details
// Self-reference using $lookup
// =========================================

print("\nREPORT 2: Employee and Manager Details");

db.employees.aggregate([
    {
        $lookup: {
            from: "employees",
            localField: "managerId",
            foreignField: "employeeId",
            as: "manager"
        }
    },
    {
        $unwind: {
            path: "$manager",
            preserveNullAndEmptyArrays: true
        }
    },
    {
        $project: {
            _id: 0,
            employeeName: 1,
            managerName: {
                $ifNull: ["$manager.employeeName", "No Manager"]
            }
        }
    },
    { $sort: { employeeName: 1 } }
]).forEach(printjson);

// =========================================
// REPORT 3: Products that have never been returned
// =========================================

print("\nREPORT 3: Products Never Returned");

db.products.aggregate([
    {
        $lookup: {
            from: "orderItems",
            localField: "productId",
            foreignField: "productId",
            as: "items"
        }
    },
    {
        $lookup: {
            from: "returns",
            localField: "items.orderItemId",
            foreignField: "orderItemId",
            as: "returns"
        }
    },
    { $match: { "returns.0": { $exists: false } } },
    {
        $project: {
            _id: 0,
            productId: 1,
            productName: 1,
            category: 1,
            price: 1
        }
    }
]).forEach(printjson);

// =========================================
// REPORT 4: Customers who have made returns
// =========================================

print("\nREPORT 4: Customers With Returns");

db.customers.aggregate([
    {
        $lookup: {
            from: "orders",
            localField: "customerId",
            foreignField: "customerId",
            as: "orders"
        }
    },
    {
        $lookup: {
            from: "orderItems",
            localField: "orders.orderId",
            foreignField: "orderId",
            as: "items"
        }
    },
    {
        $lookup: {
            from: "returns",
            localField: "items.orderItemId",
            foreignField: "orderItemId",
            as: "returns"
        }
    },
    { $match: { "returns.0": { $exists: true } } },
    {
        $project: {
            _id: 0,
            customerId: 1,
            customerName: 1,
            city: 1,
            returnCount: { $size: "$returns" }
        }
    }
]).forEach(printjson);

// =========================================
// REPORT 5: Customers who have never returned
// =========================================

print("\nREPORT 5: Customers Without Returns");

db.customers.aggregate([
    {
        $lookup: {
            from: "orders",
            localField: "customerId",
            foreignField: "customerId",
            as: "orders"
        }
    },
    {
        $lookup: {
            from: "orderItems",
            localField: "orders.orderId",
            foreignField: "orderId",
            as: "items"
        }
    },
    {
        $lookup: {
            from: "returns",
            localField: "items.orderItemId",
            foreignField: "orderItemId",
            as: "returns"
        }
    },
    { $match: { returns: { $size: 0 } } },
    {
        $project: {
            _id: 0,
            customerId: 1,
            customerName: 1,
            city: 1
        }
    }
]).forEach(printjson);

// =========================================
// REPORT 6: Total refund amount by customer
// =========================================

print("\nREPORT 6: Refund Amount By Customer");

db.returns.aggregate([
    {
        $lookup: {
            from: "refunds",
            localField: "returnId",
            foreignField: "returnId",
            as: "refunds"
        }
    },
    { $unwind: "$refunds" },
    {
        $lookup: {
            from: "orderItems",
            localField: "orderItemId",
            foreignField: "orderItemId",
            as: "item"
        }
    },
    { $unwind: "$item" },
    {
        $lookup: {
            from: "orders",
            localField: "item.orderId",
            foreignField: "orderId",
            as: "order"
        }
    },
    { $unwind: "$order" },
    {
        $lookup: {
            from: "customers",
            localField: "order.customerId",
            foreignField: "customerId",
            as: "customer"
        }
    },
    { $unwind: "$customer" },
    {
        $group: {
            _id: "$customer.customerId",
            customerName: { $first: "$customer.customerName" },
            totalRefundAmount: { $sum: "$refunds.refundAmount" }
        }
    },
    {
        $project: {
            _id: 0,
            customerId: "$_id",
            customerName: 1,
            totalRefundAmount: 1
        }
    },
    { $sort: { totalRefundAmount: -1 } }
]).forEach(printjson);

// =========================================
// REPORT 7: Refund status summary
// =========================================

print("\nREPORT 7: Refund Status Summary");

db.refunds.aggregate([
    {
        $group: {
            _id: "$refundStatus",
            numberOfRefunds: { $sum: 1 },
            totalRefundAmount: { $sum: "$refundAmount" }
        }
    },
    {
        $project: {
            _id: 0,
            refundStatus: "$_id",
            numberOfRefunds: 1,
            totalRefundAmount: 1
        }
    },
    { $sort: { totalRefundAmount: -1 } }
]).forEach(printjson);

// =========================================
// REPORT 8: Return count by product
// =========================================

print("\nREPORT 8: Return Count By Product");

db.returns.aggregate([
    {
        $lookup: {
            from: "orderItems",
            localField: "orderItemId",
            foreignField: "orderItemId",
            as: "item"
        }
    },
    { $unwind: "$item" },
    {
        $lookup: {
            from: "products",
            localField: "item.productId",
            foreignField: "productId",
            as: "product"
        }
    },
    { $unwind: "$product" },
    {
        $group: {
            _id: "$product.productId",
            productName: { $first: "$product.productName" },
            returnCount: { $sum: 1 }
        }
    },
    {
        $project: {
            _id: 0,
            productId: "$_id",
            productName: 1,
            returnCount: 1
        }
    },
    { $sort: { returnCount: -1, productName: 1 } }
]).forEach(printjson);

// =========================================
// REPORT 9: Refunds greater than average refund
// =========================================

print("\nREPORT 9: Refunds Above Average");

db.refunds.aggregate([
    {
        $group: {
            _id: null,
            averageRefund: { $avg: "$refundAmount" },
            refunds: { $push: "$$ROOT" }
        }
    },
    { $unwind: "$refunds" },
    {
        $match: {
            $expr: {
                $gt: ["$refunds.refundAmount", "$averageRefund"]
            }
        }
    },
    {
        $project: {
            _id: 0,
            refundId: "$refunds.refundId",
            returnId: "$refunds.returnId",
            refundAmount: "$refunds.refundAmount",
            averageRefund: 1,
            refundStatus: "$refunds.refundStatus"
        }
    }
]).forEach(printjson);

// =========================================
// REPORT 10: Returns handled by employees
// =========================================

print("\nREPORT 10: Returns Handled By Employees");

db.employees.aggregate([
    {
        $lookup: {
            from: "returns",
            localField: "employeeId",
            foreignField: "processedBy",
            as: "handledReturns"
        }
    },
    {
        $project: {
            _id: 0,
            employeeId: 1,
            employeeName: 1,
            returnsHandled: { $size: "$handledReturns" }
        }
    },
    { $sort: { returnsHandled: -1, employeeId: 1 } }
]).forEach(printjson);

print("\nAll Retail Returns MongoDB Reports Completed.");
