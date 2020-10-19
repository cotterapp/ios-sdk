//
//  ResetConfirmPINViewController.swift
//  Cotter
//
//  Created by Raymond Andrie on 3/22/20.
//

import UIKit
import os.log

// MARK: - Keys for Strings
public class ResetConfirmPINViewControllerKey {
    public static let navTitle = "ResetConfirmPINViewController/navTitle"
    public static let title = "ResetConfirmPINViewController/title"
    public static let showPin = "ResetConfirmPINViewController/showPin"
    public static let hidePin = "ResetConfirmPINViewController/hidePin"
}

// MARK: - Presenter Protocol delegated UI-related logic
protocol ResetConfirmPINViewPresenter {
    func onViewLoaded()
}

// MARK: - Properties of ResetConfirmPINViewController
struct ResetConfirmPINViewProps {
    let navTitle: String
    let title: String
    let showPinText: String
    let hidePinText: String
    
    let primaryColor: UIColor
    let accentColor: UIColor
    let dangerColor: UIColor
}

// MARK: - Components of ResetConfirmPINViewController
protocol ResetConfirmPINViewComponent: AnyObject {
    func setupUI()
    func setupDelegates()
    func render(_ props: ResetConfirmPINViewProps)
}

// MARK: - ResetNewPINViewPresenter Implementation
class ResetConfirmPINViewPresenterImpl: ResetConfirmPINViewPresenter {
    
    typealias VCTextKey = ResetConfirmPINViewControllerKey
    
    weak var viewController: ResetConfirmPINViewComponent!
    
    let props: ResetConfirmPINViewProps = {
        // MARK: - VC Text Definitions
        let navTitle = CotterStrings.instance.getText(for: VCTextKey.navTitle)
        let titleText = CotterStrings.instance.getText(for: VCTextKey.title)
        let showPinText = CotterStrings.instance.getText(for: VCTextKey.showPin)
        let hidePinText = CotterStrings.instance.getText(for: VCTextKey.hidePin)
        
        // MARK: - VC Color Definitions
        let primaryColor = Config.instance.colors.primary
        let accentColor = Config.instance.colors.accent
        let dangerColor = Config.instance.colors.danger
        
        return ResetConfirmPINViewProps(navTitle: navTitle, title: titleText, showPinText: showPinText, hidePinText: hidePinText, primaryColor: primaryColor, accentColor: accentColor, dangerColor: dangerColor)
    }()
    
    init(_ viewController: ResetConfirmPINViewComponent) {
        self.viewController = viewController
    }
    
    func onViewLoaded() {
        viewController.setupUI()
        viewController.setupDelegates()
        viewController.render(props)
    }
}

class ResetConfirmPINViewController: UIViewController {
    // prevCode should be passed from the previous (PINView) controller
    var prevCode: String?
    
    typealias VCTextKey = ResetConfirmPINViewControllerKey
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var codeTextField: OneTimeCodeTextField!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var keyboardView: KeyboardView!
    
    lazy var presenter: ResetConfirmPINViewPresenter = ResetConfirmPINViewPresenterImpl(self)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set-up
        presenter.onViewLoaded()
        instantiateCodeTextFieldFunctions()
    }
    
    func setError(msg: String?) {
        errorLabel.isHidden = msg == nil
        errorLabel.text = msg
    }
}

// MARK: - PINBaseController
extension ResetConfirmPINViewController : PINBaseController {
    func generateErrorMessageFrom(error: CotterError) -> String {
        let strings = CotterStrings.instance
        switch(error) {
        case CotterError.status(code: 500):
            return strings.getText(for: PinErrorMessagesKey.serverError)
        case CotterError.network:
            return strings.getText(for: PinErrorMessagesKey.networkError)
        default:
            return strings.getText(for: PinErrorMessagesKey.resetPinFailed)
        }
    }
    
    func instantiateCodeTextFieldFunctions() {
        codeTextField.removeErrorMsg = {
            self.setError(msg: nil)
        }
        
        codeTextField.didEnterLastDigit = { code in
            if self.prevCode == nil {
                os_log("%{public}@ previous PIN code does not exist",
                       log: Config.instance.log, type: .fault, #function)
                return false
            }
            
            // If the entered digits are not the same, show error.
            if code != self.prevCode! {
                self.setError(msg: CotterStrings.instance.getText(for: PinErrorMessagesKey.incorrectPinConfirmation))
                return false
            }
            
            // If code has repeating digits or is a straight number, show error.
            let pattern = "\\b(\\d)\\1+\\b"
            let result = code.range(of: pattern, options: .regularExpression)
            if result != nil || self.findSequence(sequenceLength: code.count, in: code) {
                self.setError(msg: CotterStrings.instance.getText(for: PinErrorMessagesKey.badPin))
                return false
            }
            
            guard let resetCode = Config.instance.userInfo?.resetCode, let resetChallengeID = Config.instance.userInfo?.resetChallengeID,
                let resetChallenge = Config.instance.userInfo?.resetChallenge else {
                    self.setError(msg: CotterStrings.instance.getText(for: PinErrorMessagesKey.resetPinFailed))
                    return false
            }
            
            // Define the Reset New PIN Callback
            func resetPinCb(response: CotterResult<CotterBasicResponse>) {
                switch response {
                case .success(let data):
                    if data.success {
                        self.codeTextField.clear()
                        // Clear Reset Information after success
                        Config.instance.userInfo?.clearResetInfo()
                        // Go to Reset PIN Final View
                        let resetPINFinalVC = Cotter.cotterStoryboard.instantiateViewController(withIdentifier: "PINFinalViewController") as! PINFinalViewController
                        resetPINFinalVC.requireAuth = false
                        resetPINFinalVC.delegate = self
                        resetPINFinalVC.isEnroll = true
                        let nav = CotterNavigationViewController(
                            rootViewController: resetPINFinalVC)
                        self.present(nav, animated: true, completion: nil)
                    } else {
                        self.setError(msg: CotterStrings.instance.getText(for: PinErrorMessagesKey.resetPinFailed))
                    }
                case .failure(let err):
                    self.setError(msg: self.generateErrorMessageFrom(error: err))
                }
            }
            
            CotterAPIService.shared.resetPIN(
                resetCode: resetCode,
                newCode: code,
                challengeID: resetChallengeID,
                challenge: resetChallenge,
                cb: resetPinCb
            )
            
            return true
        }
    }
}

// MARK: - ResetConfirmPINViewComponent Instantiations
extension ResetConfirmPINViewController: ResetConfirmPINViewComponent {
    func setupUI() {
        errorLabel.isHidden = true
        
        codeTextField.configure()
    }
    
    @objc private func navigateBack(sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupDelegates() {
        self.keyboardView.delegate = self
    }
    
    func render(_ props: ResetConfirmPINViewProps) {
        self.setupLeftTitleBar(with: props.navTitle)
        titleLabel.text = props.title
        titleLabel.font = Config.instance.fonts.title
        errorLabel.textColor = props.dangerColor
        errorLabel.font = Config.instance.fonts.paragraph
    }
}

// MARK: - KeyboardViewDelegate
extension ResetConfirmPINViewController : KeyboardViewDelegate {
    func keyboardButtonTapped(buttonNumber: NSInteger) {
        // If backspace tapped, remove last char. Else, append new char.
        if buttonNumber == -1 {
            codeTextField.removeNumber()
        } else {
            codeTextField.appendNumber(buttonNumber: buttonNumber)
        }
    }
}

extension ResetConfirmPINViewController: CallbackDelegate {
    func callback(token: String, error: Error?) {
        Config.instance.transactionCb(token, error)
    }
}
