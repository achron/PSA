//
//  demo.swift
//  dummy
//
//  Created by Deepak on 24/10/23

import Foundation
import PSATracker

class TrackerManager{
    static var tracker:TrackerController? = PSATracker.createTracker(namespace: "psa-swift", endpoint: "https://orga.proemsportsanalytics.com") {
        TrackerConfiguration()
            .appId("psa-swift-ios")
            .base64Encoding(false)
            .sessionContext(true)
            .platformContext(true)
            .lifecycleAutotracking(true)
            .screenViewAutotracking(true)
            .screenContext(true)
            .applicationContext(true)
            .exceptionAutotracking(true)
            .installAutotracking(true)
            .userAnonymisation(false)
        SessionConfiguration(
            foregroundTimeout: Measurement(value: 30, unit: .minutes),
            backgroundTimeout: Measurement(value: 30, unit: .minutes)
        )
    }

    
    static func notificationReceivedEvernt(data:[AnyHashable : Any]){
        tracker?.subject?.userId = Preference.userId
        
        let data = ["psa_ma_id":  data["psa_ma_id"] as? String ?? nil, "psa_campaign_id":  data["psa_campaign_id"] as? String ?? nil, "user_id":  Preference.userId, "psa_event_id": data["psa_event_id"] as? String ?? nil]
        let event = SelfDescribing(schema: "iglu:com.proemsportsanalytics/notification_received/jsonschema/1-0-0", payload: data)
        let uuid = TrackerManager.tracker?.track(event)
        print("notificationReceivedEvernt - ",uuid ?? "")
    }
    static func notificationOpenedEvernt(data:[AnyHashable : Any]){
        tracker?.subject?.userId = Preference.userId
        
        
        let data = ["psa_ma_id":  data["psa_ma_id"] as? String ?? nil, "psa_campaign_id":  data["psa_campaign_id"] as? String ?? nil, "user_id":  Preference.userId, "psa_event_id": data["psa_event_id"] as? String ?? nil]
        let event = SelfDescribing(schema: "iglu:com.proemsportsanalytics/notification_opened/jsonschema/1-0-0", payload: data)
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
