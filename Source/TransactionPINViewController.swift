//
//  TransactionPINViewController.swift
//  CotterIOS
//
//  Created by Raymond Andrie on 2/4/20.
//

import UIKit

class TransactionPINViewController: UIViewController {
    // pass config here by TransactionPINViewController.config = Config()
    var config: Config?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("loaded Transaction PIN View!")
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
