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
    public static let title = "PINFinalViewController/title"
    public static let subtitle = "PINFinalViewController/subtitle"
    public static let buttonText = "PINFinalViewController/buttonText"
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

protocol CallbackDelegate {
    func callback(token: String, error: Error?)
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
    
    var delegate: CallbackDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set-up
        presenter.onViewLoaded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
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
        let color = Config.instance.colors.primary
        let width = CGFloat(1.0)
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
            BiometricRegistrationService(event: "Verification", callback: Config.instance.pinEnrollmentCb).start()
        } else if delegate == nil {
            Config.instance.updatePINCb("this is token", nil)
        } else {
            delegate?.callback(token: "token", error: nil)
        }
    }
}
