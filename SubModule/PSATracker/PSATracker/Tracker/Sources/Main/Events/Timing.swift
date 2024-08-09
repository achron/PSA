

import Foundation

/// A timing event.
///
/// Schema: `iglu:com.snowplowanalytics.snowplow/timing/jsonschema/1-0-0`
@objc(SPTiming)
public class Timing: SelfDescribingAbstract {
    /// The timing category
    @objc
    public var category: String
    /// The timing variable
    @objc
    public var variable: String
    /// The time
    @objc
    public var timing: Int
    /// The timing label
    @objc
    public var label: String?

    /// Creates a timing event
    /// - Parameter category: The timing category
    /// - Parameter variable: The timing variable
    /// - Parameter timing: The time
    @objc
    public init(category: String, variable: String, timing: Int) {
        self.category = category
        self.variable = variable
        self.timing = timing
    }

    override var schema: String {
        return kSPUserTimingsSchema
    }

    override var payload: [String : Any] {
        var payload: [String : Any] = [:]
        payload[kSPUtCategory] = category
        payload[kSPUtVariable] = variable
        payload[kSPUtTiming] = timing
        if let label = label { payload[kSPUtLabel] = label }
        return payload
    }
    
    // MARK: - Builders
    
    /// The timing label
    @objc
    public func label(_ label: String?) -> Self {
        self.label = label
        return self
    }
}
