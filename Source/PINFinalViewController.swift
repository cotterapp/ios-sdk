//
//  PINFinalViewController.swift
//  CotterIOS
//
//  Created by Albert Purnama on 2/3/20.
//

import LocalAuthentication
import Foundation

// MARK: - Keys for Strings
public class PINFinalViewControllerKey {
    static let title = "PINFinalViewController/title"
    static let subtitle = "PINFinalViewController/subtitle"
    static let buttonText = "PINFinalViewController/buttonText"
}

// MARK: - Presenter Protocol delegated UI-related logic
protocol PINFinalViewPresenter {
    func onViewLoaded()
    func onFinish()
    func onConfigureNav()
    func onConfigureButton()
}

// MARK: - Properties of PINViewController
struct PINFinalViewProps {
    let title: String
    let subtitle: String
    let buttonTitle: String
    let successImage: String
    
    let primaryColor: UIColor
    let accentColor: UIColor
    let dangerColor: UIColor
}

// MARK: - Component Protocol delegated to render props
protocol PINFinalViewComponent : AnyObject {
    func render(_ props: PINFinalViewProps)
}

class PINFinalViewController: UIViewController {
    
    typealias VCTextKey = PINFinalViewControllerKey
    
    let props: PINFinalViewProps = {
        // MARK: VC Text Definitions
        let successTitle = CotterStrings.instance.getText(for: VCTextKey.title)
        let successSubtitle = CotterStrings.instance.getText(for: VCTextKey.subtitle)
        let successButtonTitle = CotterStrings.instance.getText(for: VCTextKey.buttonText)
        
        // MARK: - VC Image Definitions
        let successImage = CotterImages.instance.getImage(for: VCImageKey.pinSuccessImg)
        
        // MARK: - VC Color Definitions
        let primaryColor = Config.instance.colors.primary
        let accentColor = Config.instance.colors.accent
        let dangerColor = Config.instance.colors.danger
        
        return PINFinalViewProps(title: successTitle, subtitle: successSubtitle, buttonTitle: successButtonTitle, successImage: successImage, primaryColor: primaryColor, accentColor: accentColor, dangerColor: dangerColor)
    }()
    
    // Auth Service
    let authService = LocalAuthService()
    
    // Config Variables
    var requireAuth = true
    var imagePath: String? = nil
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var successLabel: UILabel!
    
    @IBOutlet weak var successSubLabel: UILabel!
    
    @IBOutlet weak var finishButton: UIButton!
    
    var presenter: PINFinalViewPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("loaded PIN Final View!")
        
        // Set-up
        configureNav()
        configureButton()
        render(props)
        
        presenter?.onViewLoaded()
    }
    
    @IBAction func finish(_ sender: UIButton) {
        // set access token or return values here
        if requireAuth {
            // Touch ID/Face ID Verification
            authService.authenticate(view: self, reason: "Verification", callback: Config.instance.pinEnrollmentCb)
        } else {
             Config.instance.updatePINCb("this is token", nil)
        }
        
        presenter?.onFinish()
    }
}

// MARK: - Private Helper Functions
extension PINFinalViewController {
    private func configureNav() {
        self.navigationItem.hidesBackButton = true
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
        
        presenter?.onConfigureNav()
    }
    
    private func configureButton() {
        let color = UIColor(red: 0.8588, green: 0.8588, blue: 0.8588, alpha: 1.0)
        let width = CGFloat(2.0)
        finishButton.setTitleColor(Config.instance.colors.primary, for: .normal)
        finishButton.backgroundColor = UIColor.clear
        finishButton.layer.cornerRadius = 10
        finishButton.layer.borderWidth = width
        finishButton.layer.borderColor = color.cgColor
        
        presenter?.onConfigureButton()
    }
}

// MARK: - PINFinalViewComponent Render
extension PINFinalViewController : PINFinalViewComponent {
    func render(_ props: PINFinalViewProps) {
        successLabel.text = props.title
        successSubLabel.text = props.subtitle
        finishButton.setTitle(props.buttonTitle, for: .normal)
        
        let cotterImages = ImageObject.defaultImages
        if cotterImages.contains(props.successImage) {
            print("[PINFinalViewController] Using Default Image...")
            imageView.image = UIImage(named: props.successImage, in: Cotter.resourceBundle, compatibleWith: nil)
        } else { // User configured their own image
            imageView.image = UIImage(named: props.successImage, in: Bundle.main, compatibleWith: nil)
        }
        imagePath = props.successImage
    }
}
