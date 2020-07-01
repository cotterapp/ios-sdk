//
//  TransactionPINViewController.swift
//  CotterIOS
//
//  Created by Raymond Andrie on 2/4/20.
//

import UIKit

// MARK: - Keys for Strings
public class TransactionPINViewControllerKey {
    static let navTitle = "TransactionPINViewController/navTitle"
    static let title = "TransactionPINViewController/title"
    static let showPin = "TransactionPINViewController/showPin"
    static let hidePin = "TransactionPINViewController/hidePin"
    static let forgetPin = "TransactionPINViewController/forgetPin"
}

// MARK: - Presenter Protocol delegated UI-related logic
protocol TransactionPINViewPresenter {
    func onViewAppeared()
    func onViewLoaded()
    func onClickPinVis(button: UIButton)
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
    
    func onClickPinVis(button: UIButton) {
        viewController.togglePinVisibility(button: button, showPinText: props.showPinText, hidePinText: props.hidePinText)
    }
}

class TransactionPINViewController: UIViewController {
    
    var authService = LocalAuthService()
    
    var hideCloseButton: Bool = false
    
    @IBOutlet weak var pinVisibilityButton: UIButton!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var keyboardView: KeyboardView!
    
    @IBOutlet weak var codeTextField: OneTimeCodeTextField!
    
    @IBOutlet weak var forgetPinButton: UIButton!
    
    lazy var presenter: TransactionPINViewPresenter = TransactionPINViewPresenterImpl(self)
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("Transaction PIN View appeared!")
        
        presenter.onViewAppeared()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("loaded Transaction PIN View!")
        
        // Set-up
        presenter.onViewLoaded()
        instantiateCodeTextFieldFunctions()
        setCotterStatusBarStyle()
    }
    
    @IBAction func onClickPinVis(_ sender: UIButton) {
        presenter.onClickPinVis(button: sender)
    }
    
    func toggleErrorMsg(msg: String?) {
        errorLabel.isHidden.toggle()
        if !errorLabel.isHidden {
            errorLabel.text = msg
        }
    }
}

// MARK: - PINBaseController
extension TransactionPINViewController : PINBaseController {
    func instantiateCodeTextFieldFunctions() {
        codeTextField.removeErrorMsg = {
            // Remove error msg if it is present
            if !self.errorLabel.isHidden {
                self.toggleErrorMsg(msg: nil)
            }
        }
        
        codeTextField.didEnterLastDigit = { code in
            print("PIN Code Entered: ", code)
            
            let cbFunc = Config.instance.transactionCb
            
            // Callback Function to execute after PIN Verification
            func pinVerificationCallback(success: Bool) {
                LoadingScreen.shared.stop()
                if success {
                    self.codeTextField.clear()
                    cbFunc("Token from Transaction PIN View!", nil)
                } else {
                    if self.errorLabel.isHidden {
                        self.toggleErrorMsg(msg: CotterStrings.instance.getText(for: PinErrorMessagesKey.incorrectPinVerification))
                    }
                    self.codeTextField.clear()
                }
            }
            
            // Verify PIN through API
            do {
                LoadingScreen.shared.start(at: self.view.window)
                _ = try self.authService.pinAuth(pin: code, event: CotterEvents.Transaction, callback: pinVerificationCallback)
            } catch let e {
                print(e)
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
        CotterAPIService.shared.getBiometricStatus(cb: { response in
            LoadingScreen.shared.stop()
            switch response {
            case .success(let resp):
                if resp.enrolled {
                    let onFinishCallback = Config.instance.transactionCb
                    func cb(success: Bool) {
                        if success {
                            onFinishCallback("dummy biometric token", nil)
                        } else {
                            print("[TransactionPINViewController.getBiometricStatus] got here!")
                            self.toggleErrorMsg(msg: "Biometric is incorrect, please use PIN")
                        }
                    }
                    self.authService.bioAuth(view: self, event: CotterEvents.Transaction, callback: cb)
                } else {
                    print("[TransactionPINViewController.getBiometricStatus] Biometric not enrolled")
                }
            case .failure(let err):
                print(err.localizedDescription)
            }
        })
    }
    
    func setupUI() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
        
        self.navigationItem.hidesBackButton = true

        if !self.hideCloseButton {
            let crossButton = UIBarButtonItem(title: "\u{2190}", style: UIBarButtonItem.Style.plain, target: self, action: #selector(TransactionPINViewController.promptClose(sender:)))
            crossButton.tintColor = UIColor.black
            self.navigationItem.leftBarButtonItems = [crossButton]
        }
        
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
        errorLabel.textColor = props.dangerColor
        errorLabel.font = Config.instance.fonts.paragraph
        pinVisibilityButton.setTitle(props.showPinText, for: .normal)
        pinVisibilityButton.setTitleColor(props.primaryColor, for: .normal)
        pinVisibilityButton.titleLabel?.font = Config.instance.fonts.subtitle
        forgetPinButton.setTitle(props.forgetPinText, for: .normal)
        forgetPinButton.setTitleColor(props.accentColor, for: .normal)
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
            // If we were to clear the text field after each failed input, we need to remove the error message as soon as we enter a new number in the subsequent try
            if !errorLabel.isHidden {
                toggleErrorMsg(msg: nil)
            }
            codeTextField.appendNumber(buttonNumber: buttonNumber)
        }
    }
}
