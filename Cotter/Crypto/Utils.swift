//
//  Utils.swift
//  Cotter
//
//  Created by Raymond Andrie on 2/28/20.
//

import Foundation
import os.log

public class CryptoUtil {
    static let x9_62HeaderECHeader = [UInt8]([
        /* sequence          */ 0x30, 0x59,
        /* |-> sequence      */ 0x30, 0x13,
        /* |---> ecPublicKey */ 0x06, 0x07, 0x2A, 0x86, 0x48, 0xCE, 0x3D, 0x02, 0x01, // http://oid-info.com/get/1.2.840.10045.2.1 (ANSI X9.62 public key type)
        /* |---> prime256v1  */ 0x06, 0x08, 0x2A, 0x86, 0x48, 0xCE, 0x3D, 0x03, 0x01, // http://oid-info.com/get/1.2.840.10045.3.1.7 (ANSI X9.62 named elliptic curve)
        /* |-> bit headers   */ 0x07, 0x03, 0x42, 0x00
        ])
    
    // keyToBase64 returns the key in a base64 format, x.962 DER format
    public static func keyToBase64(pubKey: SecKey) -> String {
        let pKey = SecKeyCopyAttributes(pubKey)!
        let converted = pKey as! [String: Any]
        let data = converted[kSecValueData as String] as! Data
        

        let DER = Data(x9_62HeaderECHeader) + data
        
        // need to add \n at the end for proper PEM encoding
        let pubKeyBase64 = DER.base64EncodedString(options:[[.lineLength64Characters, .endLineWithLineFeed]]) + "\n"
        return pubKeyBase64
    }
    
    // this is encoding used for passing in public key inside path. this is not
    // a true inmplementation of a base64URL.
    public static func keyToBase64URL(pubKey: SecKey) -> String {
        let pubKeyBase64 = keyToBase64(pubKey: pubKey)
        
        let pubKeyBase64URL = Data(pubKeyBase64.utf8).base64EncodedString()
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "=", with: "")
        return pubKeyBase64URL
    }
    
    // signBase64 takes a privKey and signs the message. The signature will be converted to base64Encoding
    public static func signBase64(privKey: SecKey, msg: String) -> String {
        let data = msg.data(using: .utf8)! as CFData

        // set the signature algorithm
        let algorithm: SecKeyAlgorithm = .ecdsaSignatureMessageX962SHA256
        
        var error: Unmanaged<CFError>?
        // create a signature
        guard let signature = SecKeyCreateSignature(
            privKey,
            algorithm,
            data as CFData,
            &error
        ) as Data? else {
            os_log("%{public}@ failed creating signature",
                   log: Config.instance.log, type: .error,
                   #function)
            return ""
        }
        
        let strSignature = signature.base64EncodedString()
        
        return strSignature
    }
}
