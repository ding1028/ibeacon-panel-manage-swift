//
//  ApiHandler.swift
//  IntercomKeypadLockClient
//
//  Created by my on 5/22/19.
//  Copyright © 2019 newlinks. All rights reserved.
//

import Foundation
import Alamofire

class ApiHandler: NSObject {
    static let shared = ApiHandler()
    private override init() {
    }
   
    func registerDevice(cellular: String, token: String, success: @escaping (Data)->(), failure: @escaping (Error)->()) {
        let parameters = [
            "token": token,
            "cellular": cellular,
            "os": "1"
        ]
        let url = Config.shared.apiUrl + "users/registerDevice";
        Alamofire.request(url, method: .post, parameters: parameters)
            .responseData { (response) in
                switch response.result {
                    case .success(let value):
                    success(value)
                    case .failure(let error):
                    failure(error)
                }
        }
    }
    
    func getUserDetails(userIx: String, success: @escaping (Data)->(), failure: @escaping (Error)->()) {
        let parameters = [
            "userIx": userIx
        ]
        let url = Config.shared.apiUrl + "users/getUserDetails";
        Alamofire.request(url, method: .post, parameters: parameters)
            .responseData { (response) in
                switch response.result {
                case .success(let value):
                    success(value)
                case .failure(let error):
                    failure(error)
                }
        }
    }
    
    func getPanelList(userIx: String, success: @escaping (Data)->(), failure: @escaping (Error)->()) {
        let parameters = [
            "userIx": userIx
        ]
        let url = Config.shared.apiUrl + "users/getPanelList";
        Alamofire.request(url, method: .post, parameters: parameters)
            .responseData { (response) in
                switch response.result {
                case .success(let value):
                    success(value)
                case .failure(let error):
                    failure(error)
                }
        }
    }
    
    func openFromApp(picture: String, userIx: String, panelIx: String, success: @escaping (Data)->(), failure: @escaping (Error)->()) {
        let parameters = [
            "picture": picture,
            "panelIx": panelIx,
            "userIx": userIx
        ]
        let url = Config.shared.apiUrl + "users/openFromApp";
        Alamofire.request(url, method: .post, parameters: parameters)
            .responseData { (response) in
                switch response.result {
                case .success(let value):
                    success(value)
                case .failure(let error):
                    failure(error)
                }
        }
    }
}
