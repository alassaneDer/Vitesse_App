//
//  DynamicHeight.swift
//  Vitesse
//
//  Created by Alassane Der on 07/09/2024.
//

import Foundation

// Modifier la fonction dynamicHeight pour mieux gérer le TextEditor
func dynamicHeight(for text: String) -> CGFloat {
    let baseHeight: CGFloat = 100
    let maxHeight: CGFloat = 200
    let minHeight: CGFloat = 100
    
    let characterLimit: Int = 70
    let numberOfLines = text.split(separator: "\n").count + (text.count / characterLimit)
    
    let height = min(maxHeight, max(minHeight, CGFloat(numberOfLines) * baseHeight / 2))
    
    return height
}
