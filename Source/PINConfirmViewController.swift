//
//  PINConfirmViewController.swift
//  CotterIOS
//
//  Created by Albert Purnama on 2/2/20.
//

import UIKit

class PINConfirmViewController:UIViewController {
    // config and prevCode should be passed from the previous (PINView) controller
    var config: Config?
    var prevCode: String?
    
    let closeTitle = "Yakin tidak Mau Buat PIN Sekarang?"
    let closeMessage = "Yakin tidak Mau Buat PIN Sekarang?"
    let stayText = "Input PIN"
    let leaveText = "Lain Kali"
    
    // Code Text Field
    @IBOutlet weak var codeTextField: OneTimeCodeTextField!
    
    // PIN Visibility Toggle Button
    @IBOutlet weak var pinVisibilityButton: UIButton!
    let showPinText = "Lihat PIN"
    let hidePinText = "Sembunyikan"
    
    // Error Label
    @IBOutlet weak var errorLabel: UILabel!
    var showErrorMsg = false
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("loaded PIN Confirmation View")
        
        // Implement Custom Back Button instead of default in Nav controller
        self.navigationItem.hidesBackButton = true
        let backButton = UIBarButtonItem(title: "\u{003C}", style: UIBarButtonItem.Style.plain, target: self, action: #selector(PINConfirmViewController.promptClose(sender:)))
        backButton.tintColor = UIColor.black
        self.navigationItem.leftBarButtonItem = backButton
        
        // Remove default Nav controller styling
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
        
        // Configure PIN Visibility Button
        configurePinVisButton()
        
        // Add Password Code Text Field
        codeTextField.configure()
        
        // Configure Error Msg Label
        configureErrorMsg()
        
        // Instantiate Function to run when user enters wrong PIN code
        codeTextField.removeErrorMsg = {
            // Remove error msg if it is present
            if self.showErrorMsg {
                self.toggleErrorMsg()
            }
        }
        
        // Instantiate Function to run when PIN is fully entered
        codeTextField.didEnterLastDigit = { code in
            print("PIN Code Entered: ", code)
            // If code is straight numbers e.g. 123456, show error.
            if code == "123456" || code == "654321" {
                self.toggleErrorMsg()
                return
            }
            
            // If the entered digits are not the same, show error.
            if code != self.prevCode! {
                self.toggleErrorMsg()
                return
            }
            
            // Run API to enroll PIN
            
            // source of the following request
            // source: https://stackoverflow.com/a/26365148
            
            // set the URL path
            let urlString = CotterAPIService.shared.getURL()!.absoluteString + "/api/v0/user/" + CotterAPIService.shared.getUserID()!
            print(urlString)
            let url = URL(string: urlString)!
            let apiKeyID = CotterAPIService.shared.getKeyID()
            let apiSecretKey = CotterAPIService.shared.getSecretKey()
            
            var request = URLRequest(url:url)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue(apiSecretKey, forHTTPHeaderField: "API_SECRET_KEY")
            request.setValue(apiKeyID, forHTTPHeaderField: "API_KEY_ID")
            request.httpMethod = "PUT"
            let parameters: [String: Any] = [
                "method": "PIN",
                "enrolled": true,
                "code": code
            ]
            request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
            
            let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
                guard let data = data,
                    let response = response as? HTTPURLResponse,
                    error == nil else { // check for fundamental networking error
                    // TODO: error handling
                    print("error", error ?? "Unknown error")
                    return
                }
                
                guard (200 ... 299) ~= response.statusCode else {   // check for http errors
                    print("statusCode should be 2xx, but is \(response.statusCode)")
                    print("response = \(response)")
                    return
                }
                
                let responseString = String(data: data, encoding: .utf8)
                print("responseString = \(String(describing: responseString))")
                
                // if it reaches this point, that means the enrollment is successful
                // go to success page
                DispatchQueue.main.async{
                    let finalVC = self.storyboard?.instantiateViewController(withIdentifier: "PINFinalViewController")as! PINFinalViewController
                    finalVC.config = self.config
                    self.navigationController?.pushViewController(finalVC, animated: true)
                }
            }
            task.resume()
        }
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Open Keypad on View Appearance
        codeTextField.becomeFirstResponder()
    }
    
    private func configurePinVisButton() {
        pinVisibilityButton.setTitleColor(UIColor(red: 0.0196, green: 0.4275, blue: 0, alpha: 1.0), for: .normal)
        pinVisibilityButton.setTitle(showPinText, for: .normal)
        pinVisibilityButton.isHidden = false
    }
    
    private func configureErrorMsg() {
        errorLabel.isHidden = true
        errorLabel.textColor = UIColor(red: 0.8392, green: 0, blue: 0, alpha: 1.0)
    }
    
    private func toggleErrorMsg() {
        showErrorMsg.toggle()
        errorLabel.isHidden.toggle()
        pinVisibilityButton.isHidden.toggle()
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
        // Perform Prompt Alert
        self.navigationController?.popViewController(animated: true)
    }

    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


// the following extensions is copied from
// https://stackoverflow.com/questions/26364914/http-request-in-swift-with-post-method
extension Dictionary {
    func percentEncoded() -> Data? {
        return map { key, value in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
        .joined(separator: "&")
        .data(using: .utf8)
    }
}

extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="

        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}
