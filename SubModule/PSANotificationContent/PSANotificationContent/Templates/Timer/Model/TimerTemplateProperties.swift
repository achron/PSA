//
//  TimerTemplateProperties.swift

import Foundation

struct TimerTemplateProperties: Decodable {
    let title: String?
    let altTilte: String?
    let msg: String?
    let altMsg: String?
    let msgSummary: String?
    let deepLink1: String?
    let largeImg: String?
    let altLargeImg: String?
    let bgClr: String?
    let chronoTitleClr: String?
    let timerThreshold: Int?
    let timerEndTime: Int?
    let titleClr: String?
    let msgClr: String?
    
    enum CodingKeys: String, CodingKey {
        case title =  "notification_title"
        case altTilte = "notification_alt_title"
        case msg = "notification_body"
        case altMsg =  "notification_alt_msg"
        case msgSummary = "notification_body_summary"
        case deepLink1 = "notification_deep_link1"
        case largeImg = "notification_large_Img"
        case altLargeImg = "notification_alt_large_Img"
        case bgClr =  "notification_bg_clr"
        case chronoTitleClr = "notification_chrono_title_clr"
        case timerThreshold = "notification_timer_threshold"
        case timerEndTime = "notification_timer_end_time"
        case titleClr = "notification_titleClr"
        case msgClr = "notification_msg_clr"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        title = try container.decodeIfPresent(String.self, forKey: .title)
        altTilte = try container.decodeIfPresent(String.self, forKey: .altTilte)
        msg = try container.decodeIfPresent(String.self, forKey: .msg)
        altMsg = try container.decodeIfPresent(String.self, forKey: .altMsg)
        msgSummary = try container.decodeIfPresent(String.self, forKey: .msgSummary)
        deepLink1 = try container.decodeIfPresent(String.self, forKey: .deepLink1)
        largeImg = try container.decodeIfPresent(String.self, forKey: .largeImg)
        altLargeImg = try container.decodeIfPresent(String.self, forKey: .altLargeImg)
        bgClr = try container.decodeIfPresent(String.self, forKey: .bgClr)
        chronoTitleClr = try container.decodeIfPresent(String.self, forKey: .chronoTitleClr)
        titleClr = try container.decodeIfPresent(String.self, forKey: .titleClr)
        msgClr = try container.decodeIfPresent(String.self, forKey: .msgClr)
        
        // Value for timerThreshold and timerEndTime key can be Int or String if received from JSON data or individual keys respectively, so checked for both case if present or else nil.
        var thresholdValue: Int? = nil
        do {
            if let intValue = try container.decodeIfPresent(Int.self, forKey: .timerThreshold) {
                thresholdValue = intValue
            }
        } catch {
            if let stringValue = try container.decodeIfPresent(String.self, forKey: .timerThreshold) {
                thresholdValue = Int(stringValue)
            }
        }
        timerThreshold = thresholdValue
        
        var timerEndValue: Int? = nil
        do {
            if let intValue = try container.decodeIfPresent(Int.self, forKey: .timerEndTime) {
                timerEndValue = intValue
            }
        } catch {
            if let stringValue = try container.decodeIfPresent(String.self, forKey: .timerEndTime) {
                timerEndValue = Int(stringValue)
            }
        }
        timerEndTime = timerEndValue
    }
}
