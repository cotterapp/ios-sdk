//
//  UpdateCreateNewPINViewController.swift
//  CotterIOS
//
//  Created by Raymond Andrie on 2/8/20.
//

import UIKit

// MARK: - Keys for Strings
public class UpdateCreateNewPINViewControllerKey {
    public static let navTitle = "UpdateCreateNewPINViewController/navTitle"
    public static let title = "UpdateCreateNewPINViewController/title"
    public static let showPin = "UpdateCreateNewPINViewController/showPin"
    public static let hidePin = "UpdateCreateNewPINViewController/hidePin"
}

// MARK: - Presenter Protocol delegated UI-related logic
protocol UpdateCreateNewPINViewPresenter {
    func onViewLoaded()
}

// MARK: - Properties of UpdateCreateNewPINViewController
struct UpdateCreateNewPINViewProps {
    let navTitle: String
    let title: String
    let showPinText: String
    let hidePinText: String
    
    let primaryColor: UIColor
    let accentColor: UIColor
    let dangerColor: UIColor
}

// MARK: - Components of UpdateCreateNewPINViewController
protocol UpdateCreateNewPINViewComponent: AnyObject {
    func setupUI()
    func setupDelegates()
    func render(_ props: UpdateCreateNewPINViewProps)
}

// MARK: - UpdateCreateNewPINViewPresenter Implementation
class UpdateCreateNewPINViewPresenterImpl: UpdateCreateNewPINViewPresenter {
    
    typealias VCTextKey = UpdateCreateNewPINViewControllerKey
    
    weak var viewController: UpdateCreateNewPINViewComponent!
    
    let props: UpdateCreateNewPINViewProps = {
        // MARK: - VC Text Definitions
        let navTitle = CotterStrings.instance.getText(for: VCTextKey.navTitle)
        let titleText = CotterStrings.instance.getText(for: VCTextKey.title)
        let showPinText = CotterStrings.instance.getText(for: VCTextKey.showPin)
        let hidePinText = CotterStrings.instance.getText(for: VCTextKey.hidePin)
        
        // MARK: - VC Color Definitions
        let primaryColor = Config.instance.colors.primary
        let accentColor = Config.instance.colors.accent
        let dangerColor = Config.instance.colors.danger
        
        return UpdateCreateNewPINViewProps(navTitle: navTitle, title: titleText, showPinText: showPinText, hidePinText: hidePinText, primaryColor: primaryColor, accentColor: accentColor, dangerColor: dangerColor)
    }()
    
    init(_ viewController: UpdateCreateNewPINViewComponent) {
        self.viewController = viewController
    }
    
    func onViewLoaded() {
        viewController.setupUI()
        viewController.setupDelegates()
        viewController.render(props)
    }
}

class UpdateCreateNewPINViewController: UIViewController {
    // Pass oldCode here by UpdateCreateNewPINViewController.oldCode = code
    var oldCode: String?
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var codeTextField: OneTimeCodeTextField!
    
    @IBOutlet weak var keyboardView: KeyboardView!

    lazy var presenter: UpdateCreateNewPINViewPresenter = UpdateCreateNewPINViewPresenterImpl(self)
    
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
extension UpdateCreateNewPINViewController : PINBaseController {
    func generateErrorMessageFrom(error: CotterError) -> String {
        return ""
    }
    
    func instantiateCodeTextFieldFunctions() {
        codeTextField.removeErrorMsg = {
            self.setError(msg: nil)
        }
        
        codeTextField.didEnterLastDigit = { code in
            // If code has repeating digits, or is a straight number, or is the old code, show error.
            let pattern = "\\b(\\d)\\1+\\b"
            let result = code.range(of: pattern, options: .regularExpression)
            
            // Ensure consecutive PIN number is rejected
            if result != nil || self.findSequence(sequenceLength: code.count, in: code) {
                self.setError(msg: CotterStrings.instance.getText(for: PinErrorMessagesKey.badPin))
                return false
            }
            
            // if new code is similar as previous code
            if code == self.oldCode {
                self.setError(msg: CotterStrings.instance.getText(for: PinErrorMessagesKey.similarPinAsBefore))
                return false
            }
            
            self.codeTextField.clear()
            
            // Go to Confirm New Pin Page
            let updateConfirmPINVC = self.storyboard?.instantiateViewController(withIdentifier: "UpdateConfirmNewPINViewController")as! UpdateConfirmNewPINViewController
            updateConfirmPINVC.prevCode = code
            updateConfirmPINVC.oldCode = self.oldCode!
            self.navigationController?.pushViewController(updateConfirmPINVC, animated: true)
            return true
        }
    }
}

// MARK: - UpdateCreateNewPINViewComponent Instantiations
extension UpdateCreateNewPINViewController: UpdateCreateNewPINViewComponent {
    func setupUI() {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
//        self.navigationItem.hidesBackButton = true
//        let backButton = UIBarButtonItem(title: "\u{2190}", style: UIBarButtonItem.Style.plain, target: self, action: #selector(UpdateCreateNewPINViewController.promptBack(sender:)))
//        backButton.tintColor = UIColor.black
//        self.navigationItem.leftBarButtonItems = [backButton]
        
        errorLabel.isHidden = true
        
        codeTextField.configure()
    }
    
    @objc private func promptBack(sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupDelegates() {
        self.keyboardView.delegate = self
    }
    
    func render(_ props: UpdateCreateNewPINViewProps) {
        setupLeftTitleBar(with: props.navTitle)
        titleLabel.text = props.title
        titleLabel.font = Config.instance.fonts.title
        titleLabel.textColor = Config.instance.colors.accent
        errorLabel.textColor = props.dangerColor
        errorLabel.font = Config.instance.fonts.paragraph
    }
}

// MARK: - KeyboardViewDelegate
extension UpdateCreateNewPINViewController : KeyboardViewDelegate {
    func keyboardButtonTapped(buttonNumber: NSInteger) {
        if buttonNumber == -1 {
            codeTextField.removeNumber()
        } else {
            codeTextField.appendNumber(buttonNumber: buttonNumber)
        }
    }
}
