//
//  AuthEndPointTests.swift
//  VitesseTests
//
//  Created by Alassane Der on 13/09/2024.
//

import XCTest
@testable import Vitesse

final class AuthEndPointTests: XCTestCase {

    func test_buildsTheAuthRequest() throws {
        let email = "email@test.fake"
        let password = "a password"
        
        let sut = try AuthEndPoint.request(with: email, and: password)
        
        XCTAssertEqual(sut.url, URL(string: "http://127.0.0.1:8080/user/auth")!)
        XCTAssertEqual(sut.httpMethod, "POST")
        XCTAssertEqual(sut.allHTTPHeaderFields, ["Content-Type": "application/json"])
        XCTAssertNotNil(sut.httpBody)
    }

}
