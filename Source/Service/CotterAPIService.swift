//
//  File.swift
//  CotterIOS
//
//  Created by Albert Purnama on 2/3/20.
//

import Foundation

public typealias Callback = (String) -> Void

public class CotterAPIService {
    // shared cotterAPI service to be used anywhere later
    // when you want to use the APIService, do CotterAPIService.shared.<function-name>
    public static let shared = CotterAPIService()
    
    // defaultCb is the default callback function for token
    public static func defaultCb(token:String) -> Void{
        print(token)
        return
    }
    
    private let urlSession = URLSession.shared
    var baseURL: URL?
    var path: String?
    var apiSecretKey: String=""
    var apiKeyID: String=""
    var userID: String?
    
    private init(){}
    
    private let jsonDecoder: JSONDecoder = {
       let jsonDecoder = JSONDecoder()
       jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
       let dateFormatter = DateFormatter()
       dateFormatter.dateFormat = "yyyy-mm-dd"
       jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)
       return jsonDecoder
    }()
    
    public func http(
        method: String,
        path: String,
        body: Data?,
        cb: HTTPCallback // pass in a protocol here
    ) {
        // set url path
        let urlString = self.baseURL!.absoluteString + path
        let url = URL(string:urlString)!
        
        // create request
        var request = URLRequest(url:url)
        
        // fill the required request headers
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(self.apiSecretKey, forHTTPHeaderField: "API_SECRET_KEY")
        request.setValue(self.apiKeyID, forHTTPHeaderField: "API_KEY_ID")
        request.httpMethod = method
        
        // fill in the body with json if exist
        if body != nil {
            request.httpBody = body
        }
        
        // start http request
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            guard let data = data,
                let response = response as? HTTPURLResponse,
                error == nil else { // check for fundamental networking error
                cb.networkErrorHandler(err: error)
                return
            }
            
            guard (200 ... 299) ~= response.statusCode else {   // check for http errors
                print("statusCode should be 2xx, but is \(response.statusCode)")
                print("response = \(response)")
                print("errMsg = \(String(decoding: data, as:UTF8.self))")
                
                // handle error
                DispatchQueue.main.async{
                    cb.statusNotOKHandler(statusCode: response.statusCode)
                }
                return
            }
            
            // if it reaches this point, that means the http request is successful
            DispatchQueue.main.async{
                cb.successfulHandler(response: data)
            }
        }
        task.resume()
    }
    
    public func auth(
        body: Data?,
        cb: HTTPCallback
    ) {
        // set url path
        let urlString = self.baseURL!.absoluteString + "/event/create"
        let url = URL(string:urlString)!
        
        // create request
        var request = URLRequest(url:url)
        
        // fill the required request headers
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(self.apiSecretKey, forHTTPHeaderField: "API_SECRET_KEY")
        request.setValue(self.apiKeyID, forHTTPHeaderField: "API_KEY_ID")
        
        // always a POST request
        request.httpMethod = "POST"
        
        // fill in the body with json if exist
        if body != nil {
            request.httpBody = body
        }
        
        // start http request
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            guard let data = data,
                let response = response as? HTTPURLResponse,
                error == nil else { // check for fundamental networking error
                // TODO: error handling
                cb.networkErrorHandler(err: error)
                return
            }
            
            guard (200 ... 299) ~= response.statusCode else {   // check for http errors
                print("statusCode should be 2xx, but is \(response.statusCode)")
                print("errorMsg = \(String(decoding: data, as: UTF8.self))")
                print("response = \(response)")
                
                // error handling
                DispatchQueue.main.async{
                    // handle failed authentication
                    cb.statusNotOKHandler(statusCode: response.statusCode)
                }
                
                return
            }
            
            // if it reaches this point, that means the http request is successful
            DispatchQueue.main.async{
                // handle success authentication
                cb.successfulHandler(response: data)
            }
        }
        task.resume()
    }
    
    public func registerUser(
        userID: String,
        cb: HTTPCallback
    ) {
        // register the user
        let method = "POST"
        let path = "/user/create"
        let data = [
            "client_user_id": userID
        ]
        
        let body = try? JSONSerialization.data(withJSONObject: data)
        
        self.http(
            method: method,
            path: path,
            body: body,
            cb: cb
        )
    }
    
    public func enrollUserPin(
        code: String,
        cb: HTTPCallback
    ) {
        let method = "PUT"
        let path = "/user/" + CotterAPIService.shared.userID!
        let data: [String: Any] = [
            "method": "PIN",
            "enrolled": true,
            "code": code
        ]
        
        let body = try? JSONSerialization.data(withJSONObject: data)
        
        self.http(
            method: method,
            path: path,
            body: body,
            cb: cb
        )
    }
    
    public func updateUserPin(
        oldCode: String,
        newCode: String,
        cb: HTTPCallback
    ) {
        let method = "PUT"
        let path = "/user/" + CotterAPIService.shared.userID!
        let data: [String: Any] = [
            "method": "PIN",
            "enrolled": true,
            "current_code": oldCode,
            "code": newCode,
            "change_code": true
        ]
        
        let body = try? JSONSerialization.data(withJSONObject: data)
        
        self.http(
            method: method,
            path: path,
            body: body,
            cb:cb
        )
    }
    
    public func requestToken(
        codeVerifier: String,
        challengeID: Int,
        authorizationCode: String,
        redirectURL: String,
        cb: HTTPCallback
    ) {
        let method = "POST"
        let path = "/verify/get_identity"
        let data: [String:Any] = [
            "code_verifier": codeVerifier,
            "challenge_id": challengeID,
            "authorization_code": authorizationCode,
            "redirect_url": redirectURL
        ]
        
        let body = try? JSONSerialization.data(withJSONObject: data)
        print(data)
        
        self.http(
            method: method,
            path: path,
            body: body,
            cb:cb
        )
    }
}

