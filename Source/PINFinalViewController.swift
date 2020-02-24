//
//  PINFinalViewController.swift
//  CotterIOS
//
//  Created by Albert Purnama on 2/3/20.
//

import LocalAuthentication
import Foundation

public class PINFinalViewControllerKey {
    // MARK: - Keys for Strings
    static let title = "PINFinalViewController/title"
    static let subtitle = "PINFinalViewController/subtitle"
    static let buttonText = "PINFinalViewController/buttonText"

    // for alerts - not used
    static let closeTitle = "PINFinalViewController/closeTitle"
    static let closeMessage = "PINFinalViewController/closeMessage"
    static let stayOnView = "PINFinalViewController/stayOnView"
    static let leaveView = "PINFinalViewController/leaveView"
    static let successImage = "PINFinalViewController/successImage"
}

class PINFinalViewController: UIViewController {
    typealias VCTextKey = PINFinalViewControllerKey
    
    // Text Customizations
    let successTitle = CotterStrings.instance.getText(for: VCTextKey.title)
    let successSubtitle = CotterStrings.instance.getText(for: VCTextKey.subtitle)
    let successButtonTitle = CotterStrings.instance.getText(for: VCTextKey.buttonText)
    
    // Auth Service
    let authService = LocalAuthService()
    
    // Config Variables
    var requireAuth = true
    var imagePath: String?
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var successLabel: UILabel!
    
    @IBOutlet weak var successSubLabel: UILabel!
    
    @IBOutlet weak var finishButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("In Final PIN View!")
        
        // Add Set-up here
        configureTexts()
        configureNav()
        loadImage(imagePath: imagePath)
        configureButton()
    }
    
    @IBAction func finish(_ sender: Any) {
        guard let onFinishCallback = Config.instance.callbackFunc else { return }
      
        // set access token or return values here
        
        if requireAuth {
            // Touch ID/Face ID Verification
            authService.authenticate(view: self, reason: "Verifikasi", callback: onFinishCallback)
        } else {
            onFinishCallback("this is token")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: - Private Helper Functions
extension PINFinalViewController {
    private func configureTexts() {
        successLabel.text = successTitle
        successSubLabel.text = successSubtitle
        finishButton.setTitle(successButtonTitle, for: .normal)
    }
    
    private func configureNav() {
        self.navigationItem.hidesBackButton = true
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
    }
    
    private func loadImage(imagePath: String?) {
        guard let imagePath = imagePath else {
            print("Using Default Image...")
            imageView.image = UIImage(named: "check", in: Bundle(identifier: "org.cocoapods.Cotter"), compatibleWith: nil)
            return
        }
      
        imageView.image = UIImage(named: imagePath, in: Bundle.main, compatibleWith: nil)
    }
    
    private func configureButton() {
        let color = UIColor(red: 0.8588, green: 0.8588, blue: 0.8588, alpha: 1.0)
        let width = CGFloat(2.0)
        finishButton.setTitleColor(Config.instance.colors.primary, for: .normal)
        finishButton.backgroundColor = UIColor.clear
        finishButton.layer.cornerRadius = 10
        finishButton.layer.borderWidth = width
        finishButton.layer.borderColor = color.cgColor
    }
}
