//
//  RegistrationView.swift
//  Vitesse
//
//  Created by Alassane Der on 26/11/2024.
//

import SwiftUI

struct RegistrationView: View {
    @ObservedObject var viewModel: RegisterViewModel
    
    // gradient de couleur
    let gradientStart = Color(hex: "#BDAEC2").opacity(0.9)
    let gradientEnd = Color(hex: "#BDAEC2").opacity(0.4)
    
    
    //for the backButton
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            // background gradient
            LinearGradient(gradient: Gradient(colors: [gradientStart, gradientEnd]), startPoint: .top, endPoint: .bottomLeading)
                .ignoresSafeArea(.all)
            
            VStack(spacing: 20) {
                Text("Register")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .padding(.bottom, 30)
                
                CustomTextField (
                    placeHolder: "first name",
                    text: $viewModel.firstName
                )
                
                CustomTextField (
                    placeHolder: "last name",
                    text: $viewModel.lastName
                )
                
                
                CustomTextField (
                    placeHolder: "email",
                    text: $viewModel.email
                )
                .textInputAutocapitalization(.never)
                .keyboardType(.emailAddress)
                .autocorrectionDisabled(true)
                
                CustomSecureField (
                    placeHolder: "Password",
                    text: $viewModel.password
                )
                
                CustomSecureField (
                    placeHolder: "Confirm Password",
                    text: $viewModel.confirmPassword
                )
                
                Spacer()
                
                LoginRegisterButton (
                    titleLabel: "Create",
                    titleLabelColor: .white,
                    backgroundColor: .black) {
                        Task {
                            await viewModel.register()
                            viewModel.showTemporaryToast()
                        }
                    }
                
                Spacer()
                
            }
            .padding(.horizontal, 40)
            .overlay {
                if !viewModel.registerMessage.isEmpty {
                    ToastView(errorMessage: viewModel.registerMessage)
                        .onAppear {
                            viewModel.showTemporaryToast()
                        }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(content: {
            ToolbarItem(placement: .topBarLeading) {
                BackButton(action: {
                    dismiss()
                }, backgroundColor: .black)
            }
        })
    }
}

#Preview {
    NavigationStack {
        RegistrationView(viewModel: RegisterViewModel())
    }
}
