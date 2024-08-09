//
//  NotificationViewController.swift
//  PsaNotificationContentCenter
//
//  Created by Tejas Kashyap on 30/01/24.


import UIKit
import UserNotifications
import UserNotificationsUI
import PSANotificationContent

class NotificationViewController: PsaNotificationContentViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func userDidPerformAction(_ action: String, withProperties properties: [String : Any]) {
        print("userDidPerformAction \(action) with props \(String(describing: properties))")
    }
    
    
    // optional: implement to get notification response
    override func userDidReceive(_ response: UNNotificationResponse?) {
        print("Push Notification Payload \(String(describing: response?.notification.request.content.userInfo))")
        let notificationPayload = response?.notification.request.content.userInfo
        if (response?.actionIdentifier == "action_2") {
//            CleverTap.sharedInstance()?.recordNotificationClickedEvent(withData: notificationPayload ?? "")
        }
    }
}
