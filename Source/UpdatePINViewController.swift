//
//  UpdatePINViewController.swift
//  CotterIOS
//
//  Created by Raymond Andrie on 2/8/20.
//

import UIKit
import os.log

// MARK: - Keys for Strings
public class UpdatePINViewControllerKey {
    public static let navTitle = "UpdatePINViewController/navTitle"
    public static let title = "UpdatePINViewController/title"
    public static let showPin = "UpdatePINViewController/showPin"
    public static let hidePin = "UpdatePINViewController/hidePin"
}

// MARK: - Presenter Protocol delegated UI-related logic
protocol UpdatePINViewPresenter {
    func onViewLoaded()
    func onClickPinVis(button: UIButton)
}

// MARK: - Properties of UpdatePINViewController
struct UpdatePINViewProps {
    let navTitle: String
    let title: String
    let showPinText: String
    let hidePinText: String
    
    let primaryColor: UIColor
    let accentColor: UIColor
    let dangerColor: UIColor
}

// MARK: - Components of UpdatePINViewController
protocol UpdatePINViewComponent: AnyObject {
    func setupUI()
    func setupDelegates()
    func render(_ props: UpdatePINViewProps)
    func togglePinVisibility(button: UIButton, showPinText: String, hidePinText: String)
}

// MARK: - UpdatePINViewPresenter Implementation
class UpdatePINViewPresenterImpl: UpdatePINViewPresenter {
    
    typealias VCTextKey = UpdatePINViewControllerKey
    
    weak var viewController: UpdatePINViewComponent!
    
    let props: UpdatePINViewProps = {
        // MARK: - VC Text Definitions
        let navTitle = CotterStrings.instance.getText(for: VCTextKey.navTitle)
        let titleText = CotterStrings.instance.getText(for: VCTextKey.title)
        let showPinText = CotterStrings.instance.getText(for: VCTextKey.showPin)
        let hidePinText = CotterStrings.instance.getText(for: VCTextKey.hidePin)
        
        // MARK: - VC Color Definitions
        let primaryColor = Config.instance.colors.primary
        let accentColor = Config.instance.colors.accent
        let dangerColor = Config.instance.colors.danger
        
        return UpdatePINViewProps(navTitle: navTitle, title: titleText, showPinText: showPinText, hidePinText: hidePinText, primaryColor: primaryColor, accentColor: accentColor, dangerColor: dangerColor)
    }()
    
    init(_ viewController: UpdatePINViewComponent) {
        self.viewController = viewController
    }
    
    func onViewLoaded() {
        viewController.setupUI()
        viewController.setupDelegates()
        viewController.render(props)
    }
    
    func onClickPinVis(button: UIButton) {
        viewController.togglePinVisibility(button: button, showPinText: props.showPinText, hidePinText: props.hidePinText)
    }
    
}

class UpdatePINViewController: UIViewController {
    
    var authService: LocalAuthService = LocalAuthService()
    
    @IBOutlet weak var pinVisibilityButton: UIButton!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var codeTextField: OneTimeCodeTextField!
    
    @IBOutlet weak var keyboardView: KeyboardView!
    
    lazy var presenter: UpdatePINViewPresenter = UpdatePINViewPresenterImpl(self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set-up
        presenter.onViewLoaded()
        instantiateCodeTextFieldFunctions()
        setCotterStatusBarStyle()
    }
    
    @IBAction func onClickPinVis(_ sender: UIButton) {
        presenter.onClickPinVis(button: sender)
    }
    
    func setError(msg: String?) {
        errorLabel.isHidden = msg == nil
        errorLabel.text = msg
    }
}

// MARK: - PINBaseController
extension UpdatePINViewController : PINBaseController {
    func generateErrorMessageFrom(error: CotterError) -> String {
        let strings = CotterStrings.instance
        switch(error) {
        case CotterError.network:
            return strings.getText(for: PinErrorMessagesKey.networkError)
        case CotterError.status(code: 500):
            return strings.getText(for: PinErrorMessagesKey.serverError)
        case CotterError.status(code: 403):
            return strings.getText(for: PinErrorMessagesKey.incorrectPinVerification)
        default:
            return strings.getText(for: PinErrorMessagesKey.updatePinFailed)
        }
    }
    
    func instantiateCodeTextFieldFunctions() {
        codeTextField.removeErrorMsg = {
            self.setError(msg: nil)
        }
        
        codeTextField.didEnterLastDigit = { code in
            func pinVerificationCallback(success: Bool, err: CotterError?) {
                LoadingScreen.shared.stop()
                if let error = err {
                    self.setError(msg: self.generateErrorMessageFrom(error: error))
                    return
                }
                
                if success {
                    self.codeTextField.clear()
                    // Go to Create New PIN View
                    let updateCreatePINVC = self.storyboard?.instantiateViewController(withIdentifier: "UpdateCreateNewPINViewController")as! UpdateCreateNewPINViewController
                    updateCreatePINVC.oldCode = code
                    self.navigationController?.pushViewController(updateCreatePINVC, animated: true)
                } else {
                    self.setError(msg: CotterStrings.instance.getText(for: PinErrorMessagesKey.incorrectPinVerification))
                    self.codeTextField.clear()
                }
            }
            
            // Verify PIN through API
            do {
                LoadingScreen.shared.start(at: self.view.window)
                _ = try self.authService.pinAuth(pin: code, event: CotterEvents.Update, callback: pinVerificationCallback)
            } catch let e {
                os_log("%{public}@ update pin verify failed { err: %{public}@ }",
                       log: Config.instance.log, type: .error,
                       #function, e.localizedDescription)
                return false
            }
            
            return true
        }
    }
}


// MARK: - UpdatePINViewComponent Instantiations
extension UpdatePINViewController: UpdatePINViewComponent {
    func setupUI() {
        errorLabel.isHidden = true
        
        // navigation controller setup
        self.navigationController?.setup()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        codeTextField.configure()
    }
    
    @objc private func promptBack(sender: UIBarButtonItem) {
        // Go back to previous screen
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupDelegates() {
        self.keyboardView.delegate = self
    }
    
    func render(_ props: UpdatePINViewProps) {
        setupLeftTitleBar(with: props.navTitle)
        titleLabel.text = props.title
        titleLabel.font = Config.instance.fonts.title
        pinVisibilityButton.setTitle(props.showPinText, for: .normal)
        pinVisibilityButton.setTitleColor(props.primaryColor, for: .normal)
        pinVisibilityButton.titleLabel?.font = Config.instance.fonts.subtitle
        errorLabel.textColor = props.dangerColor
        errorLabel.font = Config.instance.fonts.paragraph
    }
    
    func togglePinVisibility(button: UIButton, showPinText: String, hidePinText: String) {
        codeTextField.togglePinVisibility()
        if button.title(for: .normal) == showPinText {
            button.setTitle(hidePinText, for: .normal)
        } else {
            button.setTitle(showPinText, for: .normal)
        }
    }
    
}

// MARK: - KeyboardViewDelegate
extension UpdatePINViewController : KeyboardViewDelegate {
    func keyboardButtonTapped(buttonNumber: NSInteger) {
        if buttonNumber == -1 {
            codeTextField.removeNumber()
        } else {
            setError(msg: nil)
            codeTextField.appendNumber(buttonNumber: buttonNumber)
        }
    }
}
