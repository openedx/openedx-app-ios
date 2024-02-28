//
//  PushLink.swift
//  OpenEdX
//
//  Created by Anton Yarmolenka on 24/01/2024.
//

import Foundation
import Core

enum DataKeys: String, RawStringExtractable {
    case title
    case body
    case aps
    case alert
    case ab
}

// This link will have information of course and screen type which will be use to route on particular screen.
public class PushLink: DeepLink {
    let title: String?
    let body: String?
    
    override init(dictionary: [AnyHashable: Any]) {
        let aps = dictionary[DataKeys.aps.rawValue] as? [String: Any]
        let alert = aps?[DataKeys.alert.rawValue] as? [String: Any]
        let data = dictionary[DataKeys.ab.rawValue] as? [String: Any] ?? [:]
        title = alert?[DataKeys.title.rawValue] as? String
        body = alert?[DataKeys.body.rawValue] as? String

        super.init(dictionary: data)
    }
}
