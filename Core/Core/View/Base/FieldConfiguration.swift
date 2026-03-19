//
//  FieldConfiguration.swift
//  Core
//
//  Created by  Stepanok Ivan on 03.11.2022.
//

import Foundation
import SwiftUI

@Observable
public class FieldConfiguration {
     public var shake: Bool = false
     public var error: String {
        didSet {
            if error.count > 0 {
                shake = true
            }
        }
    }
     public var text: String {
        didSet {
            error = ""
            shake = false
        }
    }
    
    public var selectedItem: PickerItem?
    public let field: PickerFields
    
    public init(error: String = "", text: String = "", field: PickerFields, selectedItem: PickerItem? = nil) {
        self.error = error
        self.text = text
        self.field = field
        self.selectedItem = selectedItem
    }
}

// For previews
public extension FieldConfiguration {
    static func initial(_ title: String) -> FieldConfiguration {
        return .init(field: PickerFields(type: .text,
                                               label: title,
                                               required: false,
                                               name: title,
                                               instructions: "Instructions",
                                               options: []))
    }
}
