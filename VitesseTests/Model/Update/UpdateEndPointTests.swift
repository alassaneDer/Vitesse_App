//
//  UpdateEndPointTests.swift
//  VitesseTests
//
//  Created by Alassane Der on 14/09/2024.
//

import XCTest
@testable import Vitesse

final class UpdateEndPointTests: XCTestCase {

    func test_buildsUpdateRequest() throws {
        let token = "a token"
        let candidateID = "a candidateID"
        
        let email = "an email"
        let note = "a note"
        let linkedinURL = "a linkedInURL"
        let firstName = "a firstName"
        let lastName = "a lastName"
        let phone = "0799887766"
        
        let sut = try UpdateEndPoint.request(token: token, candidateId: candidateID, email: email, note: note, linkedinURL: linkedinURL, firstName: firstName, lastName: lastName, phone: phone)
    
        
        XCTAssertEqual(sut.url, URL(string: "http://127.0.0.1:8080/candidate/\(candidateID)")!)
        XCTAssertEqual(sut.httpMethod, "PUT")
        XCTAssertEqual(sut.allHTTPHeaderFields, ["Content-Type": "application/json", "Authorization": "Bearer \(token)"])
        
        XCTAssertNotNil(sut.httpBody)
    }

}
