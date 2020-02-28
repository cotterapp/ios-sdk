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

public protocol InternalCallback {
    // internalErrorHandler handles any internal error (i.e. keychain error)
    // prior to HTTP Requests
    func internalErrorHandler(err: String?) -> Void
    
    // internalSuccessHandler handles successful HTTP Response Request
    func internalSuccessHandler() -> Void
}

class CotterCallback: HTTPCallback, InternalCallback {
    // optional functions
    public var networkErrorFunc: ((Error?) -> Void)?
    public var statusNotOKFunc: ((Int) -> Void)?
    public var successfulFunc: ((Data?) -> Void)?
    public var internalErrorFunc: ((String?) -> Void)?
    public var internalSuccessFunc: (() -> Void)?
    
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
    
    // internalErrorHandler is the default internal handler for internal errors
    public func internalErrorHandler(err: String?) {
        print("error", err ?? "Unknown error")
        
        // if the internalErrorFunc is defined then respond with the function
        if let f = self.internalErrorFunc {
            f(err)
        }
        return
    }
    
    // internalSuccessHandler is the default internal handler for successful HTTP Requests
    public func internalSuccessHandler() {
        print("executing internal success callback")
        
        // if the internalSuccessFunc is defined then respond with the function
        if let f = self.internalSuccessFunc {
            f()
        }
        return
    }
}
