// Select database
use("InsuranceDB");

// Create customer communications collection
db.customer_communications.insertMany([
    {
        communicationId: 1,
        customerName: "Rahul Kumar",
        message: "Premium payment clarification",
        complaintStatus: "Unresolved"
    },
    {
        communicationId: 2,
        customerName: "Ananya Sharma",
        message: "Policy renewal confirmation",
        complaintStatus: "Resolved"
    },
    {
        communicationId: 3,
        customerName: "Vikram Raj",
        message: "Claim processing delay",
        complaintStatus: "Unresolved"
    },
    {
        communicationId: 4,
        customerName: "Rahul Kumar",
        message: "Policy document request",
        complaintStatus: "Unresolved"
    }
]);

// Remove existing view if present
db.unresolved_customer_complaints.drop();

// Create view for unresolved complaints
db.createView(
    "unresolved_customer_complaints",
    "customer_communications",
    [
        {
            $match: {
                complaintStatus: "Unresolved"
            }
        },
        {
            $project: {
                _id: 0,
                communicationId: 1,
                customerName: 1,
                message: 1,
                complaintStatus: 1
            }
        }
    ]
);

// Display unresolved complaints
db.unresolved_customer_complaints.find();