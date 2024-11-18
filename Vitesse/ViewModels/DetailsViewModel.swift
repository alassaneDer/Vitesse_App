//
//  DetailsViewModel.swift
//  Vitesse
//
//  Created by Alassane Der on 10/09/2024.
//

import Foundation
import Combine

final class DetailsViewModel: ObservableObject {
    
    @Published var phone: String = ""
    @Published var note: String = ""
    @Published var id: String = ""
    @Published var firstName: String = ""
    @Published var linkedinURL: String = ""
    @Published var isFavorite: Bool = false
    @Published var email: String = ""
    @Published var lastName: String = ""
        
    private var detailsLoader: DetailLoader
    private var updator: Updator
    private var asFavoritSetor: AsFavoriteSetor
    private var tokenStore: TokenStore
    
    init(updator: Updator = Updator(), detailsLoader: DetailLoader = DetailLoader(), asFavoritSetor: AsFavoriteSetor = AsFavoriteSetor(), tokenStore: TokenStore = KeychainStore()) {
        self.detailsLoader = detailsLoader
        self.tokenStore = tokenStore
        self.updator = updator
        self.asFavoritSetor = asFavoritSetor
    }
    
    // MARK: load candidate details
    func loadDetails(by candidatID: String) async throws -> CandidateItem {
        let data = try tokenStore.retrieve()
        let token = String(data: data, encoding: .utf8)!
        let request = DetailEndPoint.request(token: token, candidatID: candidatID)
        let details = try await detailsLoader.loadDetails(from: request)
        
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
            
             let updatedCandidate = try await updator.update(from: request)
            
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
            
            let request = try FavoritEndPoint.request(isAdmin: false, token: token, candidateID: candidatID)
            
            let asFavoritSetted = try await asFavoritSetor.FavoriteSetor(from: request)
            
            return asFavoritSetted
        } catch {
            print("l'id du candidat à mettre en favorit est \(candidatID)")
            throw (error)
        }
       
    }
    
}
