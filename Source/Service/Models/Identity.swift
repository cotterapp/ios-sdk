//
//  GetIdentity.swift
//  Cotter
//
//  Created by Albert Purnama on 2/24/20.
//

import Foundation

public struct CotterIdentity: Codable {
    public var identifier: Identifier
    public var token: Token
}

public struct Identifier: Codable {
    public var id:String
    public var createdAt:String
    public var updatedAt:String?
    public var deletedAt:String?
    public var identifier: String
    public var identifierType: String
    public var publicKey: String
    public var deviceType: String
    public var deviceName: String
    public var expiry: String
    
    
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

public struct Token: Codable {
    public var identifier: String
    public var identifierType: String
    public var receiver: String
    public var expireAt: String
    public var signature: String
    
    enum CodingKeys: String, CodingKey {
        case identifier
        case identifierType = "identifier_type"
        case receiver
        case expireAt = "expire_at"
        case signature
    }
}
