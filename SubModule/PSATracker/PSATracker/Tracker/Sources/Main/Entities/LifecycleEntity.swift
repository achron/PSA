

import Foundation

let kSPLifecycleEntitySchema = "iglu:com.snowplowanalytics.mobile/application_lifecycle/jsonschema/1-0-0"
let kSPLifecycleEntityParamIndex = "index"
let kSPLifecycleEntityParamIsVisible = "isVisible"

/// Entity that indicates the state of the app is visible (foreground) when the event is tracked.
///
/// Schema: `iglu:com.snowplowanalytics.mobile/application_lifecycle/jsonschema/1-0-0`
@objc(SPLifecycleEntity)
public class LifecycleEntity: SelfDescribingJson {

    /// - Parameters:
    ///    - isVisible: Indicates if the app is in foreground state (true) or background state (false)
    @objc
    public init(isVisible: Bool) {
        var parameters: [String : Any] = [:]
        parameters[kSPLifecycleEntityParamIsVisible] = isVisible
        super.init(schema: kSPLifecycleEntitySchema, andData: parameters)
    }

    /// Represents the foreground index or background index (tracked with com.snowplowanalytics.snowplow application_foreground and application_background events.
    @objc
    public var index: NSNumber? {
        set {
            data[kSPLifecycleEntityParamIndex] = newValue?.intValue
        }
        get {
            if let value = data[kSPLifecycleEntityParamIndex] as? Int {
                return NSNumber(value: value)
            }
            return nil
        }
    }
    
    // MARK: - Builders
    
    /// Represents the foreground index or background index (tracked with com.snowplowanalytics.snowplow application_foreground and application_background events.
    public func index(_ index: NSNumber?) -> Self {
        self.index = index
        return self
    }
}
