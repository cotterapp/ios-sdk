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
    func onClickPinVis()
    func onToggleErrorMsg()
    func onInstantiateCodeTextFieldFunctions()
    func onAddConfigs()
    func onAddDelegates()
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
    
    let alertBackTitle: String
    let alertBackBody: String
    let alertBackAction: String
    let alertBackCancel: String
}

// MARK: - Component Protocol delegated to render props
protocol PINViewComponent: AnyObject {
    func render(_ props: PINViewProps)
}

class PINViewController : UIViewController {
    typealias VCTextKey = PINViewControllerKey
    
    var hideCloseButton: Bool = false
    
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
        
        // MARK: - Alert Service Text Definition
        let alertBackTitle = CotterStrings.instance.getText(for: AuthAlertMessagesKey.navBackTitle)
        let alertBackBody = CotterStrings.instance.getText(for: AuthAlertMessagesKey.navBackBody)
        let alertBackAction = CotterStrings.instance.getText(for: AuthAlertMessagesKey.navBackActionButton)
        let alertBackCancel = CotterStrings.instance.getText(for: AuthAlertMessagesKey.navBackCancelButton)
        
        return PINViewProps(navTitle: navTitle, showPinText: showPinText, hidePinText: hidePinText, title: title, primaryColor: primaryColor, accentColor: accentColor, dangerColor: dangerColor, alertBackTitle: alertBackTitle, alertBackBody: alertBackBody, alertBackAction: alertBackAction, alertBackCancel: alertBackCancel)
    }()
    
    lazy var alertService: AlertService = {
        let alert = AlertService(vc: self, title: props.alertBackTitle, body: props.alertBackBody, actionButtonTitle: props.alertBackTitle, cancelButtonTitle: props.alertBackCancel)
        alert.delegate = self
        return alert
    }()
    
    @IBOutlet weak var titleLabel: UILabel!
    
    // Code Text Field
    @IBOutlet weak var codeTextField: OneTimeCodeTextField!
    
    // PIN Visibility Toggle Button
    @IBOutlet weak var pinVisibilityButton: UIButton!
    
    // Error Label
    @IBOutlet weak var errorLabel: UILabel!
    
    // Keyboard
    @IBOutlet weak var keyboardView: KeyboardView!
    
    var presenter: PINViewPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("loaded PIN Cotter Enrollment View")
        
        // Set-up
        addConfigs()
        addDelegates()
        instantiateCodeTextFieldFunctions()
        render(props)
        setCotterStatusBarStyle()
        
        presenter?.onViewLoaded()
    }
    
    @IBAction func onClickPinVis(_ sender: UIButton) {
        codeTextField.togglePinVisibility()
        if sender.title(for: .normal) == props.showPinText {
            sender.setTitle(props.hidePinText, for: .normal)
        } else {
            sender.setTitle(props.showPinText, for: .normal)
        }
        
        presenter?.onClickPinVis()
    }
    
    func toggleErrorMsg(msg: String?) {
        errorLabel.isHidden.toggle()
        if !errorLabel.isHidden {
            errorLabel.text = msg
        }
        
        presenter?.onToggleErrorMsg()
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
        
        presenter?.onInstantiateCodeTextFieldFunctions()
    }
    
    func addConfigs() {
        // Implement Custom Back Button instead of default in Nav controller
        self.navigationItem.hidesBackButton = true
        
        // if close
        if !self.hideCloseButton {
            let crossButton = UIBarButtonItem(title: "\u{2717}", style: UIBarButtonItem.Style.plain, target: self, action: #selector(promptClose(sender:)))
            crossButton.tintColor = UIColor.black
            self.navigationItem.leftBarButtonItem = crossButton
        }
        
        // Remove default Nav controller styling
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
        
        // Hide error label initially
        errorLabel.isHidden = true
        
        // Configure Code Text Field
        codeTextField.configure()
        
        presenter?.onAddConfigs()
    }
    
    func addDelegates() {
        self.keyboardView.delegate = self
        
        presenter?.onAddDelegates()
    }
  
    @objc private func promptClose(sender: UIBarButtonItem) {
        alertService.show()
    }
}

// MARK: - PINViewComponent Render
extension PINViewController : PINViewComponent {
    func render(_ props: PINViewProps) {
        navigationItem.title = props.navTitle
        titleLabel.text = props.title
        pinVisibilityButton.setTitle(props.showPinText, for: .normal)
        pinVisibilityButton.setTitleColor(props.primaryColor, for: .normal)
        errorLabel.textColor = props.dangerColor
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
        alertService.hide()
    }
    
    func actionHandler() {
        alertService.hide()
        Config.instance.pinEnrollmentCb("PIN Enrollment cancelled - no token", nil)
    }
}
