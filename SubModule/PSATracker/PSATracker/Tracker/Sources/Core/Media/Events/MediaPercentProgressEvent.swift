

import Foundation

/** Media player event fired when a percentage boundary set in the `boundaries` list in `MediaTrackingConfiguration` is reached. */
class MediaPercentProgressEvent: SelfDescribingAbstract {
    
    override var schema: String {
        return MediaSchemata.eventSchema("percent_progress")
    }
    
    override var payload: [String : Any] {
        return [:]
    }
}
