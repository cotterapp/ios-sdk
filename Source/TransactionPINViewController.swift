//
//  TransactionPINViewController.swift
//  CotterIOS
//
//  Created by Raymond Andrie on 2/4/20.
//

import UIKit

public class TransactionPINViewControllerKey {
    // MARK: - Keys for Strings
    static let showPin = "TransactionPINViewController/showPin"
    static let hidePin = "TransactionPINViewController/hidePin"
    static let closeTitle = "TransactionPINViewController/closeTitle"
    static let closeMessage = "TransactionPINViewController/closeMessage"
    static let stayOnView = "TransactionPINViewController/stayOnView"
    static let leaveView = "TransactionPINViewController/leaveView"
}

class TransactionPINViewController: UIViewController {
    var authService = LocalAuthService()
  
    typealias VCTextKey = TransactionPINViewControllerKey
    
    // Constants
    let closeTitleText = CotterStrings.instance.getText(for: VCTextKey.closeTitle)
    let closeMessageText = CotterStrings.instance.getText(for: VCTextKey.closeMessage)
    let stayText = CotterStrings.instance.getText(for: VCTextKey.stayOnView)
    let leaveText = CotterStrings.instance.getText(for: VCTextKey.leaveView)
    let showPinText = CotterStrings.instance.getText(for: VCTextKey.showPin)
    let hidePinText = CotterStrings.instance.getText(for: VCTextKey.hidePin)
  
    lazy var alertService: AlertService = {
        let alert = AlertService(vc: self, title: closeTitleText, body: closeMessageText, actionButtonTitle: leaveText, cancelButtonTitle: stayText)
        alert.delegate = self
        return alert
    }()
    
    @IBOutlet weak var pinVisibilityButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var keyboardView: KeyboardView!
    
    @IBOutlet weak var codeTextField: OneTimeCodeTextField!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("Transaction PIN View appeared!")
        
        guard let onFinishCallback = Config.instance.callbackFunc else { return }
        func cb(success: Bool) {
            if success{
                onFinishCallback("dummy biometric token", true, nil)
            } else {
                print("got here!")
                self.toggleErrorMsg(msg: "Biometric is incorrect, please use PIN")
            }
        }
        authService.bioAuth(view: self, event: "TRANSACTION", callback: cb)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("loaded Transaction PIN View!")
        
        // Set-up
        addConfigs()
        addDelegates()
        instantiateCodeTextFieldFunctions()
    }
    
    @IBAction func onClickPinVis(_ sender: UIButton) {
        codeTextField.togglePinVisibility()
        if sender.title(for: .normal) == showPinText {
            sender.setTitle(hidePinText, for: .normal)
        } else {
            sender.setTitle(showPinText, for: .normal)
        }
    }
    
    
    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            
            // If code has repeating digits or is a straight number, show error.
            let pattern = "\\b(\\d)\\1+\\b"
            let result = code.range(of: pattern, options: .regularExpression)
            if result != nil || code == "123456" || code == "654321" {
                if self.errorLabel.isHidden {
                    self.toggleErrorMsg(msg: PinErrorMessages.badPIN)
                }
                return false
            }
            
            guard let cbFunc = Config.instance.callbackFunc else {
                print("ERROR: no callback function")
                return false
            }
            
            // Callback Function to execute after PIN Verification
            func pinVerificationCallback(success: Bool) {
                if success {
                    cbFunc("Token from Transaction PIN View!", true, nil)
                } else {
                    if self.errorLabel.isHidden {
                        self.toggleErrorMsg(msg: PinErrorMessages.incorrectPIN)
                    }
                }
            }
            
            // Verify PIN through API
            do {
                _ = try self.authService.pinAuth(pin: code, event: "TRANSACTION", callback: pinVerificationCallback)
            } catch let e {
                print(e)
                return false
            }
            
            // Clear the text before continue
            self.codeTextField.clear()

            return true
        }
    }
    
    // Make Configurations
    func addConfigs() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
        
        self.navigationItem.hidesBackButton = true
        let crossButton = UIBarButtonItem(title: "\u{2717}", style: UIBarButtonItem.Style.plain, target: self, action: #selector(TransactionPINViewController.promptClose(sender:)))
        crossButton.tintColor = UIColor.black
        self.navigationItem.leftBarButtonItem = crossButton
        
        codeTextField.configure()
        configureErrorLabel()
        configurePinVisibilityButton()
    }
    
    // Add any delegates
    func addDelegates() {
        self.keyboardView.delegate = self
    }
    
    func configureErrorLabel() {
        errorLabel.isHidden = true
        errorLabel.textColor = Config.instance.colors.danger
    }
  
    func configurePinVisibilityButton() {
        pinVisibilityButton.setTitle(showPinText, for: .normal)
        pinVisibilityButton.setTitleColor(Config.instance.colors.primary, for: .normal)
    }
    
    func toggleErrorMsg(msg: String?) {
        errorLabel.isHidden.toggle()
        if !errorLabel.isHidden {
            errorLabel.text = msg
        }
    }
  
    @objc private func promptClose(sender: UIBarButtonItem) {
        alertService.show()
    }
}

// MARK: - KeyboardViewDelegate
extension TransactionPINViewController : KeyboardViewDelegate {
    func keyboardButtonTapped(buttonNumber: NSInteger) {
        if buttonNumber == -1 {
            codeTextField.removeNumber()
        } else {
            codeTextField.appendNumber(buttonNumber: buttonNumber)
        }
    }
}

// MARK: - AlertServiceDelegate
extension TransactionPINViewController : AlertServiceDelegate {
    func cancelHandler() {
        alertService.hide()
    }
    
    func actionHandler() {
        alertService.hide(onComplete: { (Bool) -> Void in
            self.navigationController?.popViewController(animated: true)
            return
        })
    }
}
