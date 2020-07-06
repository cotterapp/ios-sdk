//
//  Trusted.swift
//  Cotter
//
//  Created by Albert Purnama on 3/23/20.
//

import UIKit
import Foundation

public class NonTrustedKey {
    public static let title = "NonTrustedKey/title"
    public static let subtitle = "NonTrustedKey/subtitle"
}

public class NonTrusted {
    var eventID: String
    var cb: CotterAuthCallback
    
    var popup: BottomPopupModal
    
    let darkOverlayView = UIView()
    let promptView = UIView()
    let promptBody = UIView()
    let titleLabel = UILabel()
    let bodyLabel = UILabel()
    let imageView = UIImageView()
    
    typealias VCTextKey = NonTrustedKey
    
    // MARK: - VC Text Definitions
    let dialogTitle = CotterStrings.instance.getText(for: VCTextKey.title)
    let dialogSubtitle = CotterStrings.instance.getText(for: VCTextKey.subtitle)
    
    // MARK: - VC Image Definitions
    let successImage = CotterImages.instance.getImage(for: VCImageKey.nonTrustedPhoneTap)
    let failImage = CotterImages.instance.getImage(for: VCImageKey.nonTrustedPhoneTapFail)
    
    // initializer for old TrustedDevice class
    // do not need to use init function
    public convenience init(vc: UIViewController, eventID:String, cb: @escaping CotterAuthCallback) {
        self.init(eventID:eventID, cb:cb)
    }
    
    // init initialize the authorization prompt on a nontrusted device
    public init(eventID:String, cb: @escaping CotterAuthCallback) {
        self.eventID = eventID
        self.cb = cb
        
        // initialize the view
        self.popup = BottomPopupModal(
            img: UIImage(named: successImage, in: Cotter.resourceBundle, compatibleWith: nil)!,
            title: dialogTitle,
            body: dialogSubtitle
        )
        
        self.popup.delegate = self
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
            if !self.stop {
                self.fail()
            }
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
                    
                    self.cb(evt.oauthToken, nil)
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
            img: UIImage(named: failImage, in: Cotter.resourceBundle, compatibleWith: nil)!,
            title: "Something Went Wrong",
            body: "We're unable to confirm that it's you. Please try again."
        )
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            // dismiss 3 seconds later
            self.dismiss()
        }
    }
}

extension NonTrusted: BottomPopupModalDelegate {
    // When dismissed by tapping the dark overlay, BottomPopupModal will do the completion
    func dismissCompletion() {
        self.stop = true
    }
}
