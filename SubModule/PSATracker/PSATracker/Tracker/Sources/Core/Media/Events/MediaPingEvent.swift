

import Foundation

/** Media player event fired periodically during main content playback, regardless of other API events that have been sent. */
class MediaPingEvent: SelfDescribingAbstract {
    
    override var schema: String {
        return MediaSchemata.eventSchema("ping")
    }
    
    override var payload: [String : Any] {
        return [:]
    }
}
