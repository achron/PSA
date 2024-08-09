

import Foundation

/// Error event tracked by exception autotracking.
///
/// Schema: `iglu:com.snowplowanalytics.snowplow/application_error/jsonschema/1-0-2`
@objc(SPPSAError)
public class PSAError: SelfDescribingAbstract {
    /// Error message
    @objc
    public var message: String
    /// Error name
    @objc
    public var name: String?
    /// Stacktrace for the error
    @objc
    public var stackTrace: String?
    
    /// Creates a PSAError event.
    /// - Parameter message: Error message
    @objc
    public init(message: String) {
        self.message = message
    }
    
    override var schema: String {
        return kSPErrorSchema
    }

    override var payload: [String : Any] {
        var payload: [String : Any] = [:]
        payload[kSPErrorMessage] = message
        payload[kSPErrorStackTrace] = stackTrace
        payload[kSPErrorName] = name
        payload[kSPErrorLanguage] = "SWIFT"
        return payload
    }
    
    // MARK: - Builders
    
    /// Error name
    @objc
    public func name(_ name: String?) -> Self {
        self.name = name
        return self
    }
    
    /// Stacktrace for the error
    @objc
    public func stackTrace(_ stackTrace: String?) -> Self {
        self.stackTrace = stackTrace
        return self
    }
}
