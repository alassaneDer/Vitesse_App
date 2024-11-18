//
//  Deletor.swift
//  Vitesse
//
//  Created by Alassane Der on 07/09/2024.
//

import Foundation

final class Deletor {
    private var client: HTTPClient
    
    init(client: HTTPClient = URLSessionHTTPClient()) {
        self.client = client
    }
    
    enum Error: Swift.Error {
        case invalidResponseStatusCode
    }
    
    func delete(from request: URLRequest) async throws {
        let (_, response) = try await client.request(from: request)
        
        guard response.statusCode == 200 else {
            throw Error.invalidResponseStatusCode
        }
    }
}
