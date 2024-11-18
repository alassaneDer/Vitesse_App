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
        XCTAssertEqual(sut.phone, "")
        XCTAssertEqual(sut.note, "")
        XCTAssertEqual(sut.id, "")
        XCTAssertEqual(sut.firstName, "")
        XCTAssertEqual(sut.linkedinURL, "")
        XCTAssertEqual(sut.isFavorite, false)
        XCTAssertEqual(sut.email, "")
        XCTAssertEqual(sut.lastName, "")
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
        XCTAssertEqual(sut.firstName, "")
        XCTAssertEqual(sut.phone, "")
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
        XCTAssertEqual(sut.firstName, "")
        XCTAssertEqual(sut.phone, "")
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
        let detailsLoader = DetailLoader(client: client) // Assurez-vous que vous utilisez un bon "Loader"
        let tokenStore = TokenStoreSpy()
        let sut = DetailsViewModel(detailsLoader: detailsLoader, tokenStore: tokenStore) // Injecter le loader

        return (sut, client, tokenStore)
    }
}
