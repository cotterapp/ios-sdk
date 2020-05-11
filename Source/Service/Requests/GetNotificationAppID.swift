//
//  GetNotificationAppID.swift
//  Cotter
//
//  Created by Albert Purnama on 5/3/20.
//

import UIKit

class GetNotificationAppID: APIRequest, AutoEquatable {
    public typealias Response = CotterNotificationCredential
    
    public var path: String {
        return "/notification/company"
    }
    
    public var method: String = "GET"
    
    public var body: Data? {
        return nil
    }
}
