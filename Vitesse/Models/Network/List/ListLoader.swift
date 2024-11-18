//
//  ListLoader.swift
//  Vitesse
//
//  Created by Alassane Der on 07/09/2024.
//

import Foundation

final class ListLoader {
    
    private var client: HTTPClient
    
    init(client: HTTPClient = URLSessionHTTPClient()) {
        self.client = client
    }
    
    func loadList(from request: URLRequest) async throws -> [CandidateItem] {
        let (data, response) = try await client.request(from: request)
        let list = try ListMapper.map(data, and: response)
        
        return list
    }
    
}
