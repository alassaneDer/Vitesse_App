//
//  DeleteMapperTests.swift
//  VitesseTests
//
//  Created by Alassane Der on 14/09/2024.
//
import XCTest
@testable import Vitesse

final class DelelorTests: XCTestCase {

    func test_init_doesNotDeleteRequestUponCreation() throws {
        let result: Result<(Data, HTTPURLResponse), Error> = .failure(anyNSError())
        let (_, client) = makeSUT(result: result)
        
        XCTAssertEqual(client.requests, [])
    }
    
    func test_deletor_deliversErrorOnClientFailed() async {
        let expectedError = anyNSError()
        let result: Result<(Data, HTTPURLResponse), Error> = .failure(expectedError)
        let (sut, _) = makeSUT(result: result)
        
        do {
            try await sut.delete(from: anyURLRequest())
            XCTFail("Expected failure")
        } catch {
            XCTAssertEqual(error as NSError, expectedError)
        }
    }
    
    func test_deletor_deliversErrorOnANon200HTTPURLResponseStatusCode() async {
        let result: Result<(Data, HTTPURLResponse), Error> = .success((anyData(), anyHTTPURLResponse(statusCode: 300)))
        let (sut, _) = makeSUT(result: result)
        do {
            try await sut.delete(from: anyURLRequest())
            XCTFail("Expected failure")
        } catch {
            XCTAssertEqual(error as! CandidatesLoader.Error, .invalidResponseStatusCode)
        }
    }
    
    func test_deletor_deliversRegisterSucceded() async {
        let result: Result<(Data, HTTPURLResponse), Error> = .success((anyData(), anyHTTPURLResponse(statusCode: 200)))
        let (sut, _) = makeSUT(result: result)
        do {
            try await sut.delete(from: anyURLRequest())
        } catch {
            XCTFail("Expected success")
        }
    }
    
    
    
    
    
    
    //MARK: helpers
    private func makeSUT(result: Result<(Data, HTTPURLResponse), Error>) -> (sut: CandidatesLoader, client: HTTPClientStub) {
        let client = HTTPClientStub(result: result)
        let sut = CandidatesLoader(client: client)
        
        return (sut, client)
    }
    
}
