//
//  PINConfirmViewController.swift
//  CotterIOS
//
//  Created by Albert Purnama on 2/2/20.
//

import UIKit

// MARK: - Keys for Strings
public class PINConfirmViewControllerKey {
    public static let navTitle = "PINConfirmViewController/navTitle"
    public static let showPin = "PINConfirmViewController/showPin"
    public static let hidePin = "PINConfirmViewController/hidePin"
    public static let title = "PINConfirmViewController/title"
}

// MARK: - Presenter Protocol delegated UI-related logic
protocol PINConfirmViewPresenter {
    func onViewLoaded()
}

// MARK: - Properties of PINConfirmViewController
struct PINConfirmViewProps {
    let navTitle: String
    let showPinText: String
    let hidePinText: String
    let title: String
    
    let primaryColor: UIColor
    let accentColor: UIColor
    let dangerColor: UIColor
}

// MARK: - Components of PINConfirmViewController
protocol PINConfirmViewComponent: AnyObject {
    func setupUI()
    func setupDelegates()
    func render(_ props: PINConfirmViewProps)
}

// MARK: - PINConfirmViewPresenter Implementation
class PINConfirmViewPresenterImpl: PINConfirmViewPresenter {
    
    typealias VCTextKey = PINConfirmViewControllerKey
    
    weak var viewController: PINConfirmViewComponent!
    
    let props: PINConfirmViewProps = {
        // MARK: - VC Text Definitions
        let navTitle = CotterStrings.instance.getText(for: VCTextKey.navTitle)
        let showPinText = CotterStrings.instance.getText(for: VCTextKey.showPin)
        let hidePinText = CotterStrings.instance.getText(for: VCTextKey.hidePin)
        let title = CotterStrings.instance.getText(for: VCTextKey.title)
        
        // MARK: - VC Color Definitions
        let primaryColor = Config.instance.colors.primary
        let accentColor = Config.instance.colors.accent
        let dangerColor = Config.instance.colors.danger
        
        return PINConfirmViewProps(navTitle: navTitle, showPinText: showPinText, hidePinText: hidePinText, title: title, primaryColor: primaryColor, accentColor: accentColor, dangerColor: dangerColor)
    }()
    
    init(_ viewController: PINConfirmViewController) {
        self.viewController = viewController
    }
    
    func onViewLoaded() {
        viewController.setupUI()
        viewController.setupDelegates()
        viewController.render(props)
    }
}

class PINConfirmViewController : UIViewController {
    // prevCode should be passed from the previous (PINView) controller
    var prevCode: String?
    
    // Code Text Field
    @IBOutlet weak var codeTextField: OneTimeCodeTextField!
    
    @IBOutlet weak var pinVisibilityButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var keyboardView: KeyboardView!
    
    lazy var presenter: PINConfirmViewPresenter = PINConfirmViewPresenterImpl(self)
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        // Set-up
        presenter.onViewLoaded()
        instantiateCodeTextFieldFunctions()
    }
    
    func setError(msg: String?) {
        errorLabel.isHidden = msg == nil
        errorLabel.text = msg ?? ""
    }
}

// MARK: - PINBaseController
extension PINConfirmViewController : PINBaseController {
    func generateErrorMessageFrom(error: CotterError) -> String {
        let strings = CotterStrings.instance
        switch(error) {
        case CotterError.status(code: 500):
            return strings.getText(for: PinErrorMessagesKey.serverError)
        case CotterError.network:
            return strings.getText(for: PinErrorMessagesKey.networkError)
        default:
            return strings.getText(for: PinErrorMessagesKey.enrollPinFailed)
        }
    }
    
    func instantiateCodeTextFieldFunctions() {
        codeTextField.removeErrorMsg = {
            self.setError(msg: nil)
        }
        
        codeTextField.didEnterLastDigit = { code in
            // If the entered digits are not the same, show error.
            if code != self.prevCode! {
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
            
            // define callback
            func enrollCb(response: CotterResult<CotterUser>) {
                LoadingScreen.shared.stop()
                switch response {
                case .success:
                    self.codeTextField.clear()
                    let finalVC = self.storyboard?.instantiateViewController(withIdentifier: "PINFinalViewController")as! PINFinalViewController
                    finalVC.isEnroll = true
                    let nav = CotterNavigationViewController(
                        rootViewController: finalVC)
                    self.present(nav, animated: true, completion: nil)
                case .failure(let err):
                    self.setError(msg: self.generateErrorMessageFrom(error: err))
                }
            }
            
            
            LoadingScreen.shared.start(at: self.view.window)
            // Run API to enroll PIN
            CotterAPIService.shared.enrollUserPin(
                code: code,
                cb: enrollCb
            )
            
            return true
        }
    }
}

// MARK: - PINConfirmViewComponent Render
extension PINConfirmViewController: PINConfirmViewComponent {
    func setupUI() {
        errorLabel.isHidden = true
        
        codeTextField.configure()
    }
    
    @objc private func navigateBack(sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupDelegates() {
        self.keyboardView.delegate = self
    }
    
    func render(_ props: PINConfirmViewProps) {
        setupLeftTitleBar(with: props.navTitle)
        titleLabel.text = props.title
        titleLabel.font = Config.instance.fonts.title
        errorLabel.textColor = props.dangerColor
        errorLabel.font = Config.instance.fonts.paragraph
    }
}

// MARK: - KeyboardViewDelegate
extension PINConfirmViewController : KeyboardViewDelegate {
    func keyboardButtonTapped(buttonNumber: NSInteger) {
        // If backspace tapped, remove last char. Else, append new char.
        if buttonNumber == -1 {
            codeTextField.removeNumber()
        } else {
            codeTextField.appendNumber(buttonNumber: buttonNumber)
        }
    }
}
