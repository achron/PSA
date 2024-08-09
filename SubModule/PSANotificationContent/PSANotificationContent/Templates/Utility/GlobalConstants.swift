enum TemplateConstants {
    static let kTemplateBasic: String = "basic_template"
    static let kTemplateAutoCarousel: String = "carousel_template"
    static let kTemplateManualCarousel: String = "manual_carousel_template"
}


enum Constraints {
    static let kCaptionHeight: CGFloat = 18.0
    static let kSubCaptionHeight: CGFloat = 20.0
    static let kSubCaptionTopPadding: CGFloat = 8.0
    static let kBottomPadding: CGFloat = 18.0
    static let kCaptionLeftPadding: CGFloat = 10.0
    static let kCaptionTopPadding: CGFloat = 8.0
    static let kImageBorderWidth: CGFloat = 1.0
    static let kImageLayerBorderWidth: CGFloat = 0.4
    static let kPageControlViewHeight: CGFloat = 20.0
    static let kTimerLabelWidth: CGFloat = 100.0
    static let kLandscapeMultiplier: CGFloat = 0.5625 // 16:9 in landscape
    static let kPortraitMultiplier: CGFloat = 1.777 // 16:9 in portrait
}

enum ConstantKeys {
    static let kDefaultColor: String = ""
    static let kHexBlackColor: String = "#000000"
    static let kHexLightGrayColor: String = "#d3d3d3"
    static let kAction1: String = "action_1" // Maps to Show Previous
    static let kAction2: String = "action_2" // Maps to Show Next
    static let kAction3: String = "action_3" // Maps to public the attached deeplink
    static let kMediaTypeVideo: String = "video"
    static let kMediaTypeImage: String = "image"
    static let kMediaTypeAudio: String = "audio"
    static let kOrientationLandscape: String = "landscape"
    static let kOpenedContentUrlAction: String = "CTOpenedContentUrl"
    static let kViewContentItemAction: String = "CTViewedContentItem"
}

enum NotificationContentType: Int {
    case contentSlider = 0
    case singleMedia = 1
    case basicTemplate = 2
    case autoCarousel = 3
    case manualCarousel = 4
    case timerTemplate = 5
    case zeroBezel = 6
    case webView = 7
    case productDisplay = 8
    case rating = 9
}

let kTemplateId = "template_id"
let kContentSlider = "notification_ContentSlider"
let kTemplateBasic = "basic_template"
let kTemplateAutoCarousel = "carousel_template"
let kTemplateManualCarousel = "manual_carousel_template"
let kTemplateTimer = "timer_template"
let kSingleMediaType = "notification_mediaType"
let kSingleMediaURL = "notification_mediaUrl"
let kJSON = "json_data"
let kDeeplinkURL = "notification_deep_link"
let kTemplateZeroBezel = "template_zero_bezel"
let kTemplateWebView = "template_web_view"
let kTemplateProductDisplay = "template_product_display"
let kTemplateRating = "template_rating"
