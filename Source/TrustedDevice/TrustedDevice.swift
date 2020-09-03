//
//  TrustedDevice.swift
//  Cotter
//
//  Created by Albert Purnama on 3/24/20.
//
import Foundation
import os.log

class TrustedDevice {
    // MARK: - VC Text Definitions
    let unableToContinue = CotterStrings.instance.getText(for: TrustedErrorMessagesKey.unableToContinue)
    let deviceAlreadyReg = CotterStrings.instance.getText(for: TrustedErrorMessagesKey.deviceAlreadyReg)
    let deviceNotReg = CotterStrings.instance.getText(for: TrustedErrorMessagesKey.deviceNotReg)
    let somethingWentWrong = CotterStrings.instance.getText(for: GeneralErrorMessagesKey.someWentWrong)
    let tryAgainLater = CotterStrings.instance.getText(for: GeneralErrorMessagesKey.tryAgainLater)
    
    // MARK: - VC Image Definitions
    let successImage = CotterImages.instance.getImage(for: VCImageKey.pinSuccessImg)
    let failImage = CotterImages.instance.getImage(for: VCImageKey.nonTrustedPhoneTapFail)
    
    var parentVC: UIViewController
    var cb: FinalAuthCallback
    
    public init(
        vc: UIViewController,
        cb: @escaping FinalAuthCallback
    ) {
        self.cb = cb
        self.parentVC = vc
    }
    
    // login the userID
    public func login(userID:String) {
        // create a callback
        func loginCb(resp: CotterResult<CotterEvent>) {
            switch resp {
            case .success(let resp):
                if resp.approved {
                    self.cb("approved login", nil)
                    return
                }
                
                // which means non trusted device is logging in..
                _ = NonTrusted(vc: self.parentVC, eventID: String(resp.id), cb: castFunc(cb:cb))
                
            case .failure(let err):
                self.cb("", err)
            }
        }
        
        CotterAPIService.shared.reqAuth(clientUserID: userID, event: CotterEvents.Login, cb: loginCb)
    }
    
    public func checkEvent(userID:String) {
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
                os_log("%{public}@ checkEvent { userID: %{public}@ err: %{public}@}",
                       log: Config.instance.log, type: .debug,
                       #function, userID, err.localizedDescription)
            }
        }
        
        CotterAPIService.shared.getNewEvent(userID: userID, cb: checkCb)
    }
    
    public func registerDevice(userID: String) {
        // TODO: Before registering, check if this device is already trusted one time.
        // If so, don't continue with the registration process. Else, if this device is
        // not trusted, continue with the registration.
        func getTrustedCallback(response: CotterResult<EnrolledMethods>) {
            switch response {
            case .success(let resp):
                if resp.enrolled && resp.method == CotterMethods.TrustedDevice {
                    // Enrolled in Trusted Devices, do not continue
                    let img = UIImage(named: failImage, in: Cotter.resourceBundle, compatibleWith: nil)!
                    let popup = BottomPopupModal(img: img, title: unableToContinue, body: deviceAlreadyReg)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                        popup.dismiss()
                    }
                } else {
                    // Not enrolled in Trusted Devices, continue
                    let vc = Cotter.cotterStoryboard.instantiateViewController(withIdentifier: "RegisterTrustedViewController") as! RegisterTrustedViewController
                    vc.userID = userID
                    vc.cb = castFunc(cb:cb)
                     
                    self.parentVC.present(vc, animated: true)
                }
            case .failure:
                let img = UIImage(named: failImage, in: Cotter.resourceBundle, compatibleWith: nil)!
                let popup = BottomPopupModal(img: img, title: somethingWentWrong, body: tryAgainLater)
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    popup.dismiss()
                }
            }
        }
        
        CotterAPIService.shared.getTrustedDeviceStatus(clientUserID: userID, cb: getTrustedCallback)
    }
    
    public func scanNewDevice(userID: String) {
        // Before scanning, check that this device is already trusted. If so,
        // proceed with scanning process. If not, show modal that cannot continue.
        func getTrustedCallback(response: CotterResult<EnrolledMethods>) {
            switch response {
            case .success(let resp):
                if resp.enrolled && resp.method == CotterMethods.TrustedDevice {
                    // Enrolled in Trusted Devices, continue
                    let vc = Cotter.cotterStoryboard.instantiateViewController(withIdentifier: "QRScannerViewController") as! QRScannerViewController
                    vc.userID = userID
                    
                    self.parentVC.navigationController?.pushViewController(vc, animated: true)
                } else {
                    // Not enrolled in Trusted Devices, do not continue
                    let img = UIImage(named: failImage, in: Cotter.resourceBundle, compatibleWith: nil)!
                    let popup = BottomPopupModal(img: img, title: unableToContinue, body: deviceNotReg)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                        popup.dismiss()
                    }
                }
            case .failure:
                let img = UIImage(named: failImage, in: Cotter.resourceBundle, compatibleWith: nil)!
                let popup = BottomPopupModal(img: img, title: somethingWentWrong, body: tryAgainLater)
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    popup.dismiss()
                }
            }
        }
        
        CotterAPIService.shared.getTrustedDeviceStatus(clientUserID: userID, cb: getTrustedCallback)
    }
    
    public func removeDevice(userID: String) {
        func removeTrustedCb(resp: CotterResult<CotterUser>) {
            switch resp {
            case .success(_):
                cb("Successfully removed this device as a Trusted Device!", nil)
            case .failure(let err):
                cb("", err)
            }
        }
        
        CotterAPIService.shared.removeTrustedDeviceStatus(userID: userID, cb: removeTrustedCb)
    }
}

func castFunc(cb: @escaping FinalAuthCallback) -> CotterAuthCallback {
    return { (token: CotterOAuthToken?, err: Error?) in
        if token != nil {
            cb("token exists", err)
        }
        cb("", err)
    }
}
