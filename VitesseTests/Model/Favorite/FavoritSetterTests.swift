//
//  FavoritSetterTests.swift
//  VitesseTests
//
//  Created by Alassane Der on 15/09/2024.
//

import XCTest
@testable import Vitesse

final class FavoritSetterTests: XCTestCase {

    func test_init_DoesNotfavoritRequestUponCreation() {
        let result: Result<(Data, HTTPURLResponse), Error> = .failure(anyNSError())
        
        let (_, client) = makeSUT(result: result)
        
        XCTAssertEqual(client.requests, [])
    }
    
    func test_favoriteSetor_deliversErrorOnClientFailed() async {
        let expectedError = anyNSError()
        let result: Result<(Data, HTTPURLResponse), Error> = .failure(expectedError)
        
        let (sut, _) = makeSUT(result: result)
        
        do {
            _ = try await sut.markCandidateAsFavorite(from: anyURLRequest())
            XCTFail("Expected failure")
        } catch {
            XCTAssertEqual(error as NSError, expectedError)
        }
    }
    
    func test_favoriteSetor_deliversErrorOnMapperFailed() async {
        let result: Result<(Data, HTTPURLResponse), Error> = .success((anyData(), anyHTTPURLResponse()))
        
        let (sut, _) = makeSUT(result: result)
        
        do {
            _ = try await sut.markCandidateAsFavorite(from: anyURLRequest())
            XCTFail("Expected failure")
        } catch {
            XCTAssertEqual(error as! FavoritMapper.Error, .invalideDecodingResponse)
        }
    }
    
    func test_updator_deliversUpdatedCandidateOnSucceedRequest() async {
        let item = makeDetails_Update_Favorite_Item()
        let json = makeItemsJson(item.json)
        let result: Result<(Data, HTTPURLResponse), Error> = .success((json, anyHTTPURLResponse()))
        let (sut, _) = makeSUT(result: result)
        
        do {
            let asFavoriteSeted = try await sut.markCandidateAsFavorite(from: anyURLRequest())
            XCTAssertEqual(asFavoriteSeted, item.model)
        } catch  {
            XCTFail("Expected succes")
        }
        
    }
}

// MARK: helpers
private func makeSUT(result: Result<(Data, HTTPURLResponse), Error>) -> (sut: CandidatesLoader, client: HTTPClientStub) {
    let client = HTTPClientStub(result: result)
    let sut = CandidatesLoader(client: client)
    
    return (sut, client)
}
