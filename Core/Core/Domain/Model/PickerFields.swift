//
//  PickerFields.swift
//  Core
//
//  Created by  Stepanok Ivan on 27.10.2022.
//

import Foundation

public enum RegistrationFieldType: String, Hashable, Sendable {
    case text
    case email
    case confirm_email
    case password
    case select
    case textarea
    case checkbox
    case plaintext
    case unknown
}

public struct PickerFields: Sendable {
    public let type: RegistrationFieldType
    public let label: String
    public let required: Bool
    public let name: String
    public let instructions: String
    public let options: [Option]

    public var isHonorCode: Bool {
        name == "honor_code"
    }

    public struct Option: Sendable {
        public let value: String
        public let name: String
        public var optionDefault: Bool
        
        public init(value: String, name: String, optionDefault: Bool) {
            self.value = value
            self.name = name
            self.optionDefault = optionDefault
        }
    }
    
    public init(type: RegistrationFieldType,
                label: String,
                required: Bool,
                name: String,
                instructions: String,
                options: [Option]) {
        self.type = type
        self.label = label
        self.required = required
        self.name = name
        self.instructions = instructions
        self.options = options
    }
}

extension DataLayer.Field {
    var domain: PickerFields {
        PickerFields(type: RegistrationFieldType(rawValue: type) ?? .unknown,
                    label: label,
                    required: fieldRequired,
                    name: name,
                    instructions: instructions,
                    options: options.map { $0.map { $0.domain } } ?? [])
    }
}
