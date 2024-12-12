//
//  DiscoveryConfig.swift
//  Core
//
//  Created by SaeedBashir on 12/18/23.
//

import Foundation
import OEXFoundation

public enum DiscoveryConfigType: String {
    case native
    case webview
    case none
}

private enum DiscoveryKeys: String, RawStringExtractable {
    case discoveryType = "TYPE"
    case webview = "WEBVIEW"
    case baseURL = "BASE_URL"
    case courseDetailTemplate = "COURSE_DETAIL_TEMPLATE"
    case programDetailTemplate = "PROGRAM_DETAIL_TEMPLATE"
}

public class DiscoveryWebviewConfig: NSObject {
    public let baseURL: String?
    public let courseDetailTemplate: String?
    public let programDetailTemplate: String?
    
    init(dictionary: [String: AnyObject]) {
        baseURL = dictionary[DiscoveryKeys.baseURL] as? String
        courseDetailTemplate = dictionary[DiscoveryKeys.courseDetailTemplate] as? String
        programDetailTemplate = dictionary[DiscoveryKeys.programDetailTemplate] as? String
    }
}

public class DiscoveryConfig: NSObject {
    public let type: DiscoveryConfigType
    public let webview: DiscoveryWebviewConfig
    public var isWebViewConfigured: Bool {
        type == .webview && webview.baseURL != nil
    }
    
    init(dictionary: [String: AnyObject]) {
        type = (dictionary[DiscoveryKeys.discoveryType] as? String).flatMap {
            DiscoveryConfigType(rawValue: $0)
        } ?? .native
        webview = DiscoveryWebviewConfig(dictionary: dictionary[DiscoveryKeys.webview] as? [String: AnyObject] ?? [:])
    }
    
    public var enabled: Bool {
        return type != .none
    }
}

private let key = "DISCOVERY"
extension Config {
    public var discovery: DiscoveryConfig {
        DiscoveryConfig(dictionary: self[key] as? [String: AnyObject] ?? [:])
    }
}

private let programKey = "PROGRAM"
extension Config {
    public var program: DiscoveryConfig {
        DiscoveryConfig(dictionary: self[programKey] as? [String: AnyObject] ?? [:])
    }
}
