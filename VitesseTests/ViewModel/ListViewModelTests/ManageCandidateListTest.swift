//
//  OthersFuncListViiewmodel.swift
//  VitesseTests
//
//  Created by Alassane Der on 01/12/2024.
//

import XCTest
@testable import Vitesse

final class ManageCandidateListTest: XCTestCase {
    
    var sut: ListViewModel = ListViewModel()

    // MARK: getFirstLetter
    
    func test_getFirstLetter() {
        
        let itemWithFirstName = sut.list[0]
        let itemWithoutFirstName = sut.list[4]
        
        XCTAssertEqual(sut.getFirstLetter(item: itemWithFirstName), "M")
        XCTAssertEqual(sut.getFirstLetter(item: itemWithoutFirstName), "👤")
    }
    
    // MARK: getFirstLetter
    
    func test_applyFilter() {
        
        /// searchText empty
        sut.searchText = ""
        sut.isSelectingFavorits = false
        XCTAssertEqual(sut.applyFilter(), sut.list)
        
        ///  serachText not empy
        sut.searchText = "Marcel"
        sut.isSelectingFavorits = false
        XCTAssertEqual(sut.applyFilter(), [])
        
        ///  filtering favorits
        sut.searchText = ""
        sut.isSelectingFavorits = true
        XCTAssertEqual(sut.applyFilter(), sut.list.filter({$0.isFavorite}))
        
        
    }

    // MARK: selectCandidates
    func test_selectCandidates() {
        
        let candidate = sut.list[0]
        sut.selectCandidates(by: candidate)
        XCTAssertTrue(sut.selectedCandidatIDs.contains(candidate))
        
        sut.selectCandidates(by: candidate)
        XCTAssertFalse(sut.selectedCandidatIDs.contains(candidate))
    }

    // MARK: selectCandidates
    func test_searchCandidatesWithValidSearch() {
        sut.searchCandidates(searchText: "Marcel")
        XCTAssertEqual(sut.searchResult.count, 1)
        XCTAssertEqual(sut.searchResult.first?.firstName, "Marcel")
    }
    
    func test_searchCandidatesWithNoMatchSearch() {
        sut.searchCandidates(searchText: "Gabriel")
        XCTAssertEqual(sut.searchResult.count, 0)
    }
    
    func test_searchCandidatesWithEmptySearch() {
        sut.searchCandidates(searchText: "")
        XCTAssertEqual(sut.searchResult.count, 0)
    }
    
    // MARK: addCandidates
    
    func test_AddCandidatesDebounce() {        
        sut.searchText = "Marcel"
        let expectation = self.expectation(description: "Debounced search should update searchResult")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertEqual(self.sut.searchResult.count, 1)
            XCTAssertEqual(self.sut.searchResult.first?.firstName, "Marcel")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1)
    }
    
    func test_AddCandidatesWithEmptySearch() {        
        sut.searchText = ""
        let expectation = self.expectation(description: "Debounced search should update searchResult")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertEqual(self.sut.searchResult.count, 0)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1)
    }
    
}
