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
}

class PINFinalViewController: UIViewController {
    typealias VCTextKey = PINFinalViewControllerKey
    
    // MARK: VC Text Definitions
    let successTitle = CotterStrings.instance.getText(for: VCTextKey.title)
    let successSubtitle = CotterStrings.instance.getText(for: VCTextKey.subtitle)
    let successButtonTitle = CotterStrings.instance.getText(for: VCTextKey.buttonText)
    
    // MARK: - VC Image Definitions
    let successImage = CotterImages.instance.getImage(for: VCImageKey.pinSuccessImg)
    
    // Auth Service
    let authService = LocalAuthService()
    
    // Config Variables
    var requireAuth = true
    
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
        loadImage()
        configureButton()
    }
    
    @IBAction func finish(_ sender: Any) {
        let onFinishCallback = Config.instance.callbackFunc
      
        // set access token or return values here
        
        if requireAuth {
            // Touch ID/Face ID Verification
            authService.authenticate(view: self, reason: "Verifikasi", callback: onFinishCallback)
        } else {
            onFinishCallback("this is token", nil)
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
    
    private func loadImage() {
        let cotterImages = ImageObject.defaultImages
        
        guard !cotterImages.contains(successImage) else {
            print("Using Default Image...")
            imageView.image = UIImage(named: successImage, in: Cotter.resourceBundle, compatibleWith: nil)
            return
        }
        
        imageView.image = UIImage(named: successImage, in: Bundle.main, compatibleWith: nil)
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
