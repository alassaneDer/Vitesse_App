//
//  AuthViewModel.swift
//  Vitesse
//
//  Created by Alassane Der on 07/09/2024.
//

import Foundation
import Combine

final class AuthViewModel: ObservableObject {
    @Published var email: String = "admin@vitesse.com"
    @Published var password: String = "test123"
    @Published var authenticationMessage: String = ""
    
    // message d'authentification réussi
    
    private let authenticator: Authenticator
    private let tokenStore: TokenStore
    let onLoginSuccess: (() -> ())
    private let toastUtility: ToastUtility
    
    init(authenticator: Authenticator = Authenticator(), tokenStore: TokenStore = KeychainStore(),_ callback: @escaping () -> (), toastUtility: ToastUtility = ToastUtility()) {
        self.authenticator = authenticator
        self.tokenStore = tokenStore
        self.onLoginSuccess = callback
        self.toastUtility = toastUtility
    }
    
    @MainActor
    func login() async {
        do {
            let request = try AuthEndPoint.request(with: email, and: password)
            let item = try await authenticator.authRequest(from: request)
            let token = item.token
            if let data = token.data(using: .utf8) {
                try tokenStore.delete()
                try tokenStore.insert(data)
                onLoginSuccess()
            }
        } catch {
            authenticationMessage = "Login failed: invalid email or password."
            print(error)
        }
    }
    
    func showTemporaryToast() {
        toastUtility.showTemporaryToast(after: 5) {
            self.authenticationMessage = ""
        }
    }
    
    
}
