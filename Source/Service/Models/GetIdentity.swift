//
//  GetIdentity.swift
//  Cotter
//
//  Created by Albert Purnama on 2/24/20.
//

import Foundation

struct GetIdentityResponse: Codable {
    var identifier: Identifier
    var token: Token
}

struct Identifier: Codable {
    var id:String
    var createdAt:String
    var updatedAt:String?
    var deletedAt:String?
    var identifier: String
    var identifierType: String
    var publicKey: String
    var deviceType: String
    var deviceName: String
    var expiry: String
    
    
    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case createdAt = "created_at"
        case deletedAt = "deleted_at"
        case updatedAt = "update_at" // notice that this is update_at instead of updated_at!
        case identifier
        case identifierType = "identifier_type"
        case publicKey = "public_key"
        case deviceType = "device_type"
        case deviceName = "device_name"
        case expiry
    }
}

struct Token: Codable {
    var identifier: String
    var identifierType: String
    var receiver: String
    var expireAt: String
    var signature: String
    
    enum CodingKeys: String, CodingKey {
        case identifier
        case identifierType = "identifier_type"
        case receiver
        case expireAt = "expire_at"
        case signature
    }
}
