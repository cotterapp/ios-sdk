//
//  ResetPINViewController.swift
//  Cotter
//
//  Created by Raymond Andrie on 3/19/20.
//

import UIKit

public class ResetPINViewControllerKey {
    // MARK: - Keys for Strings
   static let navTitle = "ResetPINViewController/navTitle"
   static let title = "ResetPINViewController/title"
   static let subtitle = "ResetPINViewController/subtitle"
   static let resetFailSub = "ResetPINViewController/resetFailSub"
   static let resendEmail = "ResetPINViewController/resendEmail"
}

class ResetPINViewController: UIViewController {
    var authService = LocalAuthService()
    
    typealias VCTextKey = ResetPINViewControllerKey
    
    // MARK: - VC Text Definitions
    let navTitle = CotterStrings.instance.getText(for: VCTextKey.navTitle)
    let resetTitle = CotterStrings.instance.getText(for: VCTextKey.title)
    let resetOpeningSub = CotterStrings.instance.getText(for: VCTextKey.subtitle)
    let resetFailSub = CotterStrings.instance.getText(for: VCTextKey.resetFailSub)
    let resendEmailText = CotterStrings.instance.getText(for: VCTextKey.resendEmail)
    
    lazy var resetSubtitle: String = {
        if let userInfo = Config.instance.userInfo {
            var maskedSendingDestination = userInfo.sendingDestination.maskContactInfo(method: userInfo.sendingMethod)
            return "\(resetOpeningSub) \(maskedSendingDestination)"
        }
        return resetFailSub
    }()
    
    @IBOutlet weak var resetPinTitle: UILabel!
    
    @IBOutlet weak var resetPinSubtitle: UILabel!
    
    @IBOutlet weak var resetCodeTextField: ResetCodeTextField!
    
    @IBOutlet weak var resetPinError: UILabel!
    
    @IBOutlet weak var resendEmailButton: UIButton!
    
    @IBOutlet weak var keyboardView: KeyboardView!
    
    override func viewDidAppear(_ animated: Bool) {
        makeResetPinRequest()
    }
    
    func makeResetPinRequest() {
        // If no user info, do not continue
        guard let userInfo = Config.instance.userInfo else {
            if self.resetPinError.isHidden {
                self.toggleErrorMsg(msg: CotterStrings.instance.getText(for: PinErrorMessagesKey.unableToResetPin))
            }
            return
        }
        
        // Pin Reset Callback
        func pinResetCb(response: CotterResult<CotterResponseWithChallenge>) {
            switch response {
            case .success(let data):
                if data.success {
                    // Store the Challenge and Challenge ID
                    Config.instance.userInfo?.resetChallengeID = data.challengeID
                    Config.instance.userInfo?.resetChallenge = data.challenge
                } else {
                    // Server failed to start reset PIN process
                    if self.resetPinError.isHidden {
                        self.toggleErrorMsg(msg: CotterStrings.instance.getText(for: PinErrorMessagesKey.unableToResetPin))
                    }
                }
            case .failure(let err):
                // we can handle multiple error results here
                print(err.localizedDescription)
                
                // Display Error
                if self.resetPinError.isHidden {
                    self.toggleErrorMsg(msg: CotterStrings.instance.getText(for: PinErrorMessagesKey.unableToResetPin))
                }
            }
        }
        
        // Request PIN Reset
        CotterAPIService.shared.requestPINReset(
            name: userInfo.name,
            sendingMethod: userInfo.sendingMethod,
            sendingDestination: userInfo.sendingDestination,
            cb: pinResetCb
        )
    }
    
    @IBAction func onClickResendEmail(_ sender: UIButton) {
        // User requested a new PIN Reset
        makeResetPinRequest()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addConfigs()
        addDelegates()
        instantiateCodeTextFieldFunctions()
    }

    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ResetPINViewController {
    func instantiateCodeTextFieldFunctions() {
        resetCodeTextField.removeErrorMsg = {
            // Remove error msg if it is present
            if !self.resetPinError.isHidden {
                self.toggleErrorMsg(msg: nil)
            }
        }
        
        resetCodeTextField.didEnterLastDigit = { code in
            print("PIN Code Entered: ", code)
            
            guard let userInfo = Config.instance.userInfo, let challengeID = userInfo.resetChallengeID, let challenge = userInfo.resetChallenge else {
                if self.resetPinError.isHidden {
                    self.toggleErrorMsg(msg: CotterStrings.instance.getText(for: PinErrorMessagesKey.unableToResetPin))
                }
                return false
            }
            
            // Callback Function to execute after Email Code Verification
            func verifyPinResetCb(response: CotterResult<CotterBasicResponse>) {
                switch response {
                case .success(let data):
                    if data.success {
                        // Store the Reset Code
                        Config.instance.userInfo?.resetCode = code
                        
                        self.resetCodeTextField.clear()
                        // Go to Reset New PIN View
                        let resetNewPINVC = self.storyboard?.instantiateViewController(withIdentifier: "ResetNewPINViewController")as! ResetNewPINViewController
                        self.navigationController?.pushViewController(resetNewPINVC, animated: true)
                    } else {
                        // Display Error
                        if self.resetPinError.isHidden {
                            self.toggleErrorMsg(msg: CotterStrings.instance.getText(for: PinErrorMessagesKey.incorrectEmailCode))
                        }
                    }
                case .failure(let err):
                    // we can handle multiple error results here
                    print(err.localizedDescription)
                    
                    // Display Error
                    if self.resetPinError.isHidden {
                        self.toggleErrorMsg(msg: CotterStrings.instance.getText(for: PinErrorMessagesKey.incorrectEmailCode))
                    }
                }
            }
            
            CotterAPIService.shared.verifyPINResetCode(
                resetCode: code,
                challengeID: challengeID,
                challenge: challenge,
                cb: verifyPinResetCb
            )

            return true
        }
    }
    
    func addConfigs() {
        // Implement the Custom Back Button instead of default in Nav Controller
        self.navigationItem.hidesBackButton = true
        
        let crossButton = UIBarButtonItem(title: "\u{2190}", style: UIBarButtonItem.Style.plain, target: self, action: #selector(promptClose(sender:)))
        crossButton.tintColor = UIColor.black
        self.navigationItem.leftBarButtonItem = crossButton
        
        // Remove default Nav controller styling
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
        
        resetCodeTextField.configure()
        configureText()
        configureErrorLabel()
        configureButtons()
    }
    
    func addDelegates() {
        self.keyboardView.delegate = self
    }
    
    func configureText() {
        self.navigationItem.title = navTitle
        self.resetPinTitle.text = resetTitle
        self.resetPinSubtitle.text = resetSubtitle
    }
    
    func configureErrorLabel() {
        resetPinError.isHidden = true
        resetPinError.textColor = Config.instance.colors.danger
    }
    
    func configureButtons() {
        if let _ = Config.instance.userInfo {
            self.resendEmailButton.setTitle(resendEmailText, for: .normal)
            self.resendEmailButton.setTitleColor(Config.instance.colors.primary, for: .normal)
            return
        }
        self.resendEmailButton.isEnabled = false
    }
    
    func toggleErrorMsg(msg: String?) {
        resetPinError.isHidden.toggle()
        if !resetPinError.isHidden {
            resetPinError.text = msg
        }
    }
    
    @objc private func promptClose(sender: UIBarButtonItem) {
        // Go back to previous screen
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - KeyboardViewDelegate
extension ResetPINViewController : KeyboardViewDelegate {
    func keyboardButtonTapped(buttonNumber: NSInteger) {
        if buttonNumber == -1 {
            resetCodeTextField.removeNumber()
        } else {
            resetCodeTextField.appendNumber(buttonNumber: buttonNumber)
        }
    }
}
