

import Foundation

/** Media player event fired when 25% of ad is reached after continuous ad playback at normal speed. */
@objc(SPMediaAdFirstQuartileEvent)
public class MediaAdFirstQuartileEvent: SelfDescribingAbstract {
    
    override var schema: String {
        return MediaSchemata.eventSchema("ad_quartile")
    }
    
    override var payload: [String : Any] {
        return ["percentProgress": 25]
    }
}
