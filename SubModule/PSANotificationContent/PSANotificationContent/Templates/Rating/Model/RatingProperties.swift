//
//  RatingProperties.swift
//  CTNotificationContent
//
//  Created by Aishwarya Nanna on 07/09/22.
//

import Foundation

struct RatingProperties: Decodable {
    let title: String?
    let msg: String?
    let msgSummary: String?
    let subtitle: String?
    let defaultDeepLink: String?
    let deepLink1: String?
    let deepLink2: String?
    let deepLink3: String?
    let deepLink4: String?
    let deepLink5: String?
    let largeImg: String?
    let bgClr: String?
    let titleClr: String?
    let msgClr: String?
    
    
    enum CodingKeys: String, CodingKey {
        case title = "notification_title"
        case msg = "notification_body"
        case msgSummary = "notification_body_summary"
        case url = "notification_url"
        case deepLink1 = "notification_deep_link1"
        case titleClr = "notification_title_clr"
        case msgClr = "notification_msg_clr"
        case orientation = "notification_orientation"
        
        case subtitle = "notification_subtile"
        case defaultDeepLink = "notification_default_deep_link"
        case deepLink2 = "notification_deep_link2"
        case deepLink3 = "notification_deep_link3"
        case deepLink4 = "notification_deep_link4"
        case deepLink5 = "notification_deep_link5"
        case largeImg = "notification_large_Img"
        case bgClr = "notification_bg_clr"
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        title = try container.decodeIfPresent(String.self, forKey: .title)
        msg = try container.decodeIfPresent(String.self, forKey: .msgClr)
        msgSummary = try container.decodeIfPresent(String.self, forKey: .msgSummary)
        subtitle = try container.decodeIfPresent(String.self, forKey: .subtitle)
        defaultDeepLink = try container.decodeIfPresent(String.self, forKey: .defaultDeepLink)
        deepLink1 = try container.decodeIfPresent(String.self, forKey: .deepLink1)
        deepLink2 = try container.decodeIfPresent(String.self, forKey: .deepLink2)
        
        deepLink3 = try container.decodeIfPresent(String.self, forKey: .deepLink3)
        deepLink4 = try container.decodeIfPresent(String.self, forKey: .deepLink4)
        deepLink5 = try container.decodeIfPresent(String.self, forKey: .deepLink5)
        largeImg = try container.decodeIfPresent(String.self, forKey: .largeImg)
        bgClr = try container.decodeIfPresent(String.self, forKey: .bgClr)
        titleClr = try container.decodeIfPresent(String.self, forKey: .titleClr)
        msgClr = try container.decodeIfPresent(String.self, forKey: .msgClr)
    }
    
}
