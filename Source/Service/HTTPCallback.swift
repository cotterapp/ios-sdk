//
//  HTTPCallback.swift
//  Cotter
//
//  Created by Albert Purnama on 2/17/20.
//

import Foundation

public typealias ResultCallback<Value> = (Result<Value, Error>) -> Void
public typealias CotterResult<Value> = Result<Value, Error>

public func DefaultResultCallback<T:Encodable>(resp: Result<T, Error>) -> Void {
    switch resp {
    case .success(let data):
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .prettyPrinted
        let jsonData = try! jsonEncoder.encode(data)
        print("successful DefaultResultCallback \(String(decoding:jsonData, as: UTF8.self))")
    case .failure(let err):
        print("error on DeffaultResultCallback: \(err.localizedDescription)")
    }
}

public protocol InternalCallback {
    // internalErrorHandler handles any internal error (i.e. keychain error)
    // prior to HTTP Requests
    func internalErrorHandler(err: String?) -> Void
    // internalSuccessHandler handles successful HTTP Response Request
    func internalSuccessHandler() -> Void
}

public class CotterCallback: InternalCallback {
    // optional functions
    public var internalErrorFunc: ((String?) -> Void)?
    public var internalSuccessFunc: (() -> Void)?

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
