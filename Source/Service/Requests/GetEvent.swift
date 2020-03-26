//
//  GetEvent.swift
//  Cotter
//
//  Created by Albert Purnama on 3/24/20.
//

import Foundation

public struct GetEvent: APIRequest {
    public typealias Response = CotterEvent
    
    public var path: String {
        return "/event/get/\(self.eventID)"
    }
    
    public var method: String = "GET"
    
    public var body: Data? {
        return nil
    }
    
    var eventID:String
    
    // pubKey needs to be a base64 URL safe encoded
    public init(eventID:String){
        self.eventID = eventID
    }
}
