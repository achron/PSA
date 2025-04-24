

import Foundation
import PSATracker

class TrackerManager {
     var tracker: TrackerController?
static let shared = TrackerManager()
    private init (){
        initializeTracker()
    }
     func initializeTracker() {
        guard let url = URL(string: "https://psapn.proemsports.com/api/ccgt/tracker/ios/") else {
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
            }

            guard let data = data else {
                return
            }

            if let rawResponse = String(data: data, encoding: .utf8) {
               
            }

            do {
        
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {


                    if let enableTracker = json["constants"] as? String {
                        
                        if enableTracker == "p" {
            
                            self.tracker = PSATracker.createTracker(namespace: "psa-swift", endpoint: "https://psasdk.proemsportsanalytics.com") {
                                TrackerConfiguration()
                                    .appId("ccgt-swift-ios")
                                    .base64Encoding(true)
                                    .sessionContext(true)
                                    .platformContext(true)
                                    .lifecycleAutotracking(true)
                                    .screenViewAutotracking(true)
                                    .screenContext(true)
                                    .applicationContext(true)
                                    .exceptionAutotracking(true)
                                    .installAutotracking(true)
                                    .userAnonymisation(false)
                            }
                            print("Tracker initialized successfully")
                        } else {
                            print("Tracker disabled based on API response")
                        }
                    } else {
                        print("`enableTracker` key not found in API response")
                    }
                } else {
                    print("Unable to parse API response as JSON")
                }
            } catch {
                print("Failed to parse API response with error: \(error.localizedDescription)")
            }
        }

        task.resume()
    }

     func notificationReceivedEvernt(data: [AnyHashable: Any]) {
        guard let payload = data as? [String: Any] else {
            return
        }
        
        let event = SelfDescribing(
            schema: "iglu:com.proemsportsanalytics/notification_event/jsonschema/1-0-0",
            payload: payload
        )

        let uuid = tracker?.track(event)
    }

     func notificationOpenedEvernt(data: [AnyHashable: Any]) {
        guard let payload = data as? [String: Any] else {
            print("Invalid data format for notificationOpenedEvernt")
            return
        }
        let event = SelfDescribing(
            schema: "iglu:com.proemsportsanalytics/notification_event/jsonschema/1-0-0",
            payload: payload
        )
        let uuid = tracker?.track(event)
    }

     func updateFcm() {
        tracker?.subject?.userId = Preference.userId
        let event = SelfDescribing(
            schema: "iglu:com.proemsportsanalytics/update_fcm_token/jsonschema/1-0-0",
            payload: ["fcm_token": Preference.fcmToken]
        )
        tracker?.track(event)
    }

     func loginEvent() {
        tracker?.subject?.userId = Preference.userId
        let data = ["user_id": Preference.userId]
        let event = SelfDescribing(
            schema: "iglu:com.proemsportsanalytics/login/jsonschema/1-0-0",
            payload: data
        )
        let uuid = tracker?.track(event)
    }

     func logout() {
        tracker?.subject?.userId = Preference.userId
        let data = ["user_id": Preference.userId]
        let event = SelfDescribing(
            schema: "iglu:com.proemsportsanalytics/logout/jsonschema/1-0-0",
            payload: data
        )
        let uuid = tracker?.track(event)
    }

    func userEvent() {
        guard let tracker = tracker else {
            print("Error: Tracker not initialized")
            return
        }
        tracker.subject?.userId = Preference.userId
        let data = [
            "email": Preference.email,
            "firstName": Preference.name,
            "lastName": "YOUR_LAST_NAME",
            "phone": "YOUR_PHONE",
            "gender": "YOUR_GENDER",
            "dob": "YOUR_DOB",
            "country": "YOUR_COUNTRY",
            "state": "YOUR_STATE",
            "city": "YOUR_CITY"
        ]
        print("Preparing to track userEvent with data: \(data)")
        let event = SelfDescribing(
            schema: "iglu:com.proemsportsanalytics/user_attributes/jsonschema/1-0-0",
            payload: data
        )
        let uuid = tracker.track(event)

    }
}
