//
//  ProgramConfig.swift
//  Core
//
//  Created by Saeed Bashir on 1/24/24.
//

import Foundation

public enum ProgramConfigType: String {
    case native
    case webview
    case none
}

private enum ProgramKeys: String, RawStringExtractable {
    case programURL = "PROGRAM_URL"
    case programDetailURLTemplate = "PROGRAM_DETAIL_URL_TEMPLATE"
    case programType = "TYPE"
}

public class ProgramConfig: NSObject {

    public let programURL: String?
    public let programDetailURLTemplate: String?
    public let type: ProgramConfigType
   
    init(dictionary: [String: AnyObject]) {
        programURL = dictionary[ProgramKeys.programURL] as? String
        programDetailURLTemplate = dictionary[ProgramKeys.programDetailURLTemplate] as? String
        type = (dictionary[ProgramKeys.programType] as? String).flatMap {
            ProgramConfigType(rawValue: $0)
        } ?? .webview
    }
    
    public var enabled: Bool {
        return type != .none
    }
}

private let key = "PROGRAM"
extension Config {
    public var program: ProgramConfig {
        ProgramConfig(dictionary: self[key] as? [String: AnyObject] ?? [:])
    }
}
