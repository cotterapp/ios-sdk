//
//  File.swift
//  CotterIOS
//
//  Created by Albert Purnama on 2/3/20.
//

import Foundation

public class CotterAPIService {
    // shared cotterAPI service to be used anywhere later
    // when you want to use the APIService, do CotterAPIService.shared.<function-name>
    public static let shared = CotterAPIService()
    
    private let urlSession = URLSession.shared
    private var baseURL: URL?
    private var path: String?
    private var apiSecretKey: String=""
    private var apiKeyID: String=""
    private var userID: String?
    
    private init(){}
    
    // getURL is getter for URL object in the APIService
    public func getURL() -> URL? {
        return self.baseURL
    }
    
    // setURL sets the URL
    public func setBaseURL(url: String) {
        self.baseURL = URL(string: url)
    }
    
    // setKeyPair to set the key pair of current APIService instance
    public func setKeyPair(keyID: String, secretKey: String) {
        self.apiSecretKey = secretKey
        self.apiKeyID = keyID
    }
    
    // getKeyID to get the key ID
    public func getKeyID() -> String {
        return self.apiKeyID
    }
    
    public func getSecretKey() -> String {
        return self.apiSecretKey
    }
    
    public func setUserID(userID: String) {
        self.userID = userID
    }
    
    public func getUserID() -> String? {
        return self.userID
    }
    
    private let jsonDecoder: JSONDecoder = {
       let jsonDecoder = JSONDecoder()
       jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
       let dateFormatter = DateFormatter()
       dateFormatter.dateFormat = "yyyy-mm-dd"
       jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)
       return jsonDecoder
    }()
    
    // TODO: http requests functions should be here
    public func http(method:String, path:String, data: [String:Any]?, succesCb: @escaping (String) -> Void, errCb: @escaping (String) -> Void) {
        // set url path
        let urlString = CotterAPIService.shared.getURL()!.absoluteString + path
        let url = URL(string:urlString)!
        
        // create request
        var request = URLRequest(url:url)
        
        // fill the required request headers
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(self.getSecretKey(), forHTTPHeaderField: "API_SECRET_KEY")
        request.setValue(self.getKeyID(), forHTTPHeaderField: "API_KEY_ID")
        request.httpMethod = method
        
        // fill in the body with json if exist
        if data != nil {
            request.httpBody = try? JSONSerialization.data(withJSONObject: data!)
        }
        
        // start http request
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            guard let data = data,
                let response = response as? HTTPURLResponse,
                error == nil else { // check for fundamental networking error
                // TODO: error handling
                print("error", error ?? "Unknown error")
                return
            }
            
            guard (200 ... 299) ~= response.statusCode else {   // check for http errors
                print("statusCode should be 2xx, but is \(response.statusCode)")
                print("response = \(response)")
                
                // error handling
                DispatchQueue.main.async{
                    errCb("statusCode should be 2xx, but is \(response.statusCode)")
                }
                
                return
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
            // if it reaches this point, that means the http request is successful
            DispatchQueue.main.async{
                succesCb(responseString!)
            }
        }
        task.resume()
    }
}
