//
//  CandidatesLoader.swift
//  Vitesse
//
//  Created by Alassane Der on 27/11/2024.
//

import Foundation

final class CandidatesLoader {
    
    private var client: HTTPClient
    
    init(client: HTTPClient = URLSessionHTTPClient()) {
        self.client = client
    }
    
    enum Error: Swift.Error {
        case invalidResponseStatusCode
    }
    
    func loadList(from request: URLRequest) async throws -> [CandidateItem] {
        let (data, response) = try await client.request(from: request)
        let list = try ListMapper.map(data, and: response)
        
        return list
    }
    
    func loadDetails(from request: URLRequest) async throws -> CandidateItem {
        let (data, response) = try await client.request(from: request)
        let details = try DetailMapper.map(data, and: response)
        
        return details
    }
    
    func delete(from request: URLRequest) async throws {
        let (_, response) = try await client.request(from: request)
        
        guard response.statusCode == 200 else {
            throw Error.invalidResponseStatusCode
        }
    }
    
    func update(from request: URLRequest) async throws -> CandidateItem {
        let (data, response) = try await client.request(from: request)
        let updatedCandidat = try UpdateCandidatsMapper.map(data, and: response)
        
        return updatedCandidat
    }
    
    func markCandidateAsFavorite(from request: URLRequest) async throws -> CandidateItem {
        let (data, response) = try await client.request(from: request)
        let asFavoriteSeted = try FavoritMapper.map(data, and: response)
        
        return asFavoriteSeted
    }
}
