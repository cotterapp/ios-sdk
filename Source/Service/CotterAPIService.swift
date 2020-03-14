//
//  File.swift
//  CotterIOS
//
//  Created by Albert Purnama on 2/3/20.
//

import Foundation

public class CotterAPIService {
    // shared cotterAPI service to be used anywhere later
    // when you want to use the APIService, do CotterAPIService.shared.<function-name>
    public static var shared = CotterAPIService()
    
    private let urlSession = URLSession.shared
    var baseURL: URL?
    var path: String?
    var apiSecretKey: String=""
    var apiKeyID: String=""
    var userID: String?
    
    private init(){}
    
    private func apiClient() -> APIClient {
        return CotterClient(apiKeyID: self.apiKeyID, apiSecretKey: self.apiSecretKey, url: self.baseURL!.absoluteString)
    }
    
    public func auth(
        userID:String,
        issuer:String,
        event:String,
        code:String,
        method:String,
        pubKey:String? = nil,
        timestamp:String = String(format:"%.0f",NSDate().timeIntervalSince1970.rounded()),
        cb: @escaping ResultCallback<CotterEvent>
    ) {
        // initialize new client
        let apiClient = self.apiClient()
        
        // register the user
        let req = CreateAuthenticationEvent(
            userID: userID,
            issuer: issuer,
            event: event,
            code: code,
            method: method,
            pubKey: pubKey,
            timestamp: timestamp
        )
        
        apiClient.send(req) { response in
            cb(response)
        }
    }
    
    public func registerUser(
        userID: String,
        cb: @escaping ResultCallback<CotterUser>
    ) {
        // initialize new client
        let apiClient = self.apiClient()
       
        // register the user
        apiClient.send(RegisterUser(userID: userID)) { response in
            cb(response)
        }
    }
    
    public func enrollUserPin(
        code: String,
        cb: @escaping ResultCallback<CotterUser>
    ) {
        // initialize new client
        let apiClient = self.apiClient()

         // register the user
        let req = EnrollUserPIN(userID: CotterAPIService.shared.userID!, code: code)
        apiClient.send(req) { response in
            cb(response)
         }
    }
    
    public func updateUserPin(
        oldCode: String,
        newCode: String,
        cb: @escaping ResultCallback<CotterUser>
    ) {
        // initialize new client
        let apiClient = self.apiClient()
        
        let req = UpdateUserPIN(userID: CotterAPIService.shared.userID!, newCode:newCode, oldCode: oldCode)
        apiClient.send(req) { response in
            cb(response)
         }
    }
    
    public func getBiometricStatus(
        cb: @escaping ResultCallback<EnrolledMethods>
    ) {
        let internalCb = CotterCallback()
        
        guard let pubKey = KeyGen.pubKey else {
            internalCb.internalErrorHandler(err: "Unable to attain user's public key!")
            return
        }
        
        let pubKeyBase64 = CryptoUtil.keyToBase64URL(pubKey: pubKey)
        
        guard let userID = CotterAPIService.shared.userID else { return }
        
        let apiClient = self.apiClient()
        
        let req = GetBiometricStatus(userID: userID, pubKey: pubKeyBase64)
        apiClient.send(req, completion: cb)
    }
    
    public func updateBiometricStatus(
        enrollBiometric: Bool,
        cb: @escaping ResultCallback<CotterUser>
    ) {
        let internalCb = CotterCallback()
        
        guard let pubKey = KeyGen.pubKey else {
            internalCb.internalErrorHandler(err: "Unable to attain user's public key!")
            return
        }
        
        let pubKeyBase64 = CryptoUtil.keyToBase64(pubKey: pubKey)
        
        guard let userID = CotterAPIService.shared.userID else { return }
        
        let apiClient = self.apiClient()
        
        let req = UpdateBiometricStatus(userID: userID, enroll:enrollBiometric, pubKey: pubKeyBase64)
        
        apiClient.send(req) { response in
            cb(response)
        }
    }
    
    public func requestToken(
        codeVerifier: String,
        challengeID: Int,
        authorizationCode: String,
        redirectURL: String,
        cb: @escaping ResultCallback<CotterIdentity>
    ) {
        let apiClient = self.apiClient()
        
        let req = RequestToken(
            codeVerifier: codeVerifier,
            challengeID: challengeID,
            authorizationCode: authorizationCode,
            redirectURL: redirectURL)
        
        apiClient.send(req, completion:cb)
    }
    
    public func getUser(
        userID: String,
        cb: @escaping ResultCallback<CotterUser>
    ) {
        let apiClient = self.apiClient()
        
        let req = GetUser(userID: userID)
        apiClient.send(req, completion: cb)
    }
    
    public func registerBiometric(
        userID:String,
        pubKey:String, // base64 pubKey NOT URL SAFE!
        cb: @escaping ResultCallback<CotterUser>
    ) {
        let apiClient = self.apiClient()
        
        let req = RegisterBiometric(userID: userID, pubKey: pubKey)
        apiClient.send(req, completion:cb)
    }
}

