//
//  TokenStoreSpy.swift
//  VitesseTests
//
//  Created by Alassane Der on 13/09/2024.
//

import Foundation
@testable import Vitesse

final class TokenStoreSpy: TokenStore {
    enum ReceivedMessage: Equatable {
        case delete
        case insert
        case retrieve
    }

    private(set) var receivedMessages = [ReceivedMessage]()

    private var deletionResult: Result<Void, Error>?
    private var insertionResult: Result<Void, Error>?
    private var retrievalResult: Result<Data, Error>?

    func insert(_ data: Data) throws {
        receivedMessages.append(.insert)
        try insertionResult?.get()
    }

    func completeInsertion(with error: Error) {
        insertionResult = .failure(error)
    }

    func completeInsertionSuccessfully() {
        insertionResult = .success(())
    }

    func retrieve() throws -> Data {
        receivedMessages.append(.retrieve)
        return try retrievalResult?.get() ?? Data()
    }

    func completeRetrieval(with error: Error) {
        retrievalResult = .failure(error)
    }

    func completeRetrieval(with data: Data) {
        retrievalResult = .success(data)
    }

    func delete() throws {
        receivedMessages.append(.delete)
        try deletionResult?.get()
    }

    func completeDeletion(with error: Error) {
        deletionResult = .failure(error)
    }

    func completeDeletionSuccessfully() {
        deletionResult = .success(())
    }
}
