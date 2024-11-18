//
//  AuthenticatorTests.swift
//  VitesseTests
//
//  Created by Alassane Der on 13/09/2024.
//

import XCTest
@testable import Vitesse

final class AuthenticatorTests: XCTestCase {

    func test_init_doesNotTokenRequestUponCreation() {
        let result: Result<(Data, HTTPURLResponse), Error> =
            .failure(anyNSError())
        
        let (_, client) = makeSUT(result: result)
        
        XCTAssertEqual(client.requests, [])
    }
    func test_auth_deliversErrorOnClientFailed() async {
        let expectedError = anyNSError()
        let result: Result<(Data, HTTPURLResponse), Error> =
            .failure(expectedError)
        
        let (sut, _) = makeSUT(result: result)
        
        do {
            _ = try await sut.authRequest(from: anyURLRequest())
            XCTFail("Expected failure")
        } catch {
            XCTAssertEqual(error as NSError, expectedError)
        }
    }
    
    func test_auth_deliversErrorOnMapperFailed() async {
        let result: Result<(Data, HTTPURLResponse), Error> = .success((anyData(), anyHTTPURLResponse()))
        let (sut, _) = makeSUT(result: result)
        
        do {
            _ = try await sut.authRequest(from: anyURLRequest())
            XCTFail("Expected failure")
        } catch {
            XCTAssertEqual(error as! AuthMapper.Error, .invalidDecodingResponse)
        }
    }
    
    func test_auth_deliversTokenOnSucceedRequest() async {
        let item = makeAuthItem()
        let json = makeItemsJson(item.json)
        let result: Result<(Data, HTTPURLResponse), Error> = .success((json, anyHTTPURLResponse()))
        let (sut, _) = makeSUT(result: result)
        
        do {
            let authItem = try await sut.authRequest(from: anyURLRequest())
            XCTAssertEqual(authItem, item.model)
        } catch {
            XCTFail("Expected success")
        }
    }
    
    
    
    // MARK: Helpers
    
    private func makeSUT(result: Result<(Data, HTTPURLResponse), Error>) -> (sut: Authenticator, client: HTTPClientStub) {
        let client = HTTPClientStub(result: result)
        let sut = Authenticator(client: client)
        
        return (sut, client)
    }
    

}
