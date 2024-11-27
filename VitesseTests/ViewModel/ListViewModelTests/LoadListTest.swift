//
//  LoadListTest.swift
//  VitesseTests
//
//  Created by Alassane Der on 24/11/2024.
//

import XCTest
@testable import Vitesse

final class LoadListTest: XCTestCase {

    func test_init_doesNotTriggerLoadListUponCreation() {
        let result: Result<(Data, HTTPURLResponse), Error> = .failure(anyNSError())
        let (sut, client, _) = makeSUT(result: result)
        
        XCTAssertEqual(client.requests, [])
        XCTAssertEqual(sut.list.count, 8)
        XCTAssertEqual(sut.list[0].firstName, "Marcel")
    }

    func test_loadList_doesNotTriggerLoadListOnRetrieveTokenFailed() async {
        let result: Result<(Data, HTTPURLResponse), Error> = .failure(anyNSError())
        let (sut, _, store) = makeSUT(result: result)
        
        store.completeRetrieval(with: anyNSError())
        
        await sut.loadList()
        
        XCTAssertEqual(store.receivedMessages, [.retrieve])
        XCTAssertEqual(sut.list.count, 8)
        XCTAssertEqual(sut.list[0].firstName, "Marcel")
    }
    
    func test_loadList_doesNotTriggerLoadListOnRetrieveRequestFailed() async {
        let result: Result<(Data, HTTPURLResponse), Error> = .failure(anyNSError())
        let (sut, client, store) = makeSUT(result: result)
        
        store.completeRetrieval(with: anyData())
        
        await sut.loadList()
        XCTAssertEqual(store.receivedMessages, [.retrieve])
        XCTAssertEqual(sut.list.count, 8)
        XCTAssertEqual(sut.list[0].firstName, "Marcel")
    }
    
    func test_loadList_triggerLoadListOnSucceedRequestAndRetrieveTokenCompleted() async {
        let (candidateItem, json) = makeListItem()
        let data = makeListItemJson(json)
        let result: Result<(Data, HTTPURLResponse), Error> = .success( (data, HTTPURLResponse()) )
        let (sut, _, store) = makeSUT(result: result)
        
        store.completeRetrieval(with: anyData())
        await sut.loadList()
        
        XCTAssertEqual(store.receivedMessages, [.retrieve])
        XCTAssertEqual(sut.list.count, 2)
        XCTAssertEqual(sut.list[0].firstName, "a firstName")
        
    }

    // MARK: helpers
    
    private func makeSUT(result: Result<(Data, HTTPURLResponse), Error>) -> (sut: ListViewModel, client: HTTPClientStub, store: TokenStoreSpy) {
        
        let client = HTTPClientStub(result: result)
        let loader = ListLoader(client: client)
        let tokenStore = TokenStoreSpy()
        let sut = ListViewModel(loader: loader, tokenStore: tokenStore)
        
        return (sut, client, tokenStore)
    }
}
