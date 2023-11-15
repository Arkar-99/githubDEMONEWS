//
//  NetworkManager.swift
//  NewsDemo
//
//  Created by Arkar on 06/11/2023.
//

import Foundation
import Alamofire
import UIKit
import SwiftyJSON

class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    
    
    func postRegisterDevice(completion: @escaping (Bool) -> Void) {
        let url = "https://gateway.alzubda.com/users"
        
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        let deviceID = UIDevice.current.identifierForVendor?.uuidString ?? ""
        let deviceModelType = UIDevice.current.model
        let deviceOperatingSystem = UIDevice.current.systemVersion
                
        var parameters: [String: String] = [
            "current_version_app": appVersion,
            "device_id": deviceID,
            "device_model_type": deviceModelType,
            "device_operating_system": deviceOperatingSystem,
            "device_type": "IOS"
        ]
        print("paramaters:",parameters)
       
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: HTTPHeaders())
            .validate(statusCode: 200..<300) // Ensure a valid status code
            .responseJSON { response in
                switch response.result {
                case .success:
                    if let data = response.value {
                        print("Success: \(data)")
                        let json = JSON(data)
                        if let token = json["data"]["user_token"].stringValue as? String {
                            print("get token :", token)
                            UserDefaults.standard.set(token, forKey: "user_token")
                            UserDefaults.standard.synchronize() // Optional, but ensures immediate saving
                            print("Success: Token saved")
                            completion(true)
                            
                        } else {

                            print("Token not found in response")
                                completion(false)
                        }
                    } else {
                       
                        print("Response data is nil")
                        completion(false)
                    }
    
                case .failure(let error):
                    print("Error: \(error)")
                    completion(false)
                   
                }
            }
    }
    
    func getCategories(userToken: String, completion: @escaping ([Category]) -> Void) {
        if let url = URL(string: "https://gateway.alzubda.com/categories") {
            
            let headers: HTTPHeaders = [
                "Authorization": "Bearer \(userToken)",
            ]
            
            AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
                switch response.result {
                case .success:
                    if let data = response.value {
                        let json = JSON(data)
                        print("json :", json)
                        
                        // Check if the JSON has an array of categories under the key "data"
                        if let categoriesArray = json["data"].array {
                            
                            var categories: [Category] = []
                            
                            // Iterate through the array and create Category objects
                            for categoryJSON in categoriesArray {
                                let category = Category(json: categoryJSON)
                                categories.append(category)
                            }
                            
                            completion(categories)
                        } else {
                            print("Categories array not found in JSON")
                            completion([])
                        }
                    } else {
                        print("Response data is nil")
                        completion([])
                    }
                    
                case .failure(let error):
                    print("Error: \(error)")
                    completion([])
                }
            }
        }
    }

}

