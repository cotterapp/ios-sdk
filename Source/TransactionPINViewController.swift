//
//  TransactionPINViewController.swift
//  CotterIOS
//
//  Created by Raymond Andrie on 2/4/20.
//

import UIKit

public class TransactionPINViewControllerKey {
    // MARK: - Keys for Strings
    static let navTitle = "TransactionPINViewControllerKey/navTitle"
    static let closeTitle = "TransactionPINViewControllerKey/closeTitle"
    static let closeMessage = "TransactionPINViewControllerKey/closeMessage"
    static let stayOnView = "TransactionPINViewControllerKey/stayOnView"
    static let leaveView = "TransactionPINViewControllerKey/leaveView"
    static let title = "TransactionPINViewControllerKey/title"
    static let showPin = "TransactionPINViewControllerKey/showPin"
    static let hidePin = "TransactionPINViewControllerKey/hidePin"
    static let buttonText = "TransactionPINViewControllerKey/buttonText"
}

class TransactionPINViewController: UIViewController, KeyboardViewDelegate, PINBaseController {
    var showErrorMsg: Bool = false
    
    typealias VCTextKey = TransactionPINViewControllerKey
    
    var authService = LocalAuthService()
    
    // MARK: - Alert Service Text Definition
    let closeTitleText = CotterStrings.instance.getText(for: VCTextKey.closeTitle)
    let closeMessageText = CotterStrings.instance.getText(for: VCTextKey.closeMessage)
    let stayText = CotterStrings.instance.getText(for: VCTextKey.stayOnView)
    let leaveText = CotterStrings.instance.getText(for: VCTextKey.leaveView)
    
    // MARK: - VC Text Definitions
    let navTitle = CotterStrings.instance.getText(for: VCTextKey.navTitle)
    let showPinText = CotterStrings.instance.getText(for: VCTextKey.showPin)
    let hidePinText = CotterStrings.instance.getText(for: VCTextKey.hidePin)
    let viewTitle = CotterStrings.instance.getText(for: VCTextKey.title)
  
//    lazy var alertService: AlertService = {
//        let alert = AlertService(vc: self, title: closeTitleText, body: closeMessageText, actionButtonTitle: leaveText, cancelButtonTitle: stayText)
//        alert.delegate = self
//        return alert
//    }()
    
    @IBOutlet weak var pinVisibilityButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var keyboardView: KeyboardView!
    
    @IBOutlet weak var codeTextField: OneTimeCodeTextField!
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("Transaction PIN View appeared!")
        
        guard let onFinishCallback = Config.instance.callbackFunc else { return }
        func cb(success: Bool) {
            if success{
                onFinishCallback("dummy biometric token")
            } else {
                print("got here!")
                self.toggleErrorMsg(msg: "Biometric is incorrect, please use PIN")
            }
        }
        authService.bioAuth(view: self, event: "TRANSACTION", callback: cb)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("loaded Transaction PIN View!")
        
        // Set-up
        addConfigs()
        addDelegates()
        instantiateCodeTextFieldFunctions()
        
        // Text setup
        populateText()
    }
    
    func populateText() {
        self.navigationItem.title = navTitle
        self.titleLabel.text = viewTitle
        self.pinVisibilityButton.setTitle(showPinText, for: .normal)
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
                    cbFunc("Token from Transaction PIN View!")
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
        let crossButton = UIBarButtonItem(title: "\u{2190}", style: UIBarButtonItem.Style.plain, target: self, action: #selector(TransactionPINViewController.promptClose(sender:)))
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
        if sender.title(for: .normal) == showPinText {
            sender.setTitle(hidePinText, for: .normal)
        } else {
            sender.setTitle(showPinText, for: .normal)
        }
    }
    
    @objc private func promptClose(sender: UIBarButtonItem) {
//        alertService.show()
        // Go back to previous screen
        self.navigationController?.popViewController(animated: true)
    }
    
    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//extension TransactionPINViewController : AlertServiceDelegate {
//    func cancelHandler() {
//        alertService.hide()
//    }
//
//    func actionHandler() {
//        alertService.hide(onComplete: { (Bool) -> Void in
//            self.navigationController?.popViewController(animated: true)
//            return
//        })
//    }
//}
