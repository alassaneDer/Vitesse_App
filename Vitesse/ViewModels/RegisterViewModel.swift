//
//  RegisterViewModel.swift
//  Vitesse
//
//  Created by Alassane Der on 07/09/2024.
//

import Foundation
import Combine

final class RegisterViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    
    
    @Published var registerMessage: String = ""
    private let toastUtility: ToastUtility
    
    private let registor: Registor
    
    init(registor: Registor = Registor(), toastUtility: ToastUtility = ToastUtility()) {
        self.registor = registor
        self.toastUtility = toastUtility
    }
    
    @MainActor
    func register() async {
        
        if email.isEmpty || password.isEmpty || confirmPassword.isEmpty || firstName.isEmpty || lastName.isEmpty {
            registerMessage = "Please fill out all fields."
        } else if password != confirmPassword {
            registerMessage = "Please make sure the passwords match!"
        } else if !email.isEmail() {
            registerMessage = "Please enter a valid email!"
        } else {
            do {
                let request = try RegisterEndPoint.request(email: email, password: password, firstName: firstName, lastName: lastName)
                try await registor.register(from: request)
                
                registerMessage = "Registration succesful!"
            } catch {
                registerMessage = "Sorry! Registration failed. Please try again."
            }
        }
    }
    
    // toast avec le registerMessage
    func showTemporaryToast() {
        toastUtility.showTemporaryToast(after: 3) {
            self.registerMessage = ""
        }
    }
    
}
