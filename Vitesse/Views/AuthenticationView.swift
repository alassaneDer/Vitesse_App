//
//  AuthenticationView.swift
//  Vitesse
//
//  Created by Alassane Der on 26/11/2024.
//

import SwiftUI

struct AuthenticationView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    
    // gradient de couleur
    let gradientStart = Color(hex: "#BDAEC2").opacity(0.9)
    let gradientEnd = Color(hex: "#BDAEC2").opacity(0.4)
    
    @ObservedObject var viewModel: AuthViewModel
    
    // animation en allant vers la vue register
    @State private var isShowingRegisterView = false
    
    var body: some View {
        
        NavigationStack {
            ZStack {
                // background gradient
                LinearGradient(gradient: Gradient(colors: [gradientStart, gradientEnd]), startPoint: .top, endPoint: .bottomLeading)
                    .ignoresSafeArea(.all)
                
                
                VStack(spacing: 20) {
                    Text("Login")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                    
                    Text("Wellcome back, you have been missed !")
                    
                    // MARK: User inputs : email & password

                    CustomTextField (
                        placeHolder: "email or username",
                        text: $viewModel.email
                    )
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                        .autocorrectionDisabled(true)
                    
                    
                    CustomSecureField (
                        placeHolder: "Password",
                        text: $viewModel.password
                    )
                    
                    HStack {
                        Button(action: {
                            // nothing for now
                        }, label: {
                            Text("Forgot Password ?")
                        })
                    }
                   
                    // MARK: User actions : sign in or register
                    
                    LoginRegisterButton (
                        titleLabel: "Sign in",
                        backgroundColor: .black
                    ) {
                        Task {
                            await viewModel.login()
                        }
                    }
                    
                    LoginRegisterButton (
                        titleLabel: "Register",
                        animationDuration: 0.5
                    ) {
                        isShowingRegisterView = true
                    }
                    
                    
                    
                }
                .padding(.horizontal, 40)
                .overlay {
                    if !viewModel.authenticationMessage.isEmpty {
                        ToastView(errorMessage: viewModel.authenticationMessage)
                            .onAppear {
                                viewModel.showTemporaryToast()
                            }
                    }
                }
                
            }
            // dismiss the keyboard when tapping outside
            .onTapGesture {
                self.endEditing(true)
            }
            // navigation vers la vue REGISTER
            .navigationDestination(isPresented: $isShowingRegisterView) {
                RegistrationView(viewModel: RegisterViewModel())
                    .transition(.scale)
            }
        }
    }
}

#Preview {
    AuthenticationView(viewModel: AuthViewModel({}))
}
