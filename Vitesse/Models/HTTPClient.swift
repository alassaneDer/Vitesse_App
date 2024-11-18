//
//  HTTPClient.swift
//  Vitesse
//
//  Created by Alassane Der on 07/09/2024.
//

import Foundation

protocol HTTPClient {
    func request(from request: URLRequest) async throws -> (Data, HTTPURLResponse)
}
