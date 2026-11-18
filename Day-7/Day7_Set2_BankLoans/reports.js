
// Day 7 - Set 2
// Bank Loan Portfolio
// MongoDB Aggregation and $lookup

use("BankLoanReporting");

// ==========================================
// 1. CREATE COLLECTIONS
// ==========================================

const collections = [
    "branches",
    "customers",
    "loans",
    "loanGuarantors",
    "repayments"
];

collections.forEach(name => {
    if (!db.getCollectionNames().includes(name)) {
        db.createCollection(name);
    }
});

collections.forEach(name => {
    db.getCollection(name).deleteMany({});
});

// ==========================================
// 2. INSERT BRANCHES
// ==========================================

db.branches.insertMany([
    { branchId: 1, branchName: "Chennai Main Branch", city: "Chennai" },
    { branchId: 2, branchName: "Bangalore Branch", city: "Bangalore" },
    { branchId: 3, branchName: "Coimbatore Branch", city: "Coimbatore" },
    { branchId: 4, branchName: "Hyderabad Branch", city: "Hyderabad" },
    { branchId: 5, branchName: "Mumbai Branch", city: "Mumbai" }
]);

// ==========================================
// 3. INSERT CUSTOMERS
// ==========================================

db.customers.insertMany([
    { customerId: 101, customerName: "Arun Kumar", city: "Chennai", email: "arun@example.com" },
    { customerId: 102, customerName: "Priya Sharma", city: "Bangalore", email: "priya@example.com" },
    { customerId: 103, customerName: "Rahul Verma", city: "Chennai", email: "rahul@example.com" },
    { customerId: 104, customerName: "Sneha Raj", city: "Coimbatore", email: "sneha@example.com" },
    { customerId: 105, customerName: "Karthik S", city: "Bangalore", email: "karthik@example.com" },
    { customerId: 106, customerName: "Divya Nair", city: "Hyderabad", email: "divya@example.com" },
    { customerId: 107, customerName: "Vijay Kumar", city: "Mumbai", email: "vijay@example.com" },
    { customerId: 108, customerName: "Meena Das", city: "Chennai", email: "meena@example.com" },
    { customerId: 109, customerName: "Sanjay Rao", city: "Coimbatore", email: "sanjay@example.com" },
    { customerId: 110, customerName: "Anitha Das", city: "Hyderabad", email: "anitha@example.com" }
]);

// ==========================================
// 4. INSERT LOANS
// ==========================================

db.loans.insertMany([
    { loanId: 1001, customerId: 101, branchId: 1, loanType: "Home Loan", principalAmount: 2500000, interestRate: 8.50, loanDate: ISODate("2025-01-10"), loanStatus: "Active", totalInstallments: 120, installmentsPaid: 110 },
    { loanId: 1002, customerId: 102, branchId: 2, loanType: "Personal Loan", principalAmount: 500000, interestRate: 11.00, loanDate: ISODate("2025-02-15"), loanStatus: "Active", totalInstallments: 36, installmentsPaid: 20 },
    { loanId: 1003, customerId: 103, branchId: 1, loanType: "Vehicle Loan", principalAmount: 800000, interestRate: 9.50, loanDate: ISODate("2025-03-20"), loanStatus: "Active", totalInstallments: 60, installmentsPaid: 45 },
    { loanId: 1004, customerId: 104, branchId: 3, loanType: "Home Loan", principalAmount: 3000000, interestRate: 8.25, loanDate: ISODate("2025-04-05"), loanStatus: "Active", totalInstallments: 180, installmentsPaid: 160 },
    { loanId: 1005, customerId: 105, branchId: 2, loanType: "Education Loan", principalAmount: 600000, interestRate: 7.50, loanDate: ISODate("2025-05-12"), loanStatus: "Active", totalInstallments: 60, installmentsPaid: 30 },
    { loanId: 1006, customerId: 101, branchId: 2, loanType: "Personal Loan", principalAmount: 400000, interestRate: 12.00, loanDate: ISODate("2025-06-18"), loanStatus: "Active", totalInstallments: 24, installmentsPaid: 10 },
    { loanId: 1007, customerId: 106, branchId: 4, loanType: "Vehicle Loan", principalAmount: 900000, interestRate: 9.00, loanDate: ISODate("2025-07-22"), loanStatus: "Active", totalInstallments: 48, installmentsPaid: 25 },
    { loanId: 1008, customerId: 107, branchId: 1, loanType: "Business Loan", principalAmount: 1500000, interestRate: 10.50, loanDate: ISODate("2025-08-10"), loanStatus: "Active", totalInstallments: 60, installmentsPaid: 35 },
    { loanId: 1009, customerId: 108, branchId: 3, loanType: "Personal Loan", principalAmount: 300000, interestRate: 12.50, loanDate: ISODate("2025-09-14"), loanStatus: "Active", totalInstallments: 24, installmentsPaid: 8 },
    { loanId: 1010, customerId: 109, branchId: 4, loanType: "Home Loan", principalAmount: 2000000, interestRate: 8.75, loanDate: ISODate("2025-10-19"), loanStatus: "Active", totalInstallments: 120, installmentsPaid: 80 },
    { loanId: 1011, customerId: 102, branchId: 1, loanType: "Vehicle Loan", principalAmount: 700000, interestRate: 9.25, loanDate: ISODate("2025-11-25"), loanStatus: "Active", totalInstallments: 48, installmentsPaid: 20 },
    { loanId: 1012, customerId: 110, branchId: 2, loanType: "Education Loan", principalAmount: 450000, interestRate: 7.25, loanDate: ISODate("2025-12-05"), loanStatus: "Active", totalInstallments: 60, installmentsPaid: 15 }
]);

// ==========================================
// 5. INSERT LOAN GUARANTORS
// ==========================================

db.loanGuarantors.insertMany([
    { loanId: 1001, guarantorCustomerId: 102 },
    { loanId: 1002, guarantorCustomerId: 101 },
    { loanId: 1003, guarantorCustomerId: 104 },
    { loanId: 1004, guarantorCustomerId: 105 },
    { loanId: 1005, guarantorCustomerId: 103 },
    { loanId: 1006, guarantorCustomerId: 107 },
    { loanId: 1007, guarantorCustomerId: 101 },
    { loanId: 1008, guarantorCustomerId: 106 },
    { loanId: 1009, guarantorCustomerId: 102 },
    { loanId: 1010, guarantorCustomerId: 108 },
    { loanId: 1011, guarantorCustomerId: 109 },
    { loanId: 1012, guarantorCustomerId: 103 }
]);

// ==========================================
// 6. INSERT REPAYMENTS
// ==========================================

db.repayments.insertMany([
    { repaymentId: 1, loanId: 1001, repaymentDate: ISODate("2026-10-10"), amount: 25000, paymentStatus: "Paid" },
    { repaymentId: 2, loanId: 1001, repaymentDate: ISODate("2026-11-10"), amount: 25000, paymentStatus: "Paid" },
    { repaymentId: 3, loanId: 1002, repaymentDate: ISODate("2026-08-15"), amount: 15000, paymentStatus: "Paid" },
    { repaymentId: 4, loanId: 1002, repaymentDate: ISODate("2026-09-15"), amount: 15000, paymentStatus: "Paid" },
    { repaymentId: 5, loanId: 1003, repaymentDate: ISODate("2026-11-05"), amount: 18000, paymentStatus: "Paid" },
    { repaymentId: 6, loanId: 1004, repaymentDate: ISODate("2026-10-05"), amount: 30000, paymentStatus: "Paid" },
    { repaymentId: 7, loanId: 1005, repaymentDate: ISODate("2026-07-12"), amount: 12000, paymentStatus: "Paid" },
    { repaymentId: 8, loanId: 1006, repaymentDate: ISODate("2026-11-12"), amount: 20000, paymentStatus: "Paid" },
    { repaymentId: 9, loanId: 1007, repaymentDate: ISODate("2026-08-22"), amount: 19000, paymentStatus: "Paid" },
    { repaymentId: 10, loanId: 1008, repaymentDate: ISODate("2026-11-01"), amount: 28000, paymentStatus: "Paid" },
    { repaymentId: 11, loanId: 1009, repaymentDate: ISODate("2026-06-14"), amount: 14000, paymentStatus: "Paid" },
    { repaymentId: 12, loanId: 1010, repaymentDate: ISODate("2026-09-19"), amount: 22000, paymentStatus: "Paid" },
    { repaymentId: 13, loanId: 1011, repaymentDate: ISODate("2026-11-15"), amount: 16000, paymentStatus: "Paid" },
    { repaymentId: 14, loanId: 1012, repaymentDate: ISODate("2026-10-05"), amount: 10000, paymentStatus: "Paid" },
    { repaymentId: 15, loanId: 1003, repaymentDate: ISODate("2026-10-05"), amount: 18000, paymentStatus: "Paid" },
    { repaymentId: 16, loanId: 1004, repaymentDate: ISODate("2026-11-05"), amount: 30000, paymentStatus: "Paid" },
    { repaymentId: 17, loanId: 1007, repaymentDate: ISODate("2026-07-22"), amount: 19000, paymentStatus: "Paid" },
    { repaymentId: 18, loanId: 1009, repaymentDate: ISODate("2026-05-14"), amount: 14000, paymentStatus: "Paid" }
]);

// ==========================================
// REPORT 1
// Loans with customer and branch details
// ==========================================

print("\nREPORT 1: Loan Details with Customer and Branch");

db.loans.aggregate([
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
            from: "branches",
            localField: "branchId",
            foreignField: "branchId",
            as: "branch"
        }
    },
    { $unwind: "$customer" },
    { $unwind: "$branch" },
    {
        $project: {
            _id: 0,
            loanId: 1,
            customerName: "$customer.customerName",
            branchName: "$branch.branchName",
            loanType: 1,
            principalAmount: 1,
            interestRate: 1,
            loanStatus: 1
        }
    },
    { $sort: { loanId: 1 } }
]).forEach(printjson);

// ==========================================
// REPORT 2
// Branch-wise loan exposure
// ==========================================

print("\nREPORT 2: Branch-wise Loan Exposure");

db.branches.aggregate([
    {
        $lookup: {
            from: "loans",
            localField: "branchId",
            foreignField: "branchId",
            as: "branchLoans"
        }
    },
    {
        $project: {
            _id: 0,
            branchId: 1,
            branchName: 1,
            totalLoans: { $size: "$branchLoans" },
            totalExposure: { $sum: "$branchLoans.principalAmount" },
            averageLoanAmount: { $avg: "$branchLoans.principalAmount" }
        }
    },
    { $sort: { totalExposure: -1 } }
]).forEach(printjson);

// ==========================================
// REPORT 3
// Customers with loans in multiple branches
// ==========================================

print("\nREPORT 3: Customers with Loans in Multiple Branches");

db.customers.aggregate([
    {
        $lookup: {
            from: "loans",
            localField: "customerId",
            foreignField: "customerId",
            as: "customerLoans"
        }
    },
    {
        $project: {
            _id: 0,
            customerId: 1,
            customerName: 1,
            branchIds: {
                $setUnion: [
                    "$customerLoans.branchId",
                    []
                ]
            }
        }
    },
    {
        $addFields: {
            numberOfBranches: { $size: "$branchIds" }
        }
    },
    {
        $match: {
            numberOfBranches: { $gt: 1 }
        }
    }
]).forEach(printjson);

// ==========================================
// REPORT 4
// Guarantors who are also borrowers
// ==========================================

print("\nREPORT 4: Guarantors Who Are Also Borrowers");

db.loanGuarantors.aggregate([
    {
        $lookup: {
            from: "customers",
            localField: "guarantorCustomerId",
            foreignField: "customerId",
            as: "guarantor"
        }
    },
    {
        $lookup: {
            from: "loans",
            localField: "guarantorCustomerId",
            foreignField: "customerId",
            as: "ownLoans"
        }
    },
    {
        $lookup: {
            from: "loans",
            localField: "loanId",
            foreignField: "loanId",
            as: "guaranteedLoan"
        }
    },
    { $unwind: "$guarantor" },
    { $unwind: "$guaranteedLoan" },
    {
        $match: {
            "ownLoans.0": { $exists: true }
        }
    },
    {
        $project: {
            _id: 0,
            loanId: 1,
            guarantorName: "$guarantor.customerName",
            guarantorCustomerId: "$guarantor.customerId",
            guaranteedBorrowerId: "$guaranteedLoan.customerId"
        }
    }
]).forEach(printjson);

// ==========================================
// REPORT 5
// Branches without loans
// ==========================================

print("\nREPORT 5: Branches Without Loans");

db.branches.aggregate([
    {
        $lookup: {
            from: "loans",
            localField: "branchId",
            foreignField: "branchId",
            as: "branchLoans"
        }
    },
    {
        $match: {
            branchLoans: { $size: 0 }
        }
    },
    {
        $project: {
            _id: 0,
            branchId: 1,
            branchName: 1,
            city: 1
        }
    }
]).forEach(printjson);

// ==========================================
// REPORT 6
// Loan details with repayment totals
// ==========================================

print("\nREPORT 6: Total Repayment by Loan");

db.loans.aggregate([
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
            from: "repayments",
            let: { currentLoanId: "$loanId" },
            pipeline: [
                {
                    $match: {
                        $expr: {
                            $and: [
                                { $eq: ["$loanId", "$$currentLoanId"] },
                                { $eq: ["$paymentStatus", "Paid"] }
                            ]
                        }
                    }
                }
            ],
            as: "paidRepayments"
        }
    },
    { $unwind: "$customer" },
    {
        $project: {
            _id: 0,
            loanId: 1,
            customerName: "$customer.customerName",
            principalAmount: 1,
            totalRepaid: { $sum: "$paidRepayments.amount" }
        }
    },
    { $sort: { loanId: 1 } }
]).forEach(printjson);

// ==========================================
// REPORT 7
// Loans with no repayment in last 60 days
// Reference date: 18 November 2026
// ==========================================

print("\nREPORT 7: Loans Without Recent Repayments");

db.loans.aggregate([
    {
        $lookup: {
            from: "repayments",
            let: { currentLoanId: "$loanId" },
            pipeline: [
                {
                    $match: {
                        $expr: {
                            $and: [
                                { $eq: ["$loanId", "$$currentLoanId"] },
                                { $eq: ["$paymentStatus", "Paid"] },
                                {
                                    $gte: [
                                        "$repaymentDate",
                                        ISODate("2026-09-19")
                                    ]
                                },
                                {
                                    $lte: [
                                        "$repaymentDate",
                                        ISODate("2026-11-18")
                                    ]
                                }
                            ]
                        }
                    }
                }
            ],
            as: "recentRepayments"
        }
    },
    {
        $match: {
            recentRepayments: { $size: 0 }
        }
    },
    {
        $lookup: {
            from: "customers",
            localField: "customerId",
            foreignField: "customerId",
            as: "customer"
        }
    },
    { $unwind: "$customer" },
    {
        $project: {
            _id: 0,
            loanId: 1,
            customerName: "$customer.customerName",
            loanType: 1,
            principalAmount: 1
        }
    },
    { $sort: { loanId: 1 } }
]).forEach(printjson);

// ==========================================
// REPORT 8
// Loans with at least one recent repayment
// ==========================================

print("\nREPORT 8: Loans with Recent Repayments");

db.loans.aggregate([
    {
        $lookup: {
            from: "repayments",
            let: { currentLoanId: "$loanId" },
            pipeline: [
                {
                    $match: {
                        $expr: {
                            $and: [
                                { $eq: ["$loanId", "$$currentLoanId"] },
                                { $eq: ["$paymentStatus", "Paid"] },
                                {
                                    $gte: [
                                        "$repaymentDate",
                                        ISODate("2026-09-19")
                                    ]
                                },
                                {
                                    $lte: [
                                        "$repaymentDate",
                                        ISODate("2026-11-18")
                                    ]
                                }
                            ]
                        }
                    }
                }
            ],
            as: "recentRepayments"
        }
    },
    {
        $match: {
            "recentRepayments.0": { $exists: true }
        }
    },
    {
        $project: {
            _id: 0,
            loanId: 1,
            loanType: 1,
            recentPaymentCount: { $size: "$recentRepayments" },
            recentPaymentTotal: { $sum: "$recentRepayments.amount" }
        }
    },
    { $sort: { loanId: 1 } }
]).forEach(printjson);

// ==========================================
// REPORT 9
// Customers with loan amount above average
// ==========================================

print("\nREPORT 9: Loans Above Overall Average");

const averageLoan = db.loans.aggregate([
    {
        $group: {
            _id: null,
            averageAmount: { $avg: "$principalAmount" }
        }
    }
]).toArray()[0].averageAmount;

db.loans.aggregate([
    {
        $match: {
            principalAmount: { $gt: averageLoan }
        }
    },
    {
        $lookup: {
            from: "customers",
            localField: "customerId",
            foreignField: "customerId",
            as: "customer"
        }
    },
    { $unwind: "$customer" },
    {
        $project: {
            _id: 0,
            loanId: 1,
            customerName: "$customer.customerName",
            loanType: 1,
            principalAmount: 1
        }
    },
    { $sort: { principalAmount: -1 } }
]).forEach(printjson);

// ==========================================
// REPORT 10
// Branches with highest loan amount above
// bank-wide average of branch maximums
// ==========================================

print("\nREPORT 10: Branches Above Average Branch Maximum");

const branchMaximums = db.loans.aggregate([
    {
        $group: {
            _id: "$branchId",
            highestLoan: { $max: "$principalAmount" }
        }
    },
    {
        $group: {
            _id: null,
            averageBranchMaximum: { $avg: "$highestLoan" }
        }
    }
]).toArray()[0].averageBranchMaximum;

db.branches.aggregate([
    {
        $lookup: {
            from: "loans",
            localField: "branchId",
            foreignField: "branchId",
            as: "branchLoans"
        }
    },
    {
        $project: {
            _id: 0,
            branchId: 1,
            branchName: 1,
            highestLoan: { $max: "$branchLoans.principalAmount" }
        }
    },
    {
        $match: {
            highestLoan: { $gt: branchMaximums }
        }
    },
    { $sort: { highestLoan: -1 } }
]).forEach(printjson);

// ==========================================
// FINAL COLLECTION COUNTS
// ==========================================

print("\nFINAL COLLECTION COUNTS");

collections.forEach(name => {
    print(name + ": " + db.getCollection(name).countDocuments());
});

print("\nBank Loan Portfolio Analysis Completed.");
