//
//  ListMapper.swift
//  Vitesse
//
//  Created by Alassane Der on 07/09/2024.
//

import Foundation

enum ListMapper {
    
    private struct CandidateDTO: Decodable {
        let phone: String?
        let note: String?
        let id: String
        let firstName: String
        let linkedinURL: String?
        let isFavorite: Bool
        let email: String
        let lastName: String
        
        var candidateListItem: CandidateItem {
            CandidateItem(
                phone: phone,
                note: note,
                id: id,
                firstName: firstName,
                linkedinURL: linkedinURL,
                isFavorite: isFavorite,
                email: email,
                lastName: lastName
            )
        }
    }
    
    enum Error: Swift.Error {
        case invalideResponseStatusCode
        case invalidDecodingResponse
    }
    
    static func map(_ data: Data, and response: HTTPURLResponse) throws -> [CandidateItem] {
        guard response.statusCode == 200 else {
            throw Error.invalideResponseStatusCode
        }
        
        do {
            let candidateDTO = try JSONDecoder().decode([CandidateDTO].self, from: data)
            let list = candidateDTO.map { $0.candidateListItem }
            return list
        } catch {
            throw Error.invalidDecodingResponse
        }
    }
}
