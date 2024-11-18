//
//  SetAsFavoriteTests.swift
//  VitesseTests
//
//  Created by Alassane Der on 23/09/2024.
//

import XCTest
@testable import Vitesse

final class SetAsFavoriteTests: XCTestCase {

    func test_init_doesNotTriggerSetAsFavoriteUponCreation() {
        let result: Result<(Data, HTTPURLResponse), Error> = .failure(anyNSError())
        let (sut, client, _) = makeFavoriteSUT(result: result)
        
        XCTAssertEqual(client.requests, [])
        XCTAssertEqual(sut.phone, "")
        XCTAssertEqual(sut.note, "")
        XCTAssertEqual(sut.id, "")
        XCTAssertEqual(sut.firstName, "")
        XCTAssertEqual(sut.linkedinURL, "")
        XCTAssertEqual(sut.isFavorite, false)
        XCTAssertEqual(sut.email, "")
        XCTAssertEqual(sut.lastName, "")
    }
    
    
    func test_update_doesNotTriggerUpdatedDetailsSucceedOnRetrieveTokenFailed() async throws {
        let result: Result<(Data, HTTPURLResponse), Error> = .failure(anyNSError())
        let (sut, _, store) = makeFavoriteSUT(result: result)
        
        // simule echec de la récupération du token
        store.completeRetrieval(with: anyNSError())
        
        do {
            _ = try await sut.setAsFavorite(candidatID: "an id")
            XCTFail("Ecpected failure due to token retrieval failed")
        } catch {
            XCTAssertEqual(store.receivedMessages, [.retrieve])
            XCTAssertEqual(sut.firstName, "")
        }
        
    }
    
    func test_update_doesNotTriggerUpdatedDetailsSucceedOnRequestFailed() async throws {
        let result: Result<(Data, HTTPURLResponse), Error> = .failure(anyNSError())
        let (sut, _, store) = makeFavoriteSUT(result: result)
        
        // simule echec de la récupération du token
        store.completeRetrieval(with: anyData())
        
        do {
            _ = try await sut.setAsFavorite(candidatID: "an id")
            XCTFail("Ecpected failure due to failed Request")
        } catch {
            XCTAssertEqual(store.receivedMessages, [.retrieve])
            XCTAssertEqual(sut.firstName, "")
        }
        
    }
    
    func testLoadDetailsSuccess() async throws {
        // Prepare a successful result with fake data and HTTP response
        let (candidateItem, json) = makeDetails_Update_Favorite_Item()
        let data = makeItemsJson(json)
        let result: Result<(Data, HTTPURLResponse), Error> = .success((data, anyHTTPURLResponse(statusCode: 200)))
        
        // Create the system under test (sut) using makeLoadDetailsSUT
        let (sut, _, store) = makeFavoriteSUT(result: result)
        
        // token
        store.completeRetrieval(with: anyData())
        
        // Call the method to test
        let updatedCandidate = try await sut.setAsFavorite(candidatID: "an id")
        
        // Verify the result
        XCTAssertEqual(updatedCandidate.phone, candidateItem.phone)
        XCTAssertEqual(updatedCandidate.note, candidateItem.note)
        XCTAssertEqual(updatedCandidate.firstName, candidateItem.firstName)
        XCTAssertEqual(updatedCandidate.email, candidateItem.email)
        XCTAssertEqual(updatedCandidate.linkedinURL, candidateItem.linkedinURL)
    }
    
    
    
    //MARK: HELPERS
    private func makeFavoriteSUT(result: Result<(Data, HTTPURLResponse), Error>) -> (favoriteSut: DetailsViewModel, client: HTTPClientStub, store: TokenStoreSpy) {
        let client = HTTPClientStub(result: result)
        let asFavoriteSetor = AsFavoriteSetor(client: client)
        let tokenStore = TokenStoreSpy()
        let sut = DetailsViewModel(asFavoritSetor: asFavoriteSetor, tokenStore: tokenStore)
        
        return(sut, client, tokenStore)
    }

}
