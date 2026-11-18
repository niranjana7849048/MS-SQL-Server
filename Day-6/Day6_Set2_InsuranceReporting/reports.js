
use("InsuranceReporting");

// =========================================
// 1. CREATE COLLECTION
// =========================================

if (!db.getCollectionNames().includes("claimsNotes")) {
    db.createCollection("claimsNotes");
}

const claims = db.getCollection("claimsNotes");

// =========================================
// 2. INSERT SAMPLE CLAIM DOCUMENTS
// =========================================

claims.insertMany([
    {
        claimId: 1,
        policyId: 1001,
        customerName: "Arun Kumar",
        claimStatus: "Settled",
        claimAmount: 5000,
        settlementAmount: 4500,
        claimDate: ISODate("2026-03-01"),
        settlementDate: ISODate("2026-03-10"),
        damageCategory: "Medical",
        notes: "Medical expenses verified"
    },
    {
        claimId: 2,
        policyId: 1002,
        customerName: "Priya Sharma",
        claimStatus: "Settled",
        claimAmount: 8000,
        settlementAmount: 7500,
        claimDate: ISODate("2026-04-05"),
        settlementDate: ISODate("2026-04-20"),
        damageCategory: "Life",
        notes: "Claim approved after document verification"
    },
    {
        claimId: 3,
        policyId: 1003,
        customerName: "Rahul Verma",
        claimStatus: "Pending",
        claimAmount: 6000,
        settlementAmount: null,
        claimDate: ISODate("2026-05-10"),
        settlementDate: null,
        damageCategory: "Accident",
        notes: "Documents awaiting verification"
    },
    {
        claimId: 4,
        policyId: 1004,
        customerName: "Arun Kumar",
        claimStatus: "Settled",
        claimAmount: 10000,
        settlementAmount: 9000,
        claimDate: ISODate("2026-06-01"),
        settlementDate: ISODate("2026-06-15"),
        damageCategory: "Life",
        notes: "Settlement completed"
    },
    {
        claimId: 5,
        policyId: 1006,
        customerName: "Karthik S",
        claimStatus: "Under Review",
        claimAmount: 3000,
        settlementAmount: null,
        claimDate: ISODate("2026-07-01"),
        settlementDate: null,
        damageCategory: "Vehicle",
        notes: "Vehicle inspection in progress"
    },
    {
        claimId: 6,
        policyId: 1008,
        customerName: "Vikram Rao",
        claimStatus: "Settled",
        claimAmount: 4000,
        settlementAmount: 3500,
        claimDate: ISODate("2026-08-01"),
        settlementDate: ISODate("2026-08-12"),
        damageCategory: "Medical",
        notes: "Medical claim approved"
    },
    {
        claimId: 7,
        policyId: 1001,
        customerName: "Arun Kumar",
        claimStatus: "Settled",
        claimAmount: 2000,
        settlementAmount: 1800,
        claimDate: ISODate("2026-09-01"),
        settlementDate: ISODate("2026-09-05"),
        damageCategory: "Medical",
        notes: "Follow-up medical expenses approved"
    },
    {
        claimId: 8,
        policyId: 1007,
        customerName: "Divya Nair",
        claimStatus: "Pending",
        claimAmount: 2500,
        settlementAmount: null,
        claimDate: ISODate("2026-10-01"),
        settlementDate: null,
        damageCategory: "Travel",
        notes: "Travel documents under review"
    }
]);

// =========================================
// 3. PIPELINE 1: CLAIMS PER STATUS
// =========================================

print("CLAIMS PER STATUS");

claims.aggregate([
    {
        $match: {
            claimStatus: { $exists: true, $ne: null }
        }
    },
    {
        $group: {
            _id: "$claimStatus",
            totalClaims: { $sum: 1 },
            totalClaimAmount: { $sum: "$claimAmount" }
        }
    },
    {
        $sort: { totalClaims: -1 }
    }
]).forEach(printjson);

// =========================================
// 4. PIPELINE 2: AVERAGE SETTLEMENT TIME
// =========================================

print("AVERAGE SETTLEMENT TIME");

claims.aggregate([
    {
        $match: {
            settlementDate: { $type: "date" },
            claimDate: { $type: "date" }
        }
    },
    {
        $group: {
            _id: null,
            averageSettlementDays: {
                $avg: {
                    $divide: [
                        { $subtract: ["$settlementDate", "$claimDate"] },
                        86400000
                    ]
                }
            },
            settledClaims: { $sum: 1 }
        }
    },
    {
        $project: {
            _id: 0,
            settledClaims: 1,
            averageSettlementDays: {
                $round: ["$averageSettlementDays", 2]
            }
        }
    }
]).forEach(printjson);

// =========================================
// 5. PIPELINE 3: TOP 3 DAMAGE CATEGORIES
// =========================================

print("TOP 3 DAMAGE CATEGORIES");

claims.aggregate([
    {
        $match: {
            damageCategory: { $exists: true, $ne: null }
        }
    },
    {
        $group: {
            _id: "$damageCategory",
            totalClaims: { $sum: 1 },
            totalClaimAmount: { $sum: "$claimAmount" }
        }
    },
    {
        $sort: {
            totalClaims: -1,
            totalClaimAmount: -1
        }
    },
    {
        $limit: 3
    }
]).forEach(printjson);

// =========================================
// 6. VERIFY TOTAL DOCUMENTS
// =========================================

print("TOTAL CLAIM DOCUMENTS:");
print(claims.countDocuments());
