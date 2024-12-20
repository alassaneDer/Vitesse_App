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
    
    func test_register_doesNotTriggerRegisterSucceedOnEmptyFields() async {
        let result: Result<(Data, HTTPURLResponse), Error> = .failure(anyNSError())
        let (sut, _) = makeSUT(result: result)
        
        sut.email = ""
        sut.password = "a password"
        sut.confirmPassword = "a different password"
        sut.firstName = ""
        sut.lastName = "a lastName"
        await sut.register()
        
        XCTAssertEqual(sut.registerMessage, "Please fill out all fields.")
    }
    
    func test_register_doesNotTriggerRegisterSucceedIfPasswordNotSame() async {
        let result: Result<(Data, HTTPURLResponse), Error> = .failure(anyNSError())
        let (sut, _) = makeSUT(result: result)
        
        sut.email = "anemail@email.com"
        sut.password = "a password"
        sut.confirmPassword = "a different password"
        sut.firstName = "a firstName"
        sut.lastName = "a lastName"
        await sut.register()
        
        XCTAssertEqual(sut.registerMessage, "Please make sure the passwords match!")
    }
    
    func test_register_doesNotTriggerRegisterSucceedOnInvalidEmail() async {
        let result: Result<(Data, HTTPURLResponse), Error> = .failure(anyNSError())
        let (sut, _) = makeSUT(result: result)
        
        sut.email = "invalidEmail"
        sut.password = "a password"
        sut.confirmPassword = "a password"
        sut.firstName = "a firstName"
        sut.lastName = "a lastName"
        await sut.register()
        
        XCTAssertEqual(sut.registerMessage, "Please enter a valid email!")
    }
    
    func test_register_doesNotTriggerRegisterSucceedOnRequestFailed() async {
        let result: Result<(Data, HTTPURLResponse), Error> = .failure(anyNSError())
        let (sut, _) = makeSUT(result: result)
        
        sut.email = "anemail@email.com"
        sut.password = "a password"
        sut.confirmPassword = "a password"
        sut.firstName = "a firstName"
        sut.lastName = "a lastName"
        await sut.register()
        
        XCTAssertEqual(sut.registerMessage, "Sorry! Registration failed. Please try again.")
    }
    
    func test_register_TriggerRegisterSucceedOnSucceededRequest() async {
        let result: Result<(Data, HTTPURLResponse), Error> = .success((anyData(), anyHTTPURLResponse(statusCode: 201)))
        let (sut, _) = makeSUT(result: result)
        
        sut.email = "anemail@email.com"
        sut.password = "a password"
        sut.confirmPassword = "a password"
        sut.firstName = "a firstName"
        sut.lastName = "a lastName"
        await sut.register()
        
        XCTAssertEqual(sut.registerMessage, "Registration succesful!")
    }
    
    // MARK: showtemporary toast func tests
    
    func testShowTemporaryToast_mustDisplayMessage_untilTheDelayCompleted() {

        var sut: RegisterViewModel = RegisterViewModel()
        let expectation = self.expectation(description: "Toast message should be cleared after delay")
        
        sut.registerMessage = "Hello, World!"

        sut.showTemporaryToast()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.1) {
                   XCTAssertEqual(sut.registerMessage, "Hello, World!", "The message should be cleared only after the delay")
            expectation.fulfill()
            }
        
        waitForExpectations(timeout: 6, handler: nil)

    }
    
    func testShowTemporaryToast_mustClearMessage_ifTheDelayCompleted() {

        var sut: RegisterViewModel = RegisterViewModel()
        let expectation = self.expectation(description: "Toast message should be cleared after delay")
        
        sut.registerMessage = "Hello, World!"

        sut.showTemporaryToast()
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.1) {
                   // THEN: Vérifier que le message est bien vidé
                   XCTAssertEqual(sut.registerMessage, "", "The message should be cleared after the delay")
            expectation.fulfill()
            }
        
        waitForExpectations(timeout: 6, handler: nil)

    }

    
    
    // MARK: helpers
    private func makeSUT(result: Result<(Data, HTTPURLResponse), Error>) -> (sut: RegisterViewModel, client: HTTPClientStub) {
        let client = HTTPClientStub(result: result)
        let registor = Registor(client: client)
        
        let sut = RegisterViewModel(registor: registor)
        
        return (sut, client)
    }
    
}
