//
//  File.swift
//  CotterIOS
//
//  Created by Albert Purnama on 2/6/20.
//

import Foundation
import Security

class KeyGen {
    private static let cotterKeyTag = "org.cocoapods.CotterIOS.privKey"
    private static let keyType = kSecAttrKeyTypeECSECPrimeRandom
    private static let keySizeInBits = 256
    private static let secClass = kSecClassKey

    public static var privKey: SecKey? {
        // getter returns a base64 encoded string privateKey
        get {
            // getquery is the query for getting the key pair
            let getquery: [String: Any] = [
                kSecClass as String: secClass,
                kSecAttrApplicationTag as String: cotterKeyTag,
                kSecAttrKeyType as String: keyType,
                kSecReturnRef as String: true
            ]

            // get the key
            var item: CFTypeRef?
            let status = SecItemCopyMatching(getquery as CFDictionary, &item)
            guard status == errSecSuccess else {
                // if retrieving key has errored, then it means the biometric scan has failed
                // need to enter pin or cancel requesst

                // TODO: handle biometric error
                print("fail retrieving the key")
                return nil
            }
            let key = item as! SecKey
            
            return key
        }
        
        set {
            let key: SecKey? = KeyGen.privKey
            // if the key exists
            if key != nil {
                // remove the existing key
                let query: [String: Any] = [
                    kSecClass as String: secClass,
                    kSecAttrApplicationTag as String: cotterKeyTag,
                    kSecAttrKeyType as String: keyType,
                ]
                let status = SecItemDelete(query as CFDictionary)
                guard status == errSecSuccess else {
                    print("error deleting old key")
                    return
                }
                print("removed old key")
            }
            
            let addquery: [String: Any] = [
                kSecClass as String: secClass,
                kSecAttrApplicationTag as String: cotterKeyTag,
                kSecValueRef as String: newValue!
            ]
            
            let status = SecItemAdd(addquery as CFDictionary, nil)
            guard status == errSecSuccess else {
                print("error saving private key")
                return
            }
            print("successfully saved private key")
        }
    }
    
    public static var pubKey: SecKey? {
        get {
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
        
        // setting the access control
        // restrict to user presence on any biometric set and when the device is unlocked
        var error: Unmanaged<CFError>?
        guard let access = SecAccessControlCreateWithFlags(
            nil,  // Use the default allocator.
            kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly,
            .biometryAny,
            &error
            ) else {
                throw error!.takeRetainedValue() as Error
        }
        
        // attributes are key generation setting
        let attributes: [String: Any] = [
            kSecAttrKeyType as String:            keyType, // ECDSA
            kSecAttrKeySizeInBits as String:      keySizeInBits,
            kSecPrivateKeyAttrs as String: [
                kSecAttrApplicationTag as String: cotterKeyTag,
                kSecAttrAccessControl as String: access,
            ]
        ]
        
        // generate the key
        guard let privateKey = SecKeyCreateRandomKey(attributes as CFDictionary, &error) else {
            throw error!.takeRetainedValue() as Error
        }
        
        // assign the newly created key
        KeyGen.privKey = privateKey
    }
}
