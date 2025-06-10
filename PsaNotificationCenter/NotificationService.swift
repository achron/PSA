//
//  NotificationService.swift
//  PsaNotificationCenter
//

import UserNotifications
import FirebaseMessaging
import PSANotificationService   // Your shared library

class NotificationService: UNNotificationServiceExtension {
    private var contentHandler: ((UNNotificationContent) -> Void)?
    private var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(
        _ request: UNNotificationRequest,
        withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void
    ) {
        self.contentHandler = contentHandler
        // Copy the incoming content so we can modify it
        guard let mutableContent = request.content.mutableCopy() as? UNMutableNotificationContent else {
            // If for some reason we can’t get a mutable copy, just pass it straight through
            contentHandler(request.content)
            return
        }
        self.bestAttemptContent = mutableContent

        let userInfo = mutableContent.userInfo
        print("NotificationService didReceive: \(userInfo)")

        // 1) Fire your “delivered” event
        if let pnType = userInfo["pn_type"] as? String,
           pnType != "PUSH-NOTIFICATION-SEND-TEST"
        {
            // Build your payload however you need it:
            let payload = createSnowplowPayload(from: userInfo, eventType: "notification-delivered")
            TrackerManager.shared.notificationReceivedEvernt(data: payload)
        }

        // 2) Let Firebase populate any rich media (images, etc.)
        Messaging.serviceExtension().populateNotificationContent(mutableContent) { content in
            // This closure *is* the system’s contentHandler
            contentHandler(content)
        }
    }

    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension is killed
        // Make sure we still hand off the bestAttemptContent if we can
        if let contentHandler = contentHandler, let bestContent = bestAttemptContent {
            contentHandler(bestContent)
        }
    }

    // If you need to recreate your Snowplow payload here:
    private func createSnowplowPayload(from userInfo: [AnyHashable: Any],
                                       eventType: String) -> [String: Any] {
        return [
            "campaign_id": userInfo["psa_campaign_id"] as? String ?? NSNull(),
            "user_id": NSNull(),
            "event_type": eventType,
            "club": userInfo["club"] as? String ?? NSNull(),
            "environment": userInfo["environment"] as? String ?? NSNull(),
            "customer_key": userInfo["customer_key"] as? String ?? NSNull(),
            "reasons": NSNull(),
            "campaign_source": "PUSH-NOTIFICATION",
            "platform_name": "ios",
            "click_url": userInfo["click_url"] as? String ?? NSNull(),
            "domain_userid": userInfo["_id"] as? String ?? NSNull()
        ]
    }
}
