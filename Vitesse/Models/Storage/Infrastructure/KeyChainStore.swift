//
//  KeyChainStore.swift
//  Vitesse
//
//  Created by Alassane Der on 07/09/2024.
//

import Foundation
 /*
 La classe KeychainStore fournit une interface pour
    stocker,
    récupérer et
    supprimer
 des données dans le Keychain d'iOS, en se conformant au protocole TokenStore
 
 */



final class KeychainStore: TokenStore {
    
    private let key: String // stocke la clé d'accès utilisée pour identifier les données dans le Keychain.
    
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
        // création du dictionnaire query
        let query = [
            kSecClass: kSecClassGenericPassword, // spécifie object à stocker est un mot de pass générique
            kSecAttrAccount: key as Any,     // la clé d'identification
            kSecValueData: data         // les données
        ] as CFDictionary
        
        // ajout de query dans le Keychain
        guard SecItemAdd(query, nil) == noErr else {
            throw Error.insertFailed
        }
    }
    
    // MARK: récupération des données
    func retrieve() throws -> Data {
        let query = [
            kSecClass: kSecClassGenericPassword,    //mdp générique
            kSecAttrAccount: key,   // associé à une clé
            kSecReturnData: kCFBooleanTrue as Any,  // retourner les données
            kSecMatchLimit: kSecMatchLimitOne   // limitation de la recherche à un élément
        ] as CFDictionary
        
        var result: AnyObject?
        
        let status = SecItemCopyMatching(query, &result)
        
        guard status == noErr, let data = result as? Data else {
            throw Error.retrieveFailed
        }
        return data
    }
    
    /*
     
     Le dictionnaire query spécifie que l'on cherche à récupérer un mot de passe générique associé à la clé,
     avec la demande de renvoyer les données correspondantes (kSecReturnData) et
     de limiter la recherche à un seul élément (kSecMatchLimitOne).
     
     */
    
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
                kSecClass: kSecClassGenericPassword,    //mdp générique
                kSecAttrAccount: key,   // associé à une clé
                kSecReturnData: kCFBooleanTrue as Any,  // retourner les données
                kSecMatchLimit: kSecMatchLimitOne   // limitation de la recherche à un élément
            ] as CFDictionary
            
            
            let status = SecItemCopyMatching(query, nil)    // effectue la recherche dans le Keychain
        
            return status == noErr
    }
    
}
