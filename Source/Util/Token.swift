//
//  Token.swift
//  Cotter
//
//  Created by Albert Purnama on 7/10/20.
//

import Foundation

func setCotterDefaultToken(token: CotterOAuthToken?) {
    guard let token = token else { return }
    let sess = UserDefaults.standard
    
    sess.set(try? PropertyListEncoder().encode(token), forKey: CotterTokens.defaultToken)
}

func getCotterDefaultToken() -> CotterOAuthToken? {
    let sess = UserDefaults.standard
    if let data = sess.value(forKey: CotterTokens.defaultToken) as? Data {
        let token = try? PropertyListDecoder().decode(CotterOAuthToken.self, from: data)
        return token!
    }
    return nil
}

func deleteCotterDefaultToken() {
    let sess = UserDefaults.standard
        
    sess.set(nil, forKey: CotterTokens.defaultToken)
}
