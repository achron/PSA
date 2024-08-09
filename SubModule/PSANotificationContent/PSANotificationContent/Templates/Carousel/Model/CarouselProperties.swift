//
//  CarouselProperties.swift
//  Created by Tejas Kashyap on 05/02/24.
//

import Foundation

struct CarouselProperties: Decodable {
    let title: String?
    let msg: String?
    let msgSummary: String?
    let deepLink1: String?
    let largeImg: String?
    let img1: String?
    let img2: String?
    let img3: String?
    let bgClr: String?
    let titleClr: String?
    let msgClr: String?
    
    enum CodingKeys: String, CodingKey {
        case title =  "notification_title"
       
        case msg = "notification_body"
        case msgSummary = "notification_body_summary"
        case deepLink1 = "notification_deep_link1"
        case largeImg = "notification_large_Img"
        case img1 = "notification_img1"
        case img2 = "notification_img2"
        case img3 = "notification_img3"
        case bgClr =  "notification_bg_clr"
        case titleClr = "notification_titleClr"
        case msgClr = "notification_msg_clr"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        title = try container.decodeIfPresent(String.self, forKey: .title)
        msg = try container.decodeIfPresent(String.self, forKey: .msgClr)
        msgSummary = try container.decodeIfPresent(String.self, forKey: .msgSummary)
        largeImg = try container.decodeIfPresent(String.self, forKey: .largeImg)
        img1 = try container.decodeIfPresent(String.self, forKey: .img1)
        img2 = try container.decodeIfPresent(String.self, forKey: .img2)
        img3 = try container.decodeIfPresent(String.self, forKey: .img3)
        deepLink1 = try container.decodeIfPresent(String.self, forKey: .deepLink1)
        bgClr = try container.decodeIfPresent(String.self, forKey: .bgClr)
        titleClr = try container.decodeIfPresent(String.self, forKey: .titleClr)
        msgClr = try container.decodeIfPresent(String.self, forKey: .msgClr)
    }
}



//pt_basic = basic_template
//pt_carousel = carousel_template
//pt_manual_carousel = manual_carousel_template
//pt_id = template_id
//pt_zero_bezel =  template_zero_bezel
//pt_web_view = template_web_view
//pt_product_display = template_product_display
//pt_rating = template_rating
//
//
//pt_title = notification_title
//pt_msg = notification_body
//pt_msg_summary = notification_body_summary
//pt_url = notification_url
//pt_subtitle = notification_subtile
//pt_orientation = notification_orientation
//pt_default_dl = notification_default_deep_link
//pt_dl1 = notification_deep_link1
//pt_dl2 = notification_deep_link2
//pt_dl3 = notification_deep_link3
//pt_dl4 = notification_deep_link4
//pt_dl5 = notification_deep_link5
//
//pt_img1 = notification_img1
//pt_img2 = notification_img2
//pt_img3 = notification_img3
//
//pt_bt1 = notification_btnTitle1
//pt_bt2 = notification_btnTitle2
//pt_bt3 = notification_btnTitle3
//
//pt_st1 = notification_btnSubTitle1
//pt_st2 = notification_btnSubTitle2
//pt_st3 = notification_btnSubTitle3
//
//
//pt_price1 = notification_price1
//pt_price2 = notification_price2
//pt_price3 = notification_price3
//
//pt_product_display_action = notification_product_display_action_title
//pt_product_display_linear = notification_product_display_linear
//pt_product_display_action_clr = notification_product_display_action_title_clr
//
//pt_big_img = notification_large_Img
//pt_bg = notification_bg_clr
//pt_title_clr = notification_title_clr
//pt_msg_clr = notification_msg_clr
//
//pt_title_alt = notification_alt_title
//pt_msg_alt = notification_alt_msg
//pt_big_img_alt = notification_alt_large_Img
//pt_chrono_title_clr = notification_chrono_title_clr
//pt_timer_threshold = notification_timer_threshold
//pt_timer_end = notification_timer_end_time
//
//pt_timer = timer_template
//pt_json = json_data
//
//ct_ContentSlider =  notification_ContentSlider
//pt_carousel = carousel_template
//pt_manual_carousel = manual_carousel_template
//pt_timer = timer_template
//ct_mediaType = notification_mediaType
//ct_mediaUrl = notification_mediaUrl
//
//wzrk_dl =  notification_deep_link
//pt_zero_bezel = template_zero_bezel
//pt_web_view = template_web_view
//pt_product_display = template_product_display
//pt_rating = template_rating

