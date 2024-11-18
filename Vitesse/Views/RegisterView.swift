//
//  RegisterView.swift
//  Vitesse
//
//  Created by Alassane Der on 07/09/2024.
//

import SwiftUI

struct RegisterView: View {
    @ObservedObject var viewModel: RegisterViewModel
    
    // gradient de couleur
    let gradientStart = Color(hex: "#BDAEC2").opacity(0.9)
    let gradientEnd = Color(hex: "#BDAEC2").opacity(0.4)
    
    @State var isPassWordVisible: Bool = false
    
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
                    .padding()
                
                TextField("first name", text: $viewModel.firstName)
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 10)))
                
                TextField("last name", text: $viewModel.lastName)
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 10)))
                
                TextField("email", text: $viewModel.email)
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 10)))
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)
                    .autocorrectionDisabled(true)
                
                //combinaison TextField et securefield afin de rendre le mdp visible ou non
                HStack {
                    if isPassWordVisible {
                        TextField("Password", text: $viewModel.password)
                    } else {
                        SecureField("Password", text: $viewModel.password)
                    }
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
                
                
                HStack {
                    if isPassWordVisible {
                        TextField("Confirm Password", text: $viewModel.password)
                    } else {
                        SecureField("Confirm Password", text: $viewModel.password)
                    }
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
                
                
                
                
                
                Button(action: {
                    Task {
                        await viewModel.register()
                        viewModel.showTemporaryToast()
                        
                    }
                }){
                    Text("Create")
                        .font(.system(size: 16).weight(.bold))
                        .foregroundStyle(Color.white)
                        .padding()
                        .background(Color.black)
                        .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 10)))
                }
                
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
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16).weight(.bold))
                        .foregroundStyle(Color.white)
                        .padding(10)
                        .background(Circle().fill(Color.black))
                }
            }
        })
    }
}


#Preview {
    RegisterView(viewModel: RegisterViewModel())
}

/*
 
 .toolbar(content: {
 ToolbarItem(placement: .topBarLeading) {
 Button {
 dismiss()
 } label: {
 HStack {
 Image(systemName: "chevron.left")
 Text("Back")
 }
 .foregroundStyle(Color.black)
 }
 }
 })
 */
