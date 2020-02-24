//
//  PINViewController.swift
//  CotterIOS
//
//  Created by Albert Purnama on 2/2/20.
//

import Foundation
import UIKit

public class PINViewControllerKey {
    // MARK: - Keys for Strings
    public static let navTitle = "PINViewController/navTitle"
    public static let showPin = "PINViewController/showPin"
    public static let hidePin = "PINViewController/hidePin"
    public static let closeTitle = "PINViewController/closeTitle"
    public static let closeMessage = "PINViewController/closeMessage"
    public static let stayOnView = "PINViewController/stayOnView"
    public static let leaveView = "PINViewController/leaveView"
    public static let title = "PINViewController/title"
}

class PINViewController : UIViewController {
    // since PINViewController is too long to type
    // we can getaway with typealias here
    typealias VCTextKey = PINViewControllerKey
    
    // MARK: - Alert Service Text Definition
    // Alert Service
    let closeTitleText = CotterStrings.instance.getText(for: VCTextKey.closeTitle)
    let closeMessageText = CotterStrings.instance.getText(for: VCTextKey.closeMessage)
    let stayText = CotterStrings.instance.getText(for: VCTextKey.stayOnView)
    let leaveText = CotterStrings.instance.getText(for: VCTextKey.leaveView)
    
    // MARK: - VC Text Definitions
    let navTitle = CotterStrings.instance.getText(for: VCTextKey.navTitle)
    let showPinText = CotterStrings.instance.getText(for: VCTextKey.showPin)
    let hidePinText = CotterStrings.instance.getText(for: VCTextKey.hidePin)
    let viewTitle = CotterStrings.instance.getText(for: VCTextKey.title)
    
    // MARK: - Color Text Definitions
    let hexTitleColor = CotterColors.instance.getColor(for: EnrollmentColorVCKey.pinTitleColor)
    let hexButtonColor = CotterColors.instance.getColor(for: EnrollmentColorVCKey.pinButtonColor)
    let hexEmptyPinColor = CotterColors.instance.getColor(for: EnrollmentColorVCKey.pinEmptyColor)
    let hexErrorColor = CotterColors.instance.getColor(for: EnrollmentColorVCKey.pinErrorColor)
    let hexInputPinColor = CotterColors.instance.getColor(for: EnrollmentColorVCKey.pinInputColor)
    
    
    lazy var alertService: AlertService = {
        let alert = AlertService(vc: self, title: closeTitleText, body: closeMessageText, actionButtonTitle: leaveText, cancelButtonTitle: stayText)
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
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("loaded PIN Cotter Enrollment View")
        
        // Set-up
        addConfigs()
        addDelegates()
        instantiateCodeTextFieldFunctions()
        
        // Text setup
        populateText()
        setTextColors()
    }
    
    func populateText() {
        self.navigationItem.title = navTitle
        self.titleLabel.text = viewTitle
        self.pinVisibilityButton.setTitle(showPinText, for: .normal)
    }
    
    func setTextColors() {
        // VC Colors
        self.titleLabel.textColor = UIColor(hexString: hexTitleColor)
        self.pinVisibilityButton.setTitleColor(UIColor(hexString: hexButtonColor), for: .normal)
        self.errorLabel.textColor = UIColor(hexString: hexErrorColor)
        
        // Code Text Field Colors
        self.codeTextField.setColors(
            defaultColor: UIColor(hexString: hexEmptyPinColor),
            inputColor: UIColor(hexString: hexInputPinColor),
            errorColor: UIColor(hexString: hexErrorColor)
        )
    }
    
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
                    self.toggleErrorMsg(msg: PinErrorMessages.badPIN)
                }
                return false
            }

            // Clear Code text Field before continuing
            self.codeTextField.clear()
            
            // Go to PIN Confirmation page
            let confirmVC = self.storyboard?.instantiateViewController(withIdentifier: "PINConfirmViewController")as! PINConfirmViewController
            confirmVC.prevCode = code
            self.navigationController?.pushViewController(confirmVC, animated: true)
            return true
        }
    }
    
    func addConfigs() {
        // Implement Custom Back Button instead of default in Nav controller
        self.navigationItem.hidesBackButton = true
        let crossButton = UIBarButtonItem(title: "\u{2717}", style: UIBarButtonItem.Style.plain, target: self, action: #selector(promptClose(sender:)))
        crossButton.tintColor = UIColor.black
        self.navigationItem.leftBarButtonItem = crossButton
        
        // Remove default Nav controller styling
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
        
        codeTextField.configure()
        configureErrorMsg()
    }
    
    func addDelegates() {
        self.keyboardView.delegate = self
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
        if sender.title(for: .normal) == showPinText {
            sender.setTitle(hidePinText, for: .normal)
        } else {
            sender.setTitle(showPinText, for: .normal)
        }
    }
    
    @objc private func promptClose(sender: UIBarButtonItem) {
        alertService.show()
    }
    
    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: - Private Helper Functions
extension PINViewController {
    private func findSequence(sequenceLength: Int, in string: String) -> Bool {
        // It would be better to extract this out of func
        let digits = CharacterSet.decimalDigits
        let controlSet = digits
        // ---

        let scalars = string.unicodeScalars
        let unicodeArray = scalars.map({ $0 })

        var i = 0

        var increasingLength = 1
        var decreasingLength = 1
        for number in unicodeArray where controlSet.contains(number) {
            if i+1 >= unicodeArray.count {
                break
            }
            let nextNumber = unicodeArray[i+1]
            
            if UnicodeScalar(number.value-1) == nextNumber {
                decreasingLength += 1
            }

            if UnicodeScalar(number.value+1) == nextNumber {
                increasingLength += 1
            }
            
            if decreasingLength >= sequenceLength || increasingLength >= sequenceLength {
                return true
            }
            i += 1
        }
        return false
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
        alertService.hide(onComplete: { (Bool) -> Void in
            self.navigationController?.popViewController(animated: true)
            return
        })
    }
}
