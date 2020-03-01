//
//  RequestToken.swift
//  Cotter
//
//  Created by Albert Purnama on 3/1/20.
//

import Foundation

public struct RequestToken: APIRequest {
    public typealias Response = CotterIdentity

    public var path: String {
        return "/verify/get_identity"
    }

    public var method: String {
        return "POST"
    }

    public var body: Data? {
        let data: [String:Any] = [
            "code_verifier": codeVerifier,
            "challenge_id": challengeID,
            "authorization_code": authorizationCode,
            "redirect_url": redirectURL
        ]
        
        let body = try? JSONSerialization.data(withJSONObject: data)
        
        return body
    }

    let codeVerifier: String
    let challengeID: Int
    let authorizationCode: String
    let redirectURL: String

    // pubKey needs to be a base64 URL safe encoded
    public init(
        codeVerifier: String,
        challengeID: Int,
        authorizationCode: String,
        redirectURL: String
    ){
        self.codeVerifier = codeVerifier
        self.challengeID = challengeID
        self.authorizationCode = authorizationCode
        self.redirectURL = redirectURL
    }
}
