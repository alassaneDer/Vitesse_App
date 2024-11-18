//
//  DetailsMapperTests.swift
//  VitesseTests
//
//  Created by Alassane Der on 14/09/2024.
//

import XCTest
@testable import Vitesse

final class DetailsMapperTests: XCTestCase {

    func test_map_throwsErrorOnNon200HTTPURLResponseStatusCode() throws {
        let wrongsStatusCode = [199, 201, 300, 400, 500]
        
        try wrongsStatusCode.forEach { code in
            XCTAssertThrowsError(
                try DetailMapper.map(anyData(), and: anyHTTPURLResponse(statusCode: code))
            )
        }
    }
    
    func test_map_throwsErrorOnInvalidData() throws {
        XCTAssertThrowsError(
            try DetailMapper.map(anyData(), and: anyHTTPURLResponse())
        )
        
    }
    
    func test_map_deliversDetailsItemOnValidDataAnd200HTTPURLResponseStatusCode() throws {
        let item = makeDetails_Update_Favorite_Item()
        let json = makeItemsJson(item.json)
        
        let candidateDetailItem = try DetailMapper.map(json, and: anyHTTPURLResponse())
        
        XCTAssertEqual(candidateDetailItem, item.model)
    }

}
