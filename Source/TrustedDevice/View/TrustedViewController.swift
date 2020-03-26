//
//  TrustedViewController.swift
//  Cotter
//
//  Created by Albert Purnama on 3/24/20.
//

import UIKit

class TrustedViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var crossButton: UIButton!
    @IBOutlet weak var noButton: BasicButton!
    @IBOutlet weak var yesButton: BasicButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    var event: CotterEvent?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.noButton.setTitleColor(UIColor.init(red: 218, green:50, blue:93, alpha:1.0), for: .normal)
        self.yesButton.setTitleColor(UIColor.init(red:94, green:206, blue:153, alpha:1.0), for: .normal)
        
        self.errorLabel.textColor = UIColor.init(red: 218, green:50, blue:93, alpha:1.0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.errorLabel.text = ""
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
