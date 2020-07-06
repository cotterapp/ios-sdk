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
    func onFinish(button: UIButton)
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

// MARK: - Components of PINFinalViewController
protocol PINFinalViewComponent: AnyObject {
    func setupUI()
    func render(_ props: PINFinalViewProps)
    func didFinish(button: UIButton)
}

// MARK: - PINFinalViewPresenter Implementation
class PINFinalViewPresenterImpl: PINFinalViewPresenter {
    
    typealias VCTextKey = PINFinalViewControllerKey
    
    weak var viewController: PINFinalViewComponent!
    
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
    
    init(_ viewController: PINFinalViewController) {
        self.viewController = viewController
    }
    
    func onViewLoaded() {
        viewController.setupUI()
        viewController.render(props)
    }
    
    func onFinish(button: UIButton) {
        viewController.didFinish(button: button)
    }
}

class PINFinalViewController: UIViewController {
    
    // Auth Service
    let authService = LocalAuthService()
    
    // Config Variables
    var requireAuth = true
    var imagePath: String? = nil
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var successLabel: UILabel!
    
    @IBOutlet weak var successSubLabel: UILabel!
    
    @IBOutlet weak var finishButton: UIButton!
    
    lazy var presenter: PINFinalViewPresenter = PINFinalViewPresenterImpl(self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("loaded PIN Final View!")
        
        // Set-up
        presenter.onViewLoaded()
    }
    
    @IBAction func finish(_ sender: UIButton) {
        presenter.onFinish(button: sender)
    }
}

// MARK: - PINFinalViewComponent Render
extension PINFinalViewController: PINFinalViewComponent {
    func setupUI() {
        // Remove Navigational UI
        self.navigationItem.hidesBackButton = true
        
        // Button Configuration
        let color = UIColor(red: 0.8588, green: 0.8588, blue: 0.8588, alpha: 1.0)
        let width = CGFloat(2.0)
        finishButton.backgroundColor = UIColor.clear
        finishButton.layer.cornerRadius = 10
        finishButton.layer.borderWidth = width
        finishButton.layer.borderColor = color.cgColor
    }
    
    func render(_ props: PINFinalViewProps) {
        successLabel.text = props.title
        successLabel.font = Config.instance.fonts.title
        successSubLabel.text = props.subtitle
        successSubLabel.font = Config.instance.fonts.paragraph
        finishButton.setTitle(props.buttonTitle, for: .normal)
        finishButton.setTitleColor(props.primaryColor, for: .normal)
        finishButton.titleLabel?.font = Config.instance.fonts.subtitle
        
        let cotterImages = ImageObject.defaultImages
        if cotterImages.contains(props.successImage) {
            print("[PINFinalViewController] Using Default Image...")
            imageView.image = UIImage(named: props.successImage, in: Cotter.resourceBundle, compatibleWith: nil)
        } else { // User configured their own image
            imageView.image = UIImage(named: props.successImage, in: Bundle.main, compatibleWith: nil)
        }
        imagePath = props.successImage
    }
    
    func didFinish(button: UIButton) {
        // set access token or return values here
        if requireAuth {
            // Touch ID/Face ID Verification
            authService.authenticate(view: self, reason: "Verification", callback: Config.instance.pinEnrollmentCb)
        } else {
             Config.instance.updatePINCb("this is token", nil)
        }
    }
}
