//
//  registerMapperTests.swift
//  VitesseTests
//
//  Created by Alassane Der on 14/09/2024.
//

import XCTest
@testable import Vitesse

final class registerMapperTests: XCTestCase {

    func test_init_doesNotRegisterRequestUponCreation() throws {
        let result: Result<(Data, HTTPURLResponse), Error> = .failure(anyNSError())
        let (_, client) = makeSUT(result: result)
        
        XCTAssertEqual(client.requests, [])
    }
    
    func test_registor_deliversErrorOnClientFailed() async {
        let expectedError = anyNSError()
        let result: Result<(Data, HTTPURLResponse), Error> = .failure(expectedError)
        let (sut, _) = makeSUT(result: result)
        
        do {
            try await sut.register(from: anyURLRequest())
            XCTFail("Expected failure")
        } catch {
            XCTAssertEqual(error as NSError, expectedError)
        }
    }
    
    func test_registor_deliversErrorOnANon201HTTPURLResponseStatusCode() async {
        let result: Result<(Data, HTTPURLResponse), Error> = .success((anyData(), anyHTTPURLResponse(statusCode: 300)))
        let (sut, _) = makeSUT(result: result)
        do {
            try await sut.register(from: anyURLRequest())
            XCTFail("Expected failure")
        } catch {
            XCTAssertEqual(error as! Registor.Error, .invalidResponseStatusCode)
        }
    }
    
    func test_registor_deliversRegisterSucceded() async {
        let result: Result<(Data, HTTPURLResponse), Error> = .success((anyData(), anyHTTPURLResponse(statusCode: 201)))
        let (sut, _) = makeSUT(result: result)
        do {
            try await sut.register(from: anyURLRequest())
        } catch {
            XCTFail("Expected success")
        }
    }
    
    
    
    
    
    
    //MARK: helpers
    private func makeSUT(result: Result<(Data, HTTPURLResponse), Error>) -> (sut: Registor, client: HTTPClientStub) {
        let client = HTTPClientStub(result: result)
        let sut = Registor(client: client)
        
        return (sut, client)
    }
    
}
