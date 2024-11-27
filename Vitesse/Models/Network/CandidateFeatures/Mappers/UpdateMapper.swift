//
//  UpdateMapper.swift
//  Vitesse
//
//  Created by Alassane Der on 07/09/2024.
//

import Foundation

enum UpdateCandidatsMapper {
    
    private struct Root: Decodable {
        let phone: String?
        let note: String?
        let id: String
        let firstName: String
        let linkedinURL: String?
        let isFavorite: Bool
        let email: String
        let lastName: String
        
        var candidateItem: CandidateItem {
            CandidateItem(phone: phone, note: note, id: id, firstName: firstName, linkedinURL: linkedinURL, isFavorite: isFavorite, email: email, lastName: lastName)
        }
    }
    
    enum Error: Swift.Error {
        case invalidResponseStatusCodeUPD
        case invalidDecodingResponseUPD
    }
    
    static func map(_ data: Data, and response: HTTPURLResponse) throws -> CandidateItem {
        guard response.statusCode == 200 else {
            throw Error.invalidResponseStatusCodeUPD
        }
        
        guard let root = try? JSONDecoder().decode(Root.self, from: data) else {
            throw Error.invalidDecodingResponseUPD
        }
        
        return root.candidateItem
    }
    
}
