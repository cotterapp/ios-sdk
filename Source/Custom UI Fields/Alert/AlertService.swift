//
//  AlertService.swift
//  CotterIOS
//
//  Created by Raymond Andrie on 2/3/20.
//

import Foundation

class AlertService {
    
    func alert(
        title: String,
        body: String,
        actionButtonTitle: String,
        actionHandler: (() -> Void)? = nil,
        cancelButtonTitle: String,
        cancelHandler: (() -> Void)? = nil
    ) -> AlertViewController {
        let storyboard = UIStoryboard(name: "AlertStoryboard", bundle: Bundle(identifier: "org.cocoapods.CotterIOS"))
        let alertVC = storyboard.instantiateViewController(withIdentifier: "AlertVC") as! AlertViewController
        
        alertVC.initialize(
            title: title,
            body: body,
            actionTitle: actionButtonTitle,
            actionHandler: actionHandler,
            cancelTitle: cancelButtonTitle,
            cancelHandler: cancelHandler
        )
        
        return alertVC
    }
}
