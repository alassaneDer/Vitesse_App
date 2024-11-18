//
//  RegisterViewModelTests.swift
//  VitesseTests
//
//  Created by Alassane Der on 16/09/2024.
//

import XCTest
@testable import Vitesse

final class RegisterViewModelTests: XCTestCase {

   
    func test_init_doesNotTriggerRegisterUponCreation() {
        let result: Result<(Data, HTTPURLResponse), Error> = .failure(anyNSError())
        let (sut, client) = makeSUT(result: result)
        
        XCTAssertEqual(client.requests, [])
        XCTAssertEqual(sut.email, "")
        XCTAssertEqual(sut.password, "")
        XCTAssertEqual(sut.firstName, "")
        XCTAssertEqual(sut.lastName, "")
        XCTAssertEqual(sut.registerMessage, "")
    }
    
    
    func test_register_doesNotTriggerRegisterSucceedOnRequestFailed() async {
            let result: Result<(Data, HTTPURLResponse), Error> = .failure(anyNSError())
            let (sut, _) = makeSUT(result: result)

            sut.email = "anemail@email.com"
            sut.password = "a password"
            sut.firstName = "a firstName"
            sut.lastName = "a lastName"
            await sut.register()

            XCTAssertEqual(sut.registerMessage, "Sorry! Can't Register.")
    } 
    
    func test_register_TriggerRegisterSucceedOnSucceededRequest() async {
        let result: Result<(Data, HTTPURLResponse), Error> = .success((anyData(), anyHTTPURLResponse(statusCode: 201)))
            let (sut, _) = makeSUT(result: result)

            sut.email = "anemail@email.com"
            sut.password = "a password"
            sut.firstName = "a firstName"
            sut.lastName = "a lastName"
            await sut.register()

        XCTAssertEqual(sut.registerMessage, "Welcome \(sut.firstName)")
    }
 
    
    // MARK: helpers
    private func makeSUT(result: Result<(Data, HTTPURLResponse), Error>) -> (sut: RegisterViewModel, client: HTTPClientStub) {
        let client = HTTPClientStub(result: result)
        let registor = Registor(client: client)
        
        let sut = RegisterViewModel(registor: registor)
        
        return (sut, client)
    }

}
