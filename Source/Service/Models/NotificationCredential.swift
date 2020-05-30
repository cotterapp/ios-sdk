//
//  NotificationCredential.swift
//  Cotter
//
//  Created by Albert Purnama on 5/3/20.
//

import UIKit

public struct CotterNotificationCredential: Codable {
    public var id:Int
    public var createdAt:String
    public var updatedAt:String?
    public var deletedAt:String?
    public var companyID:String
    public var appID:String
    
    enum CodingKeys:String, CodingKey {
        case id = "ID"
        case createdAt = "created_at"
        case deletedAt = "deleted_at"
        case updatedAt = "updated_at"
        case companyID = "company_id"
        case appID = "app_id"
    }
}
