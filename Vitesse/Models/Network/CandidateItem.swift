//
//  CandidateItem.swift
//  Vitesse
//
//  Created by Alassane Der on 07/09/2024.
//

import Foundation

struct CandidateItem: Equatable, Hashable {
    let phone: String?
    let note: String?
    let id: String
    let firstName: String
    let linkedinURL: String?
    let isFavorite: Bool
    let email: String
    let lastName: String
}
