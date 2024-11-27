//
//  RegisterEndPoint.swift
//  Vitesse
//
//  Created by Alassane Der on 07/09/2024.
//

import Foundation

enum RegisterEndPoint {
    private struct RegisterRequest: Encodable {
        let email: String
        let password: String
        let firstName: String
        let lastName: String
    }
    
    static func request(email: String, password: String, firstName: String, lastName: String) throws -> URLRequest {
        let baseURL = URL(string: "http://127.0.0.1:8080/user/register")!
        
        let registerRequest = RegisterRequest(email: email, password: password, firstName: firstName, lastName: lastName)
        let data = try JSONEncoder().encode(registerRequest)
        
        var request = URLRequest(url: baseURL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = data
        
        return request
    }
}
