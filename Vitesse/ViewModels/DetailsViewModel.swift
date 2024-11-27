//
//  DetailsViewModel.swift
//  Vitesse
//
//  Created by Alassane Der on 10/09/2024.
//

import Foundation
import Combine

final class DetailsViewModel: ObservableObject {
    
    @Published var phone: String = "071122334455"
    @Published var note: String = "note to detail"
    @Published var id: String = "1"
    @Published var firstName: String = "John"
    @Published var linkedinURL: String = "fakeLinkedInURL.com"
    @Published var isFavorite: Bool = false
    @Published var email: String = "johndoe@test.com"
    @Published var lastName: String = "Doe"
    
    private var candidatesLoader: CandidatesLoader
    private var tokenStore: TokenStore
    
    init(candidatesLoader: CandidatesLoader = CandidatesLoader(), tokenStore: TokenStore = KeychainStore()) {
        self.candidatesLoader = candidatesLoader
        self.tokenStore = tokenStore
    }
    
    // MARK: load candidate details
    func loadDetails(by candidatID: String) async throws -> CandidateItem {
        let data = try tokenStore.retrieve()
        let token = String(data: data, encoding: .utf8)!
        let request = DetailEndPoint.request(token: token, candidatID: candidatID)
        print(request)
        let details = try await candidatesLoader.loadDetails(from: request)
        
        return details
    }
    
    @MainActor
    func updateDetailsOnMainThread(for candidatID: String)  async {
        do {
            let candidat = try await loadDetails(by: candidatID)
            
            phone = candidat.phone!
            note = candidat.note!
            id = candidat.id
            firstName = candidat.firstName
            linkedinURL = candidat.linkedinURL!
            isFavorite = candidat.isFavorite
            email = candidat.email
            lastName = candidat.lastName
            
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    // MARK: update candidate details
    @MainActor
    func update(by candidatID: String) async throws -> CandidateItem {
        do {
            let data = try tokenStore.retrieve()
            let token = String(data: data, encoding: .utf8)!
            
            let request = try UpdateEndPoint.request(
                token: token,
                candidateId: candidatID,
                email: email,
                note: note,
                linkedinURL: linkedinURL,
                firstName: firstName,
                lastName: lastName,
                phone: phone
            )
            
            let updatedCandidate = try await candidatesLoader.update(from: request)
            
            return updatedCandidate
        } catch {
            throw (error)
        }
    }
    
    // MARK: set candidate as favorite
    @MainActor
    func setAsFavorite(candidatID: String) async throws -> CandidateItem {
        do {
            let data = try tokenStore.retrieve()
            let token = String(data: data, encoding: .utf8)!
            
            let request = try FavoritEndPoint.request(token: token, candidateID: candidatID)
            
            let asFavoritSetted = try await candidatesLoader.markCandidateAsFavorite(from: request)
            
            return asFavoritSetted
        } catch {
            throw (error)
        }
        
    }
    
}
