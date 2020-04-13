//
//  EntryViewController.swift
//  CotterIOS_Example
//
//  Created by Albert Purnama on 3/26/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import Cotter

class EntryViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var loginButton: BasicButton!
    @IBOutlet weak var enrollTrustedForUserButton: BasicButton!
    
    var userID:String {
        set {
            CotterWrapper.cotter?.userID = newValue
        }
        
        get {
            return CotterWrapper.cotter?.userID ?? ""
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("loaded Entry View Controller!")
        // Do any additional setup after loading the view.
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        self.textField.delegate = self
        // Check if API KEY is passed
        self.infoLabel.text = Environment.shared.COTTER_API_KEY_ID ?? "No Key"
        // to set the apiKeyID and apiSecretKey follow this nice tutorial on how to setup xcode env variables
        // https://nshipster.com/launch-arguments-and-environment-variables/
        guard let apiKeyID = Environment.shared.COTTER_API_KEY_ID else {
            print("Please set COTTER_API_KEY_ID in your XCode environment variables!")
            return
        }
        guard let apiSecretKey = Environment.shared.COTTER_API_SECRET_KEY else {
            print("Please set COTTER_API_SECRET_KEY in your XCode environment variables!")
            return
        }
        
        // set the URL path
        var baseURL = "https://www.cotter.app/api/v0"
        if let devMode = Environment.shared.DEV_MODE {
            switch(devMode){
            case "ios":
                baseURL = "http://192.168.1.9:1234/api/v0"
                break
            case "local":
                baseURL = "http://localhost:1234/api/v0"
                break
            default:
                break
            }
        }

        // langConfig is an optional language configuration
        let langConfig = Indonesian()
        
        // if you want to set text configuration uncomment the following
        // langConfig.setText(for: PINViewControllerKey.title, to: "Hi! You've changed the text")
        
        // if you want to set image configuration, uncomment the following and put the image in Images.xcassets folder
//        let imageConfig = ImageObject()
//        imageConfig.setImage(for: VCImageKey.pinSuccessImg, to: "telegram")
        
        /*
         Available Color Scheme options:
            1. primary (type: UIColor?/Int?/String?) - default: #21CE99
            2. accent (type: UIColor?/Int?/String?) - default: #21CE99
            3. danger (type: UIColor?/Int?/String?) - default: #D92C59
         let colorScheme = ColorSchemeObject(primary: primary, accent: accent, danger: danger)
            OR
         colorScheme.primary = UIColor.color
         colorScheme.accent = UIColor(rgb: String/Int)
        */
        
        // Uncomment the following to set the colors to something different
        // let colorScheme = ColorSchemeObject(primary: "#355C7D", accent: "#6C5B7B", danger: "#F67280")
        
        /* User Info Configuration: To enable Reset PIN Process in Transaction Flow, required to pass in name, sending method, etc. for Reset PIN Process */
        let userName = "Albert"
        let sendingMethod = "EMAIL" // or PHONE
        let sendingDestination = "something@gmail.com" // Set user email here
        
        // Load Cotter View Controller from SDK
        CotterWrapper.cotter = Cotter(
            apiSecretKey: apiSecretKey,
            apiKeyID: apiKeyID,
            cotterURL: baseURL,
            userID: "",
            // configuration is an optional argument, remove this below and Cotter app will still function properly
            configuration: [
                "language": langConfig,   // default value is Indonesian()
                "name": userName,
                "sendingMethod": sendingMethod, // or PHONE
                "sendingDestination": sendingDestination,
                // "colors": colorScheme
            ]
        )
        
        // you can also set texts after initialization
        // CotterWrapper.cotter?.setText(key: PINViewController.title, value: "Hello World!")
        
        // set the base URL for PLBaseURL FOR DEVELOPMENT ONLY!
        Cotter.PLBaseURL = "http://localhost:3000/app"
    }
    
    @IBAction func login(_ sender: Any) {
        guard let userID = self.textField.text else { return }
        
        self.userID = userID
        
        CotterWrapper.cotter?.loginWithTrustedDevice(vc: self, cb: { (token: String, err:Error?) in
            if err != nil {
                print("error \(String(describing: err?.localizedDescription))")
                return
            }
            self.performSegue(withIdentifier: "segueToHome", sender: self)
        })
    }
    
    @IBAction func enrollTrustedDeviceForUser(_ sender: Any) {
        guard let userID = self.textField.text else { return }
        
        self.userID = userID
        
        CotterAPIService.shared.enrollTrustedDevice(userID: self.userID, cb: { response in
            switch response {
            case .success(let user):
                print("[enrollTrustedDevice] successfully registered existing user \(user.clientUserID): \(user.enrolled)")
                self.infoLabel.text = "Successfully enrolled Trusted Device for user \(user.clientUserID)!"
            case .failure(let err):
                // you can put exhaustive error handling here
                print(err.localizedDescription)
            }
        })
    }
    
    @IBAction func quickStart(_ sender: Any) {
        self.userID = randomString(length: 5)

        CotterAPIService.shared.registerUser(userID: userID, cb: { resp in
            switch resp {
            case .success(let usr):
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {

                    CotterAPIService.shared.enrollTrustedDevice(userID: self.userID, cb: { response in
                        switch response{
                        case .success(let user):
                            print("[setupTrustedDevice] successfully registered: \(user.enrolled)")
                            self.performSegue(withIdentifier: "segueToHome", sender: self)
                        case .failure(let err):
                            // you can put exhaustive error handling here
                            print(err.localizedDescription)
                        }
                    })
                }
            case .failure(let err):
                print(err.localizedDescription)
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        switch(identifier) {
        case "segueToHome":
            print("prepare segue for ViewController")
            let vc = segue.destination as! ViewController
            vc.userID = self.userID
        default:
            print("unknown segue identifier: \(identifier)")
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}

extension EntryViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

func randomString(length: Int) -> String {
  let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
  return String((0..<length).map{ _ in letters.randomElement()! })
}
