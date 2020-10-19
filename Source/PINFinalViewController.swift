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
    public static let titleUpdate = "PINFinalViewController/titleUpdate"
    public static let subtitleUpdate = "PINFinalViewController/subtitleUpdate"
    public static let buttonTextUpdate = "PINFinalViewController/buttonTextUpdate"
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
    let titleUpdate: String
    let subtitleUpdate: String
    let buttonTitleUpdate: String
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
        
        let successTitleUpdate = CotterStrings.instance.getText(for: VCTextKey.titleUpdate)
        let successSubtitleUpdate = CotterStrings.instance.getText(for: VCTextKey.subtitleUpdate)
        let successButtonTitleUpdate = CotterStrings.instance.getText(for: VCTextKey.buttonTextUpdate)
        
        // MARK: - VC Image Definitions
        let successImage = CotterImages.instance.getImage(for: VCImageKey.pinSuccessImg)
        
        // MARK: - VC Color Definitions
        let primaryColor = Config.instance.colors.primary
        let accentColor = Config.instance.colors.accent
        let dangerColor = Config.instance.colors.danger
        
        return PINFinalViewProps(
            title: successTitle,
            subtitle: successSubtitle,
            buttonTitle: successButtonTitle,
            titleUpdate: successTitleUpdate,
            subtitleUpdate: successSubtitleUpdate,
            buttonTitleUpdate: successButtonTitleUpdate,
            successImage: successImage,
            primaryColor: primaryColor,
            accentColor: accentColor,
            dangerColor: dangerColor)
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
    var isEnroll: Bool = true
    
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
        let width = CGFloat(1.0)
        finishButton.backgroundColor = UIColor.clear
        finishButton.layer.cornerRadius = 4
        finishButton.layer.borderWidth = width
        finishButton.layer.borderColor = UIColor.black
            .withAlphaComponent(0.12).cgColor
    }
    
    func render(_ props: PINFinalViewProps) {
        successLabel.text = self.isEnroll ? props.title : props.titleUpdate
        successLabel.font = Config.instance.fonts.titleLarge
        successLabel.textColor = Config.instance.colors.accent
        successSubLabel.text = self.isEnroll ? props.subtitle : props.subtitleUpdate
        successSubLabel.font = Config.instance.fonts.subtitle
        successSubLabel.textColor = Config.instance.colors.gray
        let buttonText = self.isEnroll ? props.buttonTitle : props.buttonTitleUpdate
        finishButton.setTitle(buttonText, for: .normal)
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
