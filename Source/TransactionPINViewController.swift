//
//  TransactionPINViewController.swift
//  CotterIOS
//
//  Created by Raymond Andrie on 2/4/20.
//

import UIKit

class TransactionPINViewController: UIViewController, KeyboardViewDelegate, PINBaseController {
    // MARK: - Keys for Strings
    static let showPin = "TransactionPINViewController/showPin"
    static let hidePin = "TransactionPINViewController/hidePin"
    static let closeTitle = "TransactionPINViewController/closeTitle"
    static let closeMessage = "TransactionPINViewController/closeMessage"
    static let stayOnView = "TransactionPINViewController/stayOnView"
    static let leaveView = "TransactionPINViewController/leaveView"
    
    let alertService = AlertService()
    var authService = LocalAuthService()
    
    // Constants
    let closeTitleText = CotterStrings.instance.getText(for: closeTitle)
    let closeMessageText = CotterStrings.instance.getText(for: closeMessage)
    let stayText = CotterStrings.instance.getText(for: stayOnView)
    let leaveText = CotterStrings.instance.getText(for: leaveView)
    
    let showPinText = CotterStrings.instance.getText(for: showPin)
    let hidePinText = CotterStrings.instance.getText(for: hidePin)
    
    @IBOutlet weak var pinVisibilityButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var keyboardView: KeyboardView!
    
    @IBOutlet weak var codeTextField: OneTimeCodeTextField!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("loaded Transaction PIN View!")
        
        // Set-up
        addConfigs()
        addDelegates()
        instantiateCodeTextFieldFunctions()
        
        // TODO: Show Alert for Biometrics
        guard let onFinishCallback = Config.instance.callbackFunc else { return }
        authService.authenticate(view: self, reason: "Verifikasi", callback: onFinishCallback)
    }
    
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
                self.toggleErrorMsg(msg: PinErrorMessages.badPIN)
                return
            }
            
            // Clear the text before continue
            self.codeTextField.clear()
            
            // TODO: Verify through API. If successful, execute calback
            let success = true
            
            if success {
                self.config?.callbackFunc!("This is Token!")
            } else {
                // TODO: Show Error
//                self.toggleErrorMsg(msg: PinErrorMessages.incorrectPIN)
            }
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
        configureErrorMsg()
    }
    
    // Add any delegates
    func addDelegates() {
        self.keyboardView.delegate = self
    }
    
    func keyboardButtonTapped(buttonNumber: NSInteger) {
        if buttonNumber == -1 {
            codeTextField.removeNumber()
        } else {
            codeTextField.appendNumber(buttonNumber: buttonNumber)
        }
    }
    
    func configureErrorMsg() {
        errorLabel.isHidden = true
    }
    
    func toggleErrorMsg(msg: String?) {
        errorLabel.isHidden.toggle()
        if !errorLabel.isHidden {
            errorLabel.text = msg
        }
    }
    
    @IBAction func onClickPinVis(_ sender: UIButton) {
        codeTextField.togglePinVisibility()
        if sender.title(for: .normal) == PinDisplayText.showPinText {
            sender.setTitle(PinDisplayText.hidePinText, for: .normal)
        } else {
            sender.setTitle(PinDisplayText.showPinText, for: .normal)
        }
    }
    
    @objc private func promptClose(sender: UIBarButtonItem) {
        let cancelHandler = {
            // Go back to previous screen
            self.navigationController?.popViewController(animated: true)
            return
        }
        
        // Perform Prompt Alert
        let alertVC = alertService.createDefaultAlert(title: closeTitleText, body: closeMessageText, actionText: stayText, cancelText: leaveText, cancelHandler: cancelHandler)
        
        present(alertVC, animated: true)
    }
    
    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
