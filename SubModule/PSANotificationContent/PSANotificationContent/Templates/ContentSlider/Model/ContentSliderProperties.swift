//
//  ContentSliderProperties.swift

import Foundation

struct ContentSliderProperties: Decodable {
    var orientation: String
    var showsPaging: Int
    var autoPlay: Int
    var autoDismiss: Int
    
    var items: [ItemContent]
//    let type: String
}

struct ItemContent: Decodable {
    var caption: String
    var subcaption: String
    var imageUrl: String
    var actionUrl: String
}

