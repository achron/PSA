//
//  ZeroBezelProperties.swift

import Foundation

struct ZeroBezelProperties: Decodable {
    let title: String?
    let msg: String?
    let msgSummary: String?
    let subtitle: String?
    let largeImg: String?
    let deepLink1: String?
    let titleClr: String?
    let msgClr: String?
    enum CodingKeys: String, CodingKey {
        case title = "notification_title"
        case msg = "notification_body"
        case msgSummary = "notification_body_summary"
        case subtitle = "notification_subtile"
        case largeImg = "notification_large_Img"
        case deepLink1 = "notification_deep_link1"
        case titleClr = "notification_title_clr"
        case msgClr = "notification_msg_clr"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        title = try container.decodeIfPresent(String.self, forKey: .title)
        msg = try container.decodeIfPresent(String.self, forKey: .msgClr)
        msgSummary = try container.decodeIfPresent(String.self, forKey: .msgSummary)
        largeImg = try container.decodeIfPresent(String.self, forKey: .largeImg)
        subtitle = try container.decodeIfPresent(String.self, forKey: .subtitle)
        deepLink1 = try container.decodeIfPresent(String.self, forKey: .deepLink1)
        titleClr = try container.decodeIfPresent(String.self, forKey: .titleClr)
        msgClr = try container.decodeIfPresent(String.self, forKey: .msgClr)
        
    }
}
