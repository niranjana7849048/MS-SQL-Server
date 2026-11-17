
use("HospitalPatientRecords");

// Create collection with schema validation
if (!db.getCollectionNames().includes("clinicalNotes")) {
    db.createCollection("clinicalNotes", {
        validator: {
            $jsonSchema: {
                bsonType: "object",
                required: [
                    "noteId",
                    "patientId",
                    "diagnosis",
                    "noteDate"
                ],pa?
                properties: {
                    noteId: {
                        bsonType: "string"
                    },
                    patientId: {
                        bsonType: "int"
                    },
                    diagnosis: {
                        bsonType: "string"
                    },
                    noteDate: {
                        bsonType: "date"
                    },
                    symptoms: {
                        bsonType: "array",
                        items: { bsonType: "string" }
                    },
                    vitals: {
                        bsonType: "object"
                    },
                    labResults: {
                        bsonType: "array"
                    },
                    treatmentPlan: {
                        bsonType: "string"
                    },
                    followUp: {
                        bsonType: "object"
                    }
                }
            }
        }
    });
}

const notes = db.getCollection("clinicalNotes");

// Insert documents with two different structures
notes.insertMany([
    {
        noteId: "N001",
        patientId: 1,
        diagnosis: "Hypertension",
        noteDate: ISODate("2026-11-10T09:00:00Z"),
        symptoms: ["Headache", "Dizziness"],
        vitals: {
            bloodPressure: "150/95",
            pulse: 88,
            temperature: 98.6
        },
        treatmentPlan: "Blood pressure medication and regular monitoring"
    },
    {
        noteId: "N002",
        patientId: 2,
        diagnosis: "Migraine",
        noteDate: ISODate("2026-11-11T10:00:00Z"),
        symptoms: ["Severe headache", "Sensitivity to light"],
        vitals: {
            bloodPressure: "120/80",
            pulse: 76
        },
        treatmentPlan: "Prescribed pain relief medication"
    },
    {
        noteId: "N003",
        patientId: 3,
        diagnosis: "Diabetes",
        noteDate: ISODate("2026-11-12T11:00:00Z"),
        labResults: [
            { test: "Blood Sugar", value: 180, unit: "mg/dL" },
            { test: "HbA1c", value: 7.5, unit: "%" }
        ],
        treatmentPlan: "Diet control and medication",
        followUp: {
            required: true,
            nextVisit: ISODate("2026-12-12T09:00:00Z")
        }
    },
    {
        noteId: "N004",
        patientId: 4,
        diagnosis: "Common cold",
        noteDate: ISODate("2026-11-13T12:00:00Z"),
        symptoms: ["Cough", "Runny nose"],
        treatmentPlan: "Rest and adequate fluids",
        followUp: {
            required: false
        }
    }
]);

// Display all clinical notes
print("All clinical notes:");
notes.find().forEach(printjson);

// Query clinical notes by diagnosis
print("Notes for Hypertension:");
notes.find({ diagnosis: "Hypertension" }).forEach(printjson);

// Count documents
print("Total clinical notes:");
print(notes.countDocuments());
