//
//  DetailsLoadTest.swift
//  VitesseTests
//
//  Created by Alassane Der on 23/09/2024.
//

import XCTest
@testable import Vitesse

final class LoadDetailsTest: XCTestCase {
    
    func test_init_doesNotTriggerLoadDetailsUponCreation() {
        let result: Result<(Data, HTTPURLResponse), Error> = .failure(anyNSError())
        let (sut, client, _) = makeLoadDetailsSUT(result: result)
        
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
    
    func test_loadDetails_doesNotTriggerLoadDetailsSucceedOnRetrieveTokenFailed() async throws {
        let result: Result<(Data, HTTPURLResponse), Error> = .failure(anyNSError())
        let (sut, _, store) = makeLoadDetailsSUT(result: result)
        
        // simule echec de la récupération du token
        store.completeRetrieval(with: anyNSError())
        
        do {
            _ = try await sut.loadDetails(by: "an id")
            XCTFail("Ecpected failure due to token retrieval failure, but got success")
        } catch {
            XCTAssertEqual(store.receivedMessages, [.retrieve])
            XCTAssertEqual(sut.phone, "071122334455")
        }
        
    }
    
    func test_loadDetails_doesNotTriggerLoadDetailsSucceedOnRequestFailed() async throws {
        let result: Result<(Data, HTTPURLResponse), Error> = .failure(anyNSError())
        let (sut, _, store) = makeLoadDetailsSUT(result: result)
        
        // simule echec de la récupération du token
        store.completeRetrieval(with: anyData())
        
        do {
            _ = try await sut.loadDetails(by: "an id")
            XCTFail("Ecpected failure due to token retrieval failed request")
        } catch {
            XCTAssertEqual(store.receivedMessages, [.retrieve])
            XCTAssertEqual(sut.phone, "071122334455")
        }
        
    }
    
    func testLoadDetailsSuccess() async throws {
        // Prepare a successful result with fake data and HTTP response
        let (candidateItem, json) = makeDetails_Update_Favorite_Item()
        let data = makeItemsJson(json)
        let result: Result<(Data, HTTPURLResponse), Error> = .success((data, anyHTTPURLResponse(statusCode: 200)))
        
        // Create the system under test (sut) using makeLoadDetailsSUT
        let (sut, _, store) = makeLoadDetailsSUT(result: result)
        
        // token
        store.completeRetrieval(with: anyData())
        
        // Call the method to test
        let candidate = try await sut.loadDetails(by: "an id")
        
        // Verify the result
        XCTAssertEqual(candidate.phone, candidateItem.phone)
        XCTAssertEqual(candidate.note, candidateItem.note)
        XCTAssertEqual(candidate.firstName, candidateItem.firstName)
        XCTAssertEqual(candidate.email, candidateItem.email)
        XCTAssertEqual(candidate.linkedinURL, candidateItem.linkedinURL)
    }
    
    // MARK: upload details on main thread
    
    func test_updateDetailsOnMainThreadFailedIfLoadsDetailsRequestFailed() async throws {
        let result: Result<(Data, HTTPURLResponse), Error> = .failure(anyNSError())
        let (sut, _, store) = makeLoadDetailsSUT(result: result)
        
        // simule echec de la récupération du token
        store.completeRetrieval(with: anyData())
        
        await sut.updateDetailsOnMainThread(for: "an id")
            
        XCTAssertEqual(store.receivedMessages, [.retrieve])
            
        XCTAssertEqual(sut.phone, "071122334455")
        XCTAssertEqual(sut.message, "Sorry can't load candidate details, please try later.")
        
    }
    
    func test_updateDetailsOnMainThreadSucceedIfLoadsDetailsRequestSucceed() async throws {
        // Prepare a successful result with fake data and HTTP response
        let (candidateItem, json) = makeDetails_Update_Favorite_Item()
        let data = makeItemsJson(json)
        let result: Result<(Data, HTTPURLResponse), Error> = .success((data, anyHTTPURLResponse(statusCode: 200)))
        
        // Create the system under test (sut) using makeLoadDetailsSUT
        let (sut, _, store) = makeLoadDetailsSUT(result: result)
        
        // token
        store.completeRetrieval(with: anyData())
        
        // Call the method to test
        await sut.updateDetailsOnMainThread(for: "an id")
        
        // Verify the result
        XCTAssertEqual(sut.phone, candidateItem.phone)
        XCTAssertEqual(sut.note, candidateItem.note)
        XCTAssertEqual(sut.firstName, candidateItem.firstName)
        XCTAssertEqual(sut.email, candidateItem.email)
        XCTAssertEqual(sut.linkedinURL, candidateItem.linkedinURL)
    }
    
    // MARK: showtemporary toast func tests
    
    func testShowTemporaryToast_mustDisplayMessage_untilTheDelayCompleted() {
        // Prepare a successful result with fake data and HTTP response
        let (candidateItem, json) = makeDetails_Update_Favorite_Item()
        let data = makeItemsJson(json)
        let result: Result<(Data, HTTPURLResponse), Error> = .success((data, anyHTTPURLResponse(statusCode: 200)))
        
        // Create the system under test (sut) using makeLoadDetailsSUT
        let (sut, _, store) = makeLoadDetailsSUT(result: result)
        
        // token
        store.completeRetrieval(with: anyData())
        
        sut.message = "Hello, World!"
        
        let expectation = self.expectation(description: "Toast message should be cleared after delay")
        
        sut.showTemporaryToast()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.1) {
                   // THEN: Vérifier que le message est bien vidé
                   XCTAssertEqual(sut.message, "Hello, World!", "The message should be cleared only after the delay")
            expectation.fulfill()
            }
        
        waitForExpectations(timeout: 6, handler: nil)

    }
    
    func testShowTemporaryToast_mustClearMessage_ifTheDelayCompleted() {
        // Prepare a successful result with fake data and HTTP response
        let (candidateItem, json) = makeDetails_Update_Favorite_Item()
        let data = makeItemsJson(json)
        let result: Result<(Data, HTTPURLResponse), Error> = .success((data, anyHTTPURLResponse(statusCode: 200)))
        
        // Create the system under test (sut) using makeLoadDetailsSUT
        let (sut, _, store) = makeLoadDetailsSUT(result: result)
        
        // token
        store.completeRetrieval(with: anyData())
        
        sut.message = "Hello, World!"
        
        let expectation = self.expectation(description: "Toast message should be cleared after delay")
        
        sut.showTemporaryToast()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.1) {
                   // THEN: Vérifier que le message est bien vidé
                   XCTAssertEqual(sut.message, "", "The message should be cleared after the delay")
            expectation.fulfill()
            }
        
        waitForExpectations(timeout: 6, handler: nil)

    }
    //MARK: HELPERS
    
    private func makeLoadDetailsSUT(result: Result<(Data, HTTPURLResponse), Error>) -> (detailSut: DetailsViewModel, client: HTTPClientStub, store: TokenStoreSpy) {
        let client = HTTPClientStub(result: result)
        let candidatesLoader = CandidatesLoader(client: client)
        let tokenStore = TokenStoreSpy()
        let detailsSut = DetailsViewModel(candidatesLoader: candidatesLoader, tokenStore: tokenStore)
        
        return(detailsSut, client, tokenStore)
    }
    
}
