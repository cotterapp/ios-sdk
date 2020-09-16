//
//  KeyStore.swift
//  Cotter
//
//  Created by Albert Purnama on 3/20/20.
//

import Foundation
import os.log
import Security
import LocalAuthentication

protocol KeyPair {
    var privKey: SecKey? { get }
    var pubKey: SecKey? { get }
}

class KeyStore {
    public static func trusted(userID: String) -> KeyPair {
        return KeyGenV2(generator: TrustedKeyGen(userID: userID))
    }
    
    // old trusted
    public static let biometric = KeyGenV2(generator: BiometricKeyGen())
}

class KeyGenV2: KeyPair {
    private let generator:KeyGenerator
    
    // initialize a key generation
    public init(generator:KeyGenerator) {
        self.generator = generator
    }
    
    // fetchKey fetches either private or public key
    // set pvt to true if you want to fetch private key
    private func fetchKey(pvt: Bool) -> SecKey? {
        let generator = self.generator
        var tag = generator.keyTag
        if !pvt {
            tag = generator.pubKeyTag
        }
        
        let getquery: [String: Any] = [
            kSecClass as String: generator.secClass,
            kSecAttrApplicationTag as String: tag,
            kSecAttrKeySizeInBits as String: generator.keySizeInBits,
            kSecAttrKeyType as String: generator.keyType,
            kSecReturnRef as String: true
        ]

        // get the key
        var item: CFTypeRef?
        let status = SecItemCopyMatching(getquery as CFDictionary, &item)
        guard status == errSecSuccess else {
            os_log("%{public}@ failed getting key { private: %d tag: %{public}@ status: %d }",
                   log: Config.instance.log, type: .error,
                   #function, pvt, String(decoding: tag, as: UTF8.self), status)
            return nil
        }

        let key = item as! SecKey
        
        return key
    }
    
    public var privKey: SecKey? {
        // getter returns a base64 encoded string privateKey
        get {
            let generator = self.generator
            guard let privKey = fetchKey(pvt: true) else {
                // try to generate the key first
                do {
                    try clearKeys();
                    try generator.generateKey()
                } catch let e {
                    os_log("%{public}@ privKey { err: %{public}@ }",
                           log: Config.instance.log, type: .error,
                           #function, e.localizedDescription)
                    return nil
                }

                return fetchKey(pvt: true)
            }
            return privKey
        }
    }
    
    public var pubKey: SecKey? {
        get {
            let generator = self.generator
            guard let key = fetchKey(pvt: false) else {

                // try to generate the key first
                do {
                    try clearKeys();
                    try generator.generateKey()
                } catch let e {
                    os_log("%{public}@ pubKey { err: %{public}@ }",
                           log: Config.instance.log, type: .error,
                           #function, e.localizedDescription)
                    return nil
                }
                return fetchKey(pvt: false)
            }
            return key
        }
    }
    
    public func clearKeys() throws {
        try deleteKey(tag:self.generator.keyTag)
        try deleteKey(tag:self.generator.pubKeyTag)
    }
    
    private func deleteKey(tag:Data) throws {
        os_log("%{public}@ { tag: %{public}@ }",
               log: Config.instance.log, type: .info,
               #function, tag.description)
        
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

protocol KeyGenerator {
    var keyTag:Data { get }
    var pubKeyTag:Data { get }
    
    var keyType:CFString { get }
    var keySizeInBits:Int { get }
    var secClass:CFString { get }
    
    func generateKey() throws
}

class TrustedKeyGen: KeyGenerator {
    public var keyTag: Data {
        get {
            return "org.cocoapods.Cotter.trusted.privKey.\(self.userID).\(self.issuer)".data(using: .utf8)!
        }
    }
    public var pubKeyTag: Data {
        get {
            return "org.cocoapods.Cotter.trusted.pubKey.\(self.userID).\(self.issuer)".data(using: .utf8)!
        }
    }
    
    public let keyType = kSecAttrKeyTypeECSECPrimeRandom
    public let keySizeInBits = 256
    public let secClass = kSecClassKey
    
    var userID:String = ""
    var issuer:String {
        get {
            // issuer must be the current company that is using the SDK
            return CotterAPIService.shared.apiKeyID
        }
    }
    
    // initialize a key generation
    public init() {}
    
    // init that takes in the user id for convenience purposes
    public convenience init(userID:String) {
        self.init()
        self.userID = userID
    }
    
    // generateKey generates the private key if one does not exist in the storage
    internal func generateKey() throws {
        var error: Unmanaged<CFError>?

        // attributes are key generation setting
        let attributes:[String:Any] = [
            kSecAttrKeyType as String: self.keyType, // ECDSA
            kSecAttrKeySizeInBits as String: self.keySizeInBits,
            kSecPrivateKeyAttrs as String: [
                kSecAttrIsPermanent as String: true,
                kSecAttrApplicationTag as String: self.keyTag,
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
        
        let addquery: [String: Any] = [kSecClass as String: self.secClass,
                                       kSecAttrApplicationTag as String: self.pubKeyTag,
                                       kSecValueRef as String: pubKey]
        
        let status = SecItemAdd(addquery as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw CotterError.keychainError("error saving public key")
        }
    }
}


class BiometricKeyGen: KeyGenerator {
    public let keyTag = "org.cocoapods.Cotter.privKey".data(using: .utf8)!
    public let pubKeyTag = "org.cocoapods.Cotter.pubKey".data(using: .utf8)!
    public let keyType = kSecAttrKeyTypeECSECPrimeRandom
    public let keySizeInBits = 256
    public let secClass = kSecClassKey
    
    // generateKey generates the private key if one does not exist in the storage
    public func generateKey() throws {
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
            ), error == nil else {
                throw error!.takeRetainedValue() as Error
        }

        // attributes are key generation setting
        let attributes:[String:Any] = [
            kSecAttrKeyType as String: keyType, // ECDSA
            kSecAttrKeySizeInBits as String: keySizeInBits,
            kSecPrivateKeyAttrs as String: [
                kSecAttrIsPermanent as String: true,
                kSecAttrApplicationTag as String: keyTag,
                kSecAttrAccessControl as String: access,
            ]
        ]
        
        // generate the key
        guard let pKey = SecKeyCreateRandomKey(attributes as CFDictionary, &error), error == nil else {
            throw error!.takeRetainedValue() as Error
        }
        
        // store the pubKey in the keychain with accessible control
        guard let pubKey = SecKeyCopyPublicKey(pKey) else {
            throw CotterError.keychainError("error deriving public key from private key")
        }
        
        let addquery: [String: Any] = [kSecClass as String: secClass,
                                       kSecAttrApplicationTag as String: pubKeyTag,
                                       kSecValueRef as String: pubKey]
        
        let status = SecItemAdd(addquery as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw CotterError.keychainError("error saving public key")
        }
    }
}
