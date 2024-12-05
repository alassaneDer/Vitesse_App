//
//  AuthMapper.swift
//  Vitesse
//
//  Created by Alassane Der on 07/09/2024.
//

import Foundation

enum AuthMapper {
    
    private struct Root: Decodable {
        let token: String
        let isAdmin: Bool
        
        var authItem: AuthItem {
            AuthItem(token: token, isAdmin: isAdmin)
        }
    }
    
    enum Error: Swift.Error {
        case invalidResponseStatusCode
        case invalidDecodingResponse
    }
    
    static func map(_ data: Data, and response: HTTPURLResponse) throws -> AuthItem {
        guard response.statusCode == 200 else {
            throw Error.invalidResponseStatusCode
        }
        guard let root = try? JSONDecoder().decode(Root.self, from: data) else {
            throw Error.invalidDecodingResponse
        }
        return root.authItem
    }
}
