//
//  LoginRegisterButton.swift
//  Vitesse
//
//  Created by Alassane Der on 26/11/2024.
//

import SwiftUI

struct LoginRegisterButton: View {
    
    var titleLabel: String
    var titleLabelColor: Color = Color.white
    var backgroundColor: Color = Color(hex: "#BDAEC2")
    var animationDuration: Double? = nil
    var action: () -> Void
    
    var body: some View {
        
        Button(action: {
            if let duration = animationDuration {
                withAnimation(.easeInOut(duration: duration)) {
                    action()
                }
            } else {
                action()
            }
        }, label: {
            Text(titleLabel)
                .font(.system(size: 18).weight(.bold))
                .frame(maxWidth: .infinity)
                .foregroundStyle(titleLabelColor)
                .padding()
                .background(backgroundColor)
                .clipShape(RoundedRectangle(cornerSize: CGSize(width: 15, height: 10)))
        })
    }
}

#Preview {
    LoginRegisterButton(titleLabel: "title", action: {})
}
