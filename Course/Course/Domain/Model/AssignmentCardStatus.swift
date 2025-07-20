//
//  AssignmentCardStatus.swift
//  Course
//
//  Created by Ivan Stepanok on 08.07.2025.
//

import SwiftUI
import Core
import Theme

public enum AssignmentCardStatus: Sendable {
    case completed
    case incomplete
    case pastDue
    case notAvailable
    
    public var backgroundColor: Color {
        switch self {
        case .completed:
            return Theme.Colors.success.opacity(0.1)
        case .incomplete:
            return Theme.Colors.background
        case .pastDue:
            return Theme.Colors.warning.opacity(0.1)
        case .notAvailable:
            return Theme.Colors.textSecondary.opacity(0.1)
        }
    }
    
    public var borderColor: Color {
        switch self {
        case .completed:
            return Theme.Colors.success
        case .incomplete:
            return Theme.Colors.cardViewStroke
        case .pastDue:
            return Theme.Colors.warning
        case .notAvailable:
            return Theme.Colors.textSecondary
        }
    }
    
    public var icon: Image? {
        switch self {
        case .completed:
            return CoreAssets.checkmark.swiftUIImage
        case .pastDue:
            return CoreAssets.alarm.swiftUIImage
        case .notAvailable:
            return CoreAssets.lockIcon.swiftUIImage
        case .incomplete:
            return nil
        }
    }
}
