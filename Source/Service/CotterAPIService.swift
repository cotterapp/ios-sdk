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
    
}
