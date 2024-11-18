//
//  ToastView.swift
//  Vitesse
//
//  Created by Alassane Der on 03/10/2024.
//

import SwiftUI

struct ToastView: View {
    
    @State var errorMessage: String = ""
    
    var body: some View {
        VStack {
            Text(errorMessage)
                .padding()
                .transition(.move(edge: .top))
                .background(RoundedRectangle(cornerRadius: 10).fill(Color(hue: 1.0, saturation: 0.89, brightness: 0.835).opacity(0.9)))
                .foregroundStyle(Color.white)
        }
        .padding()
    }
}

#Preview {
    ToastView()
}
