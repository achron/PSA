

import Foundation

@objc(SPRequestCallback)
public protocol RequestCallback: NSObjectProtocol {
    @objc
    func onSuccess(withCount successCount: Int)
    @objc
    func onFailure(withCount failureCount: Int, successCount: Int)
}
