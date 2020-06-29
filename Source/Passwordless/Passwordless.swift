//
//  Passwordless.swift
//  Cotter
//
//  Created by Albert Purnama on 2/13/20.
//  Starting April 29, 2020 Passwordlesss is the new name for trusted device
//

import Foundation
import OneSignal

public class Passwordless: NSObject {
    // MARK: - VC Text Definitions
    let unableToContinue = CotterStrings.instance.getText(for: TrustedErrorMessagesKey.unableToContinue)
    let deviceAlreadyReg = CotterStrings.instance.getText(for: TrustedErrorMessagesKey.deviceAlreadyReg)
    let deviceNotReg = CotterStrings.instance.getText(for: TrustedErrorMessagesKey.deviceNotReg)
    let somethingWentWrong = CotterStrings.instance.getText(for: GeneralErrorMessagesKey.someWentWrong)
    let tryAgainLater = CotterStrings.instance.getText(for: GeneralErrorMessagesKey.tryAgainLater)
    
    // MARK: - VC Image Definitions
    let successImage = CotterImages.instance.getImage(for: VCImageKey.pinSuccessImg)
    let failImage = CotterImages.instance.getImage(for: VCImageKey.nonTrustedPhoneTapFail)
    
    
    public static var shared = Passwordless()
    
    override public init() {
        self.parentVC = UIViewController()
    }
    
    public var parentVC: UIViewController
    
    // MARK: - FIDO Login
    public func login(identifier:String, cb: @escaping CotterAuthCallback = DoNothingCallback){
        // create a callback
        func loginCb(resp: CotterResult<CotterEvent>) {
            switch resp {
            case .success(let resp):
                if resp.approved {
                    cb(resp.oauthToken, nil)
                    return
                }
                
                // which means non trusted device is logging in..
                _ = NonTrusted(vc: self.parentVC, eventID: String(resp.id), cb: cb)
                
            case .failure(let err):
                cb(nil, err)
            }
        }
        
        // TODO: get the public key
        guard let pubKey = KeyStore.trusted(userID: identifier).pubKey else {
            print("[login] Unable to attain user's public key!")
            return
        }
        let pubKeyBase64 = CryptoUtil.keyToBase64(pubKey: pubKey)
        print("[login] current pubKey: \(pubKeyBase64)")
        
        OneSignal.setExternalUserId(pubKeyBase64)
        
        CotterAPIService.shared.reqAuth(clientUserID: identifier, event: CotterEvents.Login, cb: loginCb)
    }
    
    // loginWith
    public func loginWith(cotterUserID: String, cb: @escaping CotterAuthCallback = DoNothingCallback){
        // retrieve public key
        guard let pubKey = KeyStore.trusted(userID: cotterUserID).pubKey else {
            print("[login] Unable to attain user's public key!")
            return
        }
        let pubKeyBase64 = CryptoUtil.keyToBase64(pubKey: pubKey)
        print("[login] current pubKey: \(pubKeyBase64)")
        
        OneSignal.setExternalUserId(pubKeyBase64)
        
        // resp is CotterResult<CotterEvent>
        CotterAPIService.shared.reqAuthWith(cotterUserID: cotterUserID, event: CotterEvents.Login) { resp in
            switch resp {
            case .success(let resp):
                if resp.approved {
                    cb(resp.oauthToken, nil)
                    return
                }
                
                // which means non trusted device is logging in..
                _ = NonTrusted(vc: self.parentVC, eventID: String(resp.id), cb: cb)
                
            case .failure(let err):
                cb(nil, err)
            }
        }
    }
    
    public func checkEvent(identifier:String) {
        // checkEvent then callback
        func checkCb(resp: CotterResult<CotterEvent?>){
            switch resp {
            case .success(let evt):
                // if there is an authorization event..
                if evt != nil {
                    // present the trusted device consent page
                    let tVC = Cotter.cotterStoryboard.instantiateViewController(withIdentifier: "TrustedViewController") as! TrustedViewController
                    tVC.event = evt
                    self.parentVC.present(tVC, animated: true)
                }
                // else, nothing happens
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
        
        CotterAPIService.shared.getNewEvent(userID: identifier, cb: checkCb)
    }
    
    // register should register the client's userID on the server and enroll trusted device for the first time
    public func register(identifier: String, cb: @escaping (_ user: CotterUser?, _ err: Error?) -> Void) {
        // need userID: "" because as of now client_user_id will be deprecated.
        CotterAPIService.shared.registerUser(userID: identifier, cb: { resp in
            switch resp {
            case .success(_):
                // response is CotterResult<CotterUser>
                CotterAPIService.shared.enrollTrustedDevice(clientUserID: identifier) { (response) in
                    switch response{
                    case .success(let user):
                        guard let pubKey = KeyStore.trusted(userID: identifier).pubKey else {
                            print("[login] Unable to attain user's public key!")
                            return
                        }
                        let pubKeyBase64 = CryptoUtil.keyToBase64(pubKey: pubKey)
                        print("[login] current pubKey: \(pubKeyBase64)")
                        
                        OneSignal.setExternalUserId(pubKeyBase64)
                        
                        cb(user, nil)
                        
                    case .failure(let err):
                        cb(nil, err)
                    }
                }
                
            case .failure(let err):
                cb(nil, err)
            }
        })
    }
    
    // registerWith is almost the same as register function except it does not use identifier
    // as client user id
    public func registerWith(identifier: String, cb: @escaping (_ user: CotterUser?, _ err: Error?) -> Void) {
        // need userID: "" because as of now client_user_id will be deprecated.
        CotterAPIService.shared.registerUser(userID: "", cb: { resp in
            switch resp {
            case .success(let user):
                // response is CotterResult<CotterUser>
                CotterAPIService.shared.enrollTrustedDeviceWith(cotterUser: user) { (response) in
                    switch response{
                    case .success(let user):
                        guard let pubKey = KeyStore.trusted(userID: identifier).pubKey else {
                            print("[login] Unable to attain user's public key!")
                            return
                        }
                        let pubKeyBase64 = CryptoUtil.keyToBase64(pubKey: pubKey)
                        print("[login] current pubKey: \(pubKeyBase64)")
                        
                        OneSignal.setExternalUserId(pubKeyBase64)
                        
                        cb(user, nil)
                        
                    case .failure(let err):
                        cb(nil, err)
                    }
                }
                
            case .failure(let err):
                cb(nil, err)
            }
        })
    }
    
    public func registerWith(cotterUser: CotterUser, cb: @escaping (_ user: CotterUser?, _ err: Error?) -> Void) {
        // response is CotterResult<CotterUser>
        CotterAPIService.shared.enrollTrustedDeviceWith(cotterUser: cotterUser) { (response) in
            switch response{
            case .success(let user):
                cb(user, nil)
                
            case .failure(let err):
                cb(nil, err)
            }
        }
    }
    
    // logout unmaps the external user id
    public func logout() {
        OneSignal.removeExternalUserId()
    }
    
    // registerDevice registers a new trusted device
    public func registerDevice(identifier: String, cb: @escaping CotterAuthCallback = DoNothingCallback) {
        // TODO: Before registering, check if this device is already trusted one time.
        // If so, don't continue with the registration process. Else, if this device is
        // not trusted, continue with the registration.
        func getTrustedCallback(response: CotterResult<EnrolledMethods>) {
            switch response {
            case .success(let resp):
                if resp.enrolled && resp.method == CotterMethods.TrustedDevice {
                    // Enrolled in Trusted Devices, do not continue
                    let img = UIImage(named: failImage, in: Cotter.resourceBundle, compatibleWith: nil)!
                    let popup = BottomPopupModal(vc: parentVC, img: img, title: unableToContinue, body: deviceAlreadyReg)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                        popup.dismiss()
                    }
                } else {
                    // Not enrolled in Trusted Devices, continue
                    let vc = Cotter.cotterStoryboard.instantiateViewController(withIdentifier: "RegisterTrustedViewController") as! RegisterTrustedViewController
                     vc.userID = identifier
                     vc.cb = cb
                     
                     self.parentVC.present(vc, animated: true)
                }
            case .failure:
                let img = UIImage(named: failImage, in: Cotter.resourceBundle, compatibleWith: nil)!
                let popup = BottomPopupModal(vc: parentVC, img: img, title: somethingWentWrong, body: tryAgainLater)
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    popup.dismiss()
                }
            }
        }
        
        CotterAPIService.shared.getTrustedDeviceStatus(clientUserID: identifier, cb: getTrustedCallback)
    }
    
    public func scanNewDevice(identifier: String) {
        // Before scanning, check that this device is already trusted. If so,
        // proceed with scanning process. If not, show modal that cannot continue.
        func getTrustedCallback(response: CotterResult<EnrolledMethods>) {
            switch response {
            case .success(let resp):
                if resp.enrolled && resp.method == CotterMethods.TrustedDevice {
                    // Enrolled in Trusted Devices, continue
                    let vc = Cotter.cotterStoryboard.instantiateViewController(withIdentifier: "QRScannerViewController") as! QRScannerViewController
                    vc.userID = identifier
                    
                    self.parentVC.navigationController?.pushViewController(vc, animated: true)
                } else {
                    // Not enrolled in Trusted Devices, do not continue
                    let img = UIImage(named: failImage, in: Cotter.resourceBundle, compatibleWith: nil)!
                    let popup = BottomPopupModal(vc: parentVC, img: img, title: unableToContinue, body: deviceNotReg)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                        popup.dismiss()
                    }
                }
            case .failure:
                let img = UIImage(named: failImage, in: Cotter.resourceBundle, compatibleWith: nil)!
                let popup = BottomPopupModal(vc: parentVC, img: img, title: somethingWentWrong, body: tryAgainLater)
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    popup.dismiss()
                }
            }
        }
        
        CotterAPIService.shared.getTrustedDeviceStatus(clientUserID: identifier, cb: getTrustedCallback)
    }
    
    public func removeDevice(identifier: String, cb: @escaping CotterAuthCallback = DoNothingCallback) {
        func removeTrustedCb(resp: CotterResult<CotterUser>) {
            switch resp {
            case .success(_):
                print("[removeDevice] Successfully removed this device as a Trusted Device!")
                cb(nil, nil)
            case .failure(let err):
                cb(nil, err)
            }
        }
        
        CotterAPIService.shared.removeTrustedDeviceStatus(userID: identifier, cb: removeTrustedCb)
    }
}

func randomString(length: Int) -> String {
  let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
  return String((0..<length).map{ _ in letters.randomElement()! })
}
