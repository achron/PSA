

import Foundation

/** Media player event fired when the user clicked on the ad. */
@objc(SPMediaAdClickEvent)
public class MediaAdClickEvent: SelfDescribingAbstract {
    
    /// The percent of the way through the ad.
    public var percentProgress: Int?
    
    override var schema: String {
        return MediaSchemata.eventSchema("ad_click")
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
