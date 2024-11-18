//
//  VitesseApp.swift
//  Vitesse
//
//  Created by Alassane Der on 06/09/2024.
//

import SwiftUI

@main
struct VitesseApp: App {
    
    @StateObject var viewmodel = AppViewModel()
    
    var body: some Scene {
        WindowGroup {
            Group {
                if viewmodel.isLogged {
                    ListView(viewmodel: ListViewModel())

                } else {
                    AuthView(viewModel: viewmodel.authViewModel)
                        .transition(.asymmetric(insertion: .move(edge: .trailing).combined(with: .opacity),
                                                removal: .move(edge: .top).combined(with: .opacity)))
                }
            }
        }
    }
}
