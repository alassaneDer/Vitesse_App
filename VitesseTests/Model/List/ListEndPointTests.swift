//
//  ListEndPointTests.swift
//  VitesseTests
//
//  Created by Alassane Der on 14/09/2024.
//

import XCTest
@testable import Vitesse

final class ListEndPointTests: XCTestCase {

    func test_buildsListRequest() throws {
        let token = "token"
        
        let sut = ListEndPoint.request(token: token)
        
        XCTAssertEqual(sut.url, URL(string: "http://127.0.0.1:8080/candidate")!)
        XCTAssertEqual(sut.httpMethod, "GET")
        XCTAssertEqual(sut.allHTTPHeaderFields, ["Authorization": "Bearer \(token)"])
        XCTAssertNil(sut.httpBody)
    }

}
