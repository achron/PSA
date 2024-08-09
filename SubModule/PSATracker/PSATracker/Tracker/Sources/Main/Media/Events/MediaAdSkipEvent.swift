

import Foundation

/** Media player event fired when the user activated a skip control to skip the ad creative. */
@objc(SPMediaAdSkipEvent)
public class MediaAdSkipEvent: SelfDescribingAbstract {
    
    /// The percent of the way through the ad.
    public var percentProgress: Int?
    
    override var schema: String {
        return MediaSchemata.eventSchema("ad_skip")
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
