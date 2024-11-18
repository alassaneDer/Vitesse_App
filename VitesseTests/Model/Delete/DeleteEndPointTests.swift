//
//  DeleteEndPointTests.swift
//  VitesseTests
//
//  Created by Alassane Der on 14/09/2024.
//

import XCTest
@testable import Vitesse

final class DeleteEndPointTests: XCTestCase {

    func test_buildDeleteRequest() throws {
        let token = "a token"
        let candidateID = "a candidateID"
        
        let sut = DeleteEndPoint.request(token: token, candidatID: candidateID)
        
        XCTAssertEqual(sut.url, URL(string: "http://127.0.0.1:8080/candidate/\(candidateID)")!)
        XCTAssertEqual(sut.httpMethod, "DELETE")
        XCTAssertEqual(sut.allHTTPHeaderFields, ["Authorization": "Bearer \(token)"])
        XCTAssertNil(sut.httpBody)
    }

}
