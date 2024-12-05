//
//  CreateEndPoint.swift
//  Vitesse
//
//  Created by Alassane Der on 07/09/2024.
//

import Foundation

enum FavoritEndPoint {
    
    static func request(token: String, candidateID: String) throws -> URLRequest {
        let baseURL = URL(string: "http://127.0.0.1:8080/candidate/\(candidateID)/favorite")!
        var request = URLRequest(url: baseURL)
        request.httpMethod = "POST"
        
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        return request
    }
}
