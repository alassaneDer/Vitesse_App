//
//  TokenStore.swift
//  Vitesse
//
//  Created by Alassane Der on 07/09/2024.
//

import Foundation

protocol TokenStore {
    func insert(_ data: Data) throws
    func retrieve() throws -> Data
    func delete() throws
}
