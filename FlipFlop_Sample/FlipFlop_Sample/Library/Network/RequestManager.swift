//
//  RequestManager.swift
//  FlipFlop_iOS_Sample
//
//  Created by DoHyoung Kim on 2023/07/03.
//

import Foundation
import Alamofire
import UIKit

class RequestManager {
    
    enum API: String {
        
        case postToken = "/v2/apps/me/members/login"
        case getVideoRooms = "/v2/apps/me/video-rooms"
        
        var method: HTTPMethod {
            switch self {
            case .postToken:
                return .post
            default:
                return .get
            }
        }
        
        var encoding: ParameterEncoding {
            switch self {
            case .postToken:
                return JSONEncoding.default
            default:
                return URLEncoding.default
            }
        }
    }
    
    static var header: HTTPHeaders {
        var head = HTTPHeaders()
        head.add(name: "Authorization", value: "Basic " + DataStorage.token)
        return head
    }
    
    open class func req<T: Codable>(loading: Bool = true,
                                    url: API,
                                    params: (() -> [String:Any]?)? = nil,
                                    type: T.Type,
                                    completionHandler: @escaping(_ isComplete: Bool, _ response: T?, _ error: Data?) -> Void) {
        
        var fullUrl = DataStorage.host + url.rawValue
        
        fullUrl = fullUrl.replacingOccurrences(of: "{get}", with: "")
        fullUrl = fullUrl.replacingOccurrences(of: "{post}", with: "")
        
        if fullUrl.contains("{contents_id}") {
            let param = convertParams(params: params)
            var contentsID = ""
            if let idStr = param["contentsID"] as? String {
                contentsID = idStr
            } else if let idInt = param["contentsID"] as? Int {
                contentsID = "\(idInt)"
            }
            
            fullUrl = fullUrl.replacingOccurrences(of: "{contents_id}", with: contentsID)
        }
        
        AF.request(URL(string: fullUrl)!,
                   method: url.method,
                   parameters: params?(),
                   encoding: url.method == .post ? JSONEncoding.default : url.encoding,
                   headers: header)
        .responseDecodable(of:type, completionHandler: { response in
            print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
            print("fullUrl = ", response.request?.url?.absoluteString)
            print("param = ", params?())
            print("header = ", header)
            print("network status = ", response.response?.statusCode)
            if let data = response.data, let resString = String(data: data, encoding: .utf8) {
                print("resString = ", resString)
                decodeData(responseData: data, type: type)
            }
            print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
            
            switch response.result {
            case .success(let res):
                completionHandler(true, res, nil)
                break
            case .failure(let error):
                print("Error = ", error.localizedDescription)
                if response.response?.statusCode == 200 {
                    completionHandler(true, nil, nil)
                } else {
                    if let data = response.data {
                        completionHandler(false, nil, data)
                    }
                }
                break
            }
        })
    }
    
    class func uploadFile(images: [UIImage]? = nil, videos: [Any]? = nil, completionHandler: @escaping(_ isComplete: Bool, _ response: [String]?) -> Void) {
        let fullUrl = DataStorage.host + "1/file"
        
        AF.upload(multipartFormData: { multipartFormData in
            if let imgs = images {
                for img in imgs {
                    multipartFormData.append(img.jpegData(compressionQuality: 1.0)!, withName: "files",fileName: "files", mimeType: "image/jpeg")
                }
            }
        }, to: URL(string: fullUrl)!,
                  method: .post)
        .responseDecodable(of: [String].self, completionHandler: { response in
            if let data = response.data {
                print("response = ", String(data: data, encoding: .utf8))
                decodeData(responseData: data, type: [String].self)
            }
            switch response.result {
            case .success(let result):
                print("fileUpload response = ", result)
                completionHandler(true, result)
                break
            case .failure(let error):
                print("Error = ", error.localizedDescription)
                completionHandler(false, nil)
                break
            }
        })
    }
    
    class func convertParams(params: (() -> [String:Any]?)? = nil) -> [String: Any] {
        var paramDic: [String: Any] = [:]
        
        if let param = params?() {
            paramDic = param
        }
        
        return paramDic
    }
    
    class private func decodeData<T: Codable>(responseData: Data, type: T.Type) {
        do {
           let _ = try JSONDecoder().decode(type, from: responseData)
        } catch let DecodingError.dataCorrupted(context) {
            print(context)
        } catch let DecodingError.keyNotFound(key, context) {
            print("Key '\(key)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch let DecodingError.valueNotFound(value, context) {
            print("Value '\(value)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch let DecodingError.typeMismatch(type, context)  {
            print("Type '\(type)' mismatch:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch {
            print("error: ", error)
        }
    }
    
}
