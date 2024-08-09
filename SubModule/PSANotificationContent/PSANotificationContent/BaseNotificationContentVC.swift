//
//  BaseNotificationContentVC.swift
//  PSANotificationContent
//
//  Created by Tejas Kashyap on 06/02/24. 
//

import Foundation
import UIKit
import UserNotifications
import UserNotificationsUI

public class BaseNotificationContentVC: UIViewController {
    
    public var data: String = ""
    public var templateType: String = ""
    public var templateCaption: String = ""
    public var templateSubcaption: String = ""
    public var deeplinkURL: String = ""
    public var mediaType: String = ""
    public var mediaURL: String = ""
    public var isFromProductDisplay: Bool = false
    
    var parentNotificationViewController: PsaNotificationContentViewController? {
        return self.parent as? PsaNotificationContentViewController
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if #available(iOS 12.0, *) {
            guard let url = getDeeplinkUrl(), !url.isEmpty, let urlObject = URL(string: url) else {
                self.extensionContext?.performNotificationDefaultAction()
                return
            }
            parentNotificationViewController?.openUrl(urlObject)
        } else {
            // Fallback on earlier versions
        }
    }
    
    func handleAction(_ action: String) -> UNNotificationContentExtensionResponseOption {
        fatalError("You must override \(#function) in a subclass")
    }
    
    func getDeeplinkUrl() -> String? {
        fatalError("You must override \(#function) in a subclass")
    }
}
