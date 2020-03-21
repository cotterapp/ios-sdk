//
//  EventCreateResponse.swift
//  Cotter
//
//  Created by Albert Purnama on 2/17/20.
//

import Foundation

// MARK: - Response Type

public struct CotterEvent: Codable {
    var id:Int
    var createdAt:String
    var updatedAt:String?
    var deletedAt:String?
    var clientUserID:String
    var issuer:String
    var event:String
    var ip:String
    var location:String
    var timestamp:String
    var method:String
    var new:Bool
    var approved:Bool
    
    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case createdAt = "CreatedAt"
        case deletedAt = "DeletedAt"
        case clientUserID = "client_user_id"
        case issuer
        case event
        case ip
        case location
        case timestamp
        case method
        case new
        case approved
    }
}

// MARK: - Request Type

public struct CotterEventRequest: Encodable {
    let pubKey:String?
    let userID:String
    let issuer:String
    let event:String
    let ipAddr:String
    let location:String
    let timestamp:String
    let authMethod:String
    let code:String?
    let approved:Bool
    
    enum CodingKeys: String, CodingKey {
        case userID = "client_user_id"
        case issuer
        case event
        case ipAddr = "ip"
        case location
        case timestamp
        case authMethod = "method"
        case approved
        case pubKey = "public_key"
        case code
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
        
        if code != nil {
            try container.encode(code, forKey: .code)
        }
        
        if pubKey != nil {
            try container.encode(pubKey, forKey: .pubKey)
        }
    }
}
