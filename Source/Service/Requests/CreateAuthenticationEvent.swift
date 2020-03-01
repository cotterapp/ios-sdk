//
//  CreateAuthenticationEvent.swift
//  Cotter
//
//  Created by Albert Purnama on 3/1/20.
//

import Foundation

public struct CreateAuthenticationEvent: APIRequest {
    public typealias Response = CotterEvent
    
    public var path: String {
        return  "/event/create"
    }

    public var method: String {
        return "POST"
    }

    public var body: Data? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        do {
            let data = try encoder.encode(self)
            print("encoded: \(String(decoding:data, as:UTF8.self))")
            return data
        } catch {
            print("error generating CreateAuthenticationEvent request")
            return nil
        }
    }
    
    let pubKey:String?
    let userID:String
    let issuer:String
    let event:String
    let ipAddr:String
    let location:String
    let timestamp:String
    let code:String
    let authMethod:String
    let approved:Bool
    
    // pubKey needs to be a base64 URL safe encoded
    public init(
        userID:String,
        issuer:String,
        event:String,
        code:String,
        method:String,
        pubKey:String? = nil,
        timestamp:String = String(format:"%.0f",NSDate().timeIntervalSince1970.rounded())
    ){
        // get the external ip address
        self.ipAddr = LocalAuthService.ipAddr ?? "unknown"
        
        // location is still unknown for 1.3.0
        self.location = "unknown"
        
        self.timestamp = timestamp
        
        self.approved = true
        
        self.userID = userID
        self.pubKey = pubKey
        self.issuer = issuer
        self.event  = event
        self.code   = code
        self.authMethod = method
    }
}

extension CreateAuthenticationEvent:Encodable {
    enum CodingKeys: String, CodingKey {
        case userID = "client_user_id"
        case code
        case issuer
        case event
        case ipAddr = "ip"
        case location
        case timestamp
        case authMethod = "method"
        case approved
        case pubKey = "public_key"
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(userID, forKey: .userID)
        try container.encode(issuer, forKey: .issuer)
        try container.encode(event, forKey: .event)
        try container.encode(ipAddr, forKey: .ipAddr)
        try container.encode(location, forKey: .location)
        try container.encode(timestamp, forKey: .timestamp)
        try container.encode(authMethod, forKey: .authMethod)
        try container.encode(approved, forKey: .approved)
        try container.encode(code, forKey: .code)
        
        if pubKey != nil {
            try container.encode(pubKey, forKey: .pubKey)
        }
    }
}
