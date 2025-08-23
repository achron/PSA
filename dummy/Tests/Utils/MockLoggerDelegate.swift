

import Foundation
@testable import PSATracker

class MockLoggerDelegate: NSObject, LoggerDelegate {
    var errorLogs: [String] = []
    var debugLogs: [String] = []
    var verboseLogs: [String] = []

    func debug(_ tag: String, message: String) {
        debugLogs.append(message)
    }

    func error(_ tag: String, message: String) {
        errorLogs.append(message)
    }

    func verbose(_ tag: String, message: String) {
        verboseLogs.append(message)
    }
}
