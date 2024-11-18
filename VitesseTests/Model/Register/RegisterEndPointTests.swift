//
//  RegisterEndPointTests.swift
//  VitesseTests
//
//  Created by Alassane Der on 14/09/2024.
//

import XCTest
@testable import Vitesse

final class RegisterEndPointTests: XCTestCase {

    func test_buildsTheRegisterRequest() throws {
        let email = "email@test.fake"
        let password = "a password"
        let firstName = "a firstName"
        let lastName = "a lastName"
        
        let sut = try RegisterEndPoint.request(email: email, password: password, firstName: firstName, lastName: lastName)
        
        XCTAssertEqual(sut.url, URL(string: "http://127.0.0.1:8080/user/register")!)
        XCTAssertEqual(sut.httpMethod, "POST")
        XCTAssertEqual(sut.allHTTPHeaderFields, ["Content-Type": "application/json"])
        XCTAssertNotNil(sut.httpBody)
    }

}
