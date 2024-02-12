//
//  PushLink.swift
//  OpenEdX
//
//  Created by Anton Yarmolenka on 24/01/2024.
//

import Foundation

enum DataKeys: String {
    case title
    case body
    case aps
    case alert
}

// This link will have information of course and screen type which will be use to route on particular screen.
public class PushLink: DeepLink {
    let title: String?
    let body: String?
    
    override init(dictionary: [String: Any]) {
        let aps = dictionary[DataKeys.aps.rawValue] as? [String: Any]
        let alert = aps?[DataKeys.alert.rawValue] as? [String: Any]
        title = alert?[DataKeys.title.rawValue] as? String
        body = alert?[DataKeys.body.rawValue] as? String

        super.init(dictionary: dictionary)
    }
}
