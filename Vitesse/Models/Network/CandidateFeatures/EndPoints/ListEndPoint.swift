//
//  ListEndPoint.swift
//  Vitesse
//
//  Created by Alassane Der on 07/09/2024.
//

import Foundation

enum ListEndPoint {
    static func request(token: String) -> URLRequest {
        let baseURL = URL(string: "http://127.0.0.1:8080/candidate")!
        var request = URLRequest(url: baseURL)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        return request
    }
}
