//
//  HTTPClientStub.swift
//  VitesseTests
//
//  Created by Alassane Der on 12/09/2024.
//
import Foundation
@testable import Vitesse

final class HTTPClientStub: HTTPClient {
    
    private let result: Result<(Data, HTTPURLResponse), Error>
    private(set) var requests: [URLRequest] = []
    
    init(result: Result<(Data, HTTPURLResponse), Error>) {
        self.result = result
    }
    
    func request(from request: URLRequest) async throws -> (Data, HTTPURLResponse) {
        requests.append(request)
        
        return try result.get()
    }
    
}
