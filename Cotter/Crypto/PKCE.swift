//
//  PKCE.swift
//  Cotter
//
//  Created by Albert Purnama on 2/24/20.
//

import Foundation
import CommonCrypto

class PKCE {
    // createVerifier
    static func createVerifier() -> String {
        var buffer = [UInt8](repeating: 0, count: 32)
        _ = SecRandomCopyBytes(kSecRandomDefault, buffer.count, &buffer)

        let verifier = Data(buffer).base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "=", with: "")
            .replacingOccurrences(of: "/", with: "_")
            .trimmingCharacters(in: .whitespaces)

        return verifier
    }
    
    // createCodeChallenge takes in the code verifier and returns the code challenge
    static func createCodeChallenge(verifier: String) -> String? {
        guard let data = verifier.data(using: .utf8) else { return nil }
        var buffer = [UInt8](repeating: 0,  count: Int(CC_SHA256_DIGEST_LENGTH))
        
        data.withUnsafeBytes({ ptr in
            _ = CC_SHA256(ptr.baseAddress, CC_LONG(data.count), &buffer)
        })
        
        let hash = Data(buffer)
        let challenge = hash.base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
            .trimmingCharacters(in: .whitespaces)

        return challenge
    }
}
