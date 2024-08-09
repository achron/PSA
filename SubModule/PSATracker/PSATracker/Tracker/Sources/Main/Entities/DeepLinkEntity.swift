

import Foundation

/// Entity that indicates a deep-link has been received and processed.
///
/// Schema: `iglu:com.snowplowanalytics.mobile/deep_link/jsonschema/1-0-0`
@objc(SPDeepLinkEntity)
public class DeepLinkEntity: SelfDescribingJson {
    @objc
    static let schema = "iglu:com.snowplowanalytics.mobile/deep_link/jsonschema/1-0-0"
    @objc
    static let paramReferrer = "referrer"
    @objc
    static let paramUrl = "url"
    
    /// URL in the received deep-link
    @objc
    public var url: String
    /// Referrer URL, source of this deep-link
    @objc
    public var referrer: String?

    @objc
    public init(url: String) {
        self.url = url
        super.init(schema: DeepLinkEntity.schema, andData: [:])
    }

    @objc
    override public var data: [String : Any] {
        get {
            var data: [String: Any] = [:]
            data[DeepLinkEntity.paramUrl] = url
            data[DeepLinkEntity.paramReferrer] = referrer
            return data
        }
        set {}
    }
    
    // MARK: - Builders
    
    /// Referrer URL, source of this deep-link
    @objc
    public func referrer(_ referrer: String?) -> Self {
        self.referrer = referrer
        return self
    }
}
