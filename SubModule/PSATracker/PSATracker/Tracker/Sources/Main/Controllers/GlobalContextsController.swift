

import Foundation

@objc(SPGlobalContextsController)
public protocol GlobalContextsController: GlobalContextsConfigurationProtocol {
    @objc
    var tags: [String] { get }
}
