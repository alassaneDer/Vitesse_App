//
//  UpdatorTests.swift
//  VitesseTests
//
//  Created by Alassane Der on 15/09/2024.
//

import XCTest
@testable import Vitesse

final class UpdatorTests: XCTestCase {

    func test_init_DoesNotUpdateRequestUponCreation() {
        let result: Result<(Data, HTTPURLResponse), Error> = .failure(anyNSError())
        
        let (_, client) = makeSUT(result: result)
        
        XCTAssertEqual(client.requests, [])
    }
    
    func test_updator_deliversErrorOnClientFailed() async {
        let expectedError = anyNSError()
        let result: Result<(Data, HTTPURLResponse), Error> = .failure(expectedError)
        
        let (sut, _) = makeSUT(result: result)
        
        do {
            _ = try await sut.update(from: anyURLRequest())
            XCTFail("Expected failure")
        } catch {
            XCTAssertEqual(error as NSError, expectedError)
        }
    }
    
    func test_updator_deliversErrorOnMapperFailed() async {
        let result: Result<(Data, HTTPURLResponse), Error> = .success((anyData(), anyHTTPURLResponse()))
        
        let (sut, _) = makeSUT(result: result)
        
        do {
            _ = try await sut.update(from: anyURLRequest())
            XCTFail("Expected failure")
        } catch {
            XCTAssertEqual(error as! UpdateCandidatsMapper.Error, .invalidDecodingResponseUPD)
        }
    }
    
    func test_updator_deliversUpdatedCandidateOnSucceedRequest() async {
        let item = makeDetails_Update_Favorite_Item()
        let json = makeItemsJson(item.json)
        let result: Result<(Data, HTTPURLResponse), Error> = .success((json, anyHTTPURLResponse()))
        let (sut, _) = makeSUT(result: result)
        
        do {
            let updatedCandidate = try await sut.update(from: anyURLRequest())
            XCTAssertEqual(updatedCandidate, item.model)
        } catch  {
            XCTFail("Expected succes")
        }
        
    }
}

// MARK: helpers
private func makeSUT(result: Result<(Data, HTTPURLResponse), Error>) -> (sut: Updator, client: HTTPClientStub) {
    let client = HTTPClientStub(result: result)
    let sut = Updator(client: client)
    
    return (sut, client)
}