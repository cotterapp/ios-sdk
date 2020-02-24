//
//  PINFinalViewController.swift
//  CotterIOS
//
//  Created by Albert Purnama on 2/3/20.
//

import Foundation

public class PINFinalViewControllerKey {
    // MARK: - Keys for Strings
    static let closeTitle = "PINFinalViewControllerKey/closeTitle"
    static let closeMessage = "PINFinalViewControllerKey/closeMessage"
    static let stayOnView = "PINFinalViewControllerKey/stayOnView"
    static let leaveView = "PINFinalViewControllerKey/leaveView"
    static let successImage = "PINFinalViewControllerKey/successImage"
    static let title = "PINFinalViewControllerKey/title"
    static let subtitle = "PINFinalViewControllerKey/subtitle"
    static let buttonText = "PINFinalViewControllerKey/buttonText"
}

class PINFinalViewController: UIViewController {
    // since PinFinalViewControllerKey is a nuisance to type
    // we can getaway with typealias here
    typealias VCTextKey = PINFinalViewControllerKey
    
    // MARK: - VC Text Definitions
    let viewTitle = CotterStrings.instance.getText(for: VCTextKey.title)
    let viewSubtitle = CotterStrings.instance.getText(for: VCTextKey.subtitle)
    let buttonText = CotterStrings.instance.getText(for: VCTextKey.buttonText)
    let successImg = CotterStrings.instance.getText(for: VCTextKey.successImage)
    
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
        configureNav()
        loadImage(imagePath: successImg)
        configureButton()
        
        // Text setup
        populateText()
    }
    
    func populateText() {
        successLabel.text = viewTitle
        successSubLabel.text = viewSubtitle
        finishButton.setTitle(buttonText, for: .normal)
    }
    
    func configureNav() {
        self.navigationItem.hidesBackButton = true
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
    }
    
    func loadImage(imagePath: String?) {
        if imagePath == nil {
            print("Using Default Image...")
            imageView.image = UIImage(named: "check", in: Bundle(identifier: "org.cocoapods.Cotter"), compatibleWith: nil)
            return
        }
        imageView.image = UIImage(named: successImg, in: Bundle.main, compatibleWith: nil)
    }
    
    func configureButton() {
        let color = UIColor(red: 0.8588, green: 0.8588, blue: 0.8588, alpha: 1.0)
        let width = CGFloat(2.0)
        finishButton.backgroundColor = UIColor.clear
        finishButton.layer.cornerRadius = 10
        finishButton.layer.borderWidth = width
        finishButton.layer.borderColor = color.cgColor
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
