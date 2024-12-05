//
//  KeyChainStore.swift
//  Vitesse
//
//  Created by Alassane Der on 07/09/2024.
//

import Foundation

final class KeychainStore: TokenStore {
    
    private let key: String
    
    init(key: String = "com.vitesse.authtoken") {
        self.key = key
    }
    
    
    enum Error: Swift.Error {
        case insertFailed
        case retrieveFailed
        case deleteFailed
    }
    
    // MARK: insertion des données dans le Keychain
    func insert(_ data: Data) throws {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key as Any,
            kSecValueData: data
        ] as CFDictionary
        
        guard SecItemAdd(query, nil) == noErr else {
            throw Error.insertFailed
        }
    }
    
    // MARK: récupération des données
    func retrieve() throws -> Data {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecReturnData: kCFBooleanTrue as Any,
            kSecMatchLimit: kSecMatchLimitOne
        ] as CFDictionary
        
        var result: AnyObject?
        
        let status = SecItemCopyMatching(query, &result)
        
        guard status == noErr, let data = result as? Data else {
            throw Error.retrieveFailed
        }
        return data
    }

    // MARK: supression du keychain
    func delete() throws {
        if existsInKeychain() {
            let query = [
                kSecClass: kSecClassGenericPassword,
                kSecAttrAccount: key as Any
            ] as CFDictionary
            
            guard SecItemDelete(query) == noErr else {
                throw Error.deleteFailed
            }
        }
    }
    
    
    // MARK: vérification existance données dnas le keychain
    private func existsInKeychain() -> Bool {
            let query = [
                kSecClass: kSecClassGenericPassword,
                kSecAttrAccount: key,
                kSecReturnData: kCFBooleanTrue as Any,
                kSecMatchLimit: kSecMatchLimitOne
            ] as CFDictionary
            
            
            let status = SecItemCopyMatching(query, nil)        
            return status == noErr
    }
    
}
