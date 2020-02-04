//
//  File.swift
//  CotterIOS_Example
//
//  Created by Albert Purnama on 2/2/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import UIKit


class DashboardViewController: UIViewController {
    var accessToken:String?
    
    @IBOutlet weak var accessTokenLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        accessTokenLabel.text = accessToken!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
