//
//  Updator.swift
//  Vitesse
//
//  Created by Alassane Der on 07/09/2024.
//

import Foundation

final class Updator {
    
    private var client: HTTPClient
    
    init(client: HTTPClient = URLSessionHTTPClient()) {
        self.client = client
    }
    
    func update(from request: URLRequest) async throws -> CandidateItem {
        let (data, response) = try await client.request(from: request)
        let updatedCandidat = try UpdateCandidatsMapper.map(data, and: response)
        
        return updatedCandidat
    }
}
