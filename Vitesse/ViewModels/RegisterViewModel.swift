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
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    
    
    @Published var registerMessage: String = ""
    private let toastUtility: ToastUtility  // instance de ToastUtility
    
    private let registor: Registor
    
    init(registor: Registor = Registor(), toastUtility: ToastUtility = ToastUtility()) {
        self.registor = registor
        self.toastUtility = toastUtility
    }
    
    @MainActor
    func register() async {
        do {
            let request = try RegisterEndPoint.request(email: email, password: password, firstName: firstName, lastName: lastName)
            try await registor.register(from: request)
            
            registerMessage = "Welcome \(firstName)"
        } catch {
            registerMessage = "Sorry! Can't Register."  // a voir si c bien ici sa place
            print(error)
        }
    }
    
    // toast avec le registerMessage
    func showTemporaryToast() {
        toastUtility.showTemporaryToast(after: 3) {
            self.registerMessage = ""
        }
    }
    
    
}
