

import Foundation

/// A background transition event.
///
/// Schema: `iglu:com.snowplowanalytics.snowplow/application_background/jsonschema/1-0-0`
@objc(SPBackground)
public class Background: SelfDescribingAbstract {
    /// Index indicating the current transition.
    @objc
    public var index: Int

    /// Creates a brackground transition event.
    /// - Parameter index: indicate the current transition.
    @objc
    public init(index: Int) {
        self.index = index
    }

    override var schema: String {
        return kSPBackgroundSchema
    }

    override var payload: [String : Any] {
        return [
            kSPBackgroundIndex: index
        ]
    }
}
