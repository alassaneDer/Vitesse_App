//
//  AuthEndPoint.swift
//  Vitesse
//
//  Created by Alassane Der on 07/09/2024.
//

import Foundation

enum AuthEndPoint {
    
    private struct AuthRequest: Encodable {
        let email: String
        let password: String
    }
    
    static func request(with email: String, and password: String) throws -> URLRequest {
        let baseURL = URL(string: "http://127.0.0.1:8080/user/auth")!
        let authRequest = AuthRequest(email: email, password: password)
        let data = try JSONEncoder().encode(authRequest)
        
        var request = URLRequest(url: baseURL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-type")
        request.httpBody = data
        
        return request
    }
}
