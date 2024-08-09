

import Foundation

/// An enum for buffer options.
@objc(SPBufferOption)
public enum BufferOption : Int {
    /// Sends both GET and POST requests with only a single event.  Can cause a spike in
    /// network traffic if used in correlation with a large amount of events.
    case single = 1
    /// Sends POST requests in groups of 10 events.  This is the default amount of events too
    /// package into a POST.  All GET requests will still emit one at a time.
    case defaultGroup = 10
    /// Sends POST requests in groups of 25 events.  Useful for situations where many events
    /// need to be sent.  All GET requests will still emit one at a time.
    case largeGroup = 25
}

extension BufferOption {
    static func fromString(value: String) -> BufferOption? {
        switch value {
        case "Single":
            return .single
        case "DefaultGroup":
            return .defaultGroup
        case "HeavyGroup":
            return .largeGroup
        default:
            return nil
        }
    }
}
