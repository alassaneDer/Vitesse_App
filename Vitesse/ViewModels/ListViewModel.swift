//
//  ListViewModel.swift
//  Vitesse
//
//  Created by Alassane Der on 08/09/2024.
//

import Foundation
import Combine

final class ListViewModel: ObservableObject {
    @Published var list: [CandidateItem] = []
    @Published var isSelectingFavorits: Bool = false
    @Published var selectedCandidatIDs: [CandidateItem] = []
    
    @Published var searchResult: [CandidateItem] = []
    @Published var searchText: String = ""
    private var cancellables = Set<AnyCancellable>()
    var issearching: Bool {
        !searchText.isEmpty
    }
    
    private var deletor: Deletor
    private var loader: ListLoader
    private var tokenStore: TokenStore
    
    init(loader: ListLoader = ListLoader(), deletor: Deletor = Deletor(), tokenStore: TokenStore = KeychainStore()) {
        self.loader = loader
        self.deletor = deletor
        self.tokenStore = tokenStore
        addCandidates()
    }
    
    // MARK: Liste des candidats
    func loadList() async {
        do {
            let data = try tokenStore.retrieve()
            let token = String(data: data, encoding: .utf8)!
            
            let request = ListEndPoint.request(token: token)
            let item = try await loader.loadList(from: request)
                        
            await updateListOnMainThread(item: item)
        } catch {
            print(error)
        }
    }
    
    
    func getFirstLetter(item: CandidateItem) -> String {
        if let firstLetter = item.firstName.first {
            return String(firstLetter)
        }
        return "👤"
    }
    
    
    @MainActor
    func updateListOnMainThread(item: [CandidateItem]) {
        list = item
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
    
    private func searchCandidates(searchText: String) {
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
    func delete(selectedCandidatIDs: [CandidateItem], completion: @escaping () -> Void) async {
        do {
            let data = try tokenStore.retrieve()
            let token = String(data: data, encoding: .utf8)!
            
            
            for candidat in selectedCandidatIDs {
                let request = DeleteEndPoint.request(token: token, candidatID: candidat.id)
                try await deletor.delete(from: request)
            }
            
            completion()
            
        } catch {
            print(error)
        }
    }
    
    @MainActor
    func deleteAndReloadList(selectedCandidatIDs: [CandidateItem]) async {
        await delete(selectedCandidatIDs: selectedCandidatIDs) {
            self.selectedCandidatIDs = []
        }
        await loadList()

    }
    
    
}
