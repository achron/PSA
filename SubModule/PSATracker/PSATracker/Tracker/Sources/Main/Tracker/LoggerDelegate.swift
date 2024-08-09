

import Foundation

/// Logger delegate to implement in oder to receive logs from the tracker.
@objc(SPLoggerDelegate)
public protocol LoggerDelegate: NSObjectProtocol {
    @objc
    func error(_ tag: String, message: String)
    @objc
    func debug(_ tag: String, message: String)
    @objc
    func verbose(_ tag: String, message: String)
}
