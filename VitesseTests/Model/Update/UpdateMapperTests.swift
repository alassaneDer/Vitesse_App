//
//  UpdateMapperTests.swift
//  VitesseTests
//
//  Created by Alassane Der on 14/09/2024.
//
import XCTest
@testable import Vitesse

final class UpdateMapperTests: XCTestCase {

    func test_map_throwsErrorOnNon200HTTPURLResponseStatusCode() throws {
        let wrongsStatusCode = [199, 201, 300, 400, 500]
        
        try wrongsStatusCode.forEach { code in
            XCTAssertThrowsError(
                try UpdateCandidatsMapper.map(anyData(), and: anyHTTPURLResponse(statusCode: code))
            )
        }
    }
    
    func test_map_throwsErrorOnInvalidData() throws {
        XCTAssertThrowsError(
            try UpdateCandidatsMapper.map(anyData(), and: anyHTTPURLResponse())
        )
    }
    
    func test_map_deliversUpdatedCandidateOnValidDatasAnd200HTTPURLResponseStatusCode() throws {
        let item = makeDetails_Update_Favorite_Item()
        let json = makeItemsJson(item.json)
        
        let updatedCandidat = try UpdateCandidatsMapper.map(json, and: anyHTTPURLResponse())
        
        XCTAssertEqual(updatedCandidat, item.model)
    }

}
