//
//  DeleteEndPoint.swift
//  Vitesse
//
//  Created by Alassane Der on 07/09/2024.
//

import Foundation

enum DeleteEndPoint {
    static func request(token: String, candidatID: String) -> URLRequest {
        let baseURL = URL(string: "http://127.0.0.1:8080/candidate/\(candidatID)")!
        var request = URLRequest(url: baseURL)
        request.httpMethod = "DELETE"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        return request
    }
}
