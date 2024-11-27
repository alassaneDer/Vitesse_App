//
//  BackButton.swift
//  Vitesse
//
//  Created by Alassane Der on 25/11/2024.
//

import SwiftUI

struct BackButton: View {
    
    var action: () -> Void
    var backgroundColor: Color = Color(hex: "#BDBDBD").opacity(0.5)

    
    var body: some View {
        Button {
            action()
        } label: {
            Image(systemName: "chevron.left")
                .font(.system(size: 12).weight(.bold))
                .foregroundStyle(Color.white)
                .padding(10)
                .background(Circle().fill(backgroundColor))
        }
        
    }
}

#Preview {
    BackButton(action: {})
}
