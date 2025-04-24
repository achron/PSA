import UIKit
import PSATracker
import Firebase
import FirebaseMessaging

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
    
    // MARK: - Application Lifecycle
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Fetch Firebase config asynchronously
        fetchFirebaseConfig { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let (shouldInitialize, plistURL)):
                if shouldInitialize, let url = plistURL {
                    self.configureFirebaseWithCustomPlist(url: url)
                    self.requestNotificationPermission(application)
                } else {
                    self.disableFirebaseAndNotifications(application)
                }
            case .failure(let error):
                print("Failed to fetch Firebase config: \(error)")
                self.disableFirebaseAndNotifications(application)
            }
        }
        return true
    }
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {}
    
    // MARK: - Firebase Configuration
    
    private func fetchFirebaseConfig(completion: @escaping (Result<(Bool, URL?), Error>) -> Void) {
        let endpoint = "https://psapn.proemsports.com/api/ccgt/pn/ios/"
        guard let url = URL(string: endpoint) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid API URL"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data,
                  let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
               
                return
            }
            
            do {
                guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                      let configToggle = json["ios_config_toggle"] as? Bool,
                      let plistURLString = json["ios_private_key_url"] as? String,
                      let plistURL = URL(string: plistURLString) else {
                    completion(.success((false, nil)))
                    return
                }
                completion(.success((configToggle, configToggle ? plistURL : nil)))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    private func configureFirebaseWithCustomPlist(url: URL) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Failed to download plist: \(error?.localizedDescription ?? "Unknown error")")
                FirebaseApp.configure() // Fallback to default config
                return
            }
            
            do {
                guard let plist = try PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [String: Any],
                      let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                    print("Failed to process plist or access documents directory")
                    FirebaseApp.configure() // Fallback
                    return
                }
                
                let plistURL = documentsDirectory.appendingPathComponent("GoogleService-Info.plist")
                let plistData = try PropertyListSerialization.data(fromPropertyList: plist, format: .xml, options: 0)
                try plistData.write(to: plistURL)
                
                if let options = FirebaseOptions(contentsOfFile: plistURL.path) {
                    FirebaseApp.configure(options: options)
                    Messaging.messaging().delegate = self
                } else {
                    print("Failed to create FirebaseOptions from plist")
                    FirebaseApp.configure() // Fallback
                }
            } catch {
                print("Error processing plist: \(error)")
                FirebaseApp.configure() // Fallback
            }
        }.resume()
    }
    
    private func disableFirebaseAndNotifications(_ application: UIApplication) {
        application.unregisterForRemoteNotifications()
        
        if let app = FirebaseApp.app() {
            Messaging.messaging().deleteToken { error in
                print(error != nil ? "Error deleting FCM token: \(error!)" : "FCM token deleted")
            }
            app.delete { success in
                print(success ? "Firebase app deleted" : "Failed to delete Firebase app")
            }
        }
    }
    
    // MARK: - Notifications
    
    private func requestNotificationPermission(_ application: UIApplication) {
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { _, _ in }
        application.registerForRemoteNotifications()
        
        let action1 = UNNotificationAction(identifier: "action_1", title: "Back", options: [])
        let action2 = UNNotificationAction(identifier: "action_2", title: "Next", options: [])
        let action3 = UNNotificationAction(identifier: "action_3", title: "View In App", options: [])
        let category = UNNotificationCategory(identifier: "PSANotification", actions: [action1, action2, action3], intentIdentifiers: [], options: [])
        UNUserNotificationCenter.current().setNotificationCategories([category])
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for remote notifications: \(error)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        Messaging.messaging().appDidReceiveMessage(userInfo)
        completionHandler(.newData)
    }
    
    // MARK: - Firebase Messaging Delegate
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(fcmToken ?? "nil")")
        Preference.fcmToken = fcmToken ?? ""
        TrackerManager.shared.updateFcm()
        NotificationCenter.default.post(name: .init("FCMToken"), object: nil, userInfo: ["token": fcmToken ?? ""])
    }
    
    // MARK: - UNUserNotificationCenter Delegate
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        print("Notification received: \(userInfo)")
        
        if let pnType = userInfo["pn_type"] as? String, pnType != "PUSH-NOTIFICATION-SEND-TEST" {
            let snowplowPayload = createSnowplowPayload(from: userInfo, eventType: "notification-delivered")
            TrackerManager.shared.notificationReceivedEvernt(data: snowplowPayload)
        }
        // Uncomment this if you want to show the notification regardless of pn_type
        // completionHandler([.alert, .sound, .badge])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        print("Notification response: \(userInfo)")
        
        if let pnType = userInfo["pn_type"] as? String, pnType != "PUSH-NOTIFICATION-SEND-TEST" {
            let snowplowPayload = createSnowplowPayload(from: userInfo, eventType: "notification-clicked")
            TrackerManager.shared.notificationOpenedEvernt(data: snowplowPayload)
        }
        completionHandler()
    }
    // MARK: - Helper Methods
    
    private func createSnowplowPayload(from userInfo: [AnyHashable: Any], eventType: String) -> [String: Any] {
        let campaignId = userInfo["psa_campaign_id"] as? String
        let club = userInfo["club"] as? String
        let environment = userInfo["environment"] as? String
        let customerKey = userInfo["customer_key"] as? String
        let url = userInfo["click_url"] as? String
        let domainUserId = userInfo["_id"] as? String
        
        return [
            "campaign_id": campaignId ?? NSNull(),
            "user_id": NSNull(),
            "event_type": eventType,
            "club": club ?? NSNull(),
            "environment": environment ?? NSNull(),
            "customer_key": customerKey ?? NSNull(),
            "reasons": NSNull(),
            "campaign_source": "PUSH-NOTIFICATION",
            "platform_name": "ios",
            "click_url": url ?? NSNull(),
            "domain_userid": domainUserId ?? NSNull()
        ]
    }
}
