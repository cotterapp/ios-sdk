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

public class CotterCallback: HTTPCallback {
    // optional functions
    public let networkErrorFunc: ((Error?) -> Void)?
    public let statusNotOKFunc: ((Int) -> Void)?
    public let successfulFunc: ((Data?) -> Void)?
    
    public init() {
        networkErrorFunc = nil
        successfulFunc = nil
        statusNotOKFunc = nil
    }
    
    public init(
        successfulFunc: ((Data?) -> Void)? = nil,
        networkErrorFunc: ((Error?) -> Void)? = nil,
        statusNotOKFunc: ((Int) -> Void)? = nil
    ) {
        self.successfulFunc = successfulFunc
        self.networkErrorFunc = networkErrorFunc
        self.statusNotOKFunc = statusNotOKFunc
    }
    
    // networkErrorHandler is the default handler for network errors
    public func networkErrorHandler(err: Error?) {
        print("error", err ?? "Unknown error")
        
        // if the networkErrorFunc is defined then respond with the function
        guard let f = self.networkErrorFunc else { return }
        f(err)
        return
    }
    
    // statusNotOKHandler is the default handler for non 2XX responses
    public func statusNotOKHandler(statusCode: Int) {
        print("status \(statusCode) for the request")
        
        // if the statusNotOKFunc is defined then respond with the function
        guard let f = self.statusNotOKFunc else { return }
        f(statusCode)
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
        guard let f = self.successfulFunc else { return }
        f(response)
        return
    }
}
