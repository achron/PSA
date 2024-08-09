//
//  Preference.swift
//  dummy
//
//  Created by Tejas Kashyap on 24/01/24.


import Foundation

class Preference{
    static let shared = Preference()
    static private let userDefault = UserDefaults(suiteName:"group.com.app.psa")
    private init(){
        
    }
    
    static var fcmToken : String {
        get{
            return userDefault?.value(forKey: "fcmToken") as? String ?? ""
        }
        set(val){
            userDefault?.set(val, forKey: "fcmToken")
        }
    }
    static var isLogedIn : Bool {
        get{
            return userDefault?.bool(forKey: "isLogedIn")  ?? false
        }
        set(val){
            userDefault?.set(val, forKey: "isLogedIn")
        }
    }
    
    static var userId : String {
        get{
            return userDefault?.value(forKey: "userId") as? String ?? ""
        }
        set(val){
            userDefault?.set(val, forKey: "userId")
        }
    }
    
    static var email : String {
        get{
            return userDefault?.value(forKey: "email") as? String ?? ""
        }
        set(val){
            userDefault?.set(val, forKey: "email")
        }
    }
    
    static var userToken : String {
        get{
            return userDefault?.value(forKey: "userToken") as? String ?? ""
        }
        set(val){
            userDefault?.set(val, forKey: "userToken")
        }
    }
    
    static func deleteAll() {
        let dictionary = userDefault?.dictionaryRepresentation()
        dictionary?.keys.forEach { key in
            userDefault?.removeObject(forKey: key)
        }
    }
}
