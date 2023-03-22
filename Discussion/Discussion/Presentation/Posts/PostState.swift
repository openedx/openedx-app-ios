//
//  PostState.swift
//  Discussion
//
//  Created by Vladimir Chekyrta on 17.11.2022.
//

import Foundation

public enum PostState {
    case followed(id: String, Bool)
    case replyAdded(id: String)
    case readed(id: String)
}
