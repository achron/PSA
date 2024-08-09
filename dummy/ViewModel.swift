//
//  ViewModel.swift
//  dummy
//
//  Created by Tejas Kashyap on 24/01/24.


import Foundation
class ViewModel {
    let apiHandler = ApiHandler()
    var detail:APIModel? = nil
    
    var action : (()-> ())?
    var failed : (()-> ())?
    
    func login(_ param:[String:Any]){
        apiHandler.fetchData(ofType: APIModel.self, httpMethod: "POST", url: "https://app-backend-psa-d2c4cf36bd0c.herokuapp.com/login", body: param) { [weak self] success, detail, error in
            
            if success, let data = detail {
                self?.detail = data
            }else{
                print("login error = ",error)
            }
            self?.action?()
        }
    }
    
    func signUp(_ param:[String:Any]){
        
        apiHandler.fetchData(ofType: APIModel.self, httpMethod: "POST", url: "https://app-backend-psa-d2c4cf36bd0c.herokuapp.com/register", body: param) { [weak self] success, detail, error in
            
            if success, let data = detail {
                self?.detail = data
            } else{
                print("signUp error = ",error)
            }
            self?.action?()
        }
    }
}
