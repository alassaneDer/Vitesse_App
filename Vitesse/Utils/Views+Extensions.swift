//
//  Views+Extensiosn.swift
//  Vitesse
//
//  Created by Alassane Der on 07/09/2024.
//

import SwiftUI

extension View {
    func endEditing(_ force: Bool) {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            windowScene.windows.forEach { window in
                window.endEditing(true)
            }
        }
    }
}
