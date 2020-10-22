//
//  UpdateConfirmNewPINViewController.swift
//  CotterIOS
//
//  Created by Raymond Andrie on 2/8/20.
//

import UIKit
import os.log

// MARK: - Keys for Strings
public class UpdateConfirmNewPINViewControllerKey {
    public static let navTitle = "UpdateConfirmNewPINViewController/navTitle"
    public static let title = "UpdateConfirmNewPINViewController/title"
    public static let showPin = "UpdateConfirmNewPINViewController/showPin"
    public static let hidePin = "UpdateConfirmNewPINViewController/hidePin"
}

// MARK: - Presenter Protocol delegated UI-related logic
protocol UpdateConfirmNewPINViewPresenter {
    func onViewLoaded()
}

// MARK: - Properties of UpdateConfirmNewPINViewController
struct UpdateConfirmNewPINViewProps {
    let navTitle: String
    let title: String
    let showPinText: String
    let hidePinText: String
    
    let primaryColor: UIColor
    let accentColor: UIColor
    let dangerColor: UIColor
}

// MARK: - Components of UpdateConfirmNewPINViewController
protocol UpdateConfirmNewPINViewComponent: AnyObject {
    func setupUI()
    func setupDelegates()
    func render(_ props: UpdateConfirmNewPINViewProps)
}

// MARK: - UpdateConfirmNewPINViewPresenter Implementation
class UpdateConfirmNewPINViewPresenterImpl: UpdateConfirmNewPINViewPresenter {
    
    typealias VCTextKey = UpdateConfirmNewPINViewControllerKey
    
    weak var viewController: UpdateConfirmNewPINViewComponent!
    
    let props: UpdateConfirmNewPINViewProps = {
        // MARK: - VC Text Definitions
        let navTitle = CotterStrings.instance.getText(for: VCTextKey.navTitle)
        let titleText = CotterStrings.instance.getText(for: VCTextKey.title)
        let showPinText = CotterStrings.instance.getText(for: VCTextKey.showPin)
        let hidePinText = CotterStrings.instance.getText(for: VCTextKey.hidePin)
        
        // MARK: - VC Color Definitions
        let primaryColor = Config.instance.colors.primary
        let accentColor = Config.instance.colors.accent
        let dangerColor = Config.instance.colors.danger
        
        return UpdateConfirmNewPINViewProps(navTitle: navTitle, title: titleText, showPinText: showPinText, hidePinText: hidePinText, primaryColor: primaryColor, accentColor: accentColor, dangerColor: dangerColor)
    }()
    
    init(_ viewController: UpdateConfirmNewPINViewComponent) {
        self.viewController = viewController
    }
    
    func onViewLoaded() {
        viewController.setupUI()
        viewController.setupDelegates()
        viewController.render(props)
    }
}

class UpdateConfirmNewPINViewController: UIViewController {
    // Pass oldCode here
    public var oldCode: String?
    
    // Pass prevCode here by UpdateConfirmNewPINViewController.prevCode = code
    public var prevCode: String?
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var codeTextField: OneTimeCodeTextField!
    
    @IBOutlet weak var keyboardView: KeyboardView!

    lazy var presenter: UpdateConfirmNewPINViewPresenter = UpdateConfirmNewPINViewPresenterImpl(self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set-up
        presenter.onViewLoaded()
        instantiateCodeTextFieldFunctions()
    }
    
    func setError(msg: String?) {
        errorLabel.isHidden = msg == nil
        errorLabel.text = msg
    }
    
}

// MARK: - PINBaseController
extension UpdateConfirmNewPINViewController : PINBaseController {
    func generateErrorMessageFrom(error: CotterError) -> String {
        let strings = CotterStrings.instance
        switch(error) {
        case CotterError.network:
            return strings.getText(for: PinErrorMessagesKey.networkError)
        case CotterError.status(code: 500):
            return strings.getText(for: PinErrorMessagesKey.serverError)
        default:
            return strings.getText(for: PinErrorMessagesKey.updatePinFailed)
        }
    }
    
    func instantiateCodeTextFieldFunctions() {
        codeTextField.removeErrorMsg = {
            self.setError(msg: nil)
        }
        
        codeTextField.didEnterLastDigit = { code in
            if self.prevCode == nil {
                os_log("%{public}@ previous PIN code does not exist",
                       log: Config.instance.log, type: .fault, #function)
                return false
            }
            
            // If code is not the same as previous code, show error.
            if code != self.prevCode {
                self.setError(msg: CotterStrings.instance.getText(for: PinErrorMessagesKey.incorrectPinConfirmation))
                return false
            }
            
            // If code has repeating digits or is a straight number, show error.
            let pattern = "\\b(\\d)\\1+\\b"
            let result = code.range(of: pattern, options: .regularExpression)
            if result != nil || self.findSequence(sequenceLength: code.count, in: code) {
                self.setError(msg: CotterStrings.instance.getText(for: PinErrorMessagesKey.badPin))
                return false
            }
            
            // Define the callback
            func updateCb(response: CotterResult<CotterUser>) {
                LoadingScreen.shared.stop()
                switch response {
                case .success:
                    self.codeTextField.clear()
                    // Go to PIN Final View
                    let pinFinalVC = Cotter.cotterStoryboard.instantiateViewController(withIdentifier: "PINFinalViewController")as! PINFinalViewController
                    pinFinalVC.requireAuth = false
                    pinFinalVC.isEnroll = false
                    let nav = CotterNavigationViewController(
                        rootViewController: pinFinalVC)
                    nav.modalPresentationStyle = .fullScreen
                    self.present(nav, animated: true, completion: nil)
                case .failure(let err):
                    self.setError(msg: self.generateErrorMessageFrom(error: err))
                }
            }
            
            LoadingScreen.shared.start(at: self.view.window)
            // Run API to update PIN
            CotterAPIService.shared.updateUserPin(
                oldCode: self.oldCode!,
                newCode: code,
                cb: updateCb
            )
            
            return true
        }
    }
    
}

// MARK: - UpdateConfirmNewPINViewComponent Instantiations
extension UpdateConfirmNewPINViewController: UpdateConfirmNewPINViewComponent {
    func setupUI() {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        errorLabel.isHidden = true
        
        codeTextField.configure()
    }
    
    @objc private func promptBack(sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupDelegates() {
        self.keyboardView.delegate = self
    }
    
    func render(_ props: UpdateConfirmNewPINViewProps) {
        setupLeftTitleBar(with: props.navTitle)
        titleLabel.text = props.title
        titleLabel.font = Config.instance.fonts.title
        titleLabel.textColor = Config.instance.colors.accent
        errorLabel.textColor = props.dangerColor
        errorLabel.font = Config.instance.fonts.paragraph
    }
}

// MARK: - KeyboardViewDelegate
extension UpdateConfirmNewPINViewController : KeyboardViewDelegate {
    func keyboardButtonTapped(buttonNumber: NSInteger) {
        if buttonNumber == -1 {
            codeTextField.removeNumber()
        } else {
            codeTextField.appendNumber(buttonNumber: buttonNumber)
        }
    }
}
