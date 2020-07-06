//
//  PINViewController.swift
//  CotterIOS
//
//  Created by Albert Purnama on 2/2/20.
//

import Foundation
import UIKit

// MARK: - Keys for Strings
public class PINViewControllerKey {
    public static let navTitle = "PINViewController/navTitle"
    public static let showPin = "PINViewController/showPin"
    public static let hidePin = "PINViewController/hidePin"
    public static let title = "PINViewController/title"
}

// MARK: - Presenter Protocol delegated UI-related logic
protocol PINViewPresenter {
    func onViewLoaded()
    func onClickPinVis(button: UIButton)
}

// MARK: - Properties of PINViewController
struct PINViewProps {
    let navTitle: String
    let showPinText: String
    let hidePinText: String
    let title: String
    
    let primaryColor: UIColor
    let accentColor: UIColor
    let dangerColor: UIColor
}

// MARK: - Components of PINViewController
protocol PINViewComponent: AnyObject {
    func setupUI()
    func setupDelegates()
    func render(_ props: PINViewProps)
    func togglePinVisibility(button: UIButton, showPinText: String, hidePinText: String)
}

// MARK: PINViewPresenter Implementation
class PINViewPresenterImpl: PINViewPresenter {
    
    typealias VCTextKey = PINViewControllerKey
    
    weak var viewController: PINViewComponent!
    
    let props: PINViewProps = {
        // MARK: - VC Text Definitions
        let navTitle = CotterStrings.instance.getText(for: VCTextKey.navTitle)
        let showPinText = CotterStrings.instance.getText(for: VCTextKey.showPin)
        let hidePinText = CotterStrings.instance.getText(for: VCTextKey.hidePin)
        let title = CotterStrings.instance.getText(for: VCTextKey.title)
        
        // MARK: - VC Color Definitions
        let primaryColor = Config.instance.colors.primary
        let accentColor = Config.instance.colors.accent
        let dangerColor = Config.instance.colors.danger
        
        return PINViewProps(navTitle: navTitle, showPinText: showPinText, hidePinText: hidePinText, title: title, primaryColor: primaryColor, accentColor: accentColor, dangerColor: dangerColor)
    }()
    
    init(_ viewController: PINViewController) {
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

class PINViewController : UIViewController {
    
    var hideCloseButton: Bool = false
    
    var alertService: AlertService?
    
    @IBOutlet weak var titleLabel: UILabel!
    
    // Code Text Field
    @IBOutlet weak var codeTextField: OneTimeCodeTextField!
    
    // PIN Visibility Toggle Button
    @IBOutlet weak var pinVisibilityButton: UIButton!
    
    // Error Label
    @IBOutlet weak var errorLabel: UILabel!
    
    // Keyboard
    @IBOutlet weak var keyboardView: KeyboardView!
    
    lazy var presenter: PINViewPresenter = PINViewPresenterImpl(self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("loaded PIN Cotter Enrollment View")
        
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
extension PINViewController : PINBaseController {
    func instantiateCodeTextFieldFunctions() {
        // Instantiate Function to run when user enters wrong PIN code
        codeTextField.removeErrorMsg = {
            // Remove error msg if it is present
            if !self.errorLabel.isHidden {
                self.toggleErrorMsg(msg: nil)
            }
        }
        
        // Instantiate Function to run when PIN is fully entered
        codeTextField.didEnterLastDigit = { code in
            print("PIN Code Entered: ", code)
            
            // If code has repeating digits or is a straight number, show error.
            let pattern = "\\b(\\d)\\1+\\b"
            let result = code.range(of: pattern, options: .regularExpression)
            
            // Ensure consecutive PIN number is rejected
            if result != nil || self.findSequence(sequenceLength: code.count, in: code) {
                if self.errorLabel.isHidden {
                    self.toggleErrorMsg(msg: CotterStrings.instance.getText(for: PinErrorMessagesKey.badPin))
                }
                return false
            }

            // Clear Code text Field before continuing
            self.codeTextField.clear()
            
            // Go to PIN Confirmation Page
            let confirmVC = self.storyboard?.instantiateViewController(withIdentifier: "PINConfirmViewController") as! PINConfirmViewController
            confirmVC.prevCode = code
            self.navigationController?.pushViewController(confirmVC, animated: true)
            return true
        }
    }
}

// MARK: - PINViewComponent Implementations
extension PINViewController: PINViewComponent {
    func setupUI() {
        // Implement Custom Back Button instead of default in Nav controller
        self.navigationItem.hidesBackButton = self.hideCloseButton
        
        // if close
        if !self.hideCloseButton {
            let crossButton = UIBarButtonItem(title: "\u{2717}", style: UIBarButtonItem.Style.plain, target: self, action: #selector(promptClose(sender:)))
            crossButton.tintColor = Config.instance.colors.primary
            self.navigationItem.leftBarButtonItems = [crossButton]
        }
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        // Hide error label initially
        errorLabel.isHidden = true
        
        // Configure Code Text Field
        codeTextField.configure()
    }
    
    @objc private func promptClose(sender: UIBarButtonItem) {
        // Create alert service
        let alertBackTitle = CotterStrings.instance.getText(for: AuthAlertMessagesKey.navBackTitle)
        let alertBackBody = CotterStrings.instance.getText(for: AuthAlertMessagesKey.navBackBody)
        let alertBackAction = CotterStrings.instance.getText(for: AuthAlertMessagesKey.navBackActionButton)
        let alertBackCancel = CotterStrings.instance.getText(for: AuthAlertMessagesKey.navBackCancelButton)
        
        let alert = AlertService(vc: self, title: alertBackTitle, body: alertBackBody, actionButtonTitle: alertBackAction, cancelButtonTitle: alertBackCancel)
        alert.delegate = self
        
        self.alertService = alert
        
        alert.show()
    }
    
    func setupDelegates() {
        self.keyboardView.delegate = self
    }
    
    func render(_ props: PINViewProps) {
        setupLeftTitleBar(with: props.navTitle)
        titleLabel.text = props.title
        titleLabel.font = Config.instance.fonts.heading
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
extension PINViewController : KeyboardViewDelegate {
    func keyboardButtonTapped(buttonNumber: NSInteger) {
        // If backspace tapped, remove last char. Else, append new char.
        if buttonNumber == -1 {
            codeTextField.removeNumber()
        } else {
            codeTextField.appendNumber(buttonNumber: buttonNumber)
        }
    }
}

// MARK: - AlertServiceDelegate
extension PINViewController : AlertServiceDelegate {
    func cancelHandler() {
        alertService?.hide()
    }
    
    func actionHandler() {
        alertService?.hide()
        Config.instance.pinEnrollmentCb("PIN Enrollment cancelled - no token", nil)
    }
}
