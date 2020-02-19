//
//  PINConfirmViewController.swift
//  CotterIOS
//
//  Created by Albert Purnama on 2/2/20.
//

import UIKit

// PINConfirmViewControllerKey are a list of strings for key to text configuration
public class PINConfirmViewControllerKey {
    // MARK: - Keys for Strings
    static let showPin = "PINConfirmViewController/showPin"
    static let hidePin = "PINConfirmViewController/hidePin"
    static let closeTitle = "PINConfirmViewController/closeTitle"
    static let closeMessage = "PINConfirmViewController/closeMessage"
    static let stayOnView = "PINConfirmViewController/stayOnView"
    static let leaveView = "PINConfirmViewController/leaveView"
    static let title = "PINConfirmViewController/title"
}

class PINConfirmViewController : UIViewController, KeyboardViewDelegate {
    // prevCode should be passed from the previous (PINView) controller
    var prevCode: String?
    
    // since PinConfirmViewControllerKey is a nuisance to type
    // we can getaway with typealias here
    typealias VCTextKey = PINConfirmViewControllerKey
    
    let closeTitleText = CotterStrings.instance.getText(for: VCTextKey.closeTitle)
    let closeMessageText = CotterStrings.instance.getText(for: VCTextKey.closeMessage)
    let stayText = CotterStrings.instance.getText(for: VCTextKey.stayOnView)
    let leaveText = CotterStrings.instance.getText(for: VCTextKey.leaveView)
    let showPinText = CotterStrings.instance.getText(for: VCTextKey.showPin)
    let hidePinText = CotterStrings.instance.getText(for: VCTextKey.hidePin)
    
    // Code Text Field
    @IBOutlet weak var codeTextField: OneTimeCodeTextField!
    
    @IBOutlet weak var pinVisibilityButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var keyboardView: KeyboardView!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("loaded PIN Confirmation View")
        
        // Set-up
        addConfigs()
        addDelegates()
        instantiateCodeTextFieldFunctions()
        
        self.titleLabel.text = CotterStrings.instance.getText(for: VCTextKey.title)
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
            
            // If the entered digits are not the same, show error.
            if code != self.prevCode! {
                if self.errorLabel.isHidden {
                    self.toggleErrorMsg(msg: PinErrorMessages.wrongPINConfirm)
                }
                return false
            }
            
            // If code has repeating digits or is a straight number, show error.
            let pattern = "\\b(\\d)\\1+\\b"
            let result = code.range(of: pattern, options: .regularExpression)
            if result != nil || code == "123456" || code == "654321" {
                if self.errorLabel.isHidden {
                    self.toggleErrorMsg(msg: PinErrorMessages.badPIN)
                }
                return false
            }
            
            // Define the callbacks
            func successCb(resp: Data?) -> Void {
                let finalVC = self.storyboard?.instantiateViewController(withIdentifier: "PINFinalViewController")as! PINFinalViewController
                self.navigationController?.pushViewController(finalVC, animated: true)
            }
            
            func errorCb(err: Error?) -> Void {
                print(err?.localizedDescription ?? "error in the PINConfirmViewController http request")
                // Display Error
                if self.errorLabel.isHidden {
                    self.toggleErrorMsg(msg: PinErrorMessages.enrollPINFailed)
                }
            }
            
            // define the handlers, attach the callbacks
            let h = CotterCallback()
            h.successfulFunc = successCb
            h.networkErrorFunc = errorCb
            
            // Run API to enroll PIN
            CotterAPIService.shared.enrollUserPin(
                code: code,
                cb: h
            )
            
            return true
        }
    }
    
    func addConfigs() {
        self.navigationItem.hidesBackButton = true
        let backButton = UIBarButtonItem(title: "\u{2190}", style: UIBarButtonItem.Style.plain, target: self, action: #selector(PINConfirmViewController.promptClose(sender:)))
        backButton.tintColor = UIColor.black
        self.navigationItem.leftBarButtonItem = backButton
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
        
        codeTextField.configure()
        configureErrorMsg()
    }
    
    func addDelegates() {
        self.keyboardView.delegate = self
    }
    
    // This delegate function runs when the buttons in keyboardView is tapped.
    // Code Text Field is updated here.
    func keyboardButtonTapped(buttonNumber: NSInteger) {
        // If backspace tapped, remove last char. Else, append new char.
        if buttonNumber == -1 {
            print("removing number")
            codeTextField.removeNumber()
        } else {
            codeTextField.appendNumber(buttonNumber: buttonNumber)
        }
    }
    
    private func configureErrorMsg() {
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
        // Perform Prompt Alert
        self.navigationController?.popViewController(animated: true)
    }

    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
