//
//  ThreadPostState.swift
//  Discussion
//
//  Created by Vladimir Chekyrta on 17.11.2022.
//

import Foundation

public enum ThreadPostState {
    case voted(id: String, voted: Bool, votesCount: Int)
    case flagged(id: String, flagged: Bool)
    case postAdded(id: String)
}
