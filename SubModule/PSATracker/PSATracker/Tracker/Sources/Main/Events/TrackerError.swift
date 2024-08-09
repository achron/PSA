

let kMaxMessageLength = 2048
let kMaxStackLength = 8192
let kMaxExceptionNameLength = 1024

import Foundation

/// Tracker error event used in diagnostic autotracking.
///
/// Schema: `iglu:com.snowplowanalytics.snowplow/diagnostic_error/jsonschema/1-0-0`
@objc(SPTrackerError)
public class TrackerError : SelfDescribingAbstract {
    /// Class name or source where the error appeared.
    @objc
    public var source: String
    /// Message of the error.
    @objc
    public var message: String
    /// Error involved in the error.
    @objc
    public var error: Error?
    /// Exception involved in the error.
    @objc
    public var exception: NSException?
    
    /// Create tracker error.
    /// - Parameter source: Class name or source where the error appeared.
    /// - Parameter message: Message of the error.
    /// - Parameter error: Error involved in the error.
    /// - Parameter exception: Exception involved in the error.
    @objc
    public init(source: String, message: String, error: Error? = nil, exception: NSException? = nil) {
        self.source = source
        self.message = message
        self.error = error
        self.exception = exception
    }
    
    override var schema: String {
        return kSPDiagnosticErrorSchema
    }
    
    override var payload: [String : Any] {
        var payload: [String : Any] = [:]
        payload[kSPDiagnosticErrorClassName] = source
        payload[kSPDiagnosticErrorMessage] = truncate(message, maxLength: kMaxMessageLength)
        if let error = error {
            payload[kSPDiagnosticErrorExceptionName] = error
        }
        if let exception = exception {
            payload[kSPDiagnosticErrorExceptionName] = truncate(exception.name.rawValue, maxLength: kMaxExceptionNameLength)
            let symbols = (exception).callStackSymbols
            if symbols.count != 0 {
                let stackTrace = "Stacktrace:\n\(symbols)"
                payload[kSPDiagnosticErrorStack] = truncate(stackTrace, maxLength: kMaxStackLength)
            }
        }
        return payload
    }

    // -- Private methods

    private func truncate(_ s: String, maxLength: Int) -> String {
        return String(s.prefix(maxLength))
    }
}
