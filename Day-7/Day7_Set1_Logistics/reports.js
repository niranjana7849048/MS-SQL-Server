
// Day 7 - Set 1
// Logistics Shipment Analysis
// MongoDB 8.0
// Concepts: $lookup, $unwind, $group, $match, $sort

use("LogisticsReporting");

// ------------------------------------------
// 1. CREATE COLLECTIONS
// ------------------------------------------

const collections = [
    "hubs",
    "carriers",
    "customers",
    "employees",
    "shipments",
    "deliveryEvents"
];

collections.forEach(collectionName => {
    if (!db.getCollectionNames().includes(collectionName)) {
        db.createCollection(collectionName);
    }
});

// Clear previous records for safe reruns
collections.forEach(collectionName => {
    db.getCollection(collectionName).deleteMany({});
});

// ------------------------------------------
// 2. INSERT HUBS
// ------------------------------------------

db.hubs.insertMany([
    {
        hubId: 1,
        hubName: "Chennai Hub",
        city: "Chennai"
    },
    {
        hubId: 2,
        hubName: "Bangalore Hub",
        city: "Bangalore"
    },
    {
        hubId: 3,
        hubName: "Delhi Hub",
        city: "Delhi"
    },
    {
        hubId: 4,
        hubName: "Mumbai Hub",
        city: "Mumbai"
    }
]);

// ------------------------------------------
// 3. INSERT CARRIERS
// ------------------------------------------

db.carriers.insertMany([
    {
        carrierId: 1,
        carrierName: "BlueDart",
        contactNumber: "9876543210"
    },
    {
        carrierId: 2,
        carrierName: "DTDC",
        contactNumber: "9876543211"
    },
    {
        carrierId: 3,
        carrierName: "Delhivery",
        contactNumber: "9876543212"
    }
]);

// ------------------------------------------
// 4. INSERT CUSTOMERS
// ------------------------------------------

db.customers.insertMany([
    {
        customerId: 1,
        customerName: "Arun Kumar",
        city: "Chennai",
        email: "arun@example.com"
    },
    {
        customerId: 2,
        customerName: "Priya Sharma",
        city: "Bangalore",
        email: "priya@example.com"
    },
    {
        customerId: 3,
        customerName: "Rahul Verma",
        city: "Delhi",
        email: "rahul@example.com"
    },
    {
        customerId: 4,
        customerName: "Sneha Raj",
        city: "Mumbai",
        email: "sneha@example.com"
    },
    {
        customerId: 5,
        customerName: "Karthik S",
        city: "Chennai",
        email: "karthik@example.com"
    }
]);

// ------------------------------------------
// 5. INSERT EMPLOYEES
// ------------------------------------------

db.employees.insertMany([
    {
        employeeId: 1,
        employeeName: "Ramesh",
        designation: "Operations Manager",
        supervisorId: null
    },
    {
        employeeId: 2,
        employeeName: "Suresh",
        designation: "Hub Manager",
        supervisorId: 1
    },
    {
        employeeId: 3,
        employeeName: "Kavitha",
        designation: "Delivery Supervisor",
        supervisorId: 1
    },
    {
        employeeId: 4,
        employeeName: "Vijay",
        designation: "Delivery Executive",
        supervisorId: 2
    },
    {
        employeeId: 5,
        employeeName: "Divya",
        designation: "Delivery Executive",
        supervisorId: 2
    },
    {
        employeeId: 6,
        employeeName: "Manoj",
        designation: "Delivery Executive",
        supervisorId: 3
    }
]);

// ------------------------------------------
// 6. INSERT SHIPMENTS
// ------------------------------------------

db.shipments.insertMany([
    {
        shipmentId: 1,
        trackingNumber: "TRK1001",
        customerId: 1,
        carrierId: 1,
        originHubId: 1,
        destinationHubId: 2,
        shippingDate: ISODate("2026-01-01"),
        expectedDeliveryDate: ISODate("2026-01-04"),
        actualDeliveryDate: ISODate("2026-01-05"),
        shippingCost: 500,
        shipmentStatus: "Delayed",
        delayDays: 1
    },
    {
        shipmentId: 2,
        trackingNumber: "TRK1002",
        customerId: 2,
        carrierId: 2,
        originHubId: 2,
        destinationHubId: 3,
        shippingDate: ISODate("2026-01-02"),
        expectedDeliveryDate: ISODate("2026-01-05"),
        actualDeliveryDate: ISODate("2026-01-08"),
        shippingCost: 700,
        shipmentStatus: "Delayed",
        delayDays: 3
    },
    {
        shipmentId: 3,
        trackingNumber: "TRK1003",
        customerId: 1,
        carrierId: 3,
        originHubId: 1,
        destinationHubId: 1,
        shippingDate: ISODate("2026-01-03"),
        expectedDeliveryDate: ISODate("2026-01-06"),
        actualDeliveryDate: ISODate("2026-01-06"),
        shippingCost: 400,
        shipmentStatus: "Delivered",
        delayDays: 0
    },
    {
        shipmentId: 4,
        trackingNumber: "TRK1004",
        customerId: 3,
        carrierId: 1,
        originHubId: 3,
        destinationHubId: 1,
        shippingDate: ISODate("2026-01-04"),
        expectedDeliveryDate: ISODate("2026-01-07"),
        actualDeliveryDate: ISODate("2026-01-11"),
        shippingCost: 900,
        shipmentStatus: "Delayed",
        delayDays: 4
    },
    {
        shipmentId: 5,
        trackingNumber: "TRK1005",
        customerId: 4,
        carrierId: 2,
        originHubId: 2,
        destinationHubId: 4,
        shippingDate: ISODate("2026-01-05"),
        expectedDeliveryDate: ISODate("2026-01-08"),
        actualDeliveryDate: ISODate("2026-01-08"),
        shippingCost: 650,
        shipmentStatus: "Delivered",
        delayDays: 0
    },
    {
        shipmentId: 6,
        trackingNumber: "TRK1006",
        customerId: 5,
        carrierId: 3,
        originHubId: 3,
        destinationHubId: 2,
        shippingDate: ISODate("2026-01-06"),
        expectedDeliveryDate: ISODate("2026-01-09"),
        actualDeliveryDate: ISODate("2026-01-10"),
        shippingCost: 800,
        shipmentStatus: "Delayed",
        delayDays: 1
    },
    {
        shipmentId: 7,
        trackingNumber: "TRK1007",
        customerId: 2,
        carrierId: 1,
        originHubId: 1,
        destinationHubId: 3,
        shippingDate: ISODate("2026-01-07"),
        expectedDeliveryDate: ISODate("2026-01-10"),
        actualDeliveryDate: ISODate("2026-01-14"),
        shippingCost: 1200,
        shipmentStatus: "Delayed",
        delayDays: 4
    },
    {
        shipmentId: 8,
        trackingNumber: "TRK1008",
        customerId: 1,
        carrierId: 2,
        originHubId: 2,
        destinationHubId: 3,
        shippingDate: ISODate("2026-01-08"),
        expectedDeliveryDate: ISODate("2026-01-11"),
        actualDeliveryDate: ISODate("2026-01-11"),
        shippingCost: 550,
        shipmentStatus: "Delivered",
        delayDays: 0
    },
    {
        shipmentId: 9,
        trackingNumber: "TRK1009",
        customerId: 3,
        carrierId: 3,
        originHubId: 3,
        destinationHubId: 4,
        shippingDate: ISODate("2026-01-09"),
        expectedDeliveryDate: ISODate("2026-01-12"),
        actualDeliveryDate: ISODate("2026-01-14"),
        shippingCost: 950,
        shipmentStatus: "Delivered",
        delayDays: 2
    },
    {
        shipmentId: 10,
        trackingNumber: "TRK1010",
        customerId: 4,
        carrierId: 1,
        originHubId: 1,
        destinationHubId: 2,
        shippingDate: ISODate("2026-01-10"),
        expectedDeliveryDate: ISODate("2026-01-13"),
        actualDeliveryDate: ISODate("2026-01-13"),
        shippingCost: 450,
        shipmentStatus: "Delivered",
        delayDays: 0
    },
    {
        shipmentId: 11,
        trackingNumber: "TRK1011",
        customerId: 5,
        carrierId: 2,
        originHubId: 2,
        destinationHubId: 1,
        shippingDate: ISODate("2026-01-11"),
        expectedDeliveryDate: ISODate("2026-01-14"),
        actualDeliveryDate: ISODate("2026-01-18"),
        shippingCost: 1100,
        shipmentStatus: "Delayed",
        delayDays: 4
    },
    {
        shipmentId: 12,
        trackingNumber: "TRK1012",
        customerId: 2,
        carrierId: 3,
        originHubId: 3,
        destinationHubId: 1,
        shippingDate: ISODate("2026-01-12"),
        expectedDeliveryDate: ISODate("2026-01-15"),
        actualDeliveryDate: ISODate("2026-01-15"),
        shippingCost: 600,
        shipmentStatus: "Delivered",
        delayDays: 0
    },
    {
        shipmentId: 13,
        trackingNumber: "TRK1013",
        customerId: 1,
        carrierId: 1,
        originHubId: 1,
        destinationHubId: 4,
        shippingDate: ISODate("2026-01-13"),
        expectedDeliveryDate: ISODate("2026-01-16"),
        actualDeliveryDate: ISODate("2026-01-20"),
        shippingCost: 1500,
        shipmentStatus: "Delayed",
        delayDays: 4
    },
    {
        shipmentId: 14,
        trackingNumber: "TRK1014",
        customerId: 3,
        carrierId: 2,
        originHubId: 3,
        destinationHubId: 2,
        shippingDate: ISODate("2026-01-14"),
        expectedDeliveryDate: ISODate("2026-01-17"),
        actualDeliveryDate: ISODate("2026-01-17"),
        shippingCost: 750,
        shipmentStatus: "Delivered",
        delayDays: 0
    },
    {
        shipmentId: 15,
        trackingNumber: "TRK1015",
        customerId: 5,
        carrierId: 3,
        originHubId: 2,
        destinationHubId: 3,
        shippingDate: ISODate("2026-01-15"),
        expectedDeliveryDate: ISODate("2026-01-18"),
        actualDeliveryDate: ISODate("2026-01-21"),
        shippingCost: 1300,
        shipmentStatus: "Delayed",
        delayDays: 3
    },
    {
        shipmentId: 16,
        trackingNumber: "TRK1016",
        customerId: 4,
        carrierId: 1,
        originHubId: 1,
        destinationHubId: 3,
        shippingDate: ISODate("2026-01-16"),
        expectedDeliveryDate: ISODate("2026-01-19"),
        actualDeliveryDate: null,
        shippingCost: 850,
        shipmentStatus: "In Transit",
        delayDays: null
    }
]);

// ------------------------------------------
// 7. INSERT DELIVERY EVENTS
// ------------------------------------------

db.deliveryEvents.insertMany([
    {
        eventId: 1,
        shipmentId: 1,
        eventType: "Picked Up",
        eventLocation: "Chennai",
        eventDateTime: ISODate("2026-01-01T09:00:00Z"),
        eventDescription: "Shipment picked up"
    },
    {
        eventId: 2,
        shipmentId: 1,
        eventType: "In Transit",
        eventLocation: "Bangalore",
        eventDateTime: ISODate("2026-01-03T10:00:00Z"),
        eventDescription: "Shipment in transit"
    },
    {
        eventId: 3,
        shipmentId: 2,
        eventType: "Picked Up",
        eventLocation: "Bangalore",
        eventDateTime: ISODate("2026-01-02T09:00:00Z"),
        eventDescription: "Shipment picked up"
    },
    {
        eventId: 4,
        shipmentId: 2,
        eventType: "Delayed",
        eventLocation: "Delhi",
        eventDateTime: ISODate("2026-01-06T11:00:00Z"),
        eventDescription: "Delivery delayed"
    },
    {
        eventId: 5,
        shipmentId: 3,
        eventType: "Delivered",
        eventLocation: "Chennai",
        eventDateTime: ISODate("2026-01-06T12:00:00Z"),
        eventDescription: "Shipment delivered"
    },
    {
        eventId: 6,
        shipmentId: 4,
        eventType: "Picked Up",
        eventLocation: "Delhi",
        eventDateTime: ISODate("2026-01-04T09:00:00Z"),
        eventDescription: "Shipment picked up"
    },
    {
        eventId: 7,
        shipmentId: 4,
        eventType: "Delayed",
        eventLocation: "Chennai",
        eventDateTime: ISODate("2026-01-09T12:00:00Z"),
        eventDescription: "Shipment delayed"
    },
    {
        eventId: 8,
        shipmentId: 5,
        eventType: "Delivered",
        eventLocation: "Mumbai",
        eventDateTime: ISODate("2026-01-08T15:00:00Z"),
        eventDescription: "Shipment delivered"
    },
    {
        eventId: 9,
        shipmentId: 6,
        eventType: "Picked Up",
        eventLocation: "Delhi",
        eventDateTime: ISODate("2026-01-06T10:00:00Z"),
        eventDescription: "Shipment picked up"
    },
    {
        eventId: 10,
        shipmentId: 7,
        eventType: "Delayed",
        eventLocation: "Bangalore",
        eventDateTime: ISODate("2026-01-12T11:00:00Z"),
        eventDescription: "Shipment delayed"
    },
    {
        eventId: 11,
        shipmentId: 8,
        eventType: "Delivered",
        eventLocation: "Delhi",
        eventDateTime: ISODate("2026-01-11T14:00:00Z"),
        eventDescription: "Shipment delivered"
    },
    {
        eventId: 12,
        shipmentId: 9,
        eventType: "Delivered",
        eventLocation: "Mumbai",
        eventDateTime: ISODate("2026-01-14T16:00:00Z"),
        eventDescription: "Shipment delivered"
    },
    {
        eventId: 13,
        shipmentId: 10,
        eventType: "Delivered",
        eventLocation: "Bangalore",
        eventDateTime: ISODate("2026-01-13T12:00:00Z"),
        eventDescription: "Shipment delivered"
    },
    {
        eventId: 14,
        shipmentId: 11,
        eventType: "Delayed",
        eventLocation: "Chennai",
        eventDateTime: ISODate("2026-01-16T10:00:00Z"),
        eventDescription: "Shipment delayed"
    },
    {
        eventId: 15,
        shipmentId: 12,
        eventType: "Delivered",
        eventLocation: "Chennai",
        eventDateTime: ISODate("2026-01-15T14:00:00Z"),
        eventDescription: "Shipment delivered"
    },
    {
        eventId: 16,
        shipmentId: 13,
        eventType: "Delayed",
        eventLocation: "Mumbai",
        eventDateTime: ISODate("2026-01-18T11:00:00Z"),
        eventDescription: "Shipment delayed"
    },
    {
        eventId: 17,
        shipmentId: 14,
        eventType: "Delivered",
        eventLocation: "Bangalore",
        eventDateTime: ISODate("2026-01-17T13:00:00Z"),
        eventDescription: "Shipment delivered"
    },
    {
        eventId: 18,
        shipmentId: 15,
        eventType: "Delayed",
        eventLocation: "Delhi",
        eventDateTime: ISODate("2026-01-19T10:00:00Z"),
        eventDescription: "Shipment delayed"
    },
    {
        eventId: 19,
        shipmentId: 16,
        eventType: "Picked Up",
        eventLocation: "Chennai",
        eventDateTime: ISODate("2026-01-16T09:00:00Z"),
        eventDescription: "Shipment picked up"
    },
    {
        eventId: 20,
        shipmentId: 6,
        eventType: "In Transit",
        eventLocation: "Bangalore",
        eventDateTime: ISODate("2026-01-08T10:00:00Z"),
        eventDescription: "Shipment in transit"
    },
    {
        eventId: 21,
        shipmentId: 13,
        eventType: "Out for Delivery",
        eventLocation: "Mumbai",
        eventDateTime: ISODate("2026-01-20T08:00:00Z"),
        eventDescription: "Shipment out for delivery"
    }
]);

// ------------------------------------------
// 8. REPORT 1
// Shipments with customer and carrier details
// ------------------------------------------

print("\nREPORT 1: Shipment Details with Customer and Carrier");

db.shipments.aggregate([
    {
        $lookup: {
            from: "customers",
            localField: "customerId",
            foreignField: "customerId",
            as: "customer"
        }
    },
    {
        $lookup: {
            from: "carriers",
            localField: "carrierId",
            foreignField: "carrierId",
            as: "carrier"
        }
    },
    {
        $unwind: "$customer"
    },
    {
        $unwind: "$carrier"
    },
    {
        $project: {
            _id: 0,
            shipmentId: 1,
            trackingNumber: 1,
            customerName: "$customer.customerName",
            carrierName: "$carrier.carrierName",
            shippingCost: 1,
            shipmentStatus: 1
        }
    },
    {
        $sort: {
            shipmentId: 1
        }
    }
]).forEach(printjson);

// ------------------------------------------
// 9. REPORT 2
// Shipments with origin and destination hubs
// ------------------------------------------

print("\nREPORT 2: Shipment Route Details");

db.shipments.aggregate([
    {
        $lookup: {
            from: "hubs",
            localField: "originHubId",
            foreignField: "hubId",
            as: "origin"
        }
    },
    {
        $lookup: {
            from: "hubs",
            localField: "destinationHubId",
            foreignField: "hubId",
            as: "destination"
        }
    },
    {
        $unwind: "$origin"
    },
    {
        $unwind: "$destination"
    },
    {
        $project: {
            _id: 0,
            trackingNumber: 1,
            originHub: "$origin.hubName",
            destinationHub: "$destination.hubName",
            shippingCost: 1,
            shipmentStatus: 1
        }
    }
]).forEach(printjson);

// ------------------------------------------
// 10. REPORT 3
// Customers and their shipment counts
// ------------------------------------------

print("\nREPORT 3: Customer Shipment Summary");

db.customers.aggregate([
    {
        $lookup: {
            from: "shipments",
            localField: "customerId",
            foreignField: "customerId",
            as: "customerShipments"
        }
    },
    {
        $project: {
            _id: 0,
            customerId: 1,
            customerName: 1,
            city: 1,
            totalShipments: {
                $size: "$customerShipments"
            }
        }
    },
    {
        $sort: {
            totalShipments: -1,
            customerName: 1
        }
    }
]).forEach(printjson);

// ------------------------------------------
// 11. REPORT 4
// Shipments without delivery events
// ------------------------------------------

print("\nREPORT 4: Shipments Without Delivery Events");

db.shipments.aggregate([
    {
        $lookup: {
            from: "deliveryEvents",
            localField: "shipmentId",
            foreignField: "shipmentId",
            as: "events"
        }
    },
    {
        $match: {
            events: {
                $size: 0
            }
        }
    },
    {
        $project: {
            _id: 0,
            shipmentId: 1,
            trackingNumber: 1,
            shipmentStatus: 1
        }
    }
]).forEach(printjson);

// ------------------------------------------
// 12. REPORT 5
// Delivery events with shipment information
// ------------------------------------------

print("\nREPORT 5: Delivery Events with Shipment Details");

db.deliveryEvents.aggregate([
    {
        $lookup: {
            from: "shipments",
            localField: "shipmentId",
            foreignField: "shipmentId",
            as: "shipment"
        }
    },
    {
        $unwind: "$shipment"
    },
    {
        $lookup: {
            from: "customers",
            localField: "shipment.customerId",
            foreignField: "customerId",
            as: "customer"
        }
    },
    {
        $unwind: "$customer"
    },
    {
        $project: {
            _id: 0,
            eventId: 1,
            trackingNumber: "$shipment.trackingNumber",
            customerName: "$customer.customerName",
            eventType: 1,
            eventLocation: 1,
            eventDateTime: 1
        }
    },
    {
        $sort: {
            eventId: 1
        }
    }
]).forEach(printjson);

// ------------------------------------------
// 13. REPORT 6
// Carrier-wise shipment statistics
// ------------------------------------------

print("\nREPORT 6: Carrier Shipment Statistics");

db.carriers.aggregate([
    {
        $lookup: {
            from: "shipments",
            localField: "carrierId",
            foreignField: "carrierId",
            as: "carrierShipments"
        }
    },
    {
        $project: {
            _id: 0,
            carrierId: 1,
            carrierName: 1,
            totalShipments: {
                $size: "$carrierShipments"
            },
            delayedShipments: {
                $size: {
                    $filter: {
                        input: "$carrierShipments",
                        as: "shipment",
                        cond: {
                            $eq: [
                                "$$shipment.shipmentStatus",
                                "Delayed"
                            ]
                        }
                    }
                }
            },
            averageShippingCost: {
                $avg: "$carrierShipments.shippingCost"
            }
        }
    },
    {
        $sort: {
            totalShipments: -1
        }
    }
]).forEach(printjson);

// ------------------------------------------
// 14. REPORT 7
// Average delay by carrier
// ------------------------------------------

print("\nREPORT 7: Average Delay by Carrier");

db.carriers.aggregate([
    {
        $lookup: {
            from: "shipments",
            localField: "carrierId",
            foreignField: "carrierId",
            as: "carrierShipments"
        }
    },
    {
        $unwind: "$carrierShipments"
    },
    {
        $match: {
            "carrierShipments.delayDays": {
                $ne: null
            }
        }
    },
    {
        $group: {
            _id: "$carrierId",
            carrierName: {
                $first: "$carrierName"
            },
            averageDelayDays: {
                $avg: "$carrierShipments.delayDays"
            },
            totalShipments: {
                $sum: 1
            }
        }
    },
    {
        $project: {
            _id: 0,
            carrierId: "$_id",
            carrierName: 1,
            averageDelayDays: {
                $round: ["$averageDelayDays", 2]
            },
            totalShipments: 1
        }
    },
    {
        $sort: {
            averageDelayDays: -1
        }
    }
]).forEach(printjson);

// ------------------------------------------
// 15. REPORT 8
// Outbound shipments per hub
// ------------------------------------------

print("\nREPORT 8: Outbound Shipment Count by Hub");

db.hubs.aggregate([
    {
        $lookup: {
            from: "shipments",
            localField: "hubId",
            foreignField: "originHubId",
            as: "outboundShipments"
        }
    },
    {
        $project: {
            _id: 0,
            hubId: 1,
            hubName: 1,
            city: 1,
            outboundShipmentCount: {
                $size: "$outboundShipments"
            }
        }
    },
    {
        $sort: {
            outboundShipmentCount: -1
        }
    }
]).forEach(printjson);

// ------------------------------------------
// 16. REPORT 9
// Customers who shipped to Mumbai Hub
// ------------------------------------------

print("\nREPORT 9: Customers Who Shipped to Mumbai");

db.customers.aggregate([
    {
        $lookup: {
            from: "shipments",
            let: {
                currentCustomerId: "$customerId"
            },
            pipeline: [
                {
                    $match: {
                        $expr: {
                            $and: [
                                {
                                    $eq: [
                                        "$customerId",
                                        "$$currentCustomerId"
                                    ]
                                },
                                {
                                    $eq: [
                                        "$destinationHubId",
                                        4
                                    ]
                                }
                            ]
                        }
                    }
                }
            ],
            as: "mumbaiShipments"
        }
    },
    {
        $match: {
            "mumbaiShipments.0": {
                $exists: true
            }
        }
    },
    {
        $project: {
            _id: 0,
            customerId: 1,
            customerName: 1,
            totalMumbaiShipments: {
                $size: "$mumbaiShipments"
            }
        }
    }
]).forEach(printjson);

// ------------------------------------------
// 17. REPORT 10
// Delayed shipments exceeding two days
// ------------------------------------------

print("\nREPORT 10: Shipments Delayed More Than Two Days");

db.shipments.aggregate([
    {
        $match: {
            delayDays: {
                $gt: 2
            }
        }
    },
    {
        $lookup: {
            from: "carriers",
            localField: "carrierId",
            foreignField: "carrierId",
            as: "carrier"
        }
    },
    {
        $unwind: "$carrier"
    },
    {
        $project: {
            _id: 0,
            trackingNumber: 1,
            carrierName: "$carrier.carrierName",
            delayDays: 1,
            shipmentStatus: 1
        }
    },
    {
        $sort: {
            delayDays: -1
        }
    }
]).forEach(printjson);

// ------------------------------------------
// 18. FINAL COLLECTION COUNTS
// ------------------------------------------

print("\nFINAL COLLECTION COUNTS");

collections.forEach(collectionName => {
    print(
        collectionName + ": " +
        db.getCollection(collectionName).countDocuments()
    );
});

print("\nLogistics Shipment Analysis Completed.");