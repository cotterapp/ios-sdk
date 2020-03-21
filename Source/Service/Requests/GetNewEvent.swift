//
//  GetNewEvent.swift
//  Cotter
//
//  Created by Albert Purnama on 3/19/20.
//

import Foundation

public struct GetNewEvent: APIRequest {
    public typealias Response = CotterEvent?
    
    public var path: String {
        return "/event/new/\(self.userID)"
    }
    
    public let method: String = "GET"
    
    public var body: Data? {
        return nil
    }
        var userID:String
    
    public init(userID:String){
        self.userID = userID
    }
}
