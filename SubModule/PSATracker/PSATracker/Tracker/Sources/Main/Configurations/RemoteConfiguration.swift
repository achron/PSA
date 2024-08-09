

import Foundation

/// Represents the configuration for fetching configurations from a remote source.
/// For details on the correct format of a remote configuration see the official documentation.
@objc(SPRemoteConfiguration)
public class RemoteConfiguration: NSObject {
    /// URL of the remote configuration.
    @objc
    private(set) public var endpoint: String
    /// The method used to send the request.
    private(set) public var method: HttpMethodOptions?
    
    /// - Parameters:
    ///   - endpoint: URL of the remote configuration.
    ///                 The URL can include the schema/protocol (e.g.: `http://remote-config-url.xyz`).
    ///                 In case the URL doesn't include the schema/protocol, the HTTPS protocol is
    ///                 automatically selected.
    @objc
    public init(endpoint: String) {
        let url = URL(string: endpoint)
        if url?.scheme != nil && ["https", "http"].contains(url?.scheme ?? "") {
            self.endpoint = endpoint
        } else {
            self.endpoint = "https://\(endpoint)"
        }
    }

    /// - Parameters:
    ///   - endpoint: URL of the remote configuration.
    ///                 The URL can include the schema/protocol (e.g.: `http://remote-config-url.xyz`).
    ///                 In case the URL doesn't include the schema/protocol, the HTTPS protocol is
    ///                 automatically selected.
    ///   - method: The method used to send the requests (GET or POST).
    @objc
    public convenience init(endpoint: String, method: HttpMethodOptions) {
        self.init(endpoint: endpoint)
        self.method = method
    }
}
