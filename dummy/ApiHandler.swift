//
//  ApiHandler.swift
//  TableViewDemo
//
//  Created by Tejas Kashyap on 12/01/24.
//

import Foundation

class ApiHandler{
    
    func fetchData<T: Decodable>(ofType type: T.Type,httpMethod: String, allowQueryStrings: Bool = false, url: String, query: [URLQueryItem] = [],body:[String:Any], completion: @escaping (Bool , T?, String) -> Void){
        
        
        
        let baseURL = URL(string: url)!
//        let url = baseURL.appending(queryItems: query)

        var request = URLRequest(url: baseURL)
        let bodyData = try? JSONSerialization.data(
            withJSONObject: body,
            options: []
        )

        // Change the URLRequest to a POST request
        request.httpMethod = httpMethod
        request.httpBody = bodyData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

       
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                let str = String(decoding: data, as: UTF8.self)
                print("books - ",str)
                if let books = try? JSONDecoder().decode(T.self, from: data) {
                    print(books)
                    completion(true , books, "")
                } else {
                    completion(false , nil, "Cann,t parse the data")
                }
            } else if let error = error {
                completion(false , nil, "\(error)")
                print("HTTP Request Failed \(error)")
            }
        }

        task.resume()
    }
}


