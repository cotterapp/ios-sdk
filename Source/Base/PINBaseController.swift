//
//  PINBaseController.swift
//  CotterIOS
//
//  Created by Raymond Andrie on 2/5/20.
//

import Foundation

protocol PINBaseController {
    
    func addConfigs() -> Void
    
    func addDelegates() -> Void
    
    func instantiateCodeTextFieldFunctions() -> Void
    
    func configureErrorMsg() -> Void
    
    func toggleErrorMsg(msg: String?) -> Void
}
