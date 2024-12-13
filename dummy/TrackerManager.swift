//
//  demo.swift
//  dummy
//
//  Created by Deepak on 24/10/23

import Foundation
import PSATracker

class TrackerManager{
    static var tracker:TrackerController? = PSATracker.createTracker(namespace: "psa-swift", endpoint: "https://internal.proemsportsanalytics.com") {
        TrackerConfiguration()
            .appId("psa-swift-ios")
            .base64Encoding(false)
            .sessionContext(false)
            .platformContext(true)
            .lifecycleAutotracking(false)
            .screenViewAutotracking(false)
            .screenContext(false)
            .applicationContext(false)
            .exceptionAutotracking(false)
            .installAutotracking(true)
            .userAnonymisation(false)
      
    }

    
    static func notificationReceivedEvernt(data:[AnyHashable : Any]){
        tracker?.subject?.userId = Preference.userId
        
        let data = ["campaign_source":  "PUSH-NOTIFICATION",
                    "campaign_id":  data["psa_campaign_id"] as? String ?? nil,
                    "user_id":  Preference.userId,
                    "event_type": "notification-dropped",
                    "club": data["club"] as? String ?? nil,
                    "environment": data["environment"] as? String ?? nil,
                    "customer_key": data["customer_key"]  as? String ?? nil,
                    "reasons": nil,
                    "platform_name": "ios"
        ]
        let event = SelfDescribing(schema: "iglu:com.proemsportsanalytics/notification_event/jsonschema/1-0-0", payload: data)
        let uuid = TrackerManager.tracker?.track(event)
        print("notificationReceivedEvernt - ",uuid ?? "")
    }
    static func notificationOpenedEvernt(data:[AnyHashable : Any]){
        tracker?.subject?.userId = Preference.userId
        
        
        let data = ["campaign_source":  "PUSH-NOTIFICATION",
                    "campaign_id":  data["psa_campaign_id"] as? String ?? nil,
                    "user_id":  Preference.userId,
                    "event_type": "notification-clicked",
                    "club": data["club"] as? String ?? nil,
                    "environment": data["environment"] as? String ?? nil,
                    "customer_key": data["customer_key"]  as? String ?? nil,
                    "reasons": nil,
                    "platform_name": "ios"
        ]

        let event = SelfDescribing(schema: "iglu:com.proemsportsanalytics/notification_event/jsonschema/1-0-0", payload: data)
        let uuid = TrackerManager.tracker?.track(event)
        print("notificationOpenedEvernt - ",uuid ?? "")
    }
    
    static func updateFcm(){
        tracker?.subject?.userId = Preference.userId
        let event = SelfDescribing(schema: "iglu:com.proemsportsanalytics/update_fcm_token/jsonschema/1-0-0", payload:[ "fcm_token": Preference.fcmToken ] )
        TrackerManager.tracker?.track(event)
    }
    static func loginEvent(){
        tracker?.subject?.userId = Preference.userId
        let data1 = ["user_id": Preference.userId  ];
        let event = SelfDescribing(schema: "iglu:com.proemsportsanalytics/login/jsonschema/1-0-0", payload: data1)
         TrackerManager.tracker?.track(event)
    }
    static func logout(){
        tracker?.subject?.userId = Preference.userId
        let data = ["user_id": Preference.userId  ];
        let event = SelfDescribing(schema: "iglu:com.proemsportsanalytics/logout/jsonschema/1-0-0", payload: data)
        TrackerManager.tracker?.track(event)
    }
    static func userEvent(){
        tracker?.subject?.userId = Preference.userId
        let data = [
            "email": Preference.email,
            "firstName": "YOUR_FIRST_NAME",
            "lastName": "YOUR_LAST_NAME",
            "phone": "YOUR_PHONE",
            "gender": "YOUR_GENDER",
            "dob": "YOUR_DOB",
            "country": "YOUR_COUNTRY",
            "state": "YOUR_STATE",
            "city": "YOUR_CITY"
        ]
        let event = SelfDescribing(schema: "iglu:com.proemsportsanalytics/user_attributes/jsonschema/1-0-0", payload: data)
        TrackerManager.tracker?.track(event)
    }
}
