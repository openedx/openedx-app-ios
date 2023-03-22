//
//  PickerFields.swift
//  Core
//
//  Created by  Stepanok Ivan on 25.10.2022.
//

import Foundation

// MARK: - PickerFields
extension DataLayer {
    public struct RegistrationFields: Codable {
        public let method: String
        public let submitURL: String
        public let fields: [Field]
        
        enum CodingKeys: String, CodingKey {
            case method = "method"
            case submitURL = "submit_url"
            case fields = "fields"
        }
    }
    
    // MARK: - Field
    public struct Field: Codable {
        public let name: String
        public let label: String
        public let type: String
        public let placeholder: String
        public let instructions: String
        public let exposed: Bool
        public let fieldRequired: Bool
        public let restrictions: Restrictions
        public let errorMessages: ErrorMessages
        public let supplementalLink: String
        public let supplementalText: String
        public let loginIssueSupportLink: String
        public let options: [Option]?
        
        enum CodingKeys: String, CodingKey {
            case name = "name"
            case label = "label"
            case type = "type"
            case placeholder = "placeholder"
            case instructions = "instructions"
            case exposed = "exposed"
            case fieldRequired = "required"
            case restrictions = "restrictions"
            case errorMessages = "errorMessages"
            case supplementalLink = "supplementalLink"
            case supplementalText = "supplementalText"
            case loginIssueSupportLink = "loginIssueSupportLink"
            case options = "options"
        }
    }
    
    // MARK: - ErrorMessages
    public struct ErrorMessages: Codable {
        public let errorMessagesRequired: String?
        
        enum CodingKeys: String, CodingKey {
            case errorMessagesRequired = "required"
        }
    }
    
    // MARK: - Option
    public struct Option: Codable {
        public let value: String
        public let name: String
        public let optionDefault: Bool
        
        enum CodingKeys: String, CodingKey {
            case value = "value"
            case name = "name"
            case optionDefault = "default"
        }
        
        public init(value: String, name: String, optionDefault: Bool) {
            self.value = value
            self.name = name
            self.optionDefault = optionDefault
        }
    }
    
    // MARK: - Restrictions
    public struct Restrictions: Codable {
        public let maxLength: Int?
        public let minLength: Int?
        
        enum CodingKeys: String, CodingKey {
            case maxLength = "max_length"
            case minLength = "min_length"
        }
        
        public init(maxLength: Int?, minLength: Int?) {
            self.maxLength = maxLength
            self.minLength = minLength
        }
    }
}

extension DataLayer.Option {
    var domain: PickerFields.Option {
        PickerFields.Option(value: value, name: name, optionDefault: optionDefault)
    }
}
