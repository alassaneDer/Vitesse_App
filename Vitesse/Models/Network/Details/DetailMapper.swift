//
//  DetailMapper.swift
//  Vitesse
//
//  Created by Alassane Der on 07/09/2024.
//

import Foundation

enum DetailMapper {
    private struct Root: Decodable {
        let phone: String?
        let note: String?
        let id: String
        let firstName: String
        let linkedinURL: String?
        let isFavorite: Bool
        let email: String
        let lastName: String
        
        var details: CandidateItem {
            CandidateItem(
                phone: phone,
                note: note,
                id: id, 
                firstName: firstName,
                linkedinURL: linkedinURL,
                isFavorite: isFavorite,
                email: email,
                lastName: lastName)
        }
    }
    
    enum Error: Swift.Error {
        case invalidResponseStatusCode
        case invalideDecodingResponse
    }
    
    static func map(_ data: Data, and response: HTTPURLResponse) throws -> CandidateItem {
        guard response.statusCode == 200 else {
            throw Error.invalidResponseStatusCode
        }
        
        guard let root = try? JSONDecoder().decode(Root.self, from: data) else {
            throw Error.invalideDecodingResponse
        }
        
        return root.details
    }
}
