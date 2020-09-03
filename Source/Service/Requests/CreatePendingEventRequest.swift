//
//  CreatePendingEventRequest.swift
//  Cotter
//
//  Created by Albert Purnama on 3/20/20.
//

import Foundation

public struct CreatePendingEventRequest: APIRequest, AutoEquatable {
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
            return data
        } catch {
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
