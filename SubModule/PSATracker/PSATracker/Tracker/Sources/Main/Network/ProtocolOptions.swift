

import Foundation

/// An enum for HTTP security.
@objc(SPProtocol)
public enum ProtocolOptions : Int {
    /// Use HTTP.
    case http
    /// Use HTTP over TLS.
    case https
}
