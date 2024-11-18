//
//  AuthMapperTests.swift
//  VitesseTests
//
//  Created by Alassane Der on 13/09/2024.
//

import XCTest
@testable import Vitesse

final class AuthMapperTests: XCTestCase {

    func test_map_throwsErrorOnANon200HTTPURLResponseStatusCode() throws {
        let wrongStatusCodes = [199, 201, 300, 400, 500]
        
        try wrongStatusCodes.forEach { code in
            XCTAssertThrowsError(
                try AuthMapper.map(anyData(), and: anyHTTPURLResponse(statusCode: code))
            )
        }
    }
    
    func test_map_throwsErrorOnInvalidData() {
        XCTAssertThrowsError(
            try AuthMapper.map(anyData(), and: anyHTTPURLResponse())
        )
    }
    
    func test_map_deliversAuthItemOnAValidDataAnd200HTTPURLResponseStatusCode() throws {
        let item = makeAuthItem()
        let json = makeItemsJson(item.json)

        let authItem = try AuthMapper.map(json, and: anyHTTPURLResponse())

        XCTAssertEqual(authItem, item.model)
    }
}
