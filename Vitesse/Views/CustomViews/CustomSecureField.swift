//
//  CustomSecureField.swift
//  Vitesse
//
//  Created by Alassane Der on 26/11/2024.
//

import SwiftUI

struct CustomSecureField: View {
    var placeHolder: String = "Enter text here"
    @Binding var text: String
    @State private var isSecureField: Bool = true

    var backgroundColor: Color = Color(UIColor.secondarySystemBackground)
    
    var body: some View {
        HStack {
            if isSecureField {
                SecureField(placeHolder, text: $text)
            } else {
                TextField(placeHolder, text: $text)
            }
            
            Button(action: {
                isSecureField.toggle()
            }, label: {
                Image(systemName: isSecureField ? "eye.slash" : "eye")
                    .foregroundStyle(Color.gray)
            })
        }
        .padding()
        .background(backgroundColor)
        .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
    }
}

#Preview {
    CustomSecureField(text: .constant("text"))
}
