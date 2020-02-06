//
//  PINBaseController.swift
//  CotterIOS
//
//  Created by Raymond Andrie on 2/5/20.
//

import Foundation

protocol PINBaseController {
    
    var config: Config? { get set }
    var alertService: AlertService { get }
    var showErrorMsg: Bool { get set }
    
    func addConfigs() -> Void
    
    func addDelegates() -> Void
    
    func configurePinVisButton() -> Void
    
    func configureErrorMsg() -> Void
    
    func toggleErrorMsg() -> Void
    
    func instantiateCodeTextFieldFunctions() -> Void

    // Delegate Function for Keyboard View
    func keyboardButtonTapped(buttonNumber: NSInteger) -> Void
}
