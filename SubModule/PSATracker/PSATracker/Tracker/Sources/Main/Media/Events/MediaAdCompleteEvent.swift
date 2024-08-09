

import Foundation

/** Media player event that signals the ad creative was played to the end at normal speed. */
@objc(SPMediaAdCompleteEvent)
public class MediaAdCompleteEvent: SelfDescribingAbstract {
    
    override var schema: String {
        return MediaSchemata.eventSchema("ad_complete")
    }
    
    override var payload: [String : Any] {
        return [:]
    }
}
