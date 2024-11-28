//
//  DetailsLoaderTests.swift
//  VitesseTests
//
//  Created by Alassane Der on 15/09/2024.
//

import XCTest
@testable import Vitesse

final class DetailsLoaderTests: XCTestCase {

    func test_init_doesNotDetailsRequestUponCreation() {
        let result: Result<(Data, HTTPURLResponse), Error> = .failure(anyNSError())
        let (_, client) = makeSUT(result: result)
        XCTAssertEqual(client.requests, [])
    }
    
    func test_detailsLoader_deliversErrorOnClientFailed() async {
        let expectedError = anyNSError()
        let result: Result<(Data, HTTPURLResponse), Error> = .failure(expectedError)
        let (sut, _) = makeSUT(result: result)
        do {
            _ = try await sut.loadDetails(from: anyURLRequest())
            XCTFail("Expected failure")
        } catch {
            XCTAssertEqual(error as NSError, expectedError)
        }
    }

    func test_detailsLoader_deliversErrorOnMapperFailed() async {
        let result: Result<(Data, HTTPURLResponse), Error> = .success((anyData(), anyHTTPURLResponse()))
        let (sut, _) = makeSUT(result: result)
        
        do {
            _ = try await sut.loadDetails(from: anyURLRequest())
            XCTFail("Expected failure")
        } catch {
            XCTAssertEqual(error as! DetailMapper.Error, .invalideDecodingResponse)
        }
    }
    
    func test_detailsLoader_deliversDetailsOnSucceedRequest() async {
        let item = makeDetails_Update_Favorite_Item()
        let json = makeItemsJson(item.json)
        
        let result: Result<(Data, HTTPURLResponse), Error> = .success((json, anyHTTPURLResponse()))
        
        let (sut, _) = makeSUT(result: result)
        
        do {
            let details = try await sut.loadDetails(from: anyURLRequest())
            XCTAssertEqual(details, item.model)
        } catch {
            XCTFail("Expected success")
        }
    }
}

// MARK: helpers
private func makeSUT(result: Result<(Data, HTTPURLResponse), Error>) -> (sut: CandidatesLoader, client: HTTPClientStub) {
    let client = HTTPClientStub(result: result)
    let sut = CandidatesLoader(client: client)
    
    return (sut, client)
}
