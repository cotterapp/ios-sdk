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
    private static let cotterKeyTag = "org.cocoapods.Cotter.privKey".data(using: .utf8)!
    private static let cotterPubKeyTag = "org.cocoapods.Cotter.pubKey".data(using: .utf8)!
    private static let keyType = kSecAttrKeyTypeECSECPrimeRandom
    private static let keySizeInBits = 256
    private static let secClass = kSecClassKey
    
    // these values need to be set
    private static var faceIDPrompt = "Bareksa wants to authenticate you"
    
    // fetchKey fetches either private or public key
    // set pvt to true if you want to fetch private key
    private static func fetchKey(pvt: Bool) -> SecKey? {
        var tag = cotterKeyTag
        if !pvt {
            tag = cotterPubKeyTag
        }
        
        let getquery: [String: Any] = [
            kSecClass as String: secClass,
            kSecAttrApplicationTag as String: tag,
            kSecAttrKeyType as String: keyType,
            kSecReturnRef as String: true
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
    
    public static var privKey: SecKey? {
        // getter returns a base64 encoded string privateKey
        get {
            print("fetching private key, authenticating..")
            guard let privKey = fetchKey(pvt: true) else {
                // try to generate the key first
                do {
                    try KeyGen.generateKey()
                } catch let e {
                    print(e)
                    return nil
                }
                print("[inside] fetching private key, authenticating..")
                return fetchKey(pvt: true)
            }
            return privKey
        }
    }
    
    public static var pubKey: SecKey? {
        get {
            print("getting public key")
            guard let key = fetchKey(pvt: false) else {
                print("generating key pair")
                // try to generate the key first
                do {
                    try KeyGen.generateKey()
                } catch let e {
                    print(e)
                    return nil
                }
                return fetchKey(pvt: false)
            }
            return key
        }
    }
    
    // generateKey generates the private key if one does not exist in the storage
    private static func generateKey() throws {
        var error: Unmanaged<CFError>?
        // setting the access control
        // restrict to user presence on any biometric set and when the device is unlocked
        // this will prompt Face ID or Touch ID upon reading the KeyChain Item
        var accessFlag = SecAccessControlCreateFlags.userPresence
        if #available(iOS 11.3, *) {
            accessFlag = SecAccessControlCreateFlags.biometryAny
        }
        guard let access = SecAccessControlCreateWithFlags(
            nil,  // Use the default allocator.
            kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly,
            accessFlag,
            &error
            ) else {
                throw error!.takeRetainedValue() as Error
        }

        // attributes are key generation setting
        let attributes:[String:Any] = [
            kSecAttrKeyType as String: keyType, // ECDSA
            kSecAttrKeySizeInBits as String: keySizeInBits,
            kSecPrivateKeyAttrs as String: [
                kSecAttrIsPermanent as String: true,
                kSecAttrApplicationTag as String: cotterKeyTag,
                kSecAttrAccessControl as String: access,
            ]
        ]
        
        // generate the key
        guard let pKey = SecKeyCreateRandomKey(attributes as CFDictionary, &error) else {
            throw error!.takeRetainedValue() as Error
        }
        
        // store the pubKey in the keychain with accessible control
        guard let pubKey = SecKeyCopyPublicKey(pKey) else {
            throw CotterError.keychainError("error deriving public key from private key")
        }
        
        let addquery: [String: Any] = [kSecClass as String: secClass,
                                       kSecAttrApplicationTag as String: cotterPubKeyTag,
                                       kSecValueRef as String: pubKey]
        
        let status = SecItemAdd(addquery as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw CotterError.keychainError("error saving public key")
        }
    }
    
    static func clearKeys() throws {
        print("Deleting Private and Public Keys...")
        let privKeyTag = "org.cocoapods.Cotter.privKey".data(using: .utf8)!
        let pubKeyTag = "org.cocoapods.Cotter.pubKey".data(using: .utf8)!
        
        // Remove the previous key pair
        do {
            try deleteKey(tag:privKeyTag)
            try deleteKey(tag:pubKeyTag)
        } catch CotterError.keychainError(let errMsg) {
            throw CotterError.keychainError(errMsg)
        }
        
        print("Successfully Deleted Public/Private Key Pair")
    }
}

// MARK: - Keychain utilities
extension KeyGen {
    private static func deleteKey(tag:Data) throws {
        // Remove the previous key pair
        let query: [String: Any] = [
            kSecClass as String: kSecClassKey,
            kSecAttrApplicationTag as String: tag,
            kSecAttrKeyType as String: kSecAttrKeyTypeECSECPrimeRandom,
        ]
        let st = SecItemDelete(query as CFDictionary)
        guard st == errSecSuccess || st == errSecItemNotFound else {
            throw CotterError.keychainError("Error deleting key: \(String(decoding: tag, as: UTF8.self))")
        }
    }
}
