

import Foundation

@objc(SPNetworkController)
public protocol NetworkController: AnyObject {
    /// URL used to send events to the collector.
    @objc
    var endpoint: String? { get set }
    /// Method used to send events to the collector.
    @objc
    var method: HttpMethodOptions { get set }
    /// A custom path which will be added to the endpoint URL to specify the
    /// complete URL of the collector when paired with the POST method.
    @objc
    var customPostPath: String? { get set }
    /// Custom headers for http requests.
    @objc
    var requestHeaders: [String : String]? { get set }
}
