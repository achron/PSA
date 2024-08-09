

import Foundation

/// A pageview event.
/// @deprecated This event has been designed for web trackers, not suitable for mobile apps. Use DeepLinkReceived event to track deep link received in the app.
@objc(SPPageView)
public class PageView : PrimitiveAbstract {
    /// Page url.
    @objc
    public var pageUrl: String
    /// Page title.
    @objc
    public var pageTitle: String?
    /// Page referrer url.
    @objc
    public var referrer: String?

    /// Creates a Page View event
    /// - Parameter pageUrl: Page URL
    /// - Parameter pageTitle: Page title
    /// - Parameter referrer: Page referrer URL
    @objc
    public init(pageUrl: String) {
        self.pageUrl = pageUrl
    }
    
    override var eventName: String {
        return kSPEventPageView
    }
    
    override var payload: [String : Any] {
        var payload: [String : Any] = [
            kSPPageUrl: pageUrl
        ]
        payload[kSPPageTitle] = pageTitle
        payload[kSPPageRefr] = referrer
        return payload
    }
    
    // MARK: - Builders
    
    /// Page title.
    @objc
    public func pageTitle(_ title: String?) -> Self {
        self.pageTitle = title
        return self
    }
    
    /// Page referrer url.
    @objc
    public func referrer(_ referrer: String?) -> Self {
        self.referrer = referrer
        return self
    }
}
