//
//  CreateAuthenticationEvent.swift
//  Cotter
//
//  Created by Albert Purnama on 3/1/20.
//

import Foundation

public struct CreateAuthenticationEvent: APIRequest, AutoEquatable {
    public typealias Response = CotterEvent
    
    public var path: String {
        if oauth {
            return "/event/create?oauth_token=true"
        }
        return  "/event/create"
    }

    public var method: String = "POST"

    public var body: Data? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        do {
            let data = try encoder.encode(self.evt)
            print("encoded: \(String(decoding:data, as:UTF8.self))")
            return data
        } catch {
            print("error generating CreateAuthenticationEvent request")
            return nil
        }
    }
    
    let evt: CotterEventRequest
    var oauth: Bool = false
    
    // pubKey needs to be a base64 URL safe encoded
    public init(
        evt: CotterEventRequest
    ){
        self.evt = evt
    }
    
    public init(
        evt: CotterEventRequest,
        oauth: Bool
    ) {
        self.evt = evt
        self.oauth = true
    }
}
