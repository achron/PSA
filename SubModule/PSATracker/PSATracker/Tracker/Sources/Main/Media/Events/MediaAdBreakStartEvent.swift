

import Foundation

/** Media player event that signals the start of an ad break. */
@objc(SPMediaAdBreakStartEvent)
public class MediaAdBreakStartEvent: SelfDescribingAbstract {
    
    override var schema: String {
        return MediaSchemata.eventSchema("ad_break_start")
    }
    
    override var payload: [String : Any] {
        return [:]
    }
}
