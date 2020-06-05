//
//  File.swift
//  CotterIOS
//
//  Created by Albert Purnama on 2/3/20.
//

import Foundation

public class CotterAPIService: APIService {
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

        // request auth from non trusted device
        let evt = CotterEventRequest(
            pubKey: pubKey,
            userID: userID,
            issuer: CotterAPIService.shared.apiKeyID,
            event: event,
            ipAddr: LocalAuthService.ipAddr ?? "unknown",
            location: "unknown",
            timestamp: timestamp,
            authMethod: method,
            code: code,
            approved: true
        )
        
        // register the user
        let req = CreateAuthenticationEvent(
            evt: evt
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
        
        guard let pubKey = KeyStore.biometric.pubKey else {
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
        
        guard let pubKey = KeyStore.biometric.pubKey else {
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
    
    public func requestPINReset(
        name: String,
        sendingMethod: String,
        sendingDestination: String,
        cb: @escaping ResultCallback<CotterResponseWithChallenge>
    ) {
        guard let userID = CotterAPIService.shared.userID else { return }
        
        let apiClient = self.apiClient()
        
        let req = RequestPINReset(
            userID: userID,
            name: name,
            sendingMethod: sendingMethod,
            sendingDestination: sendingDestination
        )
        
        apiClient.send(req, completion: cb)
    }
    
    public func verifyPINResetCode(
        resetCode: String,
        challengeID: Int,
        challenge: String,
        cb: @escaping ResultCallback<CotterBasicResponse>
    ) {
        guard let userID = CotterAPIService.shared.userID else { return }
        
        let apiClient = self.apiClient()
        
        let req = VerifyPINResetCode(
            userID: userID,
            resetCode: resetCode,
            challengeID: challengeID,
            challenge: challenge
        )
        
        apiClient.send(req, completion: cb)
    }
    
    public func resetPIN(
        resetCode: String,
        newCode: String,
        challengeID: Int,
        challenge: String,
        cb: @escaping ResultCallback<CotterBasicResponse>
    ) {
        guard let userID = CotterAPIService.shared.userID else { return }
        
        let apiClient = self.apiClient()
        
        let req = ResetPIN(
            userID: userID,
            resetCode: resetCode,
            newCode: newCode,
            challengeID: challengeID,
            challenge: challenge
        )
        
        apiClient.send(req, completion: cb)
    }
    
    public func enrollTrustedDeviceWith(cotterUser: CotterUser, cb: @escaping ResultCallback<CotterUser>) {
        let internalCb = CotterCallback()
        
        guard let pubKey = KeyStore.trusted(userID: cotterUser.id).pubKey else {
            internalCb.internalErrorHandler(err: "Unable to attain user's public key!")
            return
        }
        
        let pubKeyBase64 = CryptoUtil.keyToBase64(pubKey: pubKey)
        
        let apiClient = self.apiClient()
        
        let req = EnrollTrustedDevice(cotterUserID: cotterUser.id, code: pubKeyBase64)
        apiClient.send(req, completion:cb)
    }
    
    public func enrollTrustedDevice(
        clientUserID: String,
        cb: @escaping ResultCallback<CotterUser>
    ) {
        let internalCb = CotterCallback()
        
        guard let pubKey = KeyStore.trusted(userID: clientUserID).pubKey else {
            internalCb.internalErrorHandler(err: "Unable to attain user's public key!")
            return
        }
        
        let pubKeyBase64 = CryptoUtil.keyToBase64(pubKey: pubKey)
        
        let apiClient = self.apiClient()
        
        let req = EnrollTrustedDevice(clientUserID: clientUserID, code: pubKeyBase64)
        apiClient.send(req, completion:cb)
    }
    
    public func getNewEvent(
        userID: String,
        cb: @escaping ResultCallback<CotterEvent?>
    ) {
        let apiClient = self.apiClient()
        
        let req = GetNewEvent(userID: userID)
        apiClient.send(req, completion:cb)
    }
    
    public func getTrustedDeviceStatus(
        clientUserID: String,
        cb: @escaping ResultCallback<EnrolledMethods>
    ) {
        let internalCb = CotterCallback()
        
        guard let pubKey = KeyStore.trusted(userID: clientUserID).pubKey else {
            internalCb.internalErrorHandler(err: "Unable to attain user's public key!")
            return
        }
        
        let pubKeyBase64 = CryptoUtil.keyToBase64URL(pubKey: pubKey)
        
        let apiClient = self.apiClient()
        
        let req = GetTrustedDeviceStatus(clientUserID: clientUserID, pubKey: pubKeyBase64)
        apiClient.send(req, completion: cb)
    }
    
    public func getTrustedDeviceStatusWith(
        cotterUserID: String,
        cb: @escaping ResultCallback<EnrolledMethods>
    ) {
        let internalCb = CotterCallback()
        
        guard let pubKey = KeyStore.trusted(userID: cotterUserID).pubKey else {
            internalCb.internalErrorHandler(err: "Unable to attain user's public key!")
            return
        }
        
        let pubKeyBase64 = CryptoUtil.keyToBase64URL(pubKey: pubKey)
        
        let apiClient = self.apiClient()
        
        let req = GetTrustedDeviceStatus(cotterUserID: cotterUserID, pubKey: pubKeyBase64)
        apiClient.send(req, completion: cb)
    }
    
    public func getTrustedDeviceEnrolledAny(
        userID: String,
        cb: @escaping ResultCallback<EnrolledMethods>
    ) {
        let apiClient = self.apiClient()
        
        let req = GetTrustedDeviceEnrolledAny(userID: userID)
        apiClient.send(req, completion: cb)
    }
    
    // reqAuthWith should always be used over reqAuth because client_user_id is deprecated
    public func reqAuthWith(
           cotterUserID:String,
           event:String,
           cb: @escaping ResultCallback<CotterEvent>
       ) {
           let timestamp = String(format:"%.0f",NSDate().timeIntervalSince1970.rounded())
           
           let internalCb = CotterCallback()
           
           guard let privKey = KeyStore.trusted(userID: cotterUserID).privKey else {
               internalCb.internalErrorHandler(err: "Unable to attain user's private key!")
               return
           }
           
           guard let pubKey = KeyStore.trusted(userID: cotterUserID).pubKey else {
               internalCb.internalErrorHandler(err: "Unable to attain user's public key!")
               return
           }
           
           let pubKeyBase64 = CryptoUtil.keyToBase64(pubKey: pubKey)
           print("current pubKey: \(pubKeyBase64)")
           
           
           // Flow of trusted device authentication:
           // 1. Check if the trusted device auth is enabled
           // 2. Check if this device is a trusted device
           // 3. If 1 and 2 passed, then send the authentication approval
           // 4. Otherwise, create a pending authorization request, or propagate the error
            self.getTrustedDeviceStatusWith(cotterUserID: cotterUserID) { response in
                let method = CotterMethods.TrustedDevice
                
                switch response {
                case .success(let resp):
                    // initialize new client
                    let apiClient = self.apiClient()
                    
                    // authorize device. But also send authorization approval
                    if resp.enrolled && resp.method == method {
                        print("[reqAuth] enrolled on trusted device")
                        
                        // authorize device, create approved event request
                        let msg = "\(cotterUserID)\(CotterAPIService.shared.apiKeyID)\(event)\(timestamp)\(method)true"
                        let code = CryptoUtil.signBase64(privKey: privKey, msg: msg)
                        print("message: \(msg)")

                        // request auth from trusted device
                        let evt = CotterEventRequest(
                            pubKey: pubKeyBase64,
                            userID: cotterUserID,
                            issuer: CotterAPIService.shared.apiKeyID,
                            event: event,
                            ipAddr: LocalAuthService.ipAddr ?? "unknown",
                            location: "unknown",
                            timestamp: timestamp,
                            authMethod: method,
                            code: code,
                            approved: true
                        )
                        
                        let req = CreateAuthenticationEvent(
                            evt: evt,
                            oauth: true
                        )
                        
                        apiClient.send(req) { response in
                            cb(response)
                        }
                        break
                    }
                    // request auth from non trusted device
                    let evt = CotterEventRequest(
                        pubKey: pubKeyBase64,
                        userID: cotterUserID,
                        issuer: CotterAPIService.shared.apiKeyID,
                        event: event,
                        ipAddr: LocalAuthService.ipAddr ?? "unknown",
                        location: "unknown",
                        timestamp: timestamp,
                        authMethod: method,
                        code: nil,
                        approved: false
                    )
                    
                    // create event
                    let req = CreatePendingEventRequest(
                        evt: evt
                    )
                    
                    apiClient.send(req) { response in
                        cb(response)
                    }

                case .failure(let err):
                    // propagates the error
                    cb(.failure(err))
                }
        }
    }
    
    public func reqAuth(
        clientUserID:String,
        event:String,
        cb: @escaping ResultCallback<CotterEvent>
    ) {
        let timestamp = String(format:"%.0f",NSDate().timeIntervalSince1970.rounded())
        
        let internalCb = CotterCallback()
        
        // TODO: NEED TO HAVE KeyGen FOR TrustedDevices
        guard let privKey = KeyStore.trusted(userID: clientUserID).privKey else {
            internalCb.internalErrorHandler(err: "Unable to attain user's private key!")
            return
        }
        
        guard let pubKey = KeyStore.trusted(userID: clientUserID).pubKey else {
            internalCb.internalErrorHandler(err: "Unable to attain user's public key!")
            return
        }
        
        let pubKeyBase64 = CryptoUtil.keyToBase64(pubKey: pubKey)
        print("current pubKey: \(pubKeyBase64)")
        
        
        // get the trusted device status first
        func innerCb(response: CotterResult<EnrolledMethods>) {
            let method = CotterMethods.TrustedDevice
            
            switch response {
            case .success(let resp):
                // initialize new client
                let apiClient = self.apiClient()
                
                // authorize device. But also send authorization approval
                if resp.enrolled && resp.method == method {
                    print("[reqAuth] enrolled on trusted device")
                    
                    // authorize device, create approved event request
                    let msg = "\(clientUserID)\(CotterAPIService.shared.apiKeyID)\(event)\(timestamp)\(method)true"
                    let code = CryptoUtil.signBase64(privKey: privKey, msg: msg)
                    print("message: \(msg)")

                    // request auth from trusted device
                    let evt = CotterEventRequest(
                        pubKey: pubKeyBase64,
                        userID: clientUserID,
                        issuer: CotterAPIService.shared.apiKeyID,
                        event: event,
                        ipAddr: LocalAuthService.ipAddr ?? "unknown",
                        location: "unknown",
                        timestamp: timestamp,
                        authMethod: method,
                        code: code,
                        approved: true
                    )
                    
                    let req = CreateAuthenticationEvent(
                        evt: evt,
                        oauth: true
                    )
                    
                    apiClient.send(req) { response in
                        cb(response)
                    }
                    break
                }
                // request auth from non trusted device
                let evt = CotterEventRequest(
                    pubKey: pubKeyBase64,
                    userID: clientUserID,
                    issuer: CotterAPIService.shared.apiKeyID,
                    event: event,
                    ipAddr: LocalAuthService.ipAddr ?? "unknown",
                    location: "unknown",
                    timestamp: timestamp,
                    authMethod: method,
                    code: nil,
                    approved: false
                )
                
                // register the user
                let req = CreatePendingEventRequest(
                    evt: evt
                )
                
                apiClient.send(req) { response in
                    cb(response)
                }

            case .failure(let err):
                // propagates the error
                cb(.failure(err))
            }
        }
        
        // Flow of trusted device authentication:
        // 1. Check if the trusted device auth is enabled
        // 2. Check if this device is a trusted device
        // 3. If 1 and 2 passed, then send the authentication approval
        // 4. Otherwise, create a pending authorization request, or propagate the error
        self.getTrustedDeviceStatus(clientUserID: clientUserID, cb: innerCb)
    }
    
    public func getEvent(
        eventID:String,
        cb: @escaping ResultCallback<CotterEvent>
    ) {
        let apiClient = self.apiClient()
        
        let req = GetEvent(eventID: eventID)
        apiClient.send(req, completion:cb)
    }
    
    public func approveEvent(
        event: CotterEvent,
        cb: @escaping ResultCallback<CotterEvent>
    ) {
        let apiClient = self.apiClient()
        
        let internalCb = CotterCallback()
        
        guard let privKey = KeyStore.trusted(userID: event.clientUserID).privKey else {
            internalCb.internalErrorHandler(err: "Unable to attain user's private key!")
            return
        }
        
        guard let pubKey = KeyStore.trusted(userID: event.clientUserID).pubKey else {
            internalCb.internalErrorHandler(err: "Unable to attain user's public key!")
            return
        }
        
        let pubKeyBase64 = CryptoUtil.keyToBase64(pubKey: pubKey)
        
        // String[] list = {Cotter.getUser(Cotter.authRequest).client_user_id, Cotter.ApiKeyID, event, timestamp, method,
        // approved + ""};
        let msg = "\(event.clientUserID)\(CotterAPIService.shared.apiKeyID)\(event.event)\(event.timestamp)\(event.method)true"
        
        let signature = CryptoUtil.signBase64(privKey: privKey, msg: msg)
        
        
        let evt = CotterEventRequest(
            pubKey: pubKeyBase64,
            userID: event.clientUserID,
            issuer: CotterAPIService.shared.apiKeyID,
            event: event.event,
            ipAddr: event.ip,
            location: event.location,
            timestamp: event.timestamp,
            authMethod: event.method,
            code: signature,
            approved: true
        )

        // register the user
        let req = RespondEvent(
            evtID: String(event.id),
            evt: evt
        )
        
        apiClient.send(req) { response in
            cb(response)
        }
    }
    
    public func registerOtherDevice(
        qrData:String,
        userID:String,
        cb: @escaping ResultCallback<CotterEvent>
    ) {
        let qrArr = qrData.split(separator: ":")
        
        if qrArr.count < 5 {
            cb(.failure(CotterAPIError.general(message: "QR Code invalid")))
        }
        
        let newPubKey = qrArr[0]
        let newAlgo = qrArr[1]
        let newIssuer = qrArr[2]
        let newUserID = qrArr[3]
        let newTimestamp = qrArr[4]
        
        let timestamp = NSDate().timeIntervalSince1970.rounded()
        let strTimestamp = String(format:"%.0f", timestamp)
        guard let castNewTimestamp = Double(newTimestamp) else {
            print("\(newTimestamp) is not a double")
            return
        }
        
        // check if the qrData has expired
        let expiry = 60.0 * 3.0 // 3 minutes expiry
        if (timestamp - castNewTimestamp)/1000 > expiry {
            // expired
            cb(.failure(CotterAPIError.general(message: "QR Code expired")))
        }
        
        let internalCb = CotterCallback()
        guard let pubKey = KeyStore.trusted(userID: userID).pubKey else {
            internalCb.internalErrorHandler(err: "Unable to attain user's public key!")
            return
        }
        
        let pubKeyBase64 = CryptoUtil.keyToBase64(pubKey: pubKey)
        
        // check userID
        if newUserID != userID {
            cb(.failure(CotterAPIError.general(message: "This QR Code belongs to another user, and cannot be registered for this user.")))
        }
        
        if newIssuer != CotterAPIService.shared.apiKeyID {
             cb(.failure(CotterAPIError.general(message: "This QR Code belongs to another app, and cannot be registered for this app.")))
        }
        
        let apiClient = self.apiClient()
        
        let event = CotterEvents.EnrollNewTrustedDevice
        let method = CotterMethods.TrustedDevice
        
        guard let privKey = KeyStore.trusted(userID: userID).privKey else {
            internalCb.internalErrorHandler(err: "Unable to attain user's private key!")
            return
        }
        
        // String[] list = {Cotter.getUser(Cotter.authRequest).client_user_id, Cotter.ApiKeyID, event, timestamp, method,
        // approved + ""};
        let msg = "\(userID)\(CotterAPIService.shared.apiKeyID)\(event)\(strTimestamp)\(method)true\(newPubKey)"
        
        let signature = CryptoUtil.signBase64(privKey: privKey, msg: msg)
        
        let evt = CotterEventRequest(
            pubKey: pubKeyBase64,
            userID: userID,
            issuer: CotterAPIService.shared.apiKeyID,
            event: event,
            ipAddr: LocalAuthService.ipAddr ?? "unknown",
            location: "unknown",
            timestamp: strTimestamp,
            authMethod: method,
            code: signature,
            approved: true,
            registerNewDevice: true,
            newDevicePublicKey: String(newPubKey),
            // TODO: get device type and name
            deviceType: "some device",
            deviceName: "New Device",
            newDeviceAlgo: String(newAlgo)
        )
        
        let req = CreateAuthenticationEvent(
            evt: evt,
            oauth: true
        )
        
        apiClient.send(req) { response in
            cb(response)
        }
    }
    
    public func removeTrustedDeviceStatus(
        userID: String,
        cb: @escaping ResultCallback<CotterUser>
    ) {
        let internalCb = CotterCallback()
        
        guard let pubKey = KeyStore.trusted(userID: userID).pubKey else {
            internalCb.internalErrorHandler(err: "Unable to attain user's public key!")
            return
        }
        
        let pubKeyBase64 = CryptoUtil.keyToBase64(pubKey: pubKey)
        
        func innerCb(response: CotterResult<EnrolledMethods>) {
            switch response {
            case .success(let resp):
                if resp.enrolled && resp.method == CotterMethods.TrustedDevice {
                    let apiClient = self.apiClient()
                    
                    let req = RemoveTrustedDeviceStatus(userID: userID, pubKey: pubKeyBase64)
                    apiClient.send(req, completion: cb)
                }
                // else, device is not enrolled in TD, propogate the error
                cb(.failure(CotterError.trustedDevice("Device not enrolled in Trusted Device feature")))
            case .failure(let err):
                // propogates the error
                cb(.failure(err))
            }
        }
        
        self.getTrustedDeviceStatus(clientUserID: userID, cb: innerCb)
    }
    
    // MARK: - notification service support
    public func getNotificationAppID(
        cb: @escaping ResultCallback<CotterNotificationCredential>
    ) {
        print("getting notification App ID")
        let apiClient = self.apiClient()
        
        let req = GetNotificationAppID()
        apiClient.send(req, completion: cb)
    }
}
