

import Foundation

let kSPMessageNotificationAttachmentParamIdentifier = "identifier"
let kSPMessageNotificationAttachmentParamType = "type"
let kSPMessageNotificationAttachmentParamUrl = "url"

/// Attachment object that identify an attachment in the MessageNotification
@objc(SPMessageNotificationAttachment)
public class MessageNotificationAttachment : NSObject {
    @objc
    public var identifer: String
    @objc
    public var type: String
    @objc
    public var url: String
    
    /// Attachments added to the notification (they can be part of the data object).
    @objc
    public init(identifier: String, type: String, url: String) {
        self.identifer = identifier
        self.type = type
        self.url = url
    }
    
    var data: [String : Any] {
        return [
            kSPMessageNotificationAttachmentParamIdentifier: identifer,
            kSPMessageNotificationAttachmentParamType: type,
            kSPMessageNotificationAttachmentParamUrl: url
        ]
    }
}
