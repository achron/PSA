

import Foundation

/** Media player event that signals the start of an ad. */
@objc(SPMediaAdStartEvent)
public class MediaAdStartEvent: SelfDescribingAbstract {
    
    override var schema: String {
        return MediaSchemata.eventSchema("ad_start")
    }
    
    override var payload: [String : Any] {
        return [:]
    }
}
