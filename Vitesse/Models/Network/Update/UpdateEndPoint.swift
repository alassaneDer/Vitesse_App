//
//  UpdateEndPoint.swift
//  Vitesse
//
//  Created by Alassane Der on 07/09/2024.
//

import Foundation
enum UpdateEndPoint {
    
    struct UpdateRequestBody: Encodable {
        let email: String
        let note: String?
        let linkedinURL: String?
        let firstName: String
        let lastName: String
        let phone: String
    }
    
    static func request(token: String, candidateId: String, email: String, note: String, linkedinURL: String, firstName: String, lastName: String, phone: String) throws -> URLRequest {
        let baseURL = URL(string: "http://127.0.0.1:8080/candidate/\(candidateId)")!
        var request = URLRequest(url: baseURL)
        request.httpMethod = "PUT"

        
        let updateRequestBody = UpdateRequestBody(email: email, note: note, linkedinURL: linkedinURL, firstName: firstName, lastName: lastName, phone: phone)
        let data = try JSONEncoder().encode(updateRequestBody)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = data
        
        
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        return request
    }
    
}
