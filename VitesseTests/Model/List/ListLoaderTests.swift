//
//  ListLoaderTests.swift
//  VitesseTests
//
//  Created by Alassane Der on 15/09/2024.
//

import XCTest
@testable import Vitesse

final class ListLoaderTests: XCTestCase {
    // MARK: vérifier que l'initialisation de listLoader n'entraine pas l'envoie de requetes réseau lors de sa création
    func test_init_doesNotListRequestUponCreation() {
        // création d'un résultat d'echec pour simuler une erreur
        let result: Result<(Data, HTTPURLResponse), Error> = .failure(anyNSError())
        
        // crétaion du sut et du client HTTP à tester
        let (_, client) = makeSUT(result: result)
        
        // test non envoie de la requete par le client à la création  du sut
        XCTAssertEqual(client.requests, [])
        
    }
    
    // MARK: vérification que listLoader renvoie une erreur si le client échou
    func test_loadList_deliversErrorOnClientFailed() async {
        // création d'une erreur
        let expectedError = anyNSError()
        
        //simuler un résultat d'cehec
        let result: Result<(Data, HTTPURLResponse), Error> = .failure(expectedError)
        
        // création du sut et du client (non utilisé ici)
        let (sut, _) = makeSUT(result: result)
        
        do {
            // appel de la methode listLoader
            _ = try await sut.loadList(from: anyURLRequest())
            
            // test echou si aucune erreur n'est levée
            XCTFail("Expected failure")
        } catch {
            // vérification correspondance erreur renvoyée et erreur attendue
            XCTAssertEqual(error as NSError, expectedError)
        }
    }
    
    // MARK: erreur si le mapper echou
    func test_loadList_deliversErrorOnMapperFailed() async {
        let result: Result<(Data, HTTPURLResponse), Error> = .success((anyData(), anyHTTPURLResponse()))
        let (sut, _) = makeSUT(result: result)
        
        do {
            _ = try await sut.loadList(from: anyURLRequest())
            XCTFail("Expected failure")
        } catch {
            XCTAssertEqual(error as! ListMapper.Error, .invalidDecodingResponse)
        }
    }
    
    // MARK: reception de list quand la requet reussit
    func test_loadList_deliversListOnSucceedRequest() async {
        let item = makeListItem()
        let json = makeListItemJson(item.json)
        let result: Result<(Data, HTTPURLResponse), Error> = .success((json, anyHTTPURLResponse()))
        let (sut, _) = makeSUT(result: result)
        
        do {
            let list = try await sut.loadList(from: anyURLRequest())
            XCTAssertEqual(list, item.model)
        } catch  {
            XCTFail("Expected succes")
        }
        
    }
    
    
    
    
    // MARK: - Helpers
    private func makeSUT(result: Result<(Data, HTTPURLResponse), Error>) -> (sut: ListLoader, clien: HTTPClientStub) {
        let client = HTTPClientStub(result: result)
        let sut = ListLoader(client: client)

        return (sut, client)
    }

}
