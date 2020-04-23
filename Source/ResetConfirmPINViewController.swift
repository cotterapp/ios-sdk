//
//  ResetConfirmPINViewController.swift
//  Cotter
//
//  Created by Raymond Andrie on 3/22/20.
//

import UIKit

// MARK: - Keys for Strings
public class ResetConfirmPINViewControllerKey {
    static let navTitle = "ResetConfirmPINViewController/navTitle"
    static let title = "ResetConfirmPINViewController/title"
    static let showPin = "ResetConfirmPINViewController/showPin"
    static let hidePin = "ResetConfirmPINViewController/hidePin"
}

// MARK: - Presenter Protocol delegated UI-related logic
protocol ResetConfirmPINViewPresenter {
    func onViewLoaded()
    func onClickPinVis(button: UIButton)
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
    func togglePinVisibility(button: UIButton, showPinText: String, hidePinText: String)
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
    
    func onClickPinVis(button: UIButton) {
        viewController.togglePinVisibility(button: button, showPinText: props.showPinText, hidePinText: props.hidePinText)
    }
    
}

class ResetConfirmPINViewController: UIViewController {
    // prevCode should be passed from the previous (PINView) controller
    var prevCode: String?
    
    typealias VCTextKey = ResetConfirmPINViewControllerKey
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var codeTextField: OneTimeCodeTextField!
    
    @IBOutlet weak var pinVisibilityButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var keyboardView: KeyboardView!
    
    lazy var presenter: ResetConfirmPINViewPresenter = ResetConfirmPINViewPresenterImpl(self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("loaded PIN Reset Confirmation View!")
        
        // Set-up
        presenter.onViewLoaded()
        instantiateCodeTextFieldFunctions()
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
extension ResetConfirmPINViewController : PINBaseController {
    func instantiateCodeTextFieldFunctions() {
        codeTextField.removeErrorMsg = {
            // Remove error msg if it is present
            if !self.errorLabel.isHidden {
                self.toggleErrorMsg(msg: nil)
            }
        }
        
        codeTextField.didEnterLastDigit = { code in
            print("PIN Code Entered: ", code)
            
            if self.prevCode == nil {
                print("No previous code exists!")
                return false
            }
            
            // If the entered digits are not the same, show error.
            if code != self.prevCode! {
                if self.errorLabel.isHidden {
                    self.toggleErrorMsg(msg: CotterStrings.instance.getText(for: PinErrorMessagesKey.incorrectPinConfirmation))
                }
                return false
            }
            
            // If code has repeating digits or is a straight number, show error.
            let pattern = "\\b(\\d)\\1+\\b"
            let result = code.range(of: pattern, options: .regularExpression)
            if result != nil || self.findSequence(sequenceLength: code.count, in: code) {
                if self.errorLabel.isHidden {
                    self.toggleErrorMsg(msg: CotterStrings.instance.getText(for: PinErrorMessagesKey.badPin))
                }
                return false
            }
            
            guard let resetCode = Config.instance.userInfo?.resetCode, let resetChallengeID = Config.instance.userInfo?.resetChallengeID,
                let resetChallenge = Config.instance.userInfo?.resetChallenge else {
                    // Display Error
                    if self.errorLabel.isHidden {
                        self.toggleErrorMsg(msg: CotterStrings.instance.getText(for: PinErrorMessagesKey.resetPinFailed))
                    }
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
                        let resetPINFinalVC = self.storyboard?.instantiateViewController(withIdentifier: "ResetPINFinalViewController")as! ResetPINFinalViewController
                        self.navigationController?.pushViewController(resetPINFinalVC, animated: true)
                    } else {
                        // Display Error
                        if self.errorLabel.isHidden {
                            self.toggleErrorMsg(msg: CotterStrings.instance.getText(for: PinErrorMessagesKey.resetPinFailed))
                        }
                    }
                case .failure(let err):
                    // we can handle multiple error results here
                    print(err.localizedDescription)
                    
                    // Display Error
                    if self.errorLabel.isHidden {
                        self.toggleErrorMsg(msg: CotterStrings.instance.getText(for: PinErrorMessagesKey.resetPinFailed))
                    }
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
        self.navigationItem.hidesBackButton = true
        let backButton = UIBarButtonItem(title: "\u{2190}", style: UIBarButtonItem.Style.plain, target: self, action: #selector(navigateBack(sender:)))
        backButton.tintColor = UIColor.black
        self.navigationItem.leftBarButtonItem = backButton
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
        
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
        navigationItem.title = props.navTitle
        titleLabel.text = props.title
        pinVisibilityButton.setTitle(props.showPinText, for: .normal)
        pinVisibilityButton.setTitleColor(props.primaryColor, for: .normal)
        errorLabel.textColor = props.dangerColor
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
extension ResetConfirmPINViewController : KeyboardViewDelegate {
    func keyboardButtonTapped(buttonNumber: NSInteger) {
        // If backspace tapped, remove last char. Else, append new char.
        if buttonNumber == -1 {
            print("removing number")
            codeTextField.removeNumber()
        } else {
            codeTextField.appendNumber(buttonNumber: buttonNumber)
        }
    }
}
