//
//  FavoritsEndPointTests.swift
//  VitesseTests
//
//  Created by Alassane Der on 14/09/2024.
//

import XCTest
@testable import Vitesse

final class FavoritsEndPointTests: XCTestCase {

    func test_builsFavoritRequest() throws {
        let token = "a token"
        let candidateID = "a candidateID"
        
        let sut = FavoritEndPoint.request(token: token, candidateID: candidateID)
        
        XCTAssertEqual(sut.url, URL(string: "http://127.0.0.1:8080/candidate/\(candidateID)/favorite")!)
        XCTAssertEqual(sut.httpMethod, "PUT")
        XCTAssertEqual(sut.allHTTPHeaderFields, ["Authorization": "Bearer \(token)"])
        
        XCTAssertNil(sut.httpBody)
    }

}
