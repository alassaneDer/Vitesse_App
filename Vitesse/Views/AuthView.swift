//
//  AuthView.swift
//  Vitesse
//
//  Created by Alassane Der on 07/09/2024.
//


import SwiftUI

struct AuthView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    
    // gradient de couleur
    let gradientStart = Color(hex: "#BDAEC2").opacity(0.9)
    let gradientEnd = Color(hex: "#BDAEC2").opacity(0.4)
    
    // viewModel
    @ObservedObject var viewModel: AuthViewModel
    
    // variable d'état pour le champ mot de pass visible ou non
    @State var isPassWordVisible: Bool = false
    
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
                    
                    TextField("email or username", text: $viewModel.email)
                        .padding()
                        .background(Color(UIColor.secondarySystemBackground))
                        .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 10)))
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                        .autocorrectionDisabled(true)
                    
                    //combinaison TextField et securefield afin de rendre le mdp visible ou non
                    HStack {
                        if isPassWordVisible {
                            // affichage du mdp
                            TextField("Password", text: $viewModel.password)
                        } else {
                            // cache le mdp
                            SecureField("Password", text: $viewModel.password)
                        }
                        // bouton pour que l'utilisateur puisse alterner entre les deux etats
                        Button {
                            isPassWordVisible.toggle()
                        } label: {
                            Image(systemName: isPassWordVisible ? "eye" : "eye.slash")
                                .foregroundStyle(Color.black)
                        }
                    }
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 10)))
                    
                    Text("Forgot Password?")
                    
                    Button(action: {
                        Task {
                            await viewModel.login()
                        }
                    }){
                        Text("Sign in")
                            .font(.system(size: 18).weight(.bold))
                            .frame(maxWidth: .infinity)
                            .foregroundStyle(Color.white)
                            .padding()
                            .background(Color.black)
                            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 10)))
                    }
                    
                    Button {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            isShowingRegisterView = true
                        }
                    } label: {
                        Text("Register")
                            .font(.system(size: 18).weight(.bold))
                            .frame(maxWidth: .infinity)
                            .foregroundStyle(Color.white)
                            .padding()
                            .background(Color(hex: "#BDAEC2"))
                            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 10)))
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
                RegisterView(viewModel: RegisterViewModel())
                    .transition(.scale)
            }
        }
    }
}

#Preview {
    AuthView(viewModel: AuthViewModel({}))
}
