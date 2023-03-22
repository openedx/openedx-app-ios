//
//  FieldConfiguration.swift
//  Core
//
//  Created by  Stepanok Ivan on 03.11.2022.
//

import Foundation
import SwiftUI

public class FieldConfiguration: ObservableObject {
    @Published public var shake: Bool = false
    @Published public var error: String {
        didSet {
            if error.count > 0 {
                shake = true
            }
        }
    }
    @Published public var text: String {
        didSet {
            error = ""
            shake = false
        }
    }
    
    @Published public var selectedItem: PickerItem?
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
