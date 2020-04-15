//
//  TrustedDevice.swift
//  Cotter
//
//  Created by Albert Purnama on 3/24/20.
//

import Foundation

class TrustedDevice {
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
                _ = NonTrusted(vc: self.parentVC, eventID: String(resp.id), cb: cb)
                
            case .failure(let err):
                self.cb("", err)
            }
        }
        
        CotterAPIService.shared.reqAuth(userID: userID, event: CotterEvents.Login, cb: loginCb)
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
                print(err.localizedDescription)
            }
        }
        
        CotterAPIService.shared.getNewEvent(userID: userID, cb: checkCb)
    }
    
    public func registerDevice(userID: String) {
        // TODO: Before registering, check if this device is already trusted one time.
        // If so, don't continue with the registration process. Else, if this device is
        // not trusted, continue with the registration.
        
        let vc = Cotter.cotterStoryboard.instantiateViewController(withIdentifier: "RegisterTrustedViewController") as! RegisterTrustedViewController
        vc.userID = userID
        vc.cb = cb
        
        self.parentVC.present(vc, animated: true)
    }
    
    public func scanNewDevice(userID: String) {
        // TODO: Before scanning, check that this device is already trusted. If so,
        // proceed with scanning process. If not, show modal that cannot continue.
        
        let vc = Cotter.cotterStoryboard.instantiateViewController(withIdentifier: "QRScannerViewController") as! QRScannerViewController
        vc.userID = userID
        
        self.parentVC.navigationController?.pushViewController(vc, animated: true)
    }
    
    public func removeDevice(userID: String) {
        func removeTrustedCb(resp: CotterResult<CotterUser>) {
            switch resp {
            case .success(_):
                print("[removeDevice] Successfully removed this device as a Trusted Device!")
                cb("Successfully removed this device as a Trusted Device!", nil)
            case .failure(let err):
                cb("", err)
            }
        }
        
        CotterAPIService.shared.removeTrustedDeviceStatus(userID: userID, cb: removeTrustedCb)
    }
}
