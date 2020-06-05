//
//  User.swift
//  Cotter
//
//  Created by Albert Purnama on 3/1/20.
//

import Foundation

public struct CotterUser: Codable {
    public var id:String
    public var createdAt:String
    public var updatedAt:String?
    public var deletedAt:String?
    public var issuer:String
    public var identifier:String
    public var clientUserID:String
    public var enrolled:[String]
    public var defaultMethod:String?
    
    enum CodingKeys:String, CodingKey {
        case id = "ID"
        case createdAt = "created_at"
        case deletedAt = "deleted_at"
        case updatedAt = "update_at" // notice that this is update_at instead of updated_at!
        case issuer
        case clientUserID = "client_user_id"
        case identifier
        case enrolled
        case defaultMethod = "default_method"
    }
}
