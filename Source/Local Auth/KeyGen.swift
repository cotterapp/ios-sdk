//
//  File.swift
//  CotterIOS
//
//  Created by Albert Purnama on 2/6/20.
//

import Foundation
import Security
import LocalAuthentication

class KeyGen {
    private static let cotterKeyTag = "org.cocoapods.CotterIOS.privKey".data(using: .utf8)!
    private static let keyType = kSecAttrKeyTypeECSECPrimeRandom
    private static let keySizeInBits = 256
    private static let secClass = kSecClassKey
    
    // these values need to be set
    private static var faceIDPrompt = "Bareksa wants to authenticate you"
    
    public static var privKey: SecKey? {
        // getter returns a base64 encoded string privateKey
        get {
            print("fetching private key")
            // getquery is the query for getting the key pair
            let getquery: [String: Any] = [
                kSecClass as String: secClass,
                kSecAttrApplicationTag as String: cotterKeyTag,
                kSecAttrKeyType as String: keyType,
                kSecReturnRef as String: true,
                kSecUseOperationPrompt as String: faceIDPrompt
            ]

            // get the key
            var item: CFTypeRef?
            let status = SecItemCopyMatching(getquery as CFDictionary, &item)
            guard status == errSecSuccess else {
                // if retrieving key has errored, then it means the biometric scan has failed
                // need to enter pin or cancel request

                // TODO: handle biometric error
                print("fail retrieving the key")
                return nil
            }

            let key = item as! SecKey
            
            return key
        }
    }
    
    public static var pubKey: SecKey? {
        get {
            print("fetching public key")
            // try to generate the key first
            do{
                try KeyGen.generateKey()
            } catch let e {
                print(e)
                return nil
            }
            
            // if private key doesn't exist, return nothing
            guard let pKey = KeyGen.privKey else {
                return nil
            }
            
            return SecKeyCopyPublicKey(pKey)
        }
    }
    
    // generateKey generates the private key if one does not exist in the storage
    public static func generateKey() throws {
        // prevent a new key generation
        if KeyGen.privKey != nil {
            return
        }
        
        let context = LAContext()
        var error: Unmanaged<CFError>?
        var attributes: [String: Any]
        // check if there is biometry
        // this is needed because we need to make sure that the access control
        // to that specific Keychain item is open. Otherwise, the private key won't be generated properly
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {
            // setting the access control
            // restrict to user presence on any biometric set and when the device is unlocked
            // this will prompt Face ID or Touch ID upon reading the KeyChain Item
            guard let access = SecAccessControlCreateWithFlags(
                nil,  // Use the default allocator.
                kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly,
                .biometryAny,
                &error
                ) else {
                    throw error!.takeRetainedValue() as Error
            }
            print("got here")
            // attributes are key generation setting
            attributes = [
                kSecAttrKeyType as String: keyType, // ECDSA
                kSecAttrKeySizeInBits as String: keySizeInBits,
                kSecPrivateKeyAttrs as String: [
                    kSecAttrIsPermanent as String: true,
                    kSecAttrApplicationTag as String: cotterKeyTag,
                    kSecAttrAccessControl as String: access,
                ]
            ]
        } else {
            print("fatal, should get here")
            // No biometrics for device
            attributes = [
               kSecAttrKeyType as String: keyType, // ECDSA
               kSecAttrKeySizeInBits as String: keySizeInBits,
               kSecPrivateKeyAttrs as String: [
                   kSecAttrIsPermanent as String: true,
                   kSecAttrApplicationTag as String: cotterKeyTag
               ]
           ]
        }
        
        // generate the key
        guard SecKeyCreateRandomKey(attributes as CFDictionary, &error) != nil else {
            throw error!.takeRetainedValue() as Error
        }
    }
}
