//
//  CoreAnalytics.swift
//  Core
//
//  Created by Saeed Bashir on 3/6/24.
//

import Foundation

//sourcery: AutoMockable
public protocol CoreAnalytics {
    func trackEvent(_ event: AnalyticsEvent, parameters: [String: Any]?)
    func trackEvent(_ event: AnalyticsEvent, biValue: EventBIValue, parameters: [String: Any]?)
    func appreview(_ event: AnalyticsEvent, biValue: EventBIValue, action: String?, rating: Int?)
    func videoQualityChanged(
        _ event: AnalyticsEvent,
        bivalue: EventBIValue,
        value: String,
        oldValue: String
    )
}

public extension CoreAnalytics {
    func trackEvent(_ event: AnalyticsEvent) {
        trackEvent(event, parameters: nil)
    }
    
    func trackEvent(_ event: AnalyticsEvent, biValue: EventBIValue) {
        trackEvent(event, biValue: biValue, parameters: nil)
    }
}

#if DEBUG
public class CoreAnalyticsMock: CoreAnalytics {
    public init() {}
    public func trackEvent(_ event: AnalyticsEvent, parameters: [String: Any]? = nil) {}
    public func trackEvent(_ event: AnalyticsEvent, biValue: EventBIValue, parameters: [String: Any]?) {}
    public func appreview(_ event: AnalyticsEvent, biValue: EventBIValue, action: String? = nil, rating: Int? = 0) {}
    public func videoQualityChanged(
        _ event: AnalyticsEvent,
        bivalue: EventBIValue,
        value: String,
        oldValue: String
    ) {}
}
#endif

public enum AnalyticsEvent: String {
    case launch = "Launch"
    case logistrationCoursesSearch = "Logistration:Courses Search"
    case logistrationExploreAllCourses = "Logistration:Explore All Courses"
    
    case userLogin = "User_Login"
    case signUpClicked = "Sign_up_Clicked"
    case signInClicked = "Logistration:Sign In Clicked"
    case userSignInClicked = "Logistration:User Sign In Clicked"
    
    case createAccountClicked = "Create_Account_Clicked"
    case registrationSuccess = "Registration_Success"
    case userLogout = "User_Logout"
    case userLogoutClicked = "Profile:Logout Clicked"
    case forgotPasswordClicked = "Forgot_password_Clicked"
    case resetPasswordClicked = "Reset_password_Clicked"
    case resetPasswordSuccess = "Logistration:Reset Password Success"
    
    case mainDiscoveryTabClicked = "Main_Discovery_tab_Clicked"
    case mainDashboardTabClicked = "Main_Dashboard_tab_Clicked"
    case mainProgramsTabClicked = "Main_Programs_tab_Clicked"
    case mainProfileTabClicked = "Main_Profile_tab_Clicked"
    
    case discoverySearchBarClicked = "Discovery_Search_Bar_Clicked"
    case discoveryCoursesSearch = "Discovery_Courses_Search"
    case discoveryCourseClicked = "Discovery_Course_Clicked"
    case discoveryProgramInfo = "Discovery:Program Info"
    
    case dashboardCourseClicked = "Dashboard_Course_Clicked"
    
    case profileEditClicked = "Profile_Edit_Clicked"
    case profileSwitch = "Profile:Switch Profile"
    case profileWifiToggle = "Profile:Wifi Toggle"
    case profileEditDoneClicked = "Profile_Edit_Done_Clicked"
    case profileDeleteAccountClicked = "Profile_Delete_Account_Clicked"
    case profileUserDeleteAccountClicked = "Profile:User Delete Account Clicked"
    case profileDeleteAccountSuccess = "Profile:Delete Account Success"
    case videoStreamQualityChanged = "Video:Streaming Quality Changed"
    case videoDownloadQualityChanged = "Video:Download Quality Changed"
    
    case profileVideoSettingsClicked = "Profile_Video_settings_Clicked"
    case privacyPolicyClicked = "Privacy_Policy_Clicked"
    case cookiePolicyClicked = "Cookie_Policy_Clicked"
    case emailSupportClicked = "Email_Support_Clicked"
    
    case courseEnrollClicked = "Course_Enroll_Clicked"
    case courseEnrollSuccess = "Course_Enroll_Success"
    case externalLinkOpenAlert = "External:Link Opening Alert"
    case externalLinkOpenAlertAction = "External:Link Opening Alert Action"
    case viewCourseClicked = "View_Course_Clicked"
    case resumeCourseTapped = "Resume_Course_Tapped"
    case sequentialClicked = "Sequential_Clicked"
    case verticalClicked = "Vertical_Clicked"
    case nextBlockClicked = "Next_Block_Clicked"
    case prevBlockClicked = "Prev_Block_Clicked"
    case finishVerticalClicked = "Finish_Vertical_Clicked"
    case finishVerticalNextSectionClicked = "Finish_Vertical_Next_section_Clicked"
    case finishVerticalBackToOutlineClicked = "Finish_Vertical_Back_to_outline_Clicked"
    case courseOutlineCourseTabClicked = "Course_Outline_Course_tab_Clicked"
    case courseOutlineVideosTabClicked = "Course_Outline_Videos_tab_Clicked"
    case courseOutlineDatesTabClicked = "Course_Outline_Dates_tab_Clicked"
    case courseOutlineDiscussionTabClicked = "Course_Outline_Discussion_tab_Clicked"
    case courseOutlineHandoutsTabClicked = "Course_Outline_Handouts_tab_Clicked"
    case datesComponentClicked = "Dates:Course Component Clicked"
    case plsBannerViewed = "PLS:Banner Viewed"
    case plsShiftDatesClicked = "PLS:Shift Button Clicked"
    case plsShiftDatesSuccess = "PLS:Shift Dates Success"
    case courseViewCertificateClicked = "Course:View Certificate Clicked"
    case bulkDownloadVideosToggle = "Video:Bulk Download Toggle"
    case bulkDownloadVideosSubsection = "Video:Bulk Download Subsection"
    case bulkDeleteVideosSubsection = "Videos:Delete Subsection Videos"
    
    case discussionAllPostsClicked = "Discussion_All_Posts_Clicked"
    case discussionFollowingClicked = "Discussion_Following_Clicked"
    case discussionTopicClicked = "Discussion_Topic_Clicked"
    
    case appreviewPopupViewed = "AppReviews:Rating Dialog Viewed"
    case appreviewPopupAction = "AppReviews:Rating Dialog Action"
    
    case courseAnnouncement = "Course:Announcements"
    case courseHandouts = "Course:Handouts"
    
    case whatnewPopup = "WhatsNew:Pop up Viewed"
    case whatnewDone = "WhatsNew:Done"
    case whatnewClose = "WhatsNew:Close"
}

public enum EventBIValue: String {
    case launch = "edx.bi.app.launch"
    case logistrationCoursesSearch = "edx.bi.app.logistration.courses_search"
    case logistrationExploreAllCourses = "edx.bi.app.logistration.explore.all.courses"
    case signInClicked = "edx.bi.app.logistration.signin.clicked"
    case userSignInClicked = "edx.bi.app.logistration.user.signin.clicked"
    
    case resetPasswordClicked = "edx.bi.app.user.reset_password.clicked"
    case resetPasswordSuccess = "edx.bi.app.user.reset_password.success"
    
    case externalLinkOpenAlert = "edx.bi.app.discovery.external_link.opening.alert"
    case externalLinkOpenAlertAction = "edx.bi.app.discovery.external_link.opening.alert_action"
    
    case datesComponentClicked = "edx.bi.app.coursedates.component.clicked"
    case plsBannerViewed = "edx.bi.app.dates.pls_banner.viewed"
    case plsShiftDatesClicked = "edx.bi.app.dates.pls_banner.shift_dates.clicked"
    case plsShiftDatesSuccess = "edx.bi.app.dates.pls_banner.shift_dates.success"
    case courseViewCertificateClicked = "edx.bi.app.course.view_certificate.clicked"
    case bulkDownloadVideosToggle = "edx.bi.app.videos.download.toggle"
    case bulkDownloadVideosSubsection = "edx.bi.video.subsection.bulkdownload"
    case bulkDeleteVideosSubsection = "edx.bi.app.video.delete.subsection"
    
    case discoveryProgramInfo = "edx.bi.app.discovery.program_info"
    case userLogoutClicked = "edx.bi.app.profile.logout.clicked"
    
    case appreviewPopupViewed = "edx.bi.app.app_reviews.rating_dialog.viewed"
    case appreviewPopupAction = "edx.bi.app.app_reviews.rating_dialog.action"
    
    case profileSwitch = "edx.bi.app.profile.switch_profile.clicked"
    case profileWifiToggle = "edx.bi.app.profile.wifi_toggle"
    
    case profileUserDeleteAccountClicked = "edx.bi.app.profile.user.delete_account.clicked"
    case profileDeleteAccountSuccess = "edx.bi.app.profile.delete_account.success"
    case videoStreamQualityChanged = "edx.bi.app.video.streaming_quality.changed"
    case videoDownloadQualityChanged = "edx.bi.app.video.download_quality.changed"
    
    case courseAnnouncement = "edx.bi.app.course.announcements"
    case courseHandouts = "edx.bi.app.course.handouts"
    
    case whatnewPopup = "edx.bi.app.whats_new.popup.viewed"
    case whatnewDone = "edx.bi.app.whats_new.done"
    case whatnewClose = "edx.bi.app.whats_new.close"
}

public struct EventParamKey {
    public static let courseID = "course_id"
    public static let courseName = "course_name"
    public static let topicID = "topic_id"
    public static let topicName = "topic_name"
    public static let blockID = "block_id"
    public static let blockName = "block_name"
    public static let method = "method"
    public static let label = "label"
    public static let coursesCount = "courses_count"
    public static let force = "force"
    public static let success = "success"
    public static let category = "category"
    public static let appVersion = "app_version"
    public static let name = "name"
    public static let link = "link"
    public static let url = "url"
    public static let screenName = "screen_name"
    public static let alertAction = "alert_action"
    public static let action = "action"
    public static let searchQuery = "search_query"
    public static let value = "value"
    public static let oldValue = "old_value"
    public static let rating = "rating"
    public static let bannerType = "banner_type"
    public static let courseSection = "course_section"
    public static let courseSubsection = "course_subsection"
    public static let noOfVideos = "number_of_videos"
    public static let supported = "supported"
}

public struct EventCategory {
    public static let appreviews = "app-reviews"
    public static let whatsNew = "whats_new"
    public static let courseDates = "course_dates"
    public static let discovery = "discovery"
    public static let profile = "profile"
    public static let video = "video"
    public static let course = "course"
}
