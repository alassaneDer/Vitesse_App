//
//  UpdateOnMainThreadTests.swift
//  VitesseTests
//
//  Created by Alassane Der on 23/09/2024.
//

import XCTest
@testable import Vitesse

final class UpdateDetailsOnMainThreadTests: XCTestCase {

    func test_init_doesNotTriggerUpdateUponCreation() {
        let result: Result<(Data, HTTPURLResponse), Error> = .failure(anyNSError())
        let (sut, client, _) = makeDetailsSUT(result: result)
        
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

    func test_update_doesNotTriggerUpdatedDetailsOnRetrieveTokenFailed() async throws {
        let result: Result<(Data, HTTPURLResponse), Error> = .failure(anyNSError())
        let (sut, _, store) = makeDetailsSUT(result: result)

        // Simule échec de la récupération du token
        store.completeRetrieval(with: anyNSError())

        // Appel de la méthode de test
        await sut.updateDetailsOnMainThread(for: "an id")

        // Vérifications : aucune mise à jour des détails ne doit être effectuée
        XCTAssertEqual(store.receivedMessages, [.retrieve])
        XCTAssertEqual(sut.firstName, "John")
        XCTAssertEqual(sut.phone, "071122334455")
    }

    func test_update_doesNotTriggerUpdatedDetailsOnRequestFailed() async throws {
        let result: Result<(Data, HTTPURLResponse), Error> = .failure(anyNSError())
        let (sut, _, store) = makeDetailsSUT(result: result)

        // Simule succès de la récupération du token, mais échec de la requête
        store.completeRetrieval(with: anyData())

        // Appel de la méthode de test
        await sut.updateDetailsOnMainThread(for: "an id")

        // Vérifications : aucune mise à jour des détails ne doit être effectuée
        XCTAssertEqual(store.receivedMessages, [.retrieve])
        XCTAssertEqual(sut.firstName, "John")
        XCTAssertEqual(sut.phone, "071122334455")
    }

    func test_updateDetailsSuccess() async throws {
        // Prépare un résultat de succès avec des données factices et une réponse HTTP valide
        let (candidateItem, json) = makeDetails_Update_Favorite_Item()
        let data = makeItemsJson(json)
        let result: Result<(Data, HTTPURLResponse), Error> = .success((data, anyHTTPURLResponse(statusCode: 200)))

        // Crée le système à tester (sut)
        let (sut, _, store) = makeDetailsSUT(result: result)

        // Simule succès de la récupération du token
        store.completeRetrieval(with: anyData())

        // Appel de la méthode à tester
        await sut.updateDetailsOnMainThread(for: "an id")

        // Vérifications : les détails doivent être correctement mis à jour
        XCTAssertEqual(sut.phone, candidateItem.phone)
        XCTAssertEqual(sut.note, candidateItem.note)
        XCTAssertEqual(sut.firstName, candidateItem.firstName)
        XCTAssertEqual(sut.email, candidateItem.email)
        XCTAssertEqual(sut.linkedinURL, candidateItem.linkedinURL)
        XCTAssertEqual(sut.lastName, candidateItem.lastName)
        XCTAssertEqual(sut.isFavorite, candidateItem.isFavorite)
    }

    // MARK: - Helpers
    private func makeDetailsSUT(result: Result<(Data, HTTPURLResponse), Error>) -> (detailsSut: DetailsViewModel, client: HTTPClientStub, store: TokenStoreSpy) {
        let client = HTTPClientStub(result: result)
        let candidatesLoader = CandidatesLoader(client: client)
        let tokenStore = TokenStoreSpy()
        let sut = DetailsViewModel(candidatesLoader: candidatesLoader, tokenStore: tokenStore)

        return (sut, client, tokenStore)
    }
}
