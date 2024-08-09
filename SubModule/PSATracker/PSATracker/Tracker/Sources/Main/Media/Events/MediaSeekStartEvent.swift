

import Foundation

/** Media player event sent when a seek operation begins. */
@objc(SPMediaSeekStartEvent)
public class MediaSeekStartEvent: SelfDescribingAbstract {
    
    override var schema: String {
        return MediaSchemata.eventSchema("seek_start")
    }
    
    override var payload: [String : Any] {
        return [:]
    }
}
