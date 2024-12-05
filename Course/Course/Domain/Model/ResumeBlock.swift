//
//  ResumeBlock.swift
//  Course
//
//  Created by  Stepanok Ivan on 05.04.2023.
//

import Foundation

public struct ResumeBlock: Sendable {
    let blockID: String
    
    public init(blockID: String) {
        self.blockID = blockID
    }
}
