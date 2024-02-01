//
//  Notification.swift
//  Core
//
//  Created by Vladimir Chekyrta on 15.12.2022.
//

import Foundation

public extension Notification.Name {
    static let onCourseEnrolled = Notification.Name("onCourseEnrolled")
    static let onTokenRefreshFailed = Notification.Name("onTokenRefreshFailed")
    static let onActualVersionReceived = Notification.Name("onActualVersionReceived")
    static let onAppUpgradeAccountSettingsTapped = Notification.Name("onAppUpgradeAccountSettingsTapped")
    static let onNewVersionAvaliable = Notification.Name("onNewVersionAvaliable")
    static let webviewReloadNotification = Notification.Name("webviewReloadNotification")
    static let onBlockCompletion = Notification.Name.init("onBlockCompletion")
    static let onRefreshCourse = Notification.Name.init("refreshCourse")
}
