//
//  ApiModel.swift
//  TableViewDemo
//
//  Created by Tejas Kashyap on 12/01/24.
//

import Foundation

// MARK: - Welcome
struct APIModel: Codable {
    let success: Bool?
    let status: Int?
    let message: String?
    let data: DataClass?
}

// MARK: - DataClass
struct DataClass: Codable {
    let id, email, password: String
    let wishlist: [String]?
    let createdAt, updatedAt: String?
    let v: Int?
    let token: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case email, password, wishlist, createdAt, updatedAt
        case v = "__v"
        case token
    }
}




//// MARK: - Welcome
//struct APIModel: Codable {
//    let batchcomplete: String
//    let modelContinue: Continue
//    let query: Query
//    let limits: Limits
//
//    enum CodingKeys: String, CodingKey {
//        case batchcomplete
//        case modelContinue = "continue"
//        case query, limits
//    }
//}
//
//// MARK: - Limits
//struct Limits: Codable {
//    let pageimages, extracts: Int
//}
//
//// MARK: - Query
//struct Query: Codable {
//    let pages: [String: Page]
//}
//
//// MARK: - Page
//struct Page: Codable {
//    let pageid, ns: Int
//    let title: String
//    let index: Int
//    let thumbnail: Thumbnail?
//    let pageimage: String?
//    let extract: String
//}
//
//// MARK: - Thumbnail
//struct Thumbnail: Codable {
//    let source: String
//    let width, height: Int
//}
//
//// MARK: - Continue
//struct Continue: Codable {
//    let gsroffset: Int
//    let continueContinue: String
//
//    enum CodingKeys: String, CodingKey {
//        case gsroffset
//        case continueContinue = "continue"
//    }
//}
//
//
//
////Endpoint: https://backend-flipkart-psa-228a78dd7ae4.herokuapp.com/login
////payload: {
////email: “email”,
////password: “password”
////}
////
////
////
////
////Signup API
////
////Endpont: https://backend-flipkart-psa-228a78dd7ae4.herokuapp.com/signup
//// 
//// * For signup name, email, password field is enough.
////payload:
////{
////  "city": "+1 (153) 318-2604",
////  "country": "+1 (334) 998-7821",
////  "dob": "1980-09-20",
////  "email": "jiqofys@mailinator.com",
////  "firstname": "Giselle",
////  "gender": "+1 (985) 377-4669",
////  "lastname": "Forbes",
////  "password": "Sint ullamco et nesc",
////  "phone": "+1 (284) 134-3684",
////  "state": "+1 (262) 402-9568",
////  "username": "dotitiwoba"
////}
