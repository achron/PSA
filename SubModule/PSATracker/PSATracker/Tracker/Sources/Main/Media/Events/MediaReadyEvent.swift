

import Foundation

/** Media player event fired when the media tracking is successfully attached to the player and can track events. */
@objc(SPMediaReadyEvent)
public class MediaReadyEvent: SelfDescribingAbstract {
    
    override var schema: String {
        return MediaSchemata.eventSchema("ready")
    }
    
    override var payload: [String : Any] {
        return [:]
    }
}
