//
//  ViewController.swift
//  CotterIOS
//
//  Created by albertputrapurnama on 02/01/2020.
//  Copyright (c) 2020 albertputrapurnama. All rights reserved.
//

import UIKit
import CotterIOS

class ViewController: UIViewController {
    var cotter: CotterViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // select the dashboard's ViewController
        let sboard = UIStoryboard(name: "Dashboard", bundle: nil)
        let dVC = sboard.instantiateViewController(withIdentifier: "DashboardViewController")as! DashboardViewController
        
        // Do any additional setup after loading the view, typically from a nib.
        self.cotter = CotterViewController.init(
            self.navigationController,
            dVC,
            "",
            "",
            "",
            ""
        )
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func clickCotter(_ sender: Any) {
        self.cotter?.startEnrollment()
    }
}
