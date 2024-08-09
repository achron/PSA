

import Foundation

/// A foreground transition event.
///
/// Schema: `iglu:com.snowplowanalytics.snowplow/application_foreground/jsonschema/1-0-0`
@objc(SPForeground)
public class Foreground: SelfDescribingAbstract {
    /// Indicate the current transition.
    @objc
    public var index: Int

    /// Creates a foreground transition event.
    /// - Parameter index: indicate the current transition.
    @objc
    public init(index: Int) {
        self.index = index
    }

    override var schema: String {
        return kSPForegroundSchema
    }

    override var payload: [String : Any] {
        return [
            kSPForegroundIndex: index
        ]
    }
}
