//
//  ListViewModel.swift
//  Vitesse
//
//  Created by Alassane Der on 08/09/2024.
//

import Foundation
import Combine

final class ListViewModel: ObservableObject {
    @Published var list: [CandidateItem] = [
        CandidateItem(phone: "0711223344", note: "note for the candidate", id: "1", firstName: "Marcel", linkedinURL: "FakeLinkedInURL.com", isFavorite: true, email: "marceldiop@test.com", lastName: "Diop"),
        
        CandidateItem(phone: "0711223344", note: "note for the candidate", id: "2", firstName: "Antoine", linkedinURL: "FakeLinkedInURL.com", isFavorite: false, email: "antoinegomez@test.com", lastName: "Gomez"),
        
        CandidateItem(phone: "0711223344", note: "note for the candidate", id: "3", firstName: "Vladimir", linkedinURL: "FakeLinkedInURL.com", isFavorite: true, email: "vladimirzarko@test.com", lastName: "Zarko"),
        
        CandidateItem(phone: "0711223344", note: "note for the candidate", id: "4", firstName: "Astel", linkedinURL: "FakeLinkedInURL.com", isFavorite: false, email: "astelrenault@test.com", lastName: "Renault"),
        
        CandidateItem(phone: "0711223344", note: "note for the candidate", id: "5", firstName: "", linkedinURL: "FakeLinkedInURL.com", isFavorite: true, email: "alicesmith@test.com", lastName: "Smith"),
        
        CandidateItem(phone: "0711223344", note: "note for the candidate", id: "6", firstName: "Charlotte", linkedinURL: "FakeLinkedInURL.com", isFavorite: true, email: "charlottebrown@test.com", lastName: "Brown"),
        
        CandidateItem(phone: "0711223344", note: "note for the candidate", id: "7", firstName: "Bob", linkedinURL: "FakeLinkedInURL.com", isFavorite: true, email: "bobjohnson@test.com", lastName: "Johnson"),
        
        CandidateItem(phone: "0711223344", note: "note for the candidate", id: "8", firstName: "Ousmane", linkedinURL: "FakeLinkedInURL.com", isFavorite: true, email: "ousmanesamb@test.com", lastName: "Samb")
        
    ]
    
    @Published var loadListMessage: String = ""
    @Published var deleteCandidateMessage: String = ""
    @Published var isSelectingFavorits: Bool = false
    @Published var selectedCandidatIDs: [CandidateItem] = []
    
    @Published var searchResult: [CandidateItem] = []
    @Published var searchText: String = ""
    private var cancellables = Set<AnyCancellable>()
    var issearching: Bool {
        !searchText.isEmpty
    }
    
    private var candidateLoader: CandidatesLoader
    private var tokenStore: TokenStore
    
    
    init(candidateLoader: CandidatesLoader = CandidatesLoader(), tokenStore: TokenStore = KeychainStore()) {
        self.candidateLoader = candidateLoader
        self.tokenStore = tokenStore
        addCandidates()
    }
    
    
    // MARK: Liste des candidats
    @MainActor
    func loadList() async {
        do {
            let data = try tokenStore.retrieve()
            let token = String(data: data, encoding: .utf8)!
            
            let request = ListEndPoint.request(token: token)
            let item = try await candidateLoader.loadList(from: request)
            
            list = item
            
            if list.isEmpty {
                loadListMessage = "Candidates list empty!"
            }
        } catch {
            loadListMessage = "Sorry can't load Candidates list, please refresh!"
            print(error)
        }
    }
    
    
    func getFirstLetter(item: CandidateItem) -> String {
        if let firstLetter = item.firstName.first {
            return String(firstLetter)
        }
        return "👤"
    }
    
    
    
    // MARK: - Implement the logic for filtering
    func applyFilter() -> [CandidateItem] {
        if issearching {
            return searchResult
        } else if isSelectingFavorits {
            return list.filter({$0.isFavorite})
        } else {
            return list
        }
    }
    
    // MARK: pour la multisélection
    func selectCandidates(by candidateID: CandidateItem) {
        if selectedCandidatIDs.contains(candidateID) {
            selectedCandidatIDs.removeAll {$0 == candidateID}
        } else {
            selectedCandidatIDs.insert(candidateID, at: selectedCandidatIDs.count)
        }
    }
    
    private func addCandidates() {
        $searchText
            .debounce(for: 0.3, scheduler: DispatchQueue.main)
            .sink { [weak self] searchText in
                self?.searchCandidates(searchText: searchText)
            }
            .store(in: &cancellables)
    }
    
    func searchCandidates(searchText: String) {
        guard !searchText.isEmpty else {
            searchResult = []
            return
        }
        
        let search = searchText.lowercased()
        searchResult = list.filter({ candidat in
            let firstNameContainsSearch = candidat.firstName.lowercased().contains(search)
            let lastNameContainsSearch = candidat.lastName.lowercased().contains(search)
            
            return firstNameContainsSearch || lastNameContainsSearch
        })
    }
    
    // MARK: perform deletion
    @MainActor
    func deleteCandidate(selectedCandidatIDs: [CandidateItem], completion: @escaping () -> Void) async {
        do {
            let data = try tokenStore.retrieve()
            let token = String(data: data, encoding: .utf8)!
            
            
            for candidat in selectedCandidatIDs {
                let request = DeleteEndPoint.request(token: token, candidatID: candidat.id)
                try await candidateLoader.delete(from: request)
            }
            
            completion()
            deleteCandidateMessage = "Candidate successfully deleted!"
        } catch {
            deleteCandidateMessage = "Can't perform deletion now, please try later!"
        }
    }
    
    @MainActor
    func deleteCandidateAndReloadList(selectedCandidatIDs: [CandidateItem]) async {
        await deleteCandidate(selectedCandidatIDs: selectedCandidatIDs) {
            self.selectedCandidatIDs = []
        }
        await loadList()
    }
        
}
