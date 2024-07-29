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
    func trackScreenEvent(_ event: AnalyticsEvent, parameters: [String: Any]?)
    func trackScreenEvent(_ event: AnalyticsEvent, biValue: EventBIValue, parameters: [String: Any]?)
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
    
    func trackScreenEvent(_ event: AnalyticsEvent) {
        trackScreenEvent(event, parameters: nil)
    }
    
    func trackScreenEvent(_ event: AnalyticsEvent, biValue: EventBIValue) {
        trackScreenEvent(event, biValue: biValue, parameters: nil)
    }
}

#if DEBUG
public class CoreAnalyticsMock: CoreAnalytics {
    public init() {}
    public func trackEvent(_ event: AnalyticsEvent, parameters: [String: Any]? = nil) {}
    public func trackEvent(_ event: AnalyticsEvent, biValue: EventBIValue, parameters: [String: Any]?) {}
    public func trackScreenEvent(_ event: AnalyticsEvent, parameters: [String: Any]?) {}
    public func trackScreenEvent(_ event: AnalyticsEvent, biValue: EventBIValue, parameters: [String: Any]?) {}
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
    case userLogin = "Logistration:Sign In Success"
    case registerClicked = "Logistration:Register Clicked"
    case signInClicked = "Logistration:Sign In Clicked"
    case userSignInClicked = "Logistration:User Sign In Clicked"
    case createAccountClicked = "Logistration:Create Account Clicked"
    case registrationSuccess = "Logistration:Register Success"
    case userLogout = "Profile:Logged Out"
    case userLogoutClicked = "Profile:Logout Clicked"
    case forgotPasswordClicked = "Logistration:Forgot Password Clicked"
    case resetPasswordClicked = "Logistration:Reset Password Clicked"
    case resetPasswordSuccess = "Logistration:Reset Password Success"
    case mainDiscoveryTabClicked = "MainDashboard:Discover"
    case mainDashboardTabClicked = "MainDashboard:My Courses"
    case mainProgramsTabClicked = "MainDashboard:My Programs"
    case mainProfileTabClicked = "MainDashboard:Profile"
    case discoverySearchBarClicked = "Discovery:Search Bar Clicked"
    case discoveryCoursesSearch = "Discovery:Courses Search"
    case discoveryCourseClicked = "Discovery:Course Clicked"
    case discoveryProgramInfo = "Discovery:Program Info"
    case dashboardCourseClicked = "Course:Dashboard"
    case profileEditClicked = "Profile:Edit Clicked"
    case profileSwitch = "Profile:Switch Profile"
    case profileWifiToggle = "Profile:Wifi Toggle"
    case profileEditDoneClicked = "Profile:Edit Done Clicked"
    case profileDeleteAccountClicked = "Profile:Delete Account Clicked"
    case profileUserDeleteAccountClicked = "Profile:User Delete Account Clicked"
    case profileDeleteAccountSuccess = "Profile:Delete Account Success"
    case videoStreamQualityChanged = "Video:Streaming Quality Changed"
    case videoDownloadQualityChanged = "Video:Download Quality Changed"
    case profileVideoSettingsClicked = "Profile:Video Setting Clicked"
    case privacyPolicyClicked = "Profile:Privacy Policy Clicked"
    case cookiePolicyClicked = "Profile:Cookie Policy Clicked"
    case emailSupportClicked = "Profile:Contact Support Clicked"
    case faqClicked = "Profile:FAQ Clicked"
    case tosClicked = "Profile:Terms of Use Clicked"
    case dataSellClicked = "Profile:Data Sell Clicked"
    case courseEnrollClicked = "Discovery:Course Enroll Clicked"
    case courseEnrollSuccess = "Discovery:Course Enroll Success"
    case externalLinkOpenAlert = "External:Link Opening Alert"
    case externalLinkOpenAlertAction = "External:Link Opening Alert Action"
    case viewCourseClicked = "Discovery:Course Info"
    case resumeCourseClicked = "Course:Resume Course Clicked"
    case sequentialClicked = "Course:Sequential Clicked"
    case verticalClicked = "Course:Unit Detail"
    case nextBlockClicked = "Course:Next Block Clicked"
    case prevBlockClicked = "Course:Prev Block Clicked"
    case finishVerticalClicked = "Course:Unit Finished Clicked"
    case finishVerticalNextSectionClicked = "Course:Finish Unit Next Unit Clicked"
    case finishVerticalBackToOutlineClicked = "Course:Unit Finish Back To Outline Clicked"
    case courseOutlineCourseTabClicked = "Course:Home Tab"
    case courseOutlineVideosTabClicked = "Course:Videos Tab"
    case courseOutlineOfflineTabClicked = "Course:Offline Tab"
    case courseOutlineDatesTabClicked = "Course:Dates Tab"
    case courseOutlineDiscussionTabClicked = "Course:Discussion Tab"
    case courseOutlineHandoutsTabClicked = "Course:Handouts Tab"
    case datesComponentClicked = "Dates:Course Component Clicked"
    case datesCalendarSyncToggle = "Dates:CalendarSync Toggle"
    case datesCalendarSyncDialogAction = "Dates:CalendarSync Dialog Action"
    case datesCalendarSyncSnackbar = "Dates:CalendarSync Snackbar"
    case plsBannerViewed = "PLS:Banner Viewed"
    case plsShiftDatesClicked = "PLS:Shift Button Clicked"
    case plsShiftDatesSuccess = "PLS:Shift Dates Success"
    case courseViewCertificateClicked = "Course:View Certificate Clicked"
    case bulkDownloadVideosToggle = "Video:Bulk Download Toggle"
    case bulkDownloadVideosSubsection = "Video:Bulk Download Subsection"
    case bulkDownloadVideosSection = "Video:Bulk Download Section"
    case bulkDeleteVideosSubsection = "Videos:Delete Subsection Videos"
    case bulkDeleteVideosSection = "Videos:Delete Section Videos"
    case discussionAllPostsClicked = "Discussion:All Posts Clicked"
    case discussionFollowingClicked = "Discussion:Following Posts Clicked"
    case discussionTopicClicked = "Discussion:Topic Clicked"
    case appreviewPopupViewed = "AppReviews:Rating Dialog Viewed"
    case appreviewPopupAction = "AppReviews:Rating Dialog Action"
    case courseAnnouncement = "Course:Announcements"
    case courseHandouts = "Course:Handouts"
    case whatnewPopup = "WhatsNew:Pop up Viewed"
    case whatnewDone = "WhatsNew:Done"
    case whatnewClose = "WhatsNew:Close"
    case logistration = "Logistration"
    case logistrationSignIn = "Logistration:Sign In"
    case logistrationRegister = "Logistration:Register"
    case profileEdit = "Profile:Edit Profile"
}

public enum EventBIValue: String {
    case launch = "edx.bi.app.launch"
    case logistrationCoursesSearch = "edx.bi.app.logistration.courses_search"
    case logistrationExploreAllCourses = "edx.bi.app.logistration.explore.all.courses"
    case userLogin = "edx.bi.app.user.signin.success"
    case signInClicked = "edx.bi.app.logistration.signin.clicked"
    case registerClicked = "edx.bi.app.logistration.register.clicked"
    case registrationSuccess = "edx.bi.app.user.register.success"
    case userSignInClicked = "edx.bi.app.logistration.user.signin.clicked"
    case createAccountClicked = "edx.bi.app.logistration.user.create_account.clicked"
    case forgotPasswordClicked = "edx.bi.app.logistration.forgot_password.clicked"
    case resetPasswordClicked = "edx.bi.app.user.reset_password.clicked"
    case resetPasswordSuccess = "edx.bi.app.user.reset_password.success"
    case courseEnrollClicked = "edx.bi.app.course.enroll.clicked"
    case courseEnrollSuccess = "edx.bi.app.course.enroll.success"
    case externalLinkOpenAlert = "edx.bi.app.discovery.external_link.opening.alert"
    case externalLinkOpenAlertAction = "edx.bi.app.discovery.external_link.opening.alert_action"
    case viewCourseClicked = "edx.bi.app.course.info"
    case resumeCourseClicked = "edx.bi.app.course.resume_course.clicked"
    case mainDiscoveryTabClicked = "edx.bi.app.main_dashboard.discover"
    case mainDashboardTabClicked = "edx.bi.app.main_dashboard.my_course"
    case mainProgramsTabClicked = "edx.bi.app.main_dashboard.my_program"
    case mainProfileTabClicked = "edx.bi.app.main_dashboard.profile"
    case profileEditClicked = "edx.bi.app.profile.edit.clicked"
    case profileEditDoneClicked = "edx.bi.app.profile.edit_done.clicked"
    case profileVideoSettingsClicked = "edx.bi.app.profile.video_setting.clicked"
    case emailSupportClicked = "edx.bi.app.profile.email_support.clicked"
    case faqClicked = "edx.bi.app.profile.faq.clicked"
    case tosClicked = "edx.bi.app.profile.terms_of_use.clicked"
    case dataSellClicked = "edx.bi.app.profile.do_not_sell_data.clicked"
    case privacyPolicyClicked = "edx.bi.app.profile.privacy_policy.clicked"
    case cookiePolicyClicked = "edx.bi.app.profile.cookie_policy.clicked"
    case profileDeleteAccountClicked = "edx.bi.app.profile.delete_account.clicked"
    case userLogout = "edx.bi.app.user.logout"
    case datesComponentClicked = "edx.bi.app.dates.component.clicked"
    case datesCalendarSyncToggle = "edx.bi.app.dates.calendar_sync.toggle"
    case datesCalendarSyncDialogAction = "edx.bi.app.dates.calendar_sync.dialog_action"
    case datesCalendarSyncSnackbar = "edx.bi.app.dates.calendar_sync.snackbar"
    case plsBannerViewed = "edx.bi.app.dates.pls_banner.viewed"
    case plsShiftDatesClicked = "edx.bi.app.dates.pls_banner.shift_dates.clicked"
    case plsShiftDatesSuccess = "edx.bi.app.dates.pls_banner.shift_dates.success"
    case courseViewCertificateClicked = "edx.bi.app.course.view_certificate.clicked"
    case bulkDownloadVideosToggle = "edx.bi.app.videos.download.toggle"
    case bulkDownloadVideosSubsection = "edx.bi.video.subsection.bulkdownload"
    case bulkDeleteVideosSubsection = "edx.bi.app.video.delete.subsection"
    case bulkDownloadVideosSection = "edx.bi.video.section.bulkdownload"
    case bulkDeleteVideosSection = "edx.bi.app.video.delete.section"
    case dashboardCourseClicked = "edx.bi.app.course.dashboard"
    case courseOutlineVideosTabClicked = "edx.bi.app.course.video_tab"
    case courseOutlineOfflineTabClicked = "edx.bi.app.course.offline_tab"
    case courseOutlineDatesTabClicked = "edx.bi.app.course.dates_tab"
    case courseOutlineDiscussionTabClicked = "edx.bi.app.course.discussion_tab"
    case courseOutlineHandoutsTabClicked = "edx.bi.app.course.handouts_tab"
    case verticalClicked = "edx.bi.app.course.unit_detail"
    case nextBlockClicked = "edx.bi.app.course.next_block.clicked"
    case prevBlockClicked = "bi.app.course.prev_block.clicked"
    case sequentialClicked = "edx.bi.app.course.sequential.clicked"
    case finishVerticalClicked = "edx.bi.app.course.unit_finished.clicked"
    case finishVerticalNextSectionClicked = "edx.bi.app.course.finish_unit.next_unit.clicked"
    case finishVerticalBackToOutlineClicked = "edx.bi.app.course.finish_unit.back_to_outline.clicked"
    case discoverySearchBarClicked = "edx.bi.app.discovery.search_bar.clicked"
    case discoveryCoursesSearch = "edx.bi.app.discovery.courses_search"
    case discoveryCourseClicked = "edx.bi.app.discovery.course.clicked"
    case discussionAllPostsClicked = "edx.bi.app.discussion.all_posts.clicked"
    case discussionFollowingClicked = "edx.bi.app.discussion.following_posts.clicked"
    case discussionTopicClicked = "edx.bi.app.discussion.topic.clicked"
    case discoveryProgramInfo = "edx.bi.app.discovery.program_info"
    case userLogoutClicked = "edx.bi.app.profile.logout.clicked"
    case courseOutlineCourseTabClicked = "edx.bi.app.course.home_tab"
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
    case logistration = "edx.bi.app.logistration"
    case logistrationSignIn = "edx.bi.app.logistration.signin"
    case logistrationRegister = "edx.bi.app.logistration.register"
    case profileEdit = "edx.bi.app.profile.edit"
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
    public static let conversion = "conversion"
    public static let enrollmentMode = "enrollment_mode"
    public static let pacing = "pacing"
    public static let dialog = "dialog"
    public static let snackbar = "snackbar"
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
