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
    
    // Calculer le nombre de lignes de texte en fonction de la longueur du texte
    let characterLimit: Int = 70 // Ajustez cette limite en fonction de la largeur du TextEditor
    let numberOfLines = text.split(separator: "\n").count + (text.count / characterLimit)
    
    // Calculer la hauteur du TextEditor
    let height = min(maxHeight, max(minHeight, CGFloat(numberOfLines) * baseHeight / 2))
    
    return height
}

/*
 
 // pour verification si j'envoie pas de NAN
 func dynamicHeight(for text: String) -> CGFloat {
     let baseHeight: CGFloat = 100
     let maxHeight: CGFloat = 200
     let minHeight: CGFloat = baseHeight
     
     // Si le texte est vide, retourner la hauteur minimale
     guard !text.isEmpty else { return minHeight }

     // Calculer le nombre de lignes de texte en fonction de la longueur du texte
     let characterLimit: Int = 70
     var numberOfLines = text.split(separator: "\n").count + (text.count / characterLimit)
     
     // S'assurer que le nombre de lignes est toujours au moins 1
     numberOfLines = max(1, numberOfLines)

     // Calculer la hauteur du TextEditor
     let height = min(maxHeight, max(minHeight, CGFloat(numberOfLines) * baseHeight / 2))
     
     // Vérifier si la hauteur calculée est une valeur valide
     guard !height.isNaN else { return minHeight }

     return height
 }

 
 */
