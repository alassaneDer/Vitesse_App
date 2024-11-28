//
//  DeleteCandidateTest.swift
//  VitesseTests
//
//  Created by Alassane Der on 24/11/2024.
//

import XCTest
@testable import Vitesse

final class DeleteTest: XCTestCase {

    func test_init_doesNotTriggerDeletionUponCreation() {
        let result: Result<(Data, HTTPURLResponse), Error> = .failure(anyNSError())
        let (sut, client, _) = makeSUT(result: result)
        
        XCTAssertEqual(client.requests, [])
        XCTAssertEqual(sut.list.count, 8)
        XCTAssertEqual(sut.list[0].firstName, "Marcel")
    }

    func test_delete_doesNotTriggerDeletionOnRetrieveTokenFailed() async {
        let result: Result<(Data, HTTPURLResponse), Error> = .failure(anyNSError())
        let (sut, _, store) = makeSUT(result: result)
        
        var callBackCallCount = 0
        var selectedCandidatIDs = [sut.list[0], sut.list[1]]
        
        store.completeRetrieval(with: anyNSError())
        await sut.deleteCandidate(selectedCandidatIDs: selectedCandidatIDs) {
            callBackCallCount += 1
        }
        
        XCTAssertEqual(store.receivedMessages, [.retrieve])
        XCTAssertEqual(sut.list.count, 8)
        XCTAssertEqual(sut.list[0].firstName, "Marcel")
        XCTAssertEqual(sut.list[1].firstName, "Antoine")
        XCTAssertEqual(callBackCallCount, 0)
    }
    
    func test_delete_doesNotTriggerDeletionOnRetrieveRequestFailed() async {
        let result: Result<(Data, HTTPURLResponse), Error> = .failure(anyNSError())
        let (sut, _, store) = makeSUT(result: result)
        
        var callBackCallCount = 0
        var selectedCandidatIDs = [sut.list[0], sut.list[1]]
        
        store.completeRetrieval(with: anyData())
        await sut.deleteCandidate(selectedCandidatIDs: selectedCandidatIDs) {
            callBackCallCount += 1
        }
        
        
        XCTAssertEqual(store.receivedMessages, [.retrieve])
        XCTAssertEqual(sut.list.count, 8)
        XCTAssertEqual(sut.list[0].firstName, "Marcel")
        XCTAssertEqual(sut.list[1].firstName, "Antoine")
        XCTAssertEqual(callBackCallCount, 0)
    }
    


    // MARK: helpers
    
    private func makeSUT(result: Result<(Data, HTTPURLResponse), Error>) -> (sut: ListViewModel, client: HTTPClientStub, store: TokenStoreSpy) {
        
        let client = HTTPClientStub(result: result)
        let candidatesLoader = CandidatesLoader(client: client)
        let tokenStore = TokenStoreSpy()
        let sut = ListViewModel(candidateLoader: candidatesLoader, tokenStore: tokenStore)
        
        return (sut, client, tokenStore)
    }

}
