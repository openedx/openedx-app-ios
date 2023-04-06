//
//  Data_ResumeBlock.swift
//  Course
//
//  Created by  Stepanok Ivan on 05.04.2023.
//

import Foundation
import Core

public extension DataLayer {
    struct ResumeBlock: Codable {
        public let lastVisitedModuleID: String
        public let lastVisitedModulePath: [String]
        public let lastVisitedBlockID: String

        enum CodingKeys: String, CodingKey {
            case lastVisitedModuleID = "last_visited_module_id"
            case lastVisitedModulePath = "last_visited_module_path"
            case lastVisitedBlockID = "last_visited_block_id"
        }

        public init(lastVisitedModuleID: String, lastVisitedModulePath: [String], lastVisitedBlockID: String) {
            self.lastVisitedModuleID = lastVisitedModuleID
            self.lastVisitedModulePath = lastVisitedModulePath
            self.lastVisitedBlockID = lastVisitedBlockID
        }
    }
}

public extension DataLayer.ResumeBlock {
    var domain: ResumeBlock {
        ResumeBlock(blockID: lastVisitedBlockID)
    }
}
