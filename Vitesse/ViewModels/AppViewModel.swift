//
//  AppViewModel.swift
//  Vitesse
//
//  Created by Alassane Der on 07/09/2024.
//

import Foundation

final class AppViewModel: ObservableObject {
    
    @Published var isLogged: Bool
    
    init() {
        isLogged = false
    }
    
    var authViewModel: AuthViewModel {
        return AuthViewModel { [weak self ] in
            DispatchQueue.main.async {
                self?.isLogged = true
            }
        }
    }
    
    var registerViewModel: RegisterViewModel {
        return RegisterViewModel()
    }
    
    var listViewModel: ListViewModel {
        return ListViewModel()
    }
}
