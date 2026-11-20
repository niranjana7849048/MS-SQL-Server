// Select database
use("TelecomDB");

// Create notification log collection
db.notification_log.insertMany([
    {
        notificationId: 1,
        subscriberId: 101,
        message: "Your balance is below 50.",
        isRead: false
    },
    {
        notificationId: 2,
        subscriberId: 101,
        message: "Recharge reminder.",
        isRead: false
    },
    {
        notificationId: 3,
        subscriberId: 102,
        message: "Your recharge was successful.",
        isRead: true
    },
    {
        notificationId: 4,
        subscriberId: 103,
        message: "Your balance is below 50.",
        isRead: false
    },
    {
        notificationId: 5,
        subscriberId: 103,
        message: "Recharge reminder.",
        isRead: false
    }
]);

// Remove existing view if present
db.unread_notification_summary.drop();

// Create view showing unread count per subscriber
db.createView(
    "unread_notification_summary",
    "notification_log",
    [
        {
            $match: {
                isRead: false
            }
        },
        {
            $group: {
                _id: "$subscriberId",
                unreadCount: {
                    $sum: 1
                }
            }
        },
        {
            $project: {
                _id: 0,
                subscriberId: "$_id",
                unreadCount: 1
            }
        },
        {
            $sort: {
                subscriberId: 1
            }
        }
    ]
);

// Display view
db.unread_notification_summary.find();