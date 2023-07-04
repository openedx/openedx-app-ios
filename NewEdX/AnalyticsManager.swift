//
//  AnalyticsManager.swift
//  NewEdX
//
//  Created by  Stepanok Ivan on 27.06.2023.
//

import Foundation
import Core
import FirebaseAnalytics
import Authorization
import Discovery
import Dashboard
import Profile
import Course
import Discussion

class AnalyticsManager: AuthorizationAnalytics,
                        MainScreenAnalytics,
                        DiscoveryAnalytics,
                        DashboardAnalytics,
                        ProfileAnalytics,
                        CourseAnalytics,
                        DiscussionAnalytics {
    
    public func setUserID(_ id: String) {
        Analytics.setUserID(id)
    }
    
    public func userLogin(method: LoginMethod) {
        logEvent(.userLogin, parameters: [Key.method: method.rawValue])
    }
    
    public func signUpClicked() {
        logEvent(.signUpClicked)
    }
    
    public func createAccountClicked() {
        logEvent(.createAccountClicked)
    }
    
    public func registrationSuccess() {
        logEvent(.registrationSuccess)
    }
    
    public func forgotPasswordClicked() {
        logEvent(.forgotPasswordClicked)
    }
    
    public func resetPasswordClicked(success: Bool) {
        logEvent(.resetPasswordClicked, parameters: [Key.success: success])
    }
    
    // MARK: MainScreenAnalytics
    
    public func mainDiscoveryTabClicked() {
        logEvent(.mainDiscoveryTabClicked)
    }
    
    public func mainDashboardTabClicked() {
        logEvent(.mainDashboardTabClicked)
    }
    
    public func mainProgramsTabClicked() {
        logEvent(.mainProgramsTabClicked)
    }
    
    public func mainProfileTabClicked() {
        logEvent(.mainProfileTabClicked)
    }
    
    // MARK: Discovery
    
    public func discoverySearchBarClicked() {
        logEvent(.discoverySearchBarClicked)
    }
    
    public func discoveryCoursesSearch(label: String, coursesCount: Int) {
        logEvent(.discoveryCoursesSearch,
                 parameters: [Key.label: label,
                              Key.coursesCount: coursesCount])
    }
    
    public func discoveryCourseClicked(courseID: String, courseName: String) {
        let parameters = [
            Key.courseID: courseID,
            Key.courseName: courseName
        ]
        logEvent(.discoveryCourseClicked, parameters: parameters)
    }
    
    // MARK: Dashboard
    
    public func dashboardCourseClicked(courseID: String, courseName: String) {
        let parameters = [
            Key.courseID: courseID,
            Key.courseName: courseName
        ]
        logEvent(.dashboardCourseClicked, parameters: parameters)
    }
    
    // MARK: Profile
    
    public func profileEditClicked() {
        logEvent(.profileEditClicked)
    }
    
    public func profileEditDoneClicked() {
        logEvent(.profileEditDoneClicked)
    }
    
    public func profileDeleteAccountClicked() {
        logEvent(.profileDeleteAccountClicked)
    }
    
    public func profileVideoSettingsClicked() {
        logEvent(.profileVideoSettingsClicked)
    }
    
    public func privacyPolicyClicked() {
        logEvent(.privacyPolicyClicked)
    }
    
    public func cookiePolicyClicked() {
        logEvent(.cookiePolicyClicked)
    }
    
    public func emailSupportClicked() {
        logEvent(.emailSupportClicked)
    }
    
    public func userLogout(force: Bool) {
        logEvent(.userLogout, parameters: [Key.force: force])
    }
    
    // MARK: Course
    
    public func courseEnrollClicked(courseId: String, courseName: String) {
        let parameters = [
            Key.courseID: courseId,
            Key.courseName: courseName
        ]
        logEvent(.courseEnrollClicked, parameters: parameters)
    }
    
    public func courseEnrollSuccess(courseId: String, courseName: String) {
        let parameters = [
            Key.courseID: courseId,
            Key.courseName: courseName
        ]
        logEvent(.courseEnrollSuccess, parameters: parameters)
    }
    
    public func viewCourseClicked(courseId: String, courseName: String) {
        let parameters = [
            Key.courseID: courseId,
            Key.courseName: courseName
        ]
        logEvent(.viewCourseClicked, parameters: parameters)
    }
    
    public func resumeCourseTapped(courseId: String, courseName: String, blockId: String) {
        let parameters = [
            Key.courseID: courseId,
            Key.courseName: courseName,
            Key.blockID: blockId
        ]
        logEvent(.resumeCourseTapped, parameters: parameters)
    }
    
    public func sequentialClicked(courseId: String, courseName: String, blockId: String, blockName: String) {
        let parameters = [
            Key.courseID: courseId,
            Key.courseName: courseName,
            Key.blockID: blockId,
            Key.blockName: blockName
        ]
        logEvent(.sequentialClicked, parameters: parameters)
    }
    
    public func verticalClicked(courseId: String, courseName: String, blockId: String, blockName: String) {
        let parameters = [
            Key.courseID: courseId,
            Key.courseName: courseName,
            Key.blockID: blockId,
            Key.blockName: blockName
        ]
        logEvent(.verticalClicked, parameters: parameters)
    }
    
    public func nextBlockClicked(courseId: String, courseName: String, blockId: String, blockName: String) {
        let parameters = [
            Key.courseID: courseId,
            Key.courseName: courseName,
            Key.blockID: blockId,
            Key.blockName: blockName
        ]
        logEvent(.nextBlockClicked, parameters: parameters)
    }
    
    public func prevBlockClicked(courseId: String, courseName: String, blockId: String, blockName: String) {
        let parameters = [
            Key.courseID: courseId,
            Key.courseName: courseName,
            Key.blockID: blockId,
            Key.blockName: blockName
        ]
        logEvent(.prevBlockClicked, parameters: parameters)
    }
    
    public func finishVerticalClicked(courseId: String, courseName: String, blockId: String, blockName: String) {
        let parameters = [
            Key.courseID: courseId,
            Key.courseName: courseName,
            Key.blockID: blockId,
            Key.blockName: blockName
        ]
        logEvent(.finishVerticalClicked, parameters: parameters)
    }
    
    public func finishVerticalNextSectionClicked(
        courseId: String,
        courseName: String,
        blockId: String,
        blockName: String
    ) {
        let parameters = [
            Key.courseID: courseId,
            Key.courseName: courseName,
            Key.blockID: blockId,
            Key.blockName: blockName
        ]
        logEvent(.finishVerticalNextSectionClicked, parameters: parameters)
    }
    
    public func finishVerticalBackToOutlineClicked(courseId: String, courseName: String) {
        let parameters = [
            Key.courseID: courseId,
            Key.courseName: courseName
        ]
        logEvent(.finishVerticalBackToOutlineClicked, parameters: parameters)
    }
    
    public func courseOutlineCourseTabClicked(courseId: String, courseName: String) {
        let parameters = [
            Key.courseID: courseId,
            Key.courseName: courseName
        ]
        logEvent(.courseOutlineCourseTabClicked, parameters: parameters)
    }
    
    public func courseOutlineVideosTabClicked(courseId: String, courseName: String) {
        let parameters = [
            Key.courseID: courseId,
            Key.courseName: courseName
        ]
        logEvent(.courseOutlineVideosTabClicked, parameters: parameters)
    }
    
    public func courseOutlineDiscussionTabClicked(courseId: String, courseName: String) {
        let parameters = [
            Key.courseID: courseId,
            Key.courseName: courseName
        ]
        logEvent(.courseOutlineDiscussionTabClicked, parameters: parameters)
    }
    
    public func courseOutlineHandoutsTabClicked(courseId: String, courseName: String) {
        let parameters = [
            Key.courseID: courseId,
            Key.courseName: courseName
        ]
        logEvent(.courseOutlineHandoutsTabClicked, parameters: parameters)
    }
    
    // MARK: Discussion
    public func discussionAllPostsClicked(courseId: String, courseName: String) {
        let parameters = [
            Key.courseID: courseId,
            Key.courseName: courseName
        ]
        logEvent(.discussionAllPostsClicked, parameters: parameters)
    }
    
    public func discussionFollowingClicked(courseId: String, courseName: String) {
        let parameters = [
            Key.courseID: courseId,
            Key.courseName: courseName
        ]
        logEvent(.discussionFollowingClicked, parameters: parameters)
    }
    
    public func discussionTopicClicked(courseId: String, courseName: String, topicId: String, topicName: String) {
        let parameters = [
            Key.courseID: courseId,
            Key.courseName: courseName,
            Key.topicID: topicId,
            Key.topicName: topicName
        ]
        logEvent(.discussionAllPostsClicked, parameters: parameters)
    }
    
    private func logEvent(_ event: Event, parameters: [String: Any]? = nil) {
        Analytics.setAnalyticsCollectionEnabled(true)
        Analytics.logEvent(event.rawValue, parameters: parameters)
    }
}

struct Key {
    static let courseID = "course_id"
    static let courseName = "course_name"
    static let topicID = "topic_id"
    static let topicName = "topic_name"
    static let blockID = "block_id"
    static let blockName = "block_name"
    static let method = "method"
    static let label = "label"
    static let coursesCount = "courses_count"
    static let force = "force"
    static let success = "success"
}

enum Event: String {
    case userLogin = "User_Login"
    case signUpClicked = "Sign_up_Clicked"
    case createAccountClicked = "Create_Account_Clicked"
    case registrationSuccess = "Registration_Success"
    case userLogout = "User_Logout"
    case forgotPasswordClicked = "Forgot_password_Clicked"
    case resetPasswordClicked = "Reset_password_Clicked"
    
    case mainDiscoveryTabClicked = "Main_Discovery_tab_Clicked"
    case mainDashboardTabClicked = "Main_Dashboard_tab_Clicked"
    case mainProgramsTabClicked = "Main_Programs_tab_Clicked"
    case mainProfileTabClicked = "Main_Profile_tab_Clicked"
    
    case discoverySearchBarClicked = "Discovery_Search_Bar_Clicked"
    case discoveryCoursesSearch = "Discovery_Courses_Search"
    case discoveryCourseClicked = "Discovery_Course_Clicked"
    
    case dashboardCourseClicked = "Dashboard_Course_Clicked"
    
    case profileEditClicked = "Profile_Edit_Clicked"
    case profileEditDoneClicked = "Profile_Edit_Done_Clicked"
    case profileDeleteAccountClicked = "Profile_Delete_Account_Clicked"
    case profileVideoSettingsClicked = "Profile_Video_settings_Clicked"
    case privacyPolicyClicked = "Privacy_Policy_Clicked"
    case cookiePolicyClicked = "Cookie_Policy_Clicked"
    case emailSupportClicked = "Email_Support_Clicked"
    
    case courseEnrollClicked = "Course_Enroll_Clicked"
    case courseEnrollSuccess = "Course_Enroll_Success"
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
    case courseOutlineDiscussionTabClicked = "Course_Outline_Discussion_tab_Clicked"
    case courseOutlineHandoutsTabClicked = "Course_Outline_Handouts_tab_Clicked"
    
    case discussionAllPostsClicked = "Discussion_All_Posts_Clicked"
    case discussionFollowingClicked = "Discussion_Following_Clicked"
    case discussionTopicClicked = "Discussion_Topic_Clicked"
}
