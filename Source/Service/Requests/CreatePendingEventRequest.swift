//
//  CreatePendingEventRequest.swift
//  Cotter
//
//  Created by Albert Purnama on 3/20/20.
//

import Foundation

public struct CreatePendingEventRequest: APIRequest {
    public typealias Response = CotterEvent
    
    public var path: String {
        return  "/event/create_pending"
    }

    public var method: String = "POST"

    public var body: Data? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        do {
            let data = try encoder.encode(self.event)
            print("encoded: \(String(decoding:data, as:UTF8.self))")
            return data
        } catch {
            print("error generating CreateAuthenticationEvent request")
            return nil
        }
    }
    
    let event: CotterEventRequest
    
    public init(
        evt: CotterEventRequest
    ) {
        self.event = evt
    }
}
