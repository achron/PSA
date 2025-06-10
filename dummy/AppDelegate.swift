import UIKit
import PSATracker
import Firebase
import FirebaseMessaging
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        Messaging.messaging().delegate = self

        fetchFirebaseConfig { [weak self] result in
            guard let self = self else { return }
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
                completion(.success((false, nil)))
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
                FirebaseApp.configure()
                return
            }
            do {
                guard let plist = try PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [String: Any],
                      let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                    print("Failed to process plist or access documents directory")
                    FirebaseApp.configure()
                    return
                }
                let plistURL = documentsDirectory.appendingPathComponent("GoogleService-Info.plist")
                let plistData = try PropertyListSerialization.data(fromPropertyList: plist, format: .xml, options: 0)
                try plistData.write(to: plistURL)
                if let options = FirebaseOptions(contentsOfFile: plistURL.path) {
                    FirebaseApp.configure(options: options)
                } else {
                    print("Failed to create FirebaseOptions from plist")
                    FirebaseApp.configure()
                }
            } catch {
                print("Error processing plist: \(error)")
                FirebaseApp.configure()
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


    private func requestNotificationPermission(_ application: UIApplication) {
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { granted, error in
            if let error = error {
                print("Authorization error: \(error)")
            }
        }
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
}


extension AppDelegate: UNUserNotificationCenterDelegate, MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(fcmToken ?? "nil")")
        Preference.fcmToken = fcmToken ?? ""
        TrackerManager.shared.updateFcm()
        NotificationCenter.default.post(name: .init("FCMToken"), object: nil, userInfo: ["token": fcmToken ?? ""])  }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        print("Notification received: \(userInfo)")
        if let pnType = userInfo["pn_type"] as? String, pnType != "PUSH-NOTIFICATION-SEND-TEST" {
            let snowplowPayload = createSnowplowPayload(from: userInfo, eventType: "notification-delivered")
            print("Notification jigolo: \(snowplowPayload)")
            TrackerManager.shared.notificationReceivedEvernt(data: snowplowPayload)
        }
        completionHandler([]) // call handler to avoid iOS dropping the callback
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        print("Notification response: \(userInfo)")
        if let pnType = userInfo["pn_type"] as? String, pnType != "PUSH-NOTIFICATION-SEND-TEST" {
            let snowplowPayload = createSnowplowPayload(from: userInfo, eventType: "notification-clicked")
            TrackerManager.shared.notificationOpenedEvernt(data: snowplowPayload)
        }
        completionHandler()
    }

    private func createSnowplowPayload(from userInfo: [AnyHashable: Any], eventType: String) -> [String: Any] {
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
