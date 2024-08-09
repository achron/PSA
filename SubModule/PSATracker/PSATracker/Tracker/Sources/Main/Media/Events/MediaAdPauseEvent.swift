

import Foundation

/** Media player event fired when the user clicked the pause control and stopped the ad creative. */
@objc(SPMediaAdPauseEvent)
public class MediaAdPauseEvent: SelfDescribingAbstract {
    
    /// The percent of the way through the ad.
    public var percentProgress: Int?
    
    override var schema: String {
        return MediaSchemata.eventSchema("ad_pause")
    }
    
    override var payload: [String : Any] {
        var data: [String: Any] = [:]
        if let percentProgress = percentProgress { data["percentProgress"] = percentProgress }
        return data
    }
    
    /// - Parameter percentProgress: The percent of the way through the ad.
    public init(percentProgress: Int? = nil) {
        self.percentProgress = percentProgress
    }
    
    @objc
    public override init() {
    }
    
    /// The percent of the way through the ad.
    @objc
    public func percentProgress(_ percentProgress: Int) -> Self {
        self.percentProgress = percentProgress
        return self
    }
}
