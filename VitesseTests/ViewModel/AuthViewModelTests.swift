//
//  AuthViewModelTests.swift
//  VitesseTests
//
//  Created by Alassane Der on 16/09/2024.
//

import XCTest
@testable import Vitesse

final class AuthViewModelTests: XCTestCase {

    func test_init_doesNotTriggerLoginUponCreation() {
        let result: Result<(Data, HTTPURLResponse), Error> = .failure(anyNSError())
        let (_, client, _) = makeSUT(result: result, callback: {})
        
        XCTAssertEqual(client.requests, [])
    }
    
    func test_login_doesNotTriggerLoginSucceedOnInvaliidFields() async {
        let result: Result<(Data, HTTPURLResponse), Error> = .failure(anyNSError())
        var callbackCallCount = 0
        let (sut, _, _) = makeSUT(result: result, callback: {
            callbackCallCount += 1
        })
        
        sut.email = ""
        sut.password = ""
        
        await sut.login()
        
        XCTAssertEqual(callbackCallCount, 0)
        XCTAssertEqual(sut.authenticationMessage, "Login failed: please enter valid email and password.")
    }
    
    func test_login_doesNotTriggerLoginSucceedOnRquestFailed() async {
        let result: Result<(Data, HTTPURLResponse), Error> = .failure(anyNSError())
        var callbackCallCount = 0
        let (sut, _, _) = makeSUT(result: result, callback: {
            callbackCallCount += 1
        })
        
        await sut.login()
        
        XCTAssertEqual(callbackCallCount, 0)
        XCTAssertEqual(sut.authenticationMessage, "Login failed: invalid email or password.")
    }
    
    
    
    func test_login_doesNotTriggerLoginSucceedOnDeleteTokenStoreFailed() async {
        let item = makeAuthItem()
        let json = makeItemsJson(item.json)
        
        let result: Result<(Data, HTTPURLResponse), Error> = .success((json, anyHTTPURLResponse()))
        
        var callbackCallCount = 0
        
        let (sut, _, store) = makeSUT(result: result, callback: {callbackCallCount += 1})
        
        store.completeDeletion(with: anyNSError())
        await sut.login()
        
        XCTAssertEqual(store.receivedMessages, [.delete])
        XCTAssertEqual(callbackCallCount, 0)
        XCTAssertEqual(sut.authenticationMessage, "Login failed: invalid email or password.")
    }
    
    func test_login_doesNotTriggerLoginSucceedOnInsertionTokenStoreFailed() async {
            let item = makeAuthItem()
            let json = makeItemsJson(item.json)
            
            let result: Result<(Data, HTTPURLResponse), Error> = .success((json, anyHTTPURLResponse()))
            
            var callbackCallCount = 0
            
            let (sut, _, store) = makeSUT(result: result, callback: {callbackCallCount += 1})
            
            store.completeDeletionSuccessfully()
            store.completeInsertion(with: anyNSError())
            await sut.login()
            
        XCTAssertEqual(store.receivedMessages, [.delete, .insert])
            XCTAssertEqual(callbackCallCount, 0)
        XCTAssertEqual(sut.authenticationMessage, "Login failed: invalid email or password.")
    }
    
    func test_login_triggersLoginOnSucceedAuthRequestAndStorageTokenCompleted() async {
        let item = makeAuthItem()
        let json = makeItemsJson(item.json)
        
        let result: Result<(Data, HTTPURLResponse), Error> = .success((json, anyHTTPURLResponse()))
        
        var callbackCallCount = 0
        
        let (sut, _, store) = makeSUT(result: result, callback: {callbackCallCount += 1})
        
        store.completeDeletionSuccessfully()
        store.completeInsertionSuccessfully()
        await sut.login()
        
        XCTAssertEqual(store.receivedMessages, [.delete, .insert])
        XCTAssertEqual(callbackCallCount, 1)
    }
    

    
    // MARK: helpers
    private func makeSUT(result: Result<(Data, HTTPURLResponse), Error>, callback: @escaping () -> Void) -> (sut: AuthViewModel, client: HTTPClientStub, token: TokenStoreSpy) {
        let client = HTTPClientStub(result: result)
        let authenticator = Authenticator(client: client)
        let tokenStore = TokenStoreSpy()
        
        let sut = AuthViewModel(authenticator: authenticator, tokenStore: tokenStore, callback)
        
        return (sut, client, tokenStore)
    }
}
