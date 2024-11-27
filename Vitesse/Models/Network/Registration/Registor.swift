//
//  RegisterMapper.swift
//  Vitesse
//
//  Created by Alassane Der on 07/09/2024.
//

import Foundation

final class Registor {
    private let client: HTTPClient
    
    init(client: HTTPClient = URLSessionHTTPClient()) {
        self.client = client
    }
    
    enum Error: Swift.Error {
        case invalidResponseStatusCode
    }
    
    func register(from request: URLRequest) async throws {
        let (_, response) = try await client.request(from: request)
        guard response.statusCode == 201 else {
            throw Error.invalidResponseStatusCode
        }
    }
}
