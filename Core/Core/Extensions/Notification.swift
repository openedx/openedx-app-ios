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
    static let appVersionLastSupportedDate = Notification.Name("appVersionLastSupportedDate")
    static let appLatestVersion = Notification.Name("appLatestVersion")
    static let blockAppBeforeUpdate = Notification.Name("blockAppBeforeUpdate")
}
