//
//  ResetPINViewController.swift
//  Cotter
//
//  Created by Raymond Andrie on 3/19/20.
//

import UIKit

// MARK: - Keys for Strings
public class ResetPINViewControllerKey {
   static let navTitle = "ResetPINViewController/navTitle"
   static let title = "ResetPINViewController/title"
   static let subtitle = "ResetPINViewController/subtitle"
   static let resetFailSub = "ResetPINViewController/resetFailSub"
   static let resendEmail = "ResetPINViewController/resendEmail"
}

// MARK: - Presenter Protocol delegated UI-related logic
protocol ResetPINViewPresenter {
    func onViewAppeared()
    func onViewLoaded()
    func clickedResendEmail()
}

// MARK: - Properties of ResetPINViewController
struct ResetPINViewProps {
    let navTitle: String
    let title: String
    let resetOpeningSub: String
    let resetFailSub: String
    let resendEmail: String
    
    let primaryColor: UIColor
    let accentColor: UIColor
    let dangerColor: UIColor
}

// MARK: - Components of ResetPINViewController
protocol ResetPINViewComponent: AnyObject {
    func setupUI()
    func setupDelegates()
    func render(_ props: ResetPINViewProps)
    func makeResetPinRequest()
}

// MARK: - ResetPINViewPresenter Implementation
class ResetPINViewPresenterImpl: ResetPINViewPresenter {
    
    typealias VCTextKey = ResetPINViewControllerKey
    
    weak var viewController: ResetPINViewComponent!
    
    let props: ResetPINViewProps = {
        // MARK: - VC Text Definitions
        let navTitle = CotterStrings.instance.getText(for: VCTextKey.navTitle)
        let resetTitle = CotterStrings.instance.getText(for: VCTextKey.title)
        let resetOpeningSub = CotterStrings.instance.getText(for: VCTextKey.subtitle)
        let resetFailSub = CotterStrings.instance.getText(for: VCTextKey.resetFailSub)
        let resendEmailText = CotterStrings.instance.getText(for: VCTextKey.resendEmail)
        
        // MARK: - VC Color Definitions
        let primaryColor = Config.instance.colors.primary
        let accentColor = Config.instance.colors.accent
        let dangerColor = Config.instance.colors.danger
        
        return ResetPINViewProps(navTitle: navTitle, title: resetTitle, resetOpeningSub: resetOpeningSub, resetFailSub: resetFailSub, resendEmail: resendEmailText, primaryColor: primaryColor, accentColor: accentColor, dangerColor: dangerColor)
    }()
    
    init(_ viewController: ResetPINViewComponent) {
        self.viewController = viewController
    }
    
    func onViewAppeared() {
        viewController.makeResetPinRequest()
    }
    
    func onViewLoaded() {
        viewController.setupUI()
        viewController.setupDelegates()
        viewController.render(props)
    }
    
    func clickedResendEmail() {
        viewController.makeResetPinRequest()
    }
}

class ResetPINViewController: UIViewController {
    
    var authService = LocalAuthService()
    
    @IBOutlet weak var resetPinTitle: UILabel!
    
    @IBOutlet weak var resetPinSubtitle: UILabel!
    
    @IBOutlet weak var resetCodeTextField: ResetCodeTextField!
    
    @IBOutlet weak var resetPinError: UILabel!
    
    @IBOutlet weak var resendEmailButton: UIButton!
    
    @IBOutlet weak var keyboardView: KeyboardView!
    
    lazy var presenter: ResetPINViewPresenter = ResetPINViewPresenterImpl(self)
    
    override func viewDidAppear(_ animated: Bool) {
        presenter.onViewAppeared()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("loaded Reset PIN View!")
        
        presenter.onViewLoaded()
        instantiateCodeTextFieldFunctions()
    }
    
    @IBAction func onClickResendEmail(_ sender: UIButton) {
        // User requested a new PIN Reset
        presenter.clickedResendEmail()
    }
    
    func toggleErrorMsg(msg: String?) {
        resetPinError.isHidden.toggle()
        if !resetPinError.isHidden {
            resetPinError.text = msg
        }
    }
}

extension ResetPINViewController: PINBaseController {
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
}

// MARK: - ResetPINViewController Instantiations
extension ResetPINViewController: ResetPINViewComponent {
    func setupUI() {
        // Implement the Custom Back Button instead of default in Nav Controller
        self.navigationItem.hidesBackButton = true
        
        let crossButton = UIBarButtonItem(title: "\u{2190}", style: UIBarButtonItem.Style.plain, target: self, action: #selector(promptClose(sender:)))
        crossButton.tintColor = UIColor.black
        self.navigationItem.leftBarButtonItem = crossButton
        
        // Remove default Nav controller styling
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
        
        resetPinError.isHidden = true
        
        resetCodeTextField.configure()
    }
    
    @objc private func promptClose(sender: UIBarButtonItem) {
        // Go back to previous screen
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupDelegates() {
        self.keyboardView.delegate = self
    }
    
    func render(_ props: ResetPINViewProps) {
        navigationItem.title = props.navTitle
        resetPinTitle.text = props.title
        resetPinError.textColor = props.dangerColor
        
        let subtitle: String = {
            if let userInfo = Config.instance.userInfo {
                let maskedSendingDestination = userInfo.sendingDestination.maskContactInfo(method: userInfo.sendingMethod)
                return "\(props.resetOpeningSub) \(maskedSendingDestination)"
            }
            return props.resetFailSub
        }()
        resetPinSubtitle.text = subtitle
        
        if let _ = Config.instance.userInfo {
            resendEmailButton.setTitle(props.resendEmail, for: .normal)
            resendEmailButton.setTitleColor(props.primaryColor, for: .normal)
        } else {
            resendEmailButton.isEnabled = false
        }
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
