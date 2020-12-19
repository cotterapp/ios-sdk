//
//  TransactionPINViewController.swift
//  CotterIOS
//
//  Created by Raymond Andrie on 2/4/20.
//

import UIKit
import os.log
import LocalAuthentication

// MARK: - Keys for Strings
public class TransactionPINViewControllerKey {
    public static let navTitle = "TransactionPINViewController/navTitle"
    public static let title = "TransactionPINViewController/title"
    public static let showPin = "TransactionPINViewController/showPin"
    public static let hidePin = "TransactionPINViewController/hidePin"
    public static let forgetPin = "TransactionPINViewController/forgetPin"
}

// MARK: - Presenter Protocol delegated UI-related logic
protocol TransactionPINViewPresenter {
    func onViewAppeared()
    func onViewLoaded()
}

// MARK: - Properties of TransactionPINViewController
struct TransactionPINViewProps {
    let navTitle: String
    let showPinText: String
    let hidePinText: String
    let forgetPinText: String
    let title: String
    
    let primaryColor: UIColor
    let accentColor: UIColor
    let dangerColor: UIColor
}

// MARK: - Components of TransactionPINViewController
protocol TransactionPINViewComponent: AnyObject {
    func getBiometricStatus()
    func setupUI()
    func setupDelegates()
    func render(_ props: TransactionPINViewProps)
    func togglePinVisibility(button: UIButton, showPinText: String, hidePinText: String)
}

// MARK: - TransactionPINViewPresenter Implementation
class TransactionPINViewPresenterImpl: TransactionPINViewPresenter {
    
    typealias VCTextKey = TransactionPINViewControllerKey
    
    weak var viewController: TransactionPINViewComponent!
    
    let props: TransactionPINViewProps = {
        // MARK: - VC Text Definitions
        let navTitle = CotterStrings.instance.getText(for: VCTextKey.navTitle)
        let showPinText = CotterStrings.instance.getText(for: VCTextKey.showPin)
        let hidePinText = CotterStrings.instance.getText(for: VCTextKey.hidePin)
        let forgetPinText = CotterStrings.instance.getText(for: VCTextKey.forgetPin)
        let titleText = CotterStrings.instance.getText(for: VCTextKey.title)
        
        // MARK: - VC Color Definitions
        let primaryColor = Config.instance.colors.primary
        let accentColor = Config.instance.colors.accent
        let dangerColor = Config.instance.colors.danger
        
        return TransactionPINViewProps(navTitle: navTitle, showPinText: showPinText, hidePinText: hidePinText, forgetPinText: forgetPinText, title: titleText, primaryColor: primaryColor, accentColor: accentColor, dangerColor: dangerColor)
    }()
    
    init(_ viewController: TransactionPINViewComponent) {
        self.viewController = viewController
    }
    
    func onViewAppeared() {
        viewController.getBiometricStatus()
    }
    
    func onViewLoaded() {
        viewController.setupUI()
        viewController.setupDelegates()
        viewController.render(props)
    }
}

class TransactionPINViewController: UIViewController {
    
    var authService = LocalAuthService()
    
    var hideCloseButton: Bool = false
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var keyboardView: KeyboardView!
    
    @IBOutlet weak var codeTextField: OneTimeCodeTextField!
    
    @IBOutlet weak var forgetPinButton: UIButton!
    
    lazy var presenter: TransactionPINViewPresenter = TransactionPINViewPresenterImpl(self)
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        presenter.onViewAppeared()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?
            .setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set-up
        presenter.onViewLoaded()
        instantiateCodeTextFieldFunctions()
        setCotterStatusBarStyle()
    }
    
    func setError(msg: String?) {
        errorLabel.isHidden = msg == nil
        errorLabel.text = msg
    }
}

// MARK: - PINBaseController
extension TransactionPINViewController : PINBaseController {
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
            return strings.getText(for: PinErrorMessagesKey.clientError)
        }
    }
    
    func instantiateCodeTextFieldFunctions() {
        codeTextField.removeErrorMsg = {
            self.setError(msg: nil)
        }
        
        codeTextField.didEnterLastDigit = { code in
            let cbFunc = Config.instance.transactionCb
            
            // Callback Function to execute after PIN Verification
            func pinVerificationCallback(success: Bool, error: CotterError?) {
                LoadingScreen.shared.stop()
                if let err = error {
                    self.setError(msg: self.generateErrorMessageFrom(error: err))
                    return
                }
                
                if success {
                    self.codeTextField.clear()
                    cbFunc("", nil)
                } else {
                    self.setError(msg: CotterStrings.instance.getText(for: PinErrorMessagesKey.incorrectPinVerification))
                    self.codeTextField.clear()
                }
            }
            
            // Verify PIN through API
            do {
                LoadingScreen.shared.start(at: self.view.window)
                _ = try self.authService.pinAuth(pin: code, event: CotterEvents.Transaction, callback: pinVerificationCallback)
            } catch let e {
                os_log("%{public}@ verify pin { err: %{public}@ }",
                       log: Config.instance.log, type: .error,
                       #function, e.localizedDescription)
                return false
            }

            return true
        }
    }
}

// MARK: - TransactionPINViewComponent Instantiations
extension TransactionPINViewController: TransactionPINViewComponent {
    func getBiometricStatus() {
        LoadingScreen.shared.start(at: self.view.window)
        // Get initial user biometric status
        let context = LAContext()
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            CotterAPIService.shared.getBiometricStatus(cb: { response in
                LoadingScreen.shared.stop()
                switch response {
                case .success(let resp):
                    if !resp.enrolled { return }

                    let cb: FinalAuthCallback = {(success, err) in
                        guard success != "", err == nil else {
                            os_log("%{public}@ verify bio { err: %{public}@ }",
                                   log: Config.instance.log, type: .error,
                                   #function, err?.localizedDescription ?? "nil")
                            return
                        }
                        Config.instance.transactionCb("dummy biometric token", nil)
                    }
                    
                    BiometricAuthenticationService(event: CotterEvents.Transaction, callback: cb).start()
                case .failure(let err):
                    self.setError(msg: self.generateErrorMessageFrom(error: err))
                }
            })
        } else {
            LoadingScreen.shared.stop()
        }
    }
    
    func setupUI() {
        self.navigationItem.hidesBackButton = self.hideCloseButton
        
        self.navigationController?.setup()
        
        errorLabel.isHidden = true
        
        codeTextField.configure()
    }
    
    @objc private func promptClose(sender: UIBarButtonItem) {
        // Go back to previous screen
        self.parent?.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupDelegates() {
        self.keyboardView.delegate = self
    }
    
    func render(_ props: TransactionPINViewProps) {
        setupLeftTitleBar(with: props.navTitle)
        titleLabel.text = props.title
        titleLabel.font = Config.instance.fonts.title
        titleLabel.textColor = Config.instance.colors.accent
        errorLabel.textColor = props.dangerColor
        errorLabel.font = Config.instance.fonts.paragraph
        forgetPinButton.setTitle(props.forgetPinText, for: .normal)
        forgetPinButton.setTitleColor(props.primaryColor, for: .normal)
        forgetPinButton.titleLabel?.font = Config.instance.fonts.subtitle
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
extension TransactionPINViewController : KeyboardViewDelegate {
    func keyboardButtonTapped(buttonNumber: NSInteger) {
        if buttonNumber == -1 {
            codeTextField.removeNumber()
        } else {
            setError(msg: nil)
            codeTextField.appendNumber(buttonNumber: buttonNumber)
        }
    }
}
