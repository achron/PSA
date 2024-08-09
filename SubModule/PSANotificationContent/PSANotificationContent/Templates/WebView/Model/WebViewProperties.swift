import Foundation

struct WebViewProperties: Decodable {
    let title: String?
    let msg: String?
    let msgSummary: String?
    let url: String?
    let deepLink1: String?
    let titleClr: String?
    let msgClr: String?
    let orientation: String?
    
    
    enum CodingKeys: String, CodingKey {
        case title = "notification_title"
        case msg = "notification_body"
        case msgSummary = "notification_body_summary"
        case url = "notification_url"
        case deepLink1 = "notification_deep_link1"
        case titleClr = "notification_title_clr"
        case msgClr = "notification_msg_clr"
        case orientation = "notification_orientation"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        title = try container.decodeIfPresent(String.self, forKey: .title)
        msg = try container.decodeIfPresent(String.self, forKey: .msgClr)
        msgSummary = try container.decodeIfPresent(String.self, forKey: .msgSummary)
        deepLink1 = try container.decodeIfPresent(String.self, forKey: .deepLink1)
        
        url = try container.decodeIfPresent(String.self, forKey: .url)
        
        titleClr = try container.decodeIfPresent(String.self, forKey: .titleClr)
        msgClr = try container.decodeIfPresent(String.self, forKey: .msgClr)
        orientation = try container.decodeIfPresent(String.self, forKey: .orientation)
    }
    
}


