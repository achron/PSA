

import Foundation

/** Media player event that signals the end of an ad break. */
@objc(SPMediaAdBreakEndEvent)
public class MediaAdBreakEndEvent: SelfDescribingAbstract {
    
    override var schema: String {
        return MediaSchemata.eventSchema("ad_break_end")
    }
    
    override var payload: [String : Any] {
        return [:]
    }
}
