//
//  HTTPCallback.swift
//  Cotter
//
//  Created by Albert Purnama on 2/17/20.
//

import Foundation

public protocol HTTPCallback {
    // networkErrorHandler handles any network error
    func networkErrorHandler(err: Error?) -> Void
    
    // statusNotOKHandler handles responsses that indicates
    // non successful client request
    func statusNotOKHandler(statusCode: Int) -> Void
    
    // successfulHandler handles successful response request
    // this does not mean that requests are approved
    // PIN authentication fails whenever approved=false
    func successfulHandler(response: Data?) -> Void
}

class CotterCallback: HTTPCallback {
    // optional functions
    public var networkErrorFunc: ((Error?) -> Void)?
    public var statusNotOKFunc: ((Int) -> Void)?
    public var successfulFunc: ((Data?) -> Void)?
    
    // networkErrorHandler is the default handler for network errors
    public func networkErrorHandler(err: Error?) {
        print("error", err ?? "Unknown error")
        
        // if the networkErrorFunc is defined then respond with the function
        if let f = self.networkErrorFunc {
            f(err)
        }
        return
    }
    
    // statusNotOKHandler is the default handler for non 2XX responses
    public func statusNotOKHandler(statusCode: Int) {
        print("status \(statusCode) for the request")
        
        // if the statusNotOKFunc is defined then respond with the function
        if let f = self.statusNotOKFunc {
            f(statusCode)
        }
        return
    }
    
    // successfulHandler is the default handler for successful requests
    public func successfulHandler(response: Data?) {
        guard let response = response else {
            print("failed parsing data to string")
            return
        }
        let respString = String(decoding:response, as: UTF8.self)
        print("successfully created the request with response: \(respString)")
        
        // if the successfulFunc is defined then respond with the function
        if let f = self.successfulFunc {
            f(response)
        }
        return
    }
}
