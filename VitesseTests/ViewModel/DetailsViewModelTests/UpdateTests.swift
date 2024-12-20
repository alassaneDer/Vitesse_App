//
//  UpdateTests.swift
//  VitesseTests
//
//  Created by Alassane Der on 23/09/2024.
//

import XCTest
@testable import Vitesse

final class UpdateTests: XCTestCase {

    
    func test_init_doesNotTriggerUpdatesUponCreation() {
        let result: Result<(Data, HTTPURLResponse), Error> = .failure(anyNSError())
        let (sut, client, _) = makeUpdateSUT(result: result)
        
        XCTAssertEqual(client.requests, [])
        XCTAssertEqual(sut.phone, "071122334455")
        XCTAssertEqual(sut.note, "note to detail")
        XCTAssertEqual(sut.id, "1")
        XCTAssertEqual(sut.firstName, "John")
        XCTAssertEqual(sut.linkedinURL, "fakeLinkedInURL.com")
        XCTAssertEqual(sut.isFavorite, false)
        XCTAssertEqual(sut.email, "johndoe@test.com")
        XCTAssertEqual(sut.lastName, "Doe")
    }
    
    
    func test_update_doesNotTriggerUpdatedDetailsSucceedOnRetrieveTokenFailed() async throws {
        let result: Result<(Data, HTTPURLResponse), Error> = .failure(anyNSError())
        let (sut, _, store) = makeUpdateSUT(result: result)
        
        // simule echec de la récupération du token
        store.completeRetrieval(with: anyNSError())
        
        do {
            _ = try await sut.update(by: "an id")
            XCTFail("Ecpected failure due to token retrieval failed")
        } catch {
            XCTAssertEqual(store.receivedMessages, [.retrieve])
            XCTAssertEqual(sut.firstName, "John")
            XCTAssertEqual(sut.message, "Sorry can't update this candidate now, please try later.")
        }
        
    }
    
    func test_update_doesNotTriggerUpdatedDetailsSucceedOnRequestFailed() async throws {
        let result: Result<(Data, HTTPURLResponse), Error> = .failure(anyNSError())
        let (sut, _, store) = makeUpdateSUT(result: result)
        
        // simule echec de la récupération du token
        store.completeRetrieval(with: anyData())
        
        do {
            _ = try await sut.update(by: "an id")
            XCTFail("Ecpected failure due to failed Request")
        } catch {
            XCTAssertEqual(store.receivedMessages, [.retrieve])
            XCTAssertEqual(sut.firstName, "John")
            XCTAssertEqual(sut.message, "Sorry can't update this candidate now, please try later.")
        }
        
    }
    
    func testLoadDetailsSuccess() async throws {
        // Prepare a successful result with fake data and HTTP response
        let (candidateItem, json) = makeDetails_Update_Favorite_Item()
        let data = makeItemsJson(json)
        let result: Result<(Data, HTTPURLResponse), Error> = .success((data, anyHTTPURLResponse(statusCode: 200)))
        
        // Create the system under test (sut) using makeLoadDetailsSUT
        let (sut, _, store) = makeUpdateSUT(result: result)
        
        // token
        store.completeRetrieval(with: anyData())
        
        // Call the method to test
        let updatedCandidate = try await sut.update(by: "an id")
        
        // Verify the result
        XCTAssertEqual(updatedCandidate.phone, candidateItem.phone)
        XCTAssertEqual(updatedCandidate.note, candidateItem.note)
        XCTAssertEqual(updatedCandidate.firstName, candidateItem.firstName)
        XCTAssertEqual(updatedCandidate.email, candidateItem.email)
        XCTAssertEqual(updatedCandidate.linkedinURL, candidateItem.linkedinURL)
        XCTAssertEqual(sut.message, "Candidate details successfully updated")
    }

    
    //MARK: HELPERS
    private func makeUpdateSUT(result: Result<(Data, HTTPURLResponse), Error>) -> (updateSut: DetailsViewModel, client: HTTPClientStub, store: TokenStoreSpy) {
        let client = HTTPClientStub(result: result)
        let candidatesLoader = CandidatesLoader(client: client)
        let tokenStore = TokenStoreSpy()
        let sut = DetailsViewModel(candidatesLoader: candidatesLoader, tokenStore: tokenStore)
        
        return(sut, client, tokenStore)
    }

}
