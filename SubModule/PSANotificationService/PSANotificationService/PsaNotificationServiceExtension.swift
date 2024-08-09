//
//  PsaNotificationServiceExtension.swift
//  SnowplowNotificationService
//
//  Created by Tejas Kashyap on 05/02/24. 
//

import Foundation
import UserNotifications

open class PsaNotificationServiceExtension: UNNotificationServiceExtension {

    public var mediaUrlKey: String?
    public var mediaTypeKey: String?
    
     var contentHandler: ((UNNotificationContent) -> Void)?
     var bestAttemptContent: UNMutableNotificationContent?
    
    open override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        self.bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        guard let userInfo = request.content.userInfo as? [String: Any] else {
            contentHandler(self.bestAttemptContent!)
            return
        }
        
        guard let mediaUrl = userInfo[kMediaUrlKey] as? String,
              let mediaType = userInfo[kMediaTypeKey] as? String else {
            // Debug logging
            #if DEBUG
            if userInfo[kMediaUrlKey] == nil {
                print("unable to add attachment: \(kMediaUrlKey) is nil")
            }
            if userInfo[kMediaTypeKey] == nil {
                print("unable to add attachment: \(kMediaTypeKey) is nil")
            }
            #endif
            
            contentHandler(self.bestAttemptContent!)
            return
        }
        
        // Load the attachment
        loadAttachment(forUrlString: mediaUrl, withType: mediaType) { attachment in
            if let attachment = attachment {
                self.bestAttemptContent?.attachments = [attachment]
            }
            contentHandler(self.bestAttemptContent!)
        }
    }

    open override func serviceExtensionTimeWillExpire() {
        if let bestAttemptContent = bestAttemptContent {
            contentHandler?(bestAttemptContent)
        }
    }
    
    func fileExtension(forMediaType mediaType: String, mimeType: String) -> String {
        var ext: String
        
        switch mediaType {
        case kImage:
            ext = "jpg"
        case kVideo:
            ext = "mp4"
        case kAudio:
            ext = "mp3"
        default:
            switch mimeType {
            case kImageJpeg:
                ext = "jpeg"
            case kImagePng:
                ext = "png"
            case kImageGif:
                ext = "gif"
            default:
                ext = ""
            }
        }
        return "." + ext
    }

    func loadAttachment(forUrlString urlString: String, withType mediaType: String, completionHandler: @escaping (UNNotificationAttachment?) -> Void) {
        guard let attachmentURL = URL(string: urlString) else {
            #if DEBUG
            print("Invalid URL string for attachment.")
            #endif
            completionHandler(nil)
            return
        }
        
        let session = URLSession(configuration: .default)
        session.downloadTask(with: attachmentURL) { (temporaryFileLocation, response, error) in
            var attachment: UNNotificationAttachment? = nil
            
            if let error = error {
                #if DEBUG
                print("Unable to add attachment: \(error.localizedDescription)")
                #endif
            } else if let temporaryFileLocation = temporaryFileLocation, let response = response {
                let fileExt = self.fileExtension(forMediaType: mediaType, mimeType: response.mimeType ?? "")
                let fileManager = FileManager.default
                let localURL = temporaryFileLocation.appendingPathExtension(fileExt)
                
                do {
                    try fileManager.moveItem(at: temporaryFileLocation, to: localURL)
                    attachment = try UNNotificationAttachment(identifier: "", url: localURL, options: nil)
                } catch {
                    #if DEBUG
                    print("Unable to add attachment: \(error.localizedDescription)")
                    #endif
                }
            }
            
            completionHandler(attachment)
        }.resume()
    }
}

