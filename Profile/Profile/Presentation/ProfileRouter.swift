//
//  ProfileRouter.swift
//  Profile
//
//  Created by  Stepanok Ivan on 16.11.2022.
//

import Foundation
import Core
import UIKit

//sourcery: AutoMockable
public protocol ProfileRouter: BaseRouter {
    
    func showEditProfile(
        userModel: Core.UserProfile,
        avatar: UIImage?,
        profileDidEdit: @escaping ((UserProfile?, UIImage?)) -> Void
    )
    
    func showSettings()
    
    func showVideoSettings()
    
    func showManageAccount()
    
    func showDatesAndCalendar()
    
    func showSyncCalendarOptions(viewModel: DatesAndCalendarViewModel)
    
    func showCoursesToSync(viewModel: DatesAndCalendarViewModel)
    
    func showVideoQualityView(viewModel: SettingsViewModel)

    func showVideoDownloadQualityView(
        downloadQuality: DownloadQuality,
        didSelect: ((DownloadQuality) -> Void)?,
        analytics: CoreAnalytics
    )

    func showDeleteProfileView()
    
}

// Mark - For testing and SwiftUI preview
#if DEBUG
public class ProfileRouterMock: BaseRouterMock, ProfileRouter {
    
    public override init() {}
    
    public func showEditProfile(
        userModel: Core.UserProfile,
        avatar: UIImage?,
        profileDidEdit: @escaping ((UserProfile?, UIImage?)) -> Void
    ) {}
    
    public func showSettings() {}
    
    public func showVideoSettings() {}
    
    public func showDatesAndCalendar() {}
    
    public func showSyncCalendarOptions(viewModel: DatesAndCalendarViewModel) {}
    
    public func showCoursesToSync(viewModel: DatesAndCalendarViewModel) {}
    
    public func showManageAccount() {}
    
    public func showVideoQualityView(viewModel: SettingsViewModel) {}

    public func showVideoDownloadQualityView(
        downloadQuality: DownloadQuality,
        didSelect: ((DownloadQuality) -> Void)?,
        analytics: CoreAnalytics
    ) {}

    public func showDeleteProfileView() {}
    
}
#endif
