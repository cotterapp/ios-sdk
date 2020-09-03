//
//  RespondEvent.swift
//  Cotter
//
//  Created by Albert Purnama on 3/25/20.
//

import Foundation

public struct RespondEvent: APIRequest, AutoEquatable {
    public typealias Response = CotterEvent
    
    public var path: String {
        return "/event/respond/\(self.eventID)"
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
    
    let eventID: String
    let event: CotterEventRequest
    
    public init(
        evtID: String,
        evt: CotterEventRequest
    ) {
        self.event = evt
        self.eventID = evtID
    }
}
