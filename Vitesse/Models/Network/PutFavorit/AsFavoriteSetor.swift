//
//  Creator.swift
//  Vitesse
//
//  Created by Alassane Der on 07/09/2024.
//

import Foundation

final class AsFavoriteSetor {
    
    private var client: HTTPClient
    
    init(client: HTTPClient = URLSessionHTTPClient()) {
        self.client = client
    }
    
    func FavoriteSetor(from request: URLRequest) async throws -> CandidateItem {
        let (data, response) = try await client.request(from: request)
        let asFavoriteSeted = try FavoritMapper.map(data, and: response)
        
        return asFavoriteSeted
    }
}
