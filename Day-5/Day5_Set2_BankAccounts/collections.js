
use("BankBranchAccounts");

// Create a capped collection
if (!db.getCollectionNames().includes("activityLogs")) {
    db.createCollection("activityLogs", {
        capped: true,
        size: 1048576,
        max: 1000
    });
}

const activityLogs = db.getCollection("activityLogs");

// Index for customer login history
activityLogs.createIndex({
    customerId: 1,
    eventType: 1,
    eventTime: -1
});

// Insert 20 activity log documents
activityLogs.insertMany([
    { logId: "L001", customerId: "C001", eventType: "LOGIN", eventTime: ISODate("2026-11-10T08:00:00Z"), details: "Mobile app login" },
    { logId: "L002", customerId: "C002", eventType: "LOGIN", eventTime: ISODate("2026-11-10T09:00:00Z"), details: "Web login" },
    { logId: "L003", customerId: "C001", eventType: "BALANCE_CHECK", eventTime: ISODate("2026-11-10T08:15:00Z"), details: "Checked savings balance" },
    { logId: "L004", customerId: "C003", eventType: "LOGIN", eventTime: ISODate("2026-11-11T10:00:00Z"), details: "Mobile app login" },
    { logId: "L005", customerId: "C001", eventType: "LOGIN", eventTime: ISODate("2026-11-11T08:30:00Z"), details: "Web login" },
    { logId: "L006", customerId: "C004", eventType: "TRANSFER", eventTime: ISODate("2026-11-11T11:00:00Z"), details: "Fund transfer initiated" },
    { logId: "L007", customerId: "C001", eventType: "LOGOUT", eventTime: ISODate("2026-11-11T08:45:00Z"), details: "User logged out" },
    { logId: "L008", customerId: "C002", eventType: "BALANCE_CHECK", eventTime: ISODate("2026-11-12T09:15:00Z"), details: "Checked current account balance" },
    { logId: "L009", customerId: "C001", eventType: "LOGIN", eventTime: ISODate("2026-11-12T07:45:00Z"), details: "Mobile app login" },
    { logId: "L010", customerId: "C005", eventType: "LOGIN", eventTime: ISODate("2026-11-12T12:00:00Z"), details: "Web login" },
    { logId: "L011", customerId: "C001", eventType: "LOGIN", eventTime: ISODate("2026-11-13T08:10:00Z"), details: "Internet banking login" },
    { logId: "L012", customerId: "C003", eventType: "LOGOUT", eventTime: ISODate("2026-11-13T10:30:00Z"), details: "User logged out" },
    { logId: "L013", customerId: "C001", eventType: "TRANSFER", eventTime: ISODate("2026-11-14T09:00:00Z"), details: "Transfer of 5000 initiated" },
    { logId: "L014", customerId: "C006", eventType: "LOGIN", eventTime: ISODate("2026-11-14T10:00:00Z"), details: "Mobile app login" },
    { logId: "L015", customerId: "C001", eventType: "LOGIN", eventTime: ISODate("2026-11-15T07:30:00Z"), details: "Mobile app login" },
    { logId: "L016", customerId: "C002", eventType: "LOGOUT", eventTime: ISODate("2026-11-15T09:30:00Z"), details: "User logged out" },
    { logId: "L017", customerId: "C007", eventType: "LOGIN", eventTime: ISODate("2026-11-16T11:00:00Z"), details: "Web login" },
    { logId: "L018", customerId: "C001", eventType: "LOGIN", eventTime: ISODate("2026-11-16T08:20:00Z"), details: "Web login" },
    { logId: "L019", customerId: "C008", eventType: "BALANCE_CHECK", eventTime: ISODate("2026-11-17T10:00:00Z"), details: "Checked account balance" },
    { logId: "L020", customerId: "C001", eventType: "LOGIN", eventTime: ISODate("2026-11-17T08:00:00Z"), details: "Mobile app login" }
]);

// Verify total documents
print("Total activity logs:");
print(activityLogs.countDocuments());

// Retrieve the last five login events of customer C001
print("Last five login events for customer C001:");
activityLogs.find({
    customerId: "C001",
    eventType: "LOGIN"
})
.sort({ eventTime: -1 })
.limit(5)
.forEach(printjson);
