

import Foundation

/** Media player event fired when a midpoint of ad is reached after continuous ad playback at normal speed. */
@objc(SPMediaAdMidpointEvent)
public class MediaAdMidpointEvent: SelfDescribingAbstract {
    
    override var schema: String {
        return MediaSchemata.eventSchema("ad_quartile")
    }
    
    override var payload: [String : Any] {
        return ["percentProgress": 50]
    }
}
