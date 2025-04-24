//
//  NotificationService.swift
//  PsaNotificationCenter
//
//  Created by Tejas Kashyap on 24/01/24.


import UserNotifications
import FirebaseMessaging
import PSANotificationService

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        let userInfo = request.content.userInfo
        
        print("Notification Data for Dev \(userInfo)")
        if let bestAttemptContent = bestAttemptContent {
            // Modify the notification content here...
            bestAttemptContent.title = "\(bestAttemptContent.title)"
            print("Notification Title is \(bestAttemptContent.title)")
            TrackerManager.shared.notificationReceivedEvernt(data: bestAttemptContent.userInfo)
            
            //contentHandler(bestAttemptContent)
            Messaging.serviceExtension().populateNotificationContent(bestAttemptContent, withContentHandler: contentHandler)
        }
    }
    


}


//class NotificationService: PsaNotificationServiceExtension {
//    
//    var contentHandler: ((UNNotificationContent) -> Void)?
//    var bestAttemptContent: UNMutableNotificationContent?
//    
//    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
//        super.didReceive(request, withContentHandler: contentHandler)
//    }
//    
//    override func serviceExtensionTimeWillExpire() {
//        // Called just before the extension will be terminated by the system.
//        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
////        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
////            contentHandler(bestAttemptContent)
////        }
//    }
//}
