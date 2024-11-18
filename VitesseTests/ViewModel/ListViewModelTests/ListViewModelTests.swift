//
//  ListViewModelTests.swift
//  VitesseTests
//
//  Created by Alassane Der on 16/09/2024.
//

import XCTest
@testable import Vitesse

final class ListViewModelTests: XCTestCase {

    
     func test_init_doesNotTriggerLoadListUponCreation() {
         let result: Result<(Data, HTTPURLResponse), Error> = .failure(anyNSError())
         let (sut, client, _) = makeSUT(result: result)
         
         XCTAssertEqual(client.requests, [])
         XCTAssertEqual(sut.list, [])
         XCTAssertEqual(sut.isSelectingFavorits, false)
         XCTAssertEqual(sut.selectedCandidatIDs, [])
         XCTAssertEqual(sut.searchResult, [])
         XCTAssertEqual(sut.searchText, "")
     }
     
     
     func test_loadList_doesNotTriggerLoadListSucceedOnRetrieveTokenFailed() async {
             let result: Result<(Data, HTTPURLResponse), Error> = .failure(anyNSError())
         let (sut, _, store) = makeSUT(result: result)
         
         store.completeRetrieval(with: anyNSError())
         await sut.loadList()
         
         XCTAssertEqual(store.receivedMessages, [.retrieve])
         XCTAssertEqual(sut.list, [])
         XCTAssertEqual(sut.isSelectingFavorits, false)
         XCTAssertEqual(sut.selectedCandidatIDs, [])
         XCTAssertEqual(sut.searchResult, [])
         XCTAssertEqual(sut.searchText, "")
     }
     
    
     func test_loadList_doesNotTriggerLoadListSucceedOnRequestFailed() async {
         let result: Result<(Data, HTTPURLResponse), Error> = .failure(anyNSError())
         let (sut, _, store) = makeSUT(result: result)
         
         store.completeRetrieval(with: anyData())
         await sut.loadList()
         
         XCTAssertEqual(store.receivedMessages, [.retrieve])
         XCTAssertEqual(sut.list, [])
         XCTAssertEqual(sut.isSelectingFavorits, false)
         XCTAssertEqual(sut.selectedCandidatIDs, [])
         XCTAssertEqual(sut.searchResult, [])
         XCTAssertEqual(sut.searchText, "")
     }
     
     func test_loadList_TriggerLoadListSucceedOnSucceededRequestAndRetrieveTokenCompleted() async {
         let item = makeListItem()
         let json = makeListItemJson(item.json)
         
         let result: Result<(Data, HTTPURLResponse), Error> = .success((json, anyHTTPURLResponse()))
         let (sut, _, store) = makeSUT(result: result)

         store.completeRetrieval(with: anyData())
         await sut.loadList()
         
         XCTAssertEqual(store.receivedMessages, [.retrieve])
         XCTAssertEqual(sut.list.count, 2)

     }
  
     
     // MARK: helpers
    private func makeSUT(result: Result<(Data, HTTPURLResponse), Error>) -> (sut: ListViewModel, client: HTTPClientStub, store: TokenStoreSpy) {
         let client = HTTPClientStub(result: result)
         let listLoader = ListLoader(client: client)
         let deletor = Deletor(client: client)
         let tokenStore = TokenStoreSpy()
         
         let sut = ListViewModel(loader: listLoader, deletor: deletor, tokenStore: tokenStore)
         
         return (sut, client, tokenStore)
     }

    
    // MARK: tests for Delete
    // delete 1
   func test_delete_doesNotTriggerDeletionSucceedOnRetrieveTokenFailed() async {
       let result: Result<(Data, HTTPURLResponse), Error> = .failure(anyNSError())
       let (sut, _, store) = makeSUT(result: result)
       
       let selectedCandidateID: [CandidateItem] = [makeListItem().model[0]]
       
       var completionExpectation = 0
       
       store.completeRetrieval(with: anyNSError())
       await sut.delete(selectedCandidatIDs: selectedCandidateID, completion: { completionExpectation += 1 })
       
       XCTAssertEqual(store.receivedMessages, [.retrieve])
       XCTAssertEqual(completionExpectation, 0)
   }
  
  // delete 2
  func test_delete_doesNotTriggerDeletionSucceedOnRequestFailed() async {
           let result: Result<(Data, HTTPURLResponse), Error> = .failure(anyNSError())
       let (sut, _, store) = makeSUT(result: result)
       let selectedCandidateID: [CandidateItem] = [makeListItem().model[0]]
       
       var completionExpectation = 0
       
       store.completeRetrieval(with: anyData())
       await sut.delete(selectedCandidatIDs: selectedCandidateID, completion: { completionExpectation += 1 })
       
       XCTAssertEqual(store.receivedMessages, [.retrieve])
       XCTAssertEqual(completionExpectation, 0)
   }
  // delete 3
//  func test_delete_TriggerDeletionSucceedOnSucceededRequestAndRetrieveTokenCompleted() async {
//      let item = makeListItem()
//      let json = makeListItemJson(item.json)
//      let result: Result<(Data, HTTPURLResponse), Error> = .success((json, anyHTTPURLResponse()))
//       let (sut, _, store) = makeSUT(result: result)
//       
//       var completionExpectation = 0
//       
//      store.completeRetrieval(with: anyData())
//      await sut.loadList()
//
//      // selectionne un élément de la liste chargé par le sut
////        guard let selectedCandidate = sut.list.first else {
////            XCTFail("la liste doit conteniur au moins un élément")
////            return
////        }
//      
////        let selectedCandidateID: [CandidateItem] = [selectedCandidate]
////
//      let selectedCandidateID: [CandidateItem] = [makeListItem().model[0]]
//
//       await sut.delete(selectedCandidatIDs: selectedCandidateID, completion: { completionExpectation += 1 })
////        await sut.deleteAndReloadList(selectedCandidatIDs: selectedCandidateID)
//      XCTAssertEqual(store.receivedMessages, [.retrieve, .retrieve])
//
//       XCTAssertEqual(completionExpectation, 1)
//      XCTAssertEqual(sut.list.count, 1)
//   }
    
    
    
    
    
    
    
    
    
    
    
    
    
    //MARK: test for deletion
//    func test_delete_doesNotTriggerDeleteSucceedOnRetrieveTokenFailed() async {
//            let result: Result<(Data, HTTPURLResponse), Error> = .failure(anyNSError())
//        let (sut, _, store) = makeSUT(result: result)
//        
//        store.completeRetrieval(with: anyNSError())
//        await sut.delete(sut.list[0])
//        
//        XCTAssertEqual(store.receivedMessages, [.retrieve])
//        XCTAssertEqual(sut.list, [])
//        XCTAssertEqual(sut.isSelectingFavorits, false)
//        XCTAssertEqual(sut.selectedCandidatIDs, [])
//        XCTAssertEqual(sut.searchResult, [])
//        XCTAssertEqual(sut.searchText, "")
//    }
//   
//    func test_loadList_doesNotTriggerLoadListSucceedOnRequestFailed() async {
//        let result: Result<(Data, HTTPURLResponse), Error> = .failure(anyNSError())
//        let (sut, _, store) = makeSUT(result: result)
//        
//        store.completeRetrieval(with: anyData())
//        await sut.loadList()
//        
//        XCTAssertEqual(store.receivedMessages, [.retrieve])
//        XCTAssertEqual(sut.list, [])
//        XCTAssertEqual(sut.isSelectingFavorits, false)
//        XCTAssertEqual(sut.selectedCandidatIDs, [])
//        XCTAssertEqual(sut.searchResult, [])
//        XCTAssertEqual(sut.searchText, "")
//    }
//    
//    func test_loadList_TriggerLoadListSucceedOnSucceededRequestAndRetrieveTokenCompleted() async {
//        let item = makeListItem()
//        let json = makeListItemJson(item.json)
//        
//        let result: Result<(Data, HTTPURLResponse), Error> = .success((json, anyHTTPURLResponse()))
//        let (sut, _, store) = makeSUT(result: result)
//
//        store.completeRetrieval(with: anyData())
//        await sut.loadList()
//        
//        XCTAssertEqual(store.receivedMessages, [.retrieve])
//        XCTAssertEqual(sut.list.count, 2)
//
//    }
 
    
}
