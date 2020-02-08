//
//  CryptoViewController.swift
//  CotterIOS_Example
//
//  Created by Albert Purnama on 2/6/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import Security
import LocalAuthentication

class CryptoViewController: UIViewController {
    public override func viewDidLoad() {
        super.viewDidLoad()
        print("loaded CryptoViewController")
    }
    
    // clearKeys to clear Cotter Keys
    @IBAction func clearKeys(_ sender: Any) {
        let tag = "org.cocoapods.CotterIOS.privKey".data(using: .utf8)!
        
        // remove the previous key pair
        // Retrieving private and public key pair
        let query: [String: Any] = [
            kSecClass as String: kSecClassKey,
            kSecAttrApplicationTag as String: tag,
            kSecAttrKeyType as String: kSecAttrKeyTypeECSECPrimeRandom,
        ]
        let st = SecItemDelete(query as CFDictionary)
        guard st == errSecSuccess || st == errSecItemNotFound else {
            print("error deleting old key")
            return
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var privateKeyLabel: UILabel!
    
    @IBAction func generateKeyPair(_ sender: Any) {
        // source:
        // https://developer.apple.com/documentation/security/certificate_key_and_trust_services/keys/generating_new_cryptographic_keys
        let tag = "com.example.keys.mykey".data(using: .utf8)!
        
        // remove the previous key pair
        // Retrieving private and public key pair
        let query: [String: Any] = [
            kSecClass as String: kSecClassKey,
            kSecAttrApplicationTag as String: tag,
            kSecAttrKeyType as String: kSecAttrKeyTypeECSECPrimeRandom,
        ]
        let st = SecItemDelete(query as CFDictionary)
        guard st == errSecSuccess || st == errSecItemNotFound else {
            print("error deleting old key")
            return
        }
        
        // setting the access control
        // restrict to user presence on any biometric set and when the device is unlocked
        var error: Unmanaged<CFError>?
        guard let access = SecAccessControlCreateWithFlags(
            nil,  // Use the default allocator.
            kSecAttrAccessibleAfterFirstUnlock,
            .userPresence,
            &error
            ) else {
                print("error creating access control")
                return
        }
        
        let attributes: [String: Any] = [
            kSecAttrKeyType as String:            kSecAttrKeyTypeECSECPrimeRandom, // ECDSA
            kSecAttrKeySizeInBits as String:      256,
            kSecAttrCanSign as String:             true,
            kSecPrivateKeyAttrs as String: [
                kSecAttrIsPermanent as String: true,
                kSecAttrApplicationTag as String: tag,
                kSecAttrAccessControl as String:    access,
            ]
        ]

        guard let privateKey = SecKeyCreateRandomKey(attributes as CFDictionary, &error) else {
//            throw error!.takeRetainedValue() as Error
            print(error!.takeRetainedValue().localizedDescription)
            return
        }
        
        let publicKey = SecKeyCopyPublicKey(privateKey)
        if let cfdata = SecKeyCopyExternalRepresentation(publicKey!, &error) {
            let data:Data = cfdata as Data
            let b64Key = data.base64EncodedString()
            print(b64Key)
        }
        
        // source:
        // https://developer.apple.com/documentation/security/certificate_key_and_trust_services/keys/storing_keys_in_the_keychain

        let context = LAContext()
        context.localizedReason = "Bareksa wants to authenticate you"
        context.localizedCancelTitle = "Bye!"
        
        // Retrieving private and public key pair
        let getquery: [String: Any] = [
            kSecClass as String: kSecClassKey,
            kSecAttrApplicationTag as String: tag,
            kSecAttrKeyType as String: kSecAttrKeyTypeECSECPrimeRandom,
            kSecUseAuthenticationContext as String: context, // this does not work on Face ID
            kSecUseOperationPrompt as String: "Hello world!", // this does not work on Face ID
            kSecReturnRef as String: true
        ]

        var item: CFTypeRef?
        let status = SecItemCopyMatching(getquery as CFDictionary, &item)
        guard status == errSecSuccess else {
            print("fail retrieving the data")
            return
        }
        let key = item as! SecKey

        if let cfdata = SecKeyCopyExternalRepresentation(key, &error) {
            let data:Data = cfdata as Data
            let b64Key = data.base64EncodedString()
            self.privateKeyLabel.text = b64Key
            self.privateKeyLabel.textColor = UIColor.black
            print("private key")
            print(b64Key)
        }
    }
}
