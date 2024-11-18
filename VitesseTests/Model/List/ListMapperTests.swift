//
//  ListMapperTests.swift
//  VitesseTests
//
//  Created by Alassane Der on 14/09/2024.
//

import XCTest
@testable import Vitesse

final class ListMapperTests: XCTestCase {
    
    func test_map_throwsErrorOnNon200HTTPURLResponseStatusCode() throws {
        let wrongsStatusCode = [199, 201, 300, 400, 500]
        
        try wrongsStatusCode.forEach { code in
            XCTAssertThrowsError(
                try ListMapper.map(anyData(), and: anyHTTPURLResponse(statusCode: code))
            )
        }
    }
    
    func test_map_throwsErrorOnInvalidData() {
        XCTAssertThrowsError(
            try ListMapper.map(anyData(), and: anyHTTPURLResponse())
        )
    }
    
    func test_map_deliversCandidateItemOnValidDataAnd200HTTPURLResponseStatusCode() throws {
        let item = makeListItem()
        let json = makeListItemJson(item.json)
        
        let candidateItem = try ListMapper.map(json, and: anyHTTPURLResponse())
        
        XCTAssertEqual(candidateItem, item.model)
    }
    
}

