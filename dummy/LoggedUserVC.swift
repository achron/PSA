//
//  ViewControllerLoggedUser.swift
//  dummy
//

import Foundation
import UIKit
import PSATracker
import FirebaseMessaging

class LoggedUserVC: UIViewController  {
    
    @IBOutlet weak var labelUserName: UILabel!
    var message : String = ""
    
    var  token = Preference.fcmToken
    override func viewDidLoad() {
        super.viewDidLoad()
        labelUserName.text = "FCMToken = \(Preference.fcmToken)"
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(labelDidGetTapped))

        labelUserName.isUserInteractionEnabled = true
        labelUserName.addGestureRecognizer(tapGesture)
        
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching FCM registration token: \(error)")
            } else if let token = token {
                self.token = token
                print("FCM registration token: \(token)")
                Preference.fcmToken =  token
                TrackerManager.shared.updateFcm()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        TrackerManager.shared.userEvent()
    }
    
    @objc func labelDidGetTapped(sender: UITapGestureRecognizer) {
        guard let label = sender.view as? UILabel else {
            return
        }
        UIPasteboard.general.string = self.token
    }
    
    @IBAction func logOutAction(_ sender: UIButton) {
        TrackerManager.shared.logout()
        Preference.deleteAll()

        if let loggedVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ViewController") as? ViewController {
            UIApplication.firstKeyWindowForConnectedScenes?.rootViewController = loggedVC
            UIApplication.firstKeyWindowForConnectedScenes?.makeKeyAndVisible()
        }
    }
}


