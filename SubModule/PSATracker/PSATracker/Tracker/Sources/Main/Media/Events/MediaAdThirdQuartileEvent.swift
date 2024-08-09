

import Foundation

/** Media player event fired when 75% of ad is reached after continuous ad playback at normal speed. */
@objc(SPMediaAdThirdQuartileEvent)
public class MediaAdThirdQuartileEvent: SelfDescribingAbstract {
    
    override var schema: String {
        return MediaSchemata.eventSchema("ad_quartile")
    }
    
    override var payload: [String : Any] {
        return ["percentProgress": 75]
    }
}
