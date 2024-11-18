//
//  SharedTestsHelpers.swift
//  VitesseTests
//
//  Created by Alassane Der on 12/09/2024.
//
import Foundation
@testable import Vitesse

func anyURL() -> URL {
    URL(string: "https://www.a-url.com")!
}

func anyURLRequest() -> URLRequest {
    URLRequest(url: anyURL())
}

func anyData() -> Data {
    "a data".data(using: .utf8)!
}

func anyNSError() -> NSError {
    NSError(domain: "a domain", code: 0)
}

func makeAuthItem() -> (model: AuthItem, json: [String: Any]) {
    let model = AuthItem(
        token: "a token",
        isAdmin: false)
    
    let json: [String: Any] = [
        "token": model.token,
        "isAdmin": model.isAdmin
    ]
    
    return(model, json)
}

func makeListItem() -> (model: [CandidateItem], json: [[String: Any]]) {
    let model = [
        CandidateItem(
            phone: "0711223344",
            note: "a note",
            id: "an id",
            firstName: "a firstName",
            linkedinURL: "https://www.linkedInURL.com",
            isFavorite: false,
            email: "fake@test.com",
            lastName: "a lastName"),
        CandidateItem(
            phone: "0711223344",
            note: "a nother note",
            id: "a nother id",
            firstName: "a nother firstName",
            linkedinURL: "https://www.linkedInURL.com",
            isFavorite: false,
            email: "fake@test.com",
            lastName: "a nother lastName")
    ]
    
    let json: [[String: Any]] = [
        
        [
            "phone": model[0].phone!,
            "note": model[0].note!,
            "id": model[0].id,
            "firstName": model[0].firstName,
            "linkedinURL": model[0].linkedinURL!,
            "isFavorite": model[0].isFavorite,
            "email": model[0].email,
            "lastName": model[0].lastName
        ],
        [
            "phone": model[1].phone!,
            "note": model[1].note!,
            "id": model[1].id,
            "firstName": model[1].firstName,
            "linkedinURL": model[1].linkedinURL!,
            "isFavorite": model[1].isFavorite,
            "email": model[1].email,
            "lastName": model[1].lastName
        ]
        
    ]
    
    return (model, json)
}

func makeDetails_Update_Favorite_Item() -> (model: CandidateItem, json: [String: Any]) { // meme chose que pour mise à jour et mise en favori
    let model = CandidateItem(
        phone: "0711223344",
        note: "a note",
        id: "an id",
        firstName: "a firstName",
        linkedinURL: "https://www.linkedInURL.com",
        isFavorite: false,
        email: "fake@test.com",
        lastName: "a lastName")
    
    let json: [String: Any] = [
        "phone": model.phone!,
        "note": model.note!,
        "id": model.id,
        "firstName": model.firstName,
        "linkedinURL": model.linkedinURL!,
        "isFavorite": model.isFavorite,
        "email": model.email,
        "lastName": model.lastName
    ]
    
    return (model, json)
}

func makeItemsJson(_ item: [String : Any]) -> Data {
    try! JSONSerialization.data(withJSONObject: item)
}
func makeListItemJson(_ item: [[String: Any]]) -> Data {
    try! JSONSerialization.data(withJSONObject: item)
}
func anyHTTPURLResponse(statusCode: Int = 200) -> HTTPURLResponse {
    HTTPURLResponse(url: anyURL(), statusCode: statusCode, httpVersion: nil, headerFields: nil)!
}
