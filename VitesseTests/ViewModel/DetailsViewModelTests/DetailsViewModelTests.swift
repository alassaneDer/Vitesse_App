////
////  DetailsViewModelTests.swift
////  VitesseTests
////
////  Created by Alassane Der on 21/09/2024.
////
//
//import XCTest
//@testable import Vitesse
//
//final class DetailsViewModelTests: XCTestCase {
//    
//    func test_init_doesNotTriggerLoadDetailsOrUpdateOrSetFavoritUponCreation() {
//        let result: Result<(Data, HTTPURLResponse), Error> = .failure(anyNSError())
//        let (sut, client, _) = makeSUT(result: result)
//        
//        XCTAssertEqual(client.requests, [])
//        XCTAssertEqual(sut.phone, "")
//        XCTAssertEqual(sut.note, "")
//        XCTAssertEqual(sut.id, "")
//        XCTAssertEqual(sut.firstName, "")
//        XCTAssertEqual(sut.linkedinURL, "")
//        XCTAssertEqual(sut.isFavorite, false)
//        XCTAssertEqual(sut.email, "")
//        XCTAssertEqual(sut.lastName, "")
//    }
//    
//    
//    func test_loadDetails_doesNotTriggerLoadDetailsSucceedOnRetrieveTokenFailed() async {
//        let result: Result<(Data, HTTPURLResponse), Error> = .failure(anyNSError())
//        let (sut, _, store) = makeSUT(result: result)
//        
//        store.completeRetrieval(with: anyNSError())
//        
//        do {
//            let candidateID = "an id"
//            let candidateDetails = try await sut.loadDetails(by: candidateID)
//        } catch {
//            print("load details failed!")
//        }
//        
//        XCTAssertEqual(store.receivedMessages, [.retrieve])
//        
//        XCTAssertEqual(sut.phone, "")
//        XCTAssertEqual(sut.note, "")
//        XCTAssertEqual(sut.id, "")
//        XCTAssertEqual(sut.firstName, "")
//        XCTAssertEqual(sut.linkedinURL, "")
//        XCTAssertEqual(sut.isFavorite, false)
//        XCTAssertEqual(sut.email, "")
//        XCTAssertEqual(sut.lastName, "")
//        
//    }
//    
//    func test_loadDetails_doesNotTriggerLoadDetailsSucceedOnRequestFailed() async {
//        let result: Result<(Data, HTTPURLResponse), Error> = .failure(anyNSError())
//        let (sut, _, store) = makeSUT(result: result)
//        
//        store.completeRetrieval(with: anyData())
//        
//        do {
//            let candidateID = "an id"
//            let candidateDetails = try await sut.loadDetails(by: candidateID)
//        } catch {
//            print("load details failed!")
//        }
//        
//        XCTAssertEqual(store.receivedMessages, [.retrieve])
//        
//        XCTAssertEqual(sut.phone, "")
//        XCTAssertEqual(sut.note, "")
//        XCTAssertEqual(sut.id, "")
//        XCTAssertEqual(sut.firstName, "")
//        XCTAssertEqual(sut.linkedinURL, "")
//        XCTAssertEqual(sut.isFavorite, false)
//        XCTAssertEqual(sut.email, "")
//        XCTAssertEqual(sut.lastName, "")
//        
//    } 
//    
//    func test_loadDetails_doesNotTriggerLoadDetailsSucceedOnFakeID() async {    // a revoir
//        let item = makeDetails_Update_Favorite_Item()
//        let json = makeItemsJson(item.json)
//        let result: Result<(Data, HTTPURLResponse), Error> = .success((json, anyHTTPURLResponse()))
//        let (sut, _, store) = makeSUT(result: result)
//        
//        store.completeRetrieval(with: anyData())
//        
//        do {
//            let candidateID = "an fake id"
//            let candidateDetails = try await sut.loadDetails(by: candidateID)
//        } catch {
//            print("load details failed!")
//        }
//        
//        XCTAssertEqual(store.receivedMessages, [.retrieve])
//        
//        XCTAssertEqual(sut.phone, "")
//        XCTAssertEqual(sut.note, "")
//        XCTAssertEqual(sut.id, "")
//        XCTAssertEqual(sut.firstName, "")
//        XCTAssertEqual(sut.linkedinURL, "")
//        XCTAssertEqual(sut.isFavorite, false)
//        XCTAssertEqual(sut.email, "")
//        XCTAssertEqual(sut.lastName, "")
//        
//    }
//    
//    func test_loadDetails_TriggerLoadDetailsSucceedOnGoodIDSucceedRequestAndRetrieveTokenCompleted() async {    // a revoir
//        let item = makeDetails_Update_Favorite_Item()
//        let json = makeItemsJson(item.json)
//        let result: Result<(Data, HTTPURLResponse), Error> = .success((json, anyHTTPURLResponse(statusCode: 200)))
//        let (sut, _, store) = makeSUT(result: result)
//        
//        
//        do {
//            store.completeRetrieval(with: anyData())
//
//            let candidateID = "an id"
//            let candidateDetails = try await sut.loadDetails(by: candidateID)
//            
//            XCTAssertEqual(store.receivedMessages, [.retrieve])
//            XCTAssertEqual(sut.phone, "")
//            XCTAssertEqual(sut.note, "")
//            XCTAssertEqual(sut.id, "")
//            XCTAssertEqual(sut.firstName, "")
//            XCTAssertEqual(sut.linkedinURL, "")
//            XCTAssertEqual(sut.isFavorite, false)
//            XCTAssertEqual(sut.email, "")
//            XCTAssertEqual(sut.lastName, "")
//        } catch {
//            print("load details failed!")
//        }
//        
//        
//        
//        
//    }
//    
//    //
//    //     func test_loadList_doesNotTriggerLoadListSucceedOnRequestFailed() async {
//    //         let result: Result<(Data, HTTPURLResponse), Error> = .failure(anyNSError())
//    //         let (sut, _, store) = makeSUT(result: result)
//    //
//    //         store.completeRetrieval(with: anyData())
//    //         await sut.loadList()
//    //
//    //         XCTAssertEqual(store.receivedMessages, [.retrieve])
//    //         XCTAssertEqual(sut.list, [])
//    //         XCTAssertEqual(sut.isSelectingFavorits, false)
//    //         XCTAssertEqual(sut.selectedCandidatIDs, [])
//    //         XCTAssertEqual(sut.searchResult, [])
//    //         XCTAssertEqual(sut.searchText, "")
//    //     }
//    //
//    //     func test_loadList_TriggerLoadListSucceedOnSucceededRequestAndRetrieveTokenCompleted() async {
//    //         let item = makeListItem()
//    //         let json = makeListItemJson(item.json)
//    //
//    //         let result: Result<(Data, HTTPURLResponse), Error> = .success((json, anyHTTPURLResponse()))
//    //         let (sut, _, store) = makeSUT(result: result)
//    //
//    //         store.completeRetrieval(with: anyData())
//    //         await sut.loadList()
//    //
//    //         XCTAssertEqual(store.receivedMessages, [.retrieve])
//    //         XCTAssertEqual(sut.list.count, 2)
//    //
//    //     }
//    
//    func testLoadDetailsSuccess() async throws {
//           // Prepare a successful result with fake data and HTTP response
//           let (candidateItem, json) = makeDetails_Update_Favorite_Item()
//           let data = makeItemsJson(json)
//           let result: Result<(Data, HTTPURLResponse), Error> = .success((data, anyHTTPURLResponse(statusCode: 200)))
//           
//           // Create the system under test (sut) using makeSUT
//           let (sut, _, _) = makeSUT(result: result)
//           
//           // Call the method
//           let candidate = try await sut.loadDetails(by: "a fake id")
//           
//           // Verify the result
//           XCTAssertEqual(candidate.phone, candidateItem.phone)
//           XCTAssertEqual(candidate.note, candidateItem.note)
//           XCTAssertEqual(candidate.firstName, candidateItem.firstName)
//           XCTAssertEqual(candidate.email, candidateItem.email)
//           XCTAssertEqual(candidate.linkedinURL, candidateItem.linkedinURL)
//       }
//
//    // MARK: helpers
//    private func makeSUT(result: Result<(Data, HTTPURLResponse), Error>) -> (sut: DetailsViewModel, client: HTTPClientStub, store: TokenStoreSpy) {
//        let client = HTTPClientStub(result: result)
//        let detailsLoader = DetailLoader(client: client)
//        let updator = Updator(client: client)
//        let asFavoritSetor = AsFavoriteSetor(client: client)
//        let tokenStore = TokenStoreSpy()
//        
//        let sut = DetailsViewModel(updator: updator, detailsLoader: detailsLoader, asFavoritSetor: asFavoritSetor, tokenStore: tokenStore)
//        
//        return (sut, client, tokenStore)
//    }
//    
//    
//}
