//
//  TrustedViewController.swift
//  Cotter
//
//  Created by Albert Purnama on 3/24/20.
//

import UIKit

public class TrustedViewControllerKey {
    // MARK: - Keys for Strings
    public static let title = "TrustedViewController/title"
    public static let subtitle = "TrustedViewController/subtitle"
    public static let buttonNo = "TrustedViewController/buttonNo"
    public static let buttonYes = "TrustedViewController/buttonYes"
}

class TrustedViewController: UIViewController {

    typealias VCTextKey = TrustedViewControllerKey
    
    // MARK: - VC Text Definitions
    let trustedTitle = CotterStrings.instance.getText(for: VCTextKey.title)
    let trustedSubtitle = CotterStrings.instance.getText(for: VCTextKey.subtitle)
    let buttonNo = CotterStrings.instance.getText(for: VCTextKey.buttonNo)
    let buttonYes = CotterStrings.instance.getText(for: VCTextKey.buttonYes)
    
    // MARK: - VC Image Definitions
    let logoImage = CotterImages.instance.getImage(for: VCImageKey.logo)
    
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var crossButton: UIButton!
    @IBOutlet weak var noButton: BasicButton!
    @IBOutlet weak var yesButton: BasicButton!
    
    var event: CotterEvent?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        self.noButton.setTitleColor(UIColor.init(red: 218, green:50, blue:93, alpha:1.0), for: .normal)
//        self.yesButton.setTitleColor(UIColor.init(red:94, green:206, blue:153, alpha:1.0), for: .normal)
//
//        self.errorLabel.textColor = UIColor.init(red: 218, green:50, blue:93, alpha:1.0)
        configureTexts()
        configureColors()
    }
    
    private func configureTexts() {
        titleLabel.text = trustedTitle
        subtitleLabel.text = trustedSubtitle
        noButton.setTitle(buttonNo, for: .normal)
        yesButton.setTitle(buttonYes, for: .normal)
    }
    
    private func configureColors() {
        noButton.setTitleColor(Config.instance.colors.danger, for: .normal)
        yesButton.setTitleColor(Config.instance.colors.primary, for: .normal)
        errorLabel.textColor = Config.instance.colors.danger
    }
    
    private func configureImage() {
        let cotterImages = ImageObject.defaultImages
        
        guard !cotterImages.contains(logoImage) else {
            print("Using Default Image...")
            logo.image = UIImage(named: logoImage, in: Cotter.resourceBundle, compatibleWith: nil)
            return
        }
        
        logo.image = UIImage(named: logoImage, in: Bundle.main, compatibleWith: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.errorLabel.text = ""
    }

    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func noAction(_ sender: Any) {
        self.close(sender)
    }
    
    @IBAction func yesAction(_ sender: Any) {
        // approve the authentication
        // String[] list = {Cotter.getUser(Cotter.authRequest).client_user_id, Cotter.ApiKeyID, event, timestamp, method,
        // approved + ""};
        guard let event = self.event else { return }
        
        func trustedCb(resp: CotterResult<CotterEvent>) {
            switch resp {
            case .success(let evt):
                if !evt.approved {
                    self.errorLabel.text = "Sign in still not approved, device key is most likely invalid"
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                        // dismiss 3 seconds later
                        self.dismiss(animated: true, completion: nil)
                    }
                    return
                }
                self.dismiss(animated: true, completion: nil)
                
            case .failure(let err):
                self.errorLabel.text = "Error approving sign in request: \(err.localizedDescription)"
            }
        }
        
        CotterAPIService.shared.approveEvent(event: event, cb: trustedCb)
    }
    
    
}
