//
//  Notification.swift
//  Core
//
//  Created by Vladimir Chekyrta on 15.12.2022.
//

import Foundation

public extension Notification.Name {
    static let userAuthorized = Notification.Name("userAuthorized")
    static let userLoggedOut = Notification.Name("userLoggedOut")
    static let onCourseEnrolled = Notification.Name("onCourseEnrolled")
    static let onblockCompletionRequested = Notification.Name("onblockCompletionRequested")
    static let onTokenRefreshFailed = Notification.Name("onTokenRefreshFailed")
    static let onActualVersionReceived = Notification.Name("onActualVersionReceived")
    static let onAppUpgradeAccountSettingsTapped = Notification.Name("onAppUpgradeAccountSettingsTapped")
    static let onNewVersionAvaliable = Notification.Name("onNewVersionAvaliable")
    static let webviewReloadNotification = Notification.Name("webviewReloadNotification")
    static let onBlockCompletion = Notification.Name("onBlockCompletion")
    static let shiftCourseDates = Notification.Name("shiftCourseDates")
    static let profileUpdated = Notification.Name("profileUpdated")
    static let getCourseDates = Notification.Name("getCourseDates")
    static let showDownloadFailed = Notification.Name("showDownloadFailed")
    static let tryDownloadAgain = Notification.Name("tryDownloadAgain")
    static let refreshEnrollments = Notification.Name("refreshEnrollments")
}

public extension Notification {
    enum UserInfoKey: String {
        case isForced
    }
}

