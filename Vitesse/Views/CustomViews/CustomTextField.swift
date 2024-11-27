//
//  CustomTextField.swift
//  Vitesse
//
//  Created by Alassane Der on 26/11/2024.
//

import SwiftUI

struct CustomTextField: View {
    
    var placeHolder: String = "Enter text here"
    @Binding var text: String
    
    var backgroundColor: Color = Color(UIColor.secondarySystemBackground)
    
    var body: some View {
        
        TextField(placeHolder, text: $text)
            .padding()
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
    }
}

#Preview {
    CustomTextField(text: .constant("Text"))
}
