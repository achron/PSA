

import Foundation

class TrackerDefaults {
    private(set) static var base64Encoded = true
    private(set) static var trackerVersionSuffix = ""
    private(set) static var devicePlatform: DevicePlatform = Utilities.platform
    private(set) static var foregroundTimeout = 1800
    private(set) static var backgroundTimeout = 1800
    private(set) static var sessionContext = true
    private(set) static var deepLinkContext = true
    private(set) static var screenContext = true
    private(set) static var applicationContext = true
    private(set) static var autotrackScreenViews = true
    private(set) static var lifecycleEvents = false
    private(set) static var exceptionEvents = true
    private(set) static var installEvent = true
    private(set) static var trackerDiagnostic = false
    private(set) static var userAnonymisation = false
    private(set) static var platformContext = true
    private(set) static var geoLocationContext = false
}
