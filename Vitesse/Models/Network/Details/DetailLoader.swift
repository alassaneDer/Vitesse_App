//
//  DetailLoader.swift
//  Vitesse
//
//  Created by Alassane Der on 07/09/2024.
//

import Foundation

final class DetailLoader {
    
    private var client: HTTPClient
    
    init(client: HTTPClient = URLSessionHTTPClient()) {
        self.client = client
    }
    
    func loadDetails(from request: URLRequest) async throws -> CandidateItem {
        let (data, response) = try await client.request(from: request)
        let details = try DetailMapper.map(data, and: response)
        
        return details
    }
}
