//
//  PSANotificationContentViewController.swift
//  PSANotificationContent
//
//  Created by Tejas Kashyap on 06/02/24.
//

import Foundation
import UIKit
import UserNotifications
import UserNotificationsUI

open class PsaNotificationContentViewController : UIViewController {
    var contentType: NotificationContentType?
    var contentViewController: BaseNotificationContentVC?
    var jsonString: String?
    var content: [String: Any]?
    var notification: UNNotification?
    var isFromProductDisplay: Bool = false

    open override func viewDidLoad() {
        super.viewDidLoad()
        self.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    func setupContentController(_ contentController: BaseNotificationContentVC?) {
        // Assuming `contentController` conforms to a protocol or base class where these methods are defined
        (contentController)?.data = (jsonString ?? "")
        (contentController)?.templateCaption = (notification?.request.content.title) ?? ""
        (contentController)?.templateSubcaption = (notification?.request.content.body) ?? ""
        
        if let deeplinkURL = content?[kDeeplinkURL] as? String {
            (contentController)?.deeplinkURL = (deeplinkURL)
        }
        
        if let contentController = contentController {
            addChild(contentController)
            contentController.view.frame = view.frame
            view.addSubview(contentController.view!)
            self.contentViewController = contentController
        }
       
    }

    
    func updateContentType(_ content: [String: Any]) {
        if content[kContentSlider] != nil {
            self.contentType = .contentSlider
            self.jsonString = (content[kContentSlider]) as? String
        } else if let templateId = content[kTemplateId] as? String {
            self.jsonString = content[kJSON] as? String ?? createJSONData(from: content)
            
            switch templateId {
            case kTemplateBasic:
                self.contentType = .basicTemplate
            case kTemplateAutoCarousel:
                self.contentType = .autoCarousel
            case kTemplateManualCarousel:
                self.contentType = .manualCarousel
            case kTemplateTimer:
                self.contentType = .timerTemplate
            case kTemplateZeroBezel:
                self.contentType = .zeroBezel
            case kTemplateWebView:
                self.contentType = .webView
            case kTemplateProductDisplay:
                self.contentType = .productDisplay
            case kTemplateRating:
                self.contentType = .rating
            default:
                // Invalid templateId value fallback to basic.
                self.contentType = .basicTemplate
            }
        } else if content[kSingleMediaType] != nil && content[kSingleMediaURL] != nil {
            self.contentType = .singleMedia
        } else {
            // Invalid payload data fallback to basic.
            self.contentType = .basicTemplate
        }
    }

    
    func openUrl(_ url: URL) {
        self.extensionContext?.open(url, completionHandler: { success in
            // If the deep link didn't work, open parent app
            if !success {
                if #available(iOS 12.0, *) {
                    self.extensionContext?.performNotificationDefaultAction()
                } else {
                    // Fallback on earlier versions
                }
            }
            
            // This removes the clicked notification from Notification Center when clicked in expanded view.
            let current = UNUserNotificationCenter.current()
            current.getDeliveredNotifications { notifications in
                let notificationIdentifier = notifications.first { $0.request.identifier == self.notification?.request.identifier }?.request.identifier
                
                if let notificationIdentifier = notificationIdentifier {
                    UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [notificationIdentifier])
                }
            }
        })
    }

    
    /// Implement in your subclass to get notification response
    open func userDidReceive(_ response: UNNotificationResponse) {
        // No operation here
        // Implement in your subclass to get notification response
    }
    
    open func userDidPerformAction(_ action: String, withProperties properties: [String: Any]) {
        // No operation here
        // Implement in your subclass to get user event type data
    }
    
    open override func preferredContentSizeDidChange(forChildContentContainer container: UIContentContainer) {
        preferredContentSize = contentViewController?.preferredContentSize ?? CGSize()
    }
    
    func createJSONData(from content: [String: Any]) -> String? {
        guard let jsonData = try? JSONSerialization.data(withJSONObject: content, options: []),
              let jsonString = String(data: jsonData, encoding: .utf8) else {
            return nil
        }
        return jsonString
    }



}

extension PsaNotificationContentViewController: UNNotificationContentExtension {
     open func didReceive(_ notification: UNNotification) {
         content = notification.request.content.userInfo as? [String:Any]
        self.notification = notification

        if let content {
            updateContentType(content)
        }
        
        switch contentType {
        case .contentSlider:
            let contentController = ContentVC()
            contentController.data = (content?[kContentSlider]) as! String
            contentController.templateCaption = (notification.request.content.title)
            contentController.templateSubcaption = (notification.request.content.body)
            if let deeplinkURL = content?[kDeeplinkURL] as? String {
                contentController.deeplinkURL = (deeplinkURL)
            }
            setupContentController(contentController)
            
        case .singleMedia:
            let contentController = SingleMediaVC()
            contentController.templateCaption = (notification.request.content.title)
            contentController.templateCaption = (notification.request.content.body)
            contentController.mediaType = (content?[kSingleMediaType]) as? String ?? ""
            contentController.mediaURL = (content?[kSingleMediaURL]) as? String ?? ""
            if let deeplinkURL = content?[kDeeplinkURL] as? String {
                contentController.deeplinkURL = (deeplinkURL)
            }
            setupContentController(contentController)
            
        case .basicTemplate, .autoCarousel, .manualCarousel, .timerTemplate, .zeroBezel, .webView, .productDisplay, .rating:
            var contentController: BaseNotificationContentVC? = nil
            
            switch contentType {
            case .basicTemplate:
                contentController = CarouselVC()
                if isFromProductDisplay {
                    (contentController as? CarouselVC)?.isFromProductDisplay = true
                }
                contentController?.data = (jsonString ?? "")
                contentController?.templateType = (kTemplateBasic)
            
            case .autoCarousel:
                contentController = CarouselVC()
                contentController?.templateType = (kTemplateAutoCarousel)
                
            case .manualCarousel:
                contentController = CarouselVC()
                contentController?.templateType = (kTemplateManualCarousel)
            
            case .timerTemplate:
                contentController = TimerVC()
            
            case .zeroBezel:
                contentController = ZeroBezelVC()
            
            case .webView:
                contentController = WebVC()
            case .productDisplay:
                if Utiltiy.isRequiredKeysProvided(jsonString: jsonString ?? "") {
                    contentController = Utiltiy.getControllerType(jsonString: jsonString ?? "")
                } else {
                    isFromProductDisplay = true
                    // Here, we directly proceed to set up a basic template as a fallback
                    contentController = CarouselVC()
                    contentController?.isFromProductDisplay = true
                    contentController?.data = (jsonString ?? "")
                    contentController?.templateType = (kTemplateBasic)
                }
            
            case .rating:
                contentController = RatingVC()
            
            default: break
            }
            
            if let contentController = contentController {
                setupContentController(contentController)
            }
            
        default: break
        }
        
        if let contentViewController = self.contentViewController {
            view.frame = contentViewController.view.frame
            preferredContentSize = contentViewController.preferredContentSize
        }
    }
    open func didReceive(_ response: UNNotificationResponse, completionHandler completion: @escaping (UNNotificationContentExtensionResponseOption) -> Void) {
       if  let actionResponseOption = contentViewController?.handleAction(response.actionIdentifier) {
           completion(actionResponseOption)
       }
        userDidReceive(response)
    }
}
