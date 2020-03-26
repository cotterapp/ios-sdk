//
//  Trusted.swift
//  Cotter
//
//  Created by Albert Purnama on 3/23/20.
//

import UIKit
import Foundation

public class NonTrusted {
    var parentVC: UIViewController!
    var eventID: String
    var cb: FinalAuthCallback
    
    var popup: BottomPopupModal
    
    let darkOverlayView = UIView()
    let promptView = UIView()
    let promptBody = UIView()
    let titleLabel = UILabel()
    let bodyLabel = UILabel()
    let imageView = UIImageView()
    
    let successImage = CotterImages.instance.getImage(for: VCImageKey.nonTrustedPhoneTap)
    let failImage = CotterImages.instance.getImage(for: VCImageKey.nonTrustedPhoneTapFail)
    
    // init initialize the authorization prompt on a nontrusted device
    public init(vc:UIViewController, eventID:String, cb: @escaping FinalAuthCallback) {
        parentVC = vc
        self.eventID = eventID
        self.cb = cb
        
        // initialize the view
        self.popup = BottomPopupModal(
            vc: vc,
            img: UIImage(named: successImage, in: Cotter.resourceBundle, compatibleWith: nil)!,
            title: "Approve this login from your phone",
            body: "A notification is sent to your trusted device to confirm it's you"
        )
        
        self.waitForApproval()
    }
    
    private func dismiss() {
        // add some nice animation
        self.popup.dismiss()
    }
    
    let SECONDS_TO_ERROR:Double = 60;
    let SECONDS_TO_RETRY:Double = 1;
    var stop:Bool = false
    
    private func waitForApproval() {
        self.checkApproval()
        DispatchQueue.main.asyncAfter(deadline: .now() + SECONDS_TO_ERROR) {
            self.fail()
        }
    }
    
    private func checkApproval() {
        print("checking approval..")
        func checkCb(resp: CotterResult<CotterEvent>) {
            switch resp {
            case .success(let evt):
                if evt.approved {
                    // means that the attempt is approved
                    
                    // invalidate timers, dismiss the prompt
                    self.dismiss()
                    
                    self.cb("approved", nil)
                } else {
                    if !self.stop {
                        DispatchQueue.main.asyncAfter(deadline: .now() + SECONDS_TO_RETRY) {
                            self.checkApproval()
                        }
                    }
                }
            case .failure(let err):
                // network error or parsing error
                print(err.localizedDescription)
            }
        }
        CotterAPIService.shared.getEvent(eventID:self.eventID, cb:checkCb)
    }
    
    private func fail() {
        self.stop = true
        
        self.popup.dismiss(animated: false)
        self.popup = BottomPopupModal(
            vc: self.parentVC,
            img: UIImage(named: failImage, in: Cotter.resourceBundle, compatibleWith: nil)!,
            title: "Something Went Wrong",
            body: "We're unable to confirm that it's you. Please try again"
        )
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            // dismiss 3 seconds later
            self.dismiss()
        }
    }
}
