//
//  RegisterTrustedViewController.swift
//  Cotter
//
//  Created by Albert Purnama on 3/25/20.
//

import UIKit
import os.log

public class RegisterTrustedViewControllerKey {
    // MARK: - Keys for Strings
    public static let title = "RegisterTrustedViewControllerKey/title"
    public static let subtitle = "RegisterTrustedViewControllerKey/subtitle"
}

class RegisterTrustedViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    typealias VCTextKey = RegisterTrustedViewControllerKey
    
    // MARK: - VC Text Definitions
    let registerTitle = CotterStrings.instance.getText(for: VCTextKey.title)
    let registerSubtitle = CotterStrings.instance.getText(for: VCTextKey.subtitle)
    let somethingWentWrong = CotterStrings.instance.getText(for: GeneralErrorMessagesKey.someWentWrong)
    let reqTimeout = CotterStrings.instance.getText(for: GeneralErrorMessagesKey.requestTimeout)
    
    // MARK: - VC Image Definitions
    let successImage = CotterImages.instance.getImage(for: VCImageKey.pinSuccessImg)
    let failImage = CotterImages.instance.getImage(for: VCImageKey.nonTrustedPhoneTapFail)
    
    // TODO: this should be changed to cotter's userID
    var userID: String?
    var cb: CotterAuthCallback?
    
    // set the imageViewSize
    let qrWidth = min(300, UIScreen.main.bounds.width - 120)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.configureTexts()
        self.generateQR()
        self.waitForEnrollment()
    }
    
    private func configureTexts() {
        titleLabel.text = registerTitle
        subtitleLabel.text = registerSubtitle
    }
    
    private func generateQR() {
        guard let userID = self.userID else { return }
        
        guard let pubKey = KeyStore.trusted(userID: userID).pubKey else { return }
        
        let pubKeyBase64 = CryptoUtil.keyToBase64(pubKey: pubKey)
        
        let algo = "ECDSA"
        
        let apiKeyID = CotterAPIService.shared.apiKeyID
        
        let timestamp = String(format:"%.0f",NSDate().timeIntervalSince1970.rounded())
        
        let qrMsg = "\(pubKeyBase64):\(algo):\(apiKeyID):\(userID):\(timestamp)"
        
        self.printQR(text: qrMsg)
    }
    
    private func printQR(text: String) {
        // 1
        let myString = text// 2
        let data = myString.data(using: String.Encoding.ascii)// 3
        guard let qrFilter = CIFilter(name: "CIQRCodeGenerator") else { return }// 4
        qrFilter.setValue(data, forKey: "inputMessage")// 5
        guard let qrImage = qrFilter.outputImage else { return }
        
        // scaling the picture up, for larger QR Code size
        let transform = CGAffineTransform(scaleX: qrWidth/50, y: qrWidth/50)
        
        self.imageView.image = UIImage(ciImage: qrImage.transformed(by: transform))
        self.imageView.heightAnchor.constraint(equalToConstant: qrWidth).isActive = true
        self.imageView.widthAnchor.constraint(equalToConstant: qrWidth).isActive = true
        self.view.layoutIfNeeded()
    }
    
    private func success() {
        self.imageView.image = UIImage(named: successImage, in: Cotter.resourceBundle, compatibleWith: nil)
        
        self.imageView.removeConstraints(self.imageView.constraints)
        self.imageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        self.imageView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        self.view.layoutIfNeeded()
        
        self.dismiss()
    }
    
    private func fail() {
        self.imageView.image = UIImage(named: failImage, in: Cotter.resourceBundle, compatibleWith: nil)
        
        self.titleLabel.text = somethingWentWrong
        self.subtitleLabel.text = reqTimeout
        
        // remove all previous Constraints
        self.imageView.removeConstraints(self.imageView.constraints)
        self.imageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        self.imageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        self.view.layoutIfNeeded()
        
        self.dismiss()
    }
    
    // set timers
    private let SECONDS_TO_RETRY:Double = 1;
    private let SECONDS_TO_STOP:Double = 180;
    var stop: Bool = false
    
    private func waitForEnrollment() {
        self.retry()
        DispatchQueue.main.asyncAfter(deadline: .now() + SECONDS_TO_STOP) {
            self.stopRetry()
        }
    }
    
    
    private func dismiss() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            // dismiss 3 seconds later
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc
    private func retry() {
        guard let userID = self.userID else { return }
        
        func cb(resp: CotterResult<EnrolledMethods>) {
            switch resp {
            case .success(let resp):
                if resp.enrolled {
                    // handle success
                    self.success()
                    // call callback func
                    if let cb = self.cb {
                        cb(nil, nil)
                    }
                } else {
                    if !self.stop {
                        // continue retry
                        DispatchQueue.main.asyncAfter(deadline: .now() + SECONDS_TO_RETRY) {
                            self.retry()
                        }
                    } else {
                        // stop retrying
                        if let cb = self.cb {
                            cb(nil, CotterError.trustedDevice("failed to enroll this device as a trusted device!"))
                        }
                    }
                }
            case .failure(let err):
                // do nothing, keep retrying
                os_log("%{public}@ trusted device status {err: %{public}@}",
                       log: Config.instance.log, type: .debug,
                       #function, err.localizedDescription)
            }
        }
        
        CotterAPIService.shared.getTrustedDeviceStatus(clientUserID: userID, cb: cb)
    }
    
    @objc
    private func stopRetry() {
        // handle error
        self.stop = true
        self.fail()
    }
    
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
