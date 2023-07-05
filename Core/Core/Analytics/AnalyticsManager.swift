//
//  AnalyticsManager.swift
//  NewEdX
//
//  Created by  Stepanok Ivan on 27.06.2023.
//

import Foundation
import FirebaseAnalytics
import Authorization
import Discovery
import Dashboard
import Profile
import Course
import Discussion

public protocol BaseCourseAnalytics {
    associatedtype Event: RawRepresentable where Event.RawValue == String
    func logEvent(_ event: Event, parameters: [String: Any]?)
}

public class AnalyticsManager: BaseCourseAnalytics,
                               AuthorizationAnalytics,
                               MainScreenAnalytics,
                               DiscoveryAnalytics,
                               DashboardAnalytics,
                               ProfileAnalytics,
                               CourseAnalytics,
                               DiscussionAnalytics {
    
    public enum Event: String {
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
    
    public func logEvent(_ event: Event, parameters: [String: Any]?) {
        Analytics.setAnalyticsCollectionEnabled(true)
        Analytics.logEvent(event.rawValue, parameters: parameters)
    }
    
    public func userLogin(method: LoginMethod) {
        logEvent(.userLogin, parameters: ["method": method.rawValue])
    }
    
    public func signUpClicked() {
        logEvent(.signUpClicked, parameters: nil)
    }
    
    public func createAccountClicked(provider: LoginProvider) {
        logEvent(.createAccountClicked,
                 parameters: ["provider": provider.rawValue])
    }
    
    public func registrationSuccess(provider: LoginProvider) {
        logEvent(.registrationSuccess,
                 parameters: ["provider": provider.rawValue])
    }
    
    public func forgotPasswordClicked() {
        logEvent(.forgotPasswordClicked, parameters: nil)
    }
    
    public func resetPasswordClicked(success: Bool) {
        logEvent(.resetPasswordClicked, parameters: ["success": success])
    }
    
    // MARK: MainScreenAnalytics
    
    public func mainDiscoveryTabClicked() {
        logEvent(.mainDiscoveryTabClicked, parameters: nil)
    }
    
    public func mainDashboardTabClicked() {
        logEvent(.mainDashboardTabClicked, parameters: nil)
    }
    
    public func mainProgramsTabClicked() {
        logEvent(.mainProgramsTabClicked, parameters: nil)
    }
    
    public func mainProfileTabClicked() {
        logEvent(.mainProfileTabClicked, parameters: nil)
    }
    
    // MARK: Discovery
    
    public func discoverySearchBarClicked() {
        logEvent(.discoverySearchBarClicked, parameters: nil)
    }
    
    public func discoveryCoursesSearch(label: String, coursesCount: Int) {
        logEvent(.discoveryCoursesSearch,
                 parameters: ["label": label,
                              "courses_count": coursesCount])
    }
    
    public func discoveryCourseClicked(courseID: String, courseName: String) {
        logEvent(.discoveryCourseClicked, parameters: ["course_id": courseID,
                                                       "course_name": courseName])
    }
    
    // MARK: Dashboard
    
    public func dashboardCourseClicked(courseID: String, courseName: String) {
        logEvent(.dashboardCourseClicked, parameters: ["course_id": courseID,
                                                       "course_name": courseName])
    }
    
    // MARK: Profile
    
    public func profileEditClicked() {
        logEvent(.profileEditClicked, parameters: nil)
    }
    
    public func profileEditDoneClicked() {
        logEvent(.profileEditDoneClicked, parameters: nil)
    }
    
    public func profileDeleteAccountClicked() {
        logEvent(.profileDeleteAccountClicked, parameters: nil)
    }
    
    public func profileVideoSettingsClicked() {
        logEvent(.profileVideoSettingsClicked, parameters: nil)
    }
    
    public func privacyPolicyClicked() {
        logEvent(.privacyPolicyClicked, parameters: nil)
    }
    
    public func cookiePolicyClicked() {
        logEvent(.cookiePolicyClicked, parameters: nil)
    }
    
    public func emailSupportClicked() {
        logEvent(.emailSupportClicked, parameters: nil)
    }
    
    public func userLogout(force: Bool) {
        logEvent(.userLogout, parameters: ["force": force])
    }
    
    // MARK: Course
    
    public func courseEnrollClicked(courseId: String, courseName: String) {
        logEvent(.courseEnrollClicked, parameters: ["course_id": courseId,
                                                    "course_name": courseName])
    }
    
    public func courseEnrollSuccess(courseId: String, courseName: String) {
        logEvent(.courseEnrollSuccess, parameters: ["course_id": courseId,
                                                    "course_name": courseName])
    }
    
    public func viewCourseClicked(courseId: String, courseName: String) {
        logEvent(.viewCourseClicked, parameters: ["course_id": courseId,
                                                  "course_name": courseName])
    }
    
    public func resumeCourseTapped(courseId: String, courseName: String, blockId: String) {
        logEvent(.resumeCourseTapped, parameters: ["course_id": courseId,
                                                   "course_name": courseName])
    }
    
    public func sequentialClicked(courseId: String, courseName: String, blockId: String, blockName: String) {
        logEvent(.sequentialClicked, parameters: ["course_id": courseId,
                                                  "course_name": courseName,
                                                  "block_id": blockId,
                                                  "block_name": blockName])
    }
    
    public func verticalClicked(courseId: String, courseName: String, blockId: String, blockName: String) {
        logEvent(.verticalClicked, parameters: ["course_id": courseId,
                                                "course_name": courseName,
                                                "block_id": blockId,
                                                "block_name": blockName])
    }
    
    public func nextBlockClicked(courseId: String, courseName: String, blockId: String, blockName: String) {
        logEvent(.nextBlockClicked, parameters: ["course_id": courseId,
                                                 "course_name": courseName,
                                                 "block_id": blockId,
                                                 "block_name": blockName])
    }
    
    public func prevBlockClicked(courseId: String, courseName: String, blockId: String, blockName: String) {
        logEvent(.prevBlockClicked, parameters: ["course_id": courseId,
                                                 "course_name": courseName,
                                                 "block_id": blockId,
                                                 "block_name": blockName])
    }
    
    public func finishVerticalClicked(courseId: String, courseName: String, blockId: String, blockName: String) {
        logEvent(.finishVerticalClicked, parameters: ["course_id": courseId,
                                                      "course_name": courseName,
                                                      "block_id": blockId,
                                                      "block_name": blockName])
    }
    
    public func finishVerticalNextSectionClicked(courseId: String, courseName: String, blockId: String, blockName: String) {
        logEvent(.finishVerticalNextSectionClicked, parameters: ["course_id": courseId,
                                                                 "course_name": courseName,
                                                                 "block_id": blockId,
                                                                 "block_name": blockName])
    }
    
    public func finishVerticalBackToOutlineClicked(courseId: String, courseName: String) {
        logEvent(.finishVerticalBackToOutlineClicked, parameters: ["course_id": courseId,
                                                                   "course_name": courseName])
    }
    
    public func courseOutlineCourseTabClicked(courseId: String, courseName: String) {
        logEvent(.courseOutlineCourseTabClicked, parameters: ["course_id": courseId,
                                                              "course_name": courseName])
    }
    
    public func courseOutlineVideosTabClicked(courseId: String, courseName: String) {
        logEvent(.courseOutlineVideosTabClicked, parameters: ["course_id": courseId,
                                                              "course_name": courseName])
    }
    
    public func courseOutlineDiscussionTabClicked(courseId: String, courseName: String) {
        logEvent(.courseOutlineDiscussionTabClicked, parameters: ["course_id": courseId,
                                                                  "course_name": courseName])
    }
    
    public func courseOutlineHandoutsTabClicked(courseId: String, courseName: String) {
        logEvent(.courseOutlineHandoutsTabClicked, parameters: ["course_id": courseId,
                                                                "course_name": courseName])
    }
    
    // MARK: Discussion

    public func discussionAllPostsClicked(courseId: String, courseName: String) {
        logEvent(.discussionAllPostsClicked, parameters: ["course_id": courseId,
                                                          "course_name": courseName])
    }
    
    public func discussionFollowingClicked(courseId: String, courseName: String) {
        logEvent(.discussionFollowingClicked, parameters: ["course_id": courseId,
                                                           "course_name": courseName])
    }
    
    public func discussionTopicClicked(courseId: String, courseName: String, topicId: String, topicName: String) {
        logEvent(.discussionAllPostsClicked, parameters: ["course_id": courseId,
                                                          "course_name": courseName,
                                                          "topic_id": topicId,
                                                          "topic_name": topicName])
    }
}
