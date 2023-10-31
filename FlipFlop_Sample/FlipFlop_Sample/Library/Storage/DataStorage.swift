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
    
    static func initializeToken(apiKey: String, apiSecret: String) {
        let loginString = String(format: "%@:%@", apiKey, apiSecret)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        token = base64LoginString
    }
}
