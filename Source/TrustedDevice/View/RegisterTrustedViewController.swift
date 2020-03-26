//
//  RegisterTrustedViewController.swift
//  Cotter
//
//  Created by Albert Purnama on 3/25/20.
//

import UIKit

class RegisterTrustedViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    let successImage = CotterImages.instance.getImage(for: VCImageKey.pinSuccessImg)
    let failImage = CotterImages.instance.getImage(for: VCImageKey.nonTrustedPhoneTapFail)
    
    var userID: String?
    
    // set the imageViewSize
    let qrWidth = min(300, UIScreen.main.bounds.width - 120)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.generateQR()
        self.waitForEnrollment()
    }
    
    private func generateQR() {
        guard let userID = self.userID else { return }
        
        guard let pubKey = KeyStore.trusted.pubKey else { return }
        
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
        
        self.titleLabel.text = "Something Went Wrong"
        self.subtitleLabel.text = "This request timed out. Please try again later."
        
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
        // retry
        print("trying...")
        guard let userID = self.userID else { return }
        
        func cb(resp: CotterResult<EnrolledMethods>) {
            switch resp {
            case .success(let resp):
                if resp.enrolled {
                    // handle success
                    self.success()
                } else {
                    print("not enrolled as trusted device")
                    if !self.stop {
                        // continue retry
                        DispatchQueue.main.asyncAfter(deadline: .now() + SECONDS_TO_RETRY) {
                            self.retry()
                        }
                    } else {
                        // stop retrying
                        print("stopped retrying")
                    }
                }
            case .failure(let err):
                // do nothing, keep retrying
                print("trusted retry failure: \(err.localizedDescription)")
            }
        }
        
        CotterAPIService.shared.getTrustedDeviceStatus(userID: userID, cb: cb)
    }
    
    @objc
    private func stopRetry() {
        // handle error
        self.stop = true
        self.fail()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
