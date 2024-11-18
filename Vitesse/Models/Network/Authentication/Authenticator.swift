//
//  Authenticator.swift
//  Vitesse
//
//  Created by Alassane Der on 07/09/2024.
//

import Foundation

final class Authenticator {
    
    private let client: HTTPClient
    
    init(client: HTTPClient = URLSessionHTTPClient()) {
        self.client = client
    }
    
    func authRequest(from request: URLRequest) async throws -> AuthItem {
        let (data, response) = try await client.request(from: request)
        let item = try AuthMapper.map(data, and: response)

        return item
    }
    
}
