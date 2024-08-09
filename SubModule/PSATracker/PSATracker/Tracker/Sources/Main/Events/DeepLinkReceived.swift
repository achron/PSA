

import Foundation

/// A deep-link received in the app.
///
/// Schema: `iglu:com.snowplowanalytics.mobile/deep_link_received/jsonschema/1-0-0`
@objc(SPDeepLinkReceived)
public class DeepLinkReceived: SelfDescribingAbstract {
    /// Referrer URL, source of this deep-link.
    @objc
    public var referrer: String?
    /// URL in the received deep-link.
    @objc
    public var url: String

    /// Creates a deep-link received event.
    /// - Parameter url: URL in the received deep-link.
    @objc
    public init(url: String) {
        self.url = url
    }

    @objc
    class var schema: String {
        return "iglu:com.snowplowanalytics.mobile/deep_link_received/jsonschema/1-0-0"
    }

    @objc
    class var paramUrl: String {
        return "url"
    }

    @objc
    class var paramReferrer: String {
        return "referrer"
    }

    override var schema: String {
        return DeepLinkReceived.schema
    }

    override var payload: [String : Any] {
        var payload: [String : Any] = [:]
        if let referrer = referrer {
            payload[DeepLinkReceived.paramReferrer] = referrer
        }
        payload[DeepLinkReceived.paramUrl] = url
        return payload
    }
    
    // MARK: - Builders
    
    /// Referrer URL, source of this deep-link.
    @objc
    public func referrer(_ referrer: String?) -> Self {
        self.referrer = referrer
        return self
    }
}
