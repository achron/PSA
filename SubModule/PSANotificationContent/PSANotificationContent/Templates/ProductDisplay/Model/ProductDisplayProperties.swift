//
//  ProductDisplayProperties.swift
//  CTNotificationContent
//
//  Created by Aishwarya Nanna on 22/03/22.
//

import Foundation

@objc public class ProductDisplayProperties: NSObject,Decodable {
    @objc public let title: String?
    @objc public let msg: String?
    @objc public let subtitle: String?
    @objc public let img1: String
    @objc public let img2: String
    @objc public let img3: String?
    @objc public let btnTitle1: String
    @objc public let btnTitle2: String
    @objc public let btnTitle3: String?
    @objc public let btnSubTitle1: String
    @objc public let btnSubTitle2: String
    @objc public let btnSubTitle3: String?
    @objc public let deepLink1: String
    @objc public let deepLink2: String
    @objc public let deepLink3: String?
    @objc public let price1: String
    @objc public let price2: String
    @objc public let price3: String?
    @objc public let bgClr: String?
    @objc public let actionTitle: String
    @objc public let linearDislay: String?
    @objc public let actionTitleClr: String?
    @objc public let titleClr: String?
    @objc public let msgClr: String?
    
    
    enum CodingKeys: String, CodingKey {
        case title = "notification_title"
        case msg = "notification_body"
        case subtitle = "notification_subtile"
        case img1 = "notification_img1"
        case img2 = "notification_img2"
        case img3 = "notification_img3"
        case btnTitle1 = "notification_btnTitle1"
        case btnTitle2 = "notification_btnTitle2"
        case btnTitle3 = "notification_btnTitle3"
        case btnSubTitle1 = "notification_btnSubTitle1"
        case btnSubTitle2 = "notification_btnSubTitle2"
        case btnSubTitle3 = "notification_btnSubTitle3"
        case deepLink1 = "notification_deep_link1"
        case deepLink2 = "notification_deep_link2"
        case deepLink3 = "notification_deep_link3"
        case price1 = "notification_price1"
        case price2 = "notification_price2"
        case price3 = "notification_price3"
        case bgClr = "notification_bg_clr"
        case actionTitle = "notification_product_display_action_title"
        case linearDislay = "notification_product_display_linear"
        case actionTitleClr = "notification_product_display_action_title_clr"
        case titleClr = "notification_title_clr"
        case msgClr = "notification_msg_clr"
    }
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        title = try container.decodeIfPresent(String.self, forKey: .title)
        msg = try container.decodeIfPresent(String.self, forKey: .msg)
        subtitle = try container.decodeIfPresent(String.self, forKey: .subtitle)
        img1 = try container.decodeIfPresent(String.self, forKey: .img1) ?? ""
        img2 = try container.decodeIfPresent(String.self, forKey: .img2) ?? ""
        img3 = try container.decodeIfPresent(String.self, forKey: .img3)
        
        btnTitle1 = try container.decodeIfPresent(String.self, forKey: .btnTitle1) ?? ""
        btnTitle2 = try container.decodeIfPresent(String.self, forKey: .btnTitle2) ?? ""
        btnTitle3 = try container.decodeIfPresent(String.self, forKey: .btnTitle3)
        btnSubTitle1 = try container.decodeIfPresent(String.self, forKey: .btnSubTitle1) ?? ""
        btnSubTitle2 = try container.decodeIfPresent(String.self, forKey: .btnSubTitle2) ?? ""
        btnSubTitle3 = try container.decodeIfPresent(String.self, forKey: .btnSubTitle3)
        deepLink1 = try container.decodeIfPresent(String.self, forKey: .deepLink1) ?? ""
        deepLink2 = try container.decodeIfPresent(String.self, forKey: .deepLink2) ?? ""
        deepLink3 = try container.decodeIfPresent(String.self, forKey: .deepLink3)
        
        price1 = try container.decodeIfPresent(String.self, forKey: .price1) ?? ""
        price2 = try container.decodeIfPresent(String.self, forKey: .price2) ?? ""
        price3 = try container.decodeIfPresent(String.self, forKey: .price3)
        
        bgClr = try container.decodeIfPresent(String.self, forKey: .bgClr)
        
        actionTitle = try container.decodeIfPresent(String.self, forKey: .actionTitle) ?? ""
        linearDislay = try container.decodeIfPresent(String.self, forKey: .linearDislay)
        actionTitleClr = try container.decodeIfPresent(String.self, forKey: .actionTitleClr)
        
        titleClr = try container.decodeIfPresent(String.self, forKey: .titleClr)
        msgClr = try container.decodeIfPresent(String.self, forKey: .msgClr)
    }
}
