//
//  AnalyticsManager.swift
//  NewEdX
//
//  Created by  Stepanok Ivan on 27.06.2023.
//

import Foundation

protocol CourseAnalyticsProtocol {
    func logEvent(_ event: Event)
}

public class AnalyticsManager: CourseAnalyticsProtocol {
    enum Event: String {
        case userLogin = "User Login"
        case signUpClicked = "Sign up Clicked"
        case createAccountClicked = "Create Account Clicked"
        case registrationSuccess = "Registration Success"
        case userLogout = "User Logout"
        case forgotPasswordClicked = "Forgot password Clicked"
        case resetPasswordClicked = "Reset password Clicked"
        case mainDiscoveryTabClicked = "Main: Discovery tab Clicked"
        case mainDashboardTabClicked = "Main: Dashboard tab Clicked"
        case mainProgramsTabClicked = "Main: Programs tab Clicked"
        case mainProfileTabClicked = "Main: Profile tab Clicked"
        case discoverySearchBarClicked = "Discovery: Search Bar Clicked"
        case discoveryCoursesSearch = "Discovery: Courses Search"
        case discoveryCourseClicked = "Discovery: Course Clicked"
        case dashboardCourseClicked = "Dashboard: Course Clicked"
        case profileEditClicked = "Profile: Edit Clicked"
        case profileEditDoneClicked = "Profile: Edit Done Clicked"
        case profileDeleteAccountClicked = "Profile: Delete Account Clicked"
        case profileVideoSettingsClicked = "Profile: Video settings Clicked"
        case privacyPolicyClicked = "Privacy Policy Clicked"
        case cookiePolicyClicked = "Cookie Policy Clicked"
        case emailSupportClicked = "Email Support Clicked"
        case courseEnrollClicked = "Course Enroll Clicked"
        case courseEnrollSuccess = "Course Enroll Success"
        case viewCourseClicked = "View Course Clicked"
        case resumeCourseTapped = "Resume Course Tapped"
        case sequentialClicked = "Sequential Clicked"
        case verticalClicked = "Vertical Clicked"
        case nextBlockClicked = "Next Block Clicked"
        case prevBlockClicked = "Prev Block Clicked"
        case finishVerticalClicked = "Finish Vertical Clicked"
        case finishVerticalNextSectionClicked = "Finish Vertical: Next section Clicked"
        case finishVerticalBackToOutlineClicked = "Finish Vertical: Back to outline Clicked"
        case courseOutlineCourseTabClicked = "Course Outline: Course tab Clicked"
        case courseOutlineVideosTabClicked = "Course Outline: Videos tab Clicked"
        case courseOutlineDiscussionTabClicked = "Course Outline: Discussion tab Clicked"
        case courseOutlineHandoutsTabClicked = "Course Outline: Handouts tab Clicked"
        case discussionAllPostsClicked = "Discussion: All Posts Clicked"
        case discussionFollowingClicked = "Discussion: Following Clicked"
        case discussionTopicClicked = "Discussion: Topic Clicked"
    }

    func logEvent(_ event: Event) {
        
    }
}
