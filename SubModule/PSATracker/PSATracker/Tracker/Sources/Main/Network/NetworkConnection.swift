

import Foundation

/// Interface for the component that
/// sends events to the collector.
@objc(SPNetworkConnection)
public protocol NetworkConnection: NSObjectProtocol {
    /// Send requests to the collector.
    /// - Parameter requests: to send,
    /// - Returns: results of the sending operation.
    @objc
    func sendRequests(_ requests: [Request]) -> [RequestResult]
    /// - Returns: http method used to send requests to the collector.
    @objc
    var httpMethod: HttpMethodOptions { get }
    /// - Returns: URL of the collector.
    @objc
    var urlEndpoint: URL? { get }
}
