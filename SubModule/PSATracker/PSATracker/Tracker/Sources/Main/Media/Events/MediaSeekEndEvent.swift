

import Foundation

/** Media player event sent when a seek operation completes. */
@objc(SPMediaSeekEndEvent)
public class MediaSeekEndEvent: SelfDescribingAbstract {
    
    override var schema: String {
        return MediaSchemata.eventSchema("seek_end")
    }
    
    override var payload: [String : Any] {
        return [:]
    }
}
