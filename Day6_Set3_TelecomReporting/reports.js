
// Day 6 - Set 3: Telecom Usage and Billing Reporting
// MongoDB 8.0
// Database: TelecomReporting
// Collection: usageEvents

use("TelecomReporting");

// --------------------------------------------------
// 1. CREATE COLLECTION
// --------------------------------------------------

if (!db.getCollectionNames().includes("usageEvents")) {
    db.createCollection("usageEvents");
}

const usageEvents = db.getCollection("usageEvents");

// Clear existing documents to make the script safe to rerun.
usageEvents.deleteMany({});

// --------------------------------------------------
// 2. INSERT SAMPLE USAGE EVENTS
// --------------------------------------------------

usageEvents.insertMany([
    {
        usageId: 1,
        subscriberId: 101,
        subscriberName: "Arun Kumar",
        circle: "Chennai",
        planName: "Basic Plan",
        usageDate: ISODate("2026-11-01T09:00:00Z"),
        usageType: "DATA",
        dataUsedGB: 1.20,
        callMinutes: 120,
        sessionDurationMinutes: 25,
        cellTower: "CHN-TOWER-01"
    },
    {
        usageId: 2,
        subscriberId: 101,
        subscriberName: "Arun Kumar",
        circle: "Chennai",
        planName: "Basic Plan",
        usageDate: ISODate("2026-11-01T14:00:00Z"),
        usageType: "CALL",
        dataUsedGB: 1.10,
        callMinutes: 90,
        sessionDurationMinutes: 15,
        cellTower: "CHN-TOWER-01"
    },
    {
        usageId: 3,
        subscriberId: 102,
        subscriberName: "Priya Sharma",
        circle: "Bangalore",
        planName: "Smart Plan",
        usageDate: ISODate("2026-11-02T10:00:00Z"),
        usageType: "DATA",
        dataUsedGB: 3.00,
        callMinutes: 250,
        sessionDurationMinutes: 40,
        cellTower: "BLR-TOWER-02"
    },
    {
        usageId: 4,
        subscriberId: 102,
        subscriberName: "Priya Sharma",
        circle: "Bangalore",
        planName: "Smart Plan",
        usageDate: ISODate("2026-11-02T15:00:00Z"),
        usageType: "CALL",
        dataUsedGB: 2.50,
        callMinutes: 200,
        sessionDurationMinutes: 30,
        cellTower: "BLR-TOWER-02"
    },
    {
        usageId: 5,
        subscriberId: 103,
        subscriberName: "Rahul Verma",
        circle: "Chennai",
        planName: "Premium Plan",
        usageDate: ISODate("2026-11-03T08:00:00Z"),
        usageType: "DATA",
        dataUsedGB: 6.00,
        callMinutes: 400,
        sessionDurationMinutes: 55,
        cellTower: "CHN-TOWER-03"
    },
    {
        usageId: 6,
        subscriberId: 103,
        subscriberName: "Rahul Verma",
        circle: "Chennai",
        planName: "Premium Plan",
        usageDate: ISODate("2026-11-03T18:00:00Z"),
        usageType: "CALL",
        dataUsedGB: 5.50,
        callMinutes: 350,
        sessionDurationMinutes: 45,
        cellTower: "CHN-TOWER-03"
    },
    {
        usageId: 7,
        subscriberId: 104,
        subscriberName: "Sneha Reddy",
        circle: "Hyderabad",
        planName: "Smart Plan",
        usageDate: ISODate("2026-11-04T11:00:00Z"),
        usageType: "DATA",
        dataUsedGB: 2.00,
        callMinutes: 180,
        sessionDurationMinutes: 35,
        cellTower: "HYD-TOWER-01"
    },
    {
        usageId: 8,
        subscriberId: 104,
        subscriberName: "Sneha Reddy",
        circle: "Hyderabad",
        planName: "Smart Plan",
        usageDate: ISODate("2026-11-04T17:00:00Z"),
        usageType: "CALL",
        dataUsedGB: 2.20,
        callMinutes: 160,
        sessionDurationMinutes: 25,
        cellTower: "HYD-TOWER-01"
    },
    {
        usageId: 9,
        subscriberId: 105,
        subscriberName: "Karthik Raj",
        circle: "Chennai",
        planName: "Unlimited Plan",
        usageDate: ISODate("2026-11-05T09:00:00Z"),
        usageType: "DATA",
        dataUsedGB: 12.00,
        callMinutes: 600,
        sessionDurationMinutes: 70,
        cellTower: "CHN-TOWER-04"
    },
    {
        usageId: 10,
        subscriberId: 105,
        subscriberName: "Karthik Raj",
        circle: "Chennai",
        planName: "Unlimited Plan",
        usageDate: ISODate("2026-11-05T19:00:00Z"),
        usageType: "CALL",
        dataUsedGB: 11.00,
        callMinutes: 550,
        sessionDurationMinutes: 65,
        cellTower: "CHN-TOWER-04"
    },
    {
        usageId: 11,
        subscriberId: 106,
        subscriberName: "Meena Iyer",
        circle: "Bangalore",
        planName: "Basic Plan",
        usageDate: ISODate("2026-11-06T10:00:00Z"),
        usageType: "DATA",
        dataUsedGB: 0.80,
        callMinutes: 100,
        sessionDurationMinutes: 20,
        cellTower: "BLR-TOWER-03"
    },
    {
        usageId: 12,
        subscriberId: 106,
        subscriberName: "Meena Iyer",
        circle: "Bangalore",
        planName: "Basic Plan",
        usageDate: ISODate("2026-11-06T16:00:00Z"),
        usageType: "CALL",
        dataUsedGB: 0.70,
        callMinutes: 80,
        sessionDurationMinutes: 15,
        cellTower: "BLR-TOWER-03"
    },
    {
        usageId: 13,
        subscriberId: 107,
        subscriberName: "Vijay Kumar",
        circle: "Hyderabad",
        planName: "Premium Plan",
        usageDate: ISODate("2026-11-07T09:00:00Z"),
        usageType: "DATA",
        dataUsedGB: 4.50,
        callMinutes: 500,
        sessionDurationMinutes: 60,
        cellTower: "HYD-TOWER-02"
    },
    {
        usageId: 14,
        subscriberId: 107,
        subscriberName: "Vijay Kumar",
        circle: "Hyderabad",
        planName: "Premium Plan",
        usageDate: ISODate("2026-11-07T20:00:00Z"),
        usageType: "CALL",
        dataUsedGB: 4.00,
        callMinutes: 450,
        sessionDurationMinutes: 50,
        cellTower: "HYD-TOWER-02"
    },
    {
        usageId: 15,
        subscriberId: 108,
        subscriberName: "Divya Nair",
        circle: "Mumbai",
        planName: "Smart Plan",
        usageDate: ISODate("2026-11-08T10:00:00Z"),
        usageType: "DATA",
        dataUsedGB: 3.20,
        callMinutes: 220,
        sessionDurationMinutes: 40,
        cellTower: "MUM-TOWER-01"
    },
    {
        usageId: 16,
        subscriberId: 108,
        subscriberName: "Divya Nair",
        circle: "Mumbai",
        planName: "Smart Plan",
        usageDate: ISODate("2026-11-08T18:00:00Z"),
        usageType: "CALL",
        dataUsedGB: 2.50,
        callMinutes: 180,
        sessionDurationMinutes: 30,
        cellTower: "MUM-TOWER-01"
    },
    {
        usageId: 17,
        subscriberId: 109,
        subscriberName: "Sanjay Rao",
        circle: "Mumbai",
        planName: "Unlimited Plan",
        usageDate: ISODate("2026-11-09T09:00:00Z"),
        usageType: "DATA",
        dataUsedGB: 18.00,
        callMinutes: 700,
        sessionDurationMinutes: 80,
        cellTower: "MUM-TOWER-02"
    },
    {
        usageId: 18,
        subscriberId: 109,
        subscriberName: "Sanjay Rao",
        circle: "Mumbai",
        planName: "Unlimited Plan",
        usageDate: ISODate("2026-11-09T19:00:00Z"),
        usageType: "CALL",
        dataUsedGB: 15.00,
        callMinutes: 650,
        sessionDurationMinutes: 70,
        cellTower: "MUM-TOWER-02"
    }
]);

print("TOTAL USAGE EVENTS:");
print(usageEvents.countDocuments());

// --------------------------------------------------
// 3. PIPELINE 1: HOURLY USAGE
// --------------------------------------------------

print("\nPIPELINE 1: HOURLY USAGE");

usageEvents.aggregate([
    {
        $group: {
            _id: {
                hour: {
                    $hour: "$usageDate"
                }
            },
            totalEvents: {
                $sum: 1
            },
            totalDataUsedGB: {
                $sum: "$dataUsedGB"
            },
            totalCallMinutes: {
                $sum: "$callMinutes"
            }
        }
    },
    {
        $project: {
            _id: 0,
            hour: "$_id.hour",
            totalEvents: 1,
            totalDataUsedGB: {
                $round: ["$totalDataUsedGB", 2]
            },
            totalCallMinutes: 1
        }
    },
    {
        $sort: {
            hour: 1
        }
    }
]).forEach(printjson);

// --------------------------------------------------
// 4. PIPELINE 2: AVERAGE SESSION LENGTH
// --------------------------------------------------

print("\nPIPELINE 2: AVERAGE SESSION LENGTH");

usageEvents.aggregate([
    {
        $group: {
            _id: "$usageType",
            totalSessions: {
                $sum: 1
            },
            averageSessionMinutes: {
                $avg: "$sessionDurationMinutes"
            },
            totalSessionMinutes: {
                $sum: "$sessionDurationMinutes"
            }
        }
    },
    {
        $project: {
            _id: 0,
            usageType: "$_id",
            totalSessions: 1,
            averageSessionMinutes: {
                $round: ["$averageSessionMinutes", 2]
            },
            totalSessionMinutes: 1
        }
    },
    {
        $sort: {
            usageType: 1
        }
    }
]).forEach(printjson);

// --------------------------------------------------
// 5. PIPELINE 3: BUSIEST CELL TOWER
// --------------------------------------------------

print("\nPIPELINE 3: BUSIEST CELL TOWER");

usageEvents.aggregate([
    {
        $group: {
            _id: "$cellTower",
            totalEvents: {
                $sum: 1
            },
            totalDataUsedGB: {
                $sum: "$dataUsedGB"
            },
            totalCallMinutes: {
                $sum: "$callMinutes"
            }
        }
    },
    {
        $sort: {
            totalEvents: -1,
            totalDataUsedGB: -1
        }
    },
    {
        $limit: 3
    },
    {
        $project: {
            _id: 0,
            cellTower: "$_id",
            totalEvents: 1,
            totalDataUsedGB: {
                $round: ["$totalDataUsedGB", 2]
            },
            totalCallMinutes: 1
        }
    }
]).forEach(printjson);

// --------------------------------------------------
// 6. COMPLETION MESSAGE
// --------------------------------------------------

print("\nTELECOM MONGODB REPORTS COMPLETED.");
