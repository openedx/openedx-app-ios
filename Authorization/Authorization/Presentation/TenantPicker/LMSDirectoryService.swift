//
//  LMSDirectoryService.swift
//  Authorization
//
//  Created by Ivan Stepanok on 20.08.2026.
//

import Core
import Foundation

enum LMSDirectoryError: Error {
    case notFound
    case offline
    case decodingFailed
}

/// Where the app's list of platforms comes from. One implementation today —
/// a JSON document, hosted or shipped with the app — behind a protocol so the
/// screen does not care which of the two it got.
protocol LMSDirectoryService: Sendable {
    /// Every platform in the directory, in the order the document lists them.
    func platforms() async throws -> [LMSSummary]
    /// Everything needed to re-theme the app and sign in to one of them.
    func details(id: String) async throws -> LMSDetail
}
