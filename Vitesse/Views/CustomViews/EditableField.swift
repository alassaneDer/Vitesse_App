//
//  EditableField.swift
//  Vitesse
//
//  Created by Alassane Der on 25/11/2024.
//

import SwiftUI

struct EditableField: View {
    let title: String
    let icon: String?
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    
    var body: some View {
        VStack(alignment: .leading, content: {
            Text(title)
                .fontWeight(.semibold)
            HStack {
                if let icon = icon {
                    Image(systemName: icon)
                }
                TextField("Enter candidate's \(title)", text: $text)
                    .keyboardType(keyboardType)
                    .autocorrectionDisabled(true)
                    .textInputAutocapitalization(.never)
            }
            .padding(15)
            .background(RoundedRectangle(cornerRadius: 10).fill(Color(hex: "#BDBDBD").opacity(0.2)))
        })
    }
}
