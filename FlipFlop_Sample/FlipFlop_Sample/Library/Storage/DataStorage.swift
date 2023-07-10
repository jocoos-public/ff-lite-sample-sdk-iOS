//
//  DataStorage.swift
//  FlipFlop_iOS_Sample
//
//  Created by DoHyoung Kim on 2023/07/03.
//

import Foundation
import UIKit

class DataStorage: NSObject {
    
    static var isLogined: Bool {
        get {
            if let logined = UserDefaults.standard.object(forKey: "isLogined") as? Bool {
                return logined
            } else {
                return false
            }
        }
        
        set {
            UserDefaults.standard.setValue(newValue, forKey: "isLogined")
            UserDefaults.standard.synchronize()
        }
    }
    
    static var loginUser: LoginUserResModel? {
        get {
            if let userData = UserDefaults.standard.object(forKey: "loginUser") as? Data {
                if let userInfo = try? JSONDecoder().decode(LoginUserResModel.self, from: userData) {
                    return userInfo
                } else {
                    return nil
                }
            } else {
                return nil
            }
        }
        
        set {
            if let user = newValue {
                if let userData = try? JSONEncoder().encode(user) {
                    UserDefaults.standard.setValue(userData, forKey: "loginUser")
                    UserDefaults.standard.synchronize()
                } else {
                    UserDefaults.standard.removeObject(forKey: "loginUser")
                    UserDefaults.standard.synchronize()
                }
            } else {
                UserDefaults.standard.removeObject(forKey: "loginUser")
                UserDefaults.standard.synchronize()
            }
        }
    }
    
    static var host: String {
        get {
            if let url = UserDefaults.standard.object(forKey: "hostUrl") as? String {
                return url
            } else {
                return ""
            }
        }
        
        set {
            UserDefaults.standard.setValue(newValue, forKey: "hostUrl")
            UserDefaults.standard.synchronize()
        }
    }
    
    static var token: String = ""
    
    static var fflToken: FFLTokensModel?
    
    static func getToken() {
        guard let userData = loginUser else {return}
        
        
        RequestManager.req(url: .postLogin,
                           params: {
            return [
                "username": userData.username,
                "password": "1234"
            ]
        },
                           type: TokenResModel.self) { isComplete, response, error in
            
            if isComplete {
                if let res = response {
                    token = res.accessToken
                    fflToken = res.fflTokens
                }
            }
        }
    }
}
