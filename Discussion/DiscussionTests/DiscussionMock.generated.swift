// Generated using Sourcery 2.1.2 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT


// Generated with SwiftyMocky 4.2.0
// Required Sourcery: 1.8.0


import SwiftyMocky
import XCTest
import Core
import Discussion
import Foundation
import SwiftUI
import Combine
import OEXFoundation


// MARK: - DiscussionAnalytics

open class DiscussionAnalyticsMock: DiscussionAnalytics, Mock {
    public init(sequencing sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst, stubbing stubbingPolicy: StubbingPolicy = .wrap, file: StaticString = #file, line: UInt = #line) {
        SwiftyMockyTestObserver.setup()
        self.sequencingPolicy = sequencingPolicy
        self.stubbingPolicy = stubbingPolicy
        self.file = file
        self.line = line
    }

    var matcher: Matcher = Matcher.default
    var stubbingPolicy: StubbingPolicy = .wrap
    var sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst

    private var queue = DispatchQueue(label: "com.swiftymocky.invocations", qos: .userInteractive)
    private var invocations: [MethodType] = []
    private var methodReturnValues: [Given] = []
    private var methodPerformValues: [Perform] = []
    private var file: StaticString?
    private var line: UInt?

    public typealias PropertyStub = Given
    public typealias MethodStub = Given
    public typealias SubscriptStub = Given

    /// Convenience method - call setupMock() to extend debug information when failure occurs
    public func setupMock(file: StaticString = #file, line: UInt = #line) {
        self.file = file
        self.line = line
    }

    /// Clear mock internals. You can specify what to reset (invocations aka verify, givens or performs) or leave it empty to clear all mock internals
    public func resetMock(_ scopes: MockScope...) {
        let scopes: [MockScope] = scopes.isEmpty ? [.invocation, .given, .perform] : scopes
        if scopes.contains(.invocation) { invocations = [] }
        if scopes.contains(.given) { methodReturnValues = [] }
        if scopes.contains(.perform) { methodPerformValues = [] }
    }





    open func discussionAllPostsClicked(courseId: String, courseName: String) {
        addInvocation(.m_discussionAllPostsClicked__courseId_courseIdcourseName_courseName(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`)))
		let perform = methodPerformValue(.m_discussionAllPostsClicked__courseId_courseIdcourseName_courseName(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`))) as? (String, String) -> Void
		perform?(`courseId`, `courseName`)
    }

    open func discussionFollowingClicked(courseId: String, courseName: String) {
        addInvocation(.m_discussionFollowingClicked__courseId_courseIdcourseName_courseName(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`)))
		let perform = methodPerformValue(.m_discussionFollowingClicked__courseId_courseIdcourseName_courseName(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`))) as? (String, String) -> Void
		perform?(`courseId`, `courseName`)
    }

    open func discussionTopicClicked(courseId: String, courseName: String, topicId: String, topicName: String) {
        addInvocation(.m_discussionTopicClicked__courseId_courseIdcourseName_courseNametopicId_topicIdtopicName_topicName(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`), Parameter<String>.value(`topicId`), Parameter<String>.value(`topicName`)))
		let perform = methodPerformValue(.m_discussionTopicClicked__courseId_courseIdcourseName_courseNametopicId_topicIdtopicName_topicName(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`), Parameter<String>.value(`topicId`), Parameter<String>.value(`topicName`))) as? (String, String, String, String) -> Void
		perform?(`courseId`, `courseName`, `topicId`, `topicName`)
    }

    open func discussionCreateNewPost(courseID: String, topicID: String, postType: String, followPost: Bool, author: String) {
        addInvocation(.m_discussionCreateNewPost__courseID_courseIDtopicID_topicIDpostType_postTypefollowPost_followPostauthor_author(Parameter<String>.value(`courseID`), Parameter<String>.value(`topicID`), Parameter<String>.value(`postType`), Parameter<Bool>.value(`followPost`), Parameter<String>.value(`author`)))
		let perform = methodPerformValue(.m_discussionCreateNewPost__courseID_courseIDtopicID_topicIDpostType_postTypefollowPost_followPostauthor_author(Parameter<String>.value(`courseID`), Parameter<String>.value(`topicID`), Parameter<String>.value(`postType`), Parameter<Bool>.value(`followPost`), Parameter<String>.value(`author`))) as? (String, String, String, Bool, String) -> Void
		perform?(`courseID`, `topicID`, `postType`, `followPost`, `author`)
    }

    open func discussionResponseAdded(courseID: String, threadID: String, responseID: String, author: String) {
        addInvocation(.m_discussionResponseAdded__courseID_courseIDthreadID_threadIDresponseID_responseIDauthor_author(Parameter<String>.value(`courseID`), Parameter<String>.value(`threadID`), Parameter<String>.value(`responseID`), Parameter<String>.value(`author`)))
		let perform = methodPerformValue(.m_discussionResponseAdded__courseID_courseIDthreadID_threadIDresponseID_responseIDauthor_author(Parameter<String>.value(`courseID`), Parameter<String>.value(`threadID`), Parameter<String>.value(`responseID`), Parameter<String>.value(`author`))) as? (String, String, String, String) -> Void
		perform?(`courseID`, `threadID`, `responseID`, `author`)
    }

    open func discussionCommentAdded(courseID: String, threadID: String, responseID: String, commentID: String, author: String) {
        addInvocation(.m_discussionCommentAdded__courseID_courseIDthreadID_threadIDresponseID_responseIDcommentID_commentIDauthor_author(Parameter<String>.value(`courseID`), Parameter<String>.value(`threadID`), Parameter<String>.value(`responseID`), Parameter<String>.value(`commentID`), Parameter<String>.value(`author`)))
		let perform = methodPerformValue(.m_discussionCommentAdded__courseID_courseIDthreadID_threadIDresponseID_responseIDcommentID_commentIDauthor_author(Parameter<String>.value(`courseID`), Parameter<String>.value(`threadID`), Parameter<String>.value(`responseID`), Parameter<String>.value(`commentID`), Parameter<String>.value(`author`))) as? (String, String, String, String, String) -> Void
		perform?(`courseID`, `threadID`, `responseID`, `commentID`, `author`)
    }

    open func discussionFollowToggle(courseID: String, threadID: String, author: String, follow: Bool) {
        addInvocation(.m_discussionFollowToggle__courseID_courseIDthreadID_threadIDauthor_authorfollow_follow(Parameter<String>.value(`courseID`), Parameter<String>.value(`threadID`), Parameter<String>.value(`author`), Parameter<Bool>.value(`follow`)))
		let perform = methodPerformValue(.m_discussionFollowToggle__courseID_courseIDthreadID_threadIDauthor_authorfollow_follow(Parameter<String>.value(`courseID`), Parameter<String>.value(`threadID`), Parameter<String>.value(`author`), Parameter<Bool>.value(`follow`))) as? (String, String, String, Bool) -> Void
		perform?(`courseID`, `threadID`, `author`, `follow`)
    }

    open func discussionLikeToggle(courseID: String, threadID: String, responseID: String?, commentID: String?, author: String, discussionType: String, like: Bool) {
        addInvocation(.m_discussionLikeToggle__courseID_courseIDthreadID_threadIDresponseID_responseIDcommentID_commentIDauthor_authordiscussionType_discussionTypelike_like(Parameter<String>.value(`courseID`), Parameter<String>.value(`threadID`), Parameter<String?>.value(`responseID`), Parameter<String?>.value(`commentID`), Parameter<String>.value(`author`), Parameter<String>.value(`discussionType`), Parameter<Bool>.value(`like`)))
		let perform = methodPerformValue(.m_discussionLikeToggle__courseID_courseIDthreadID_threadIDresponseID_responseIDcommentID_commentIDauthor_authordiscussionType_discussionTypelike_like(Parameter<String>.value(`courseID`), Parameter<String>.value(`threadID`), Parameter<String?>.value(`responseID`), Parameter<String?>.value(`commentID`), Parameter<String>.value(`author`), Parameter<String>.value(`discussionType`), Parameter<Bool>.value(`like`))) as? (String, String, String?, String?, String, String, Bool) -> Void
		perform?(`courseID`, `threadID`, `responseID`, `commentID`, `author`, `discussionType`, `like`)
    }

    open func discussionReportToggle(courseID: String, threadID: String, responseID: String?, commentID: String?, author: String, discussionType: String, report: Bool) {
        addInvocation(.m_discussionReportToggle__courseID_courseIDthreadID_threadIDresponseID_responseIDcommentID_commentIDauthor_authordiscussionType_discussionTypereport_report(Parameter<String>.value(`courseID`), Parameter<String>.value(`threadID`), Parameter<String?>.value(`responseID`), Parameter<String?>.value(`commentID`), Parameter<String>.value(`author`), Parameter<String>.value(`discussionType`), Parameter<Bool>.value(`report`)))
		let perform = methodPerformValue(.m_discussionReportToggle__courseID_courseIDthreadID_threadIDresponseID_responseIDcommentID_commentIDauthor_authordiscussionType_discussionTypereport_report(Parameter<String>.value(`courseID`), Parameter<String>.value(`threadID`), Parameter<String?>.value(`responseID`), Parameter<String?>.value(`commentID`), Parameter<String>.value(`author`), Parameter<String>.value(`discussionType`), Parameter<Bool>.value(`report`))) as? (String, String, String?, String?, String, String, Bool) -> Void
		perform?(`courseID`, `threadID`, `responseID`, `commentID`, `author`, `discussionType`, `report`)
    }


    fileprivate enum MethodType {
        case m_discussionAllPostsClicked__courseId_courseIdcourseName_courseName(Parameter<String>, Parameter<String>)
        case m_discussionFollowingClicked__courseId_courseIdcourseName_courseName(Parameter<String>, Parameter<String>)
        case m_discussionTopicClicked__courseId_courseIdcourseName_courseNametopicId_topicIdtopicName_topicName(Parameter<String>, Parameter<String>, Parameter<String>, Parameter<String>)
        case m_discussionCreateNewPost__courseID_courseIDtopicID_topicIDpostType_postTypefollowPost_followPostauthor_author(Parameter<String>, Parameter<String>, Parameter<String>, Parameter<Bool>, Parameter<String>)
        case m_discussionResponseAdded__courseID_courseIDthreadID_threadIDresponseID_responseIDauthor_author(Parameter<String>, Parameter<String>, Parameter<String>, Parameter<String>)
        case m_discussionCommentAdded__courseID_courseIDthreadID_threadIDresponseID_responseIDcommentID_commentIDauthor_author(Parameter<String>, Parameter<String>, Parameter<String>, Parameter<String>, Parameter<String>)
        case m_discussionFollowToggle__courseID_courseIDthreadID_threadIDauthor_authorfollow_follow(Parameter<String>, Parameter<String>, Parameter<String>, Parameter<Bool>)
        case m_discussionLikeToggle__courseID_courseIDthreadID_threadIDresponseID_responseIDcommentID_commentIDauthor_authordiscussionType_discussionTypelike_like(Parameter<String>, Parameter<String>, Parameter<String?>, Parameter<String?>, Parameter<String>, Parameter<String>, Parameter<Bool>)
        case m_discussionReportToggle__courseID_courseIDthreadID_threadIDresponseID_responseIDcommentID_commentIDauthor_authordiscussionType_discussionTypereport_report(Parameter<String>, Parameter<String>, Parameter<String?>, Parameter<String?>, Parameter<String>, Parameter<String>, Parameter<Bool>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_discussionAllPostsClicked__courseId_courseIdcourseName_courseName(let lhsCourseid, let lhsCoursename), .m_discussionAllPostsClicked__courseId_courseIdcourseName_courseName(let rhsCourseid, let rhsCoursename)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseId"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCoursename, rhs: rhsCoursename, with: matcher), lhsCoursename, rhsCoursename, "courseName"))
				return Matcher.ComparisonResult(results)

            case (.m_discussionFollowingClicked__courseId_courseIdcourseName_courseName(let lhsCourseid, let lhsCoursename), .m_discussionFollowingClicked__courseId_courseIdcourseName_courseName(let rhsCourseid, let rhsCoursename)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseId"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCoursename, rhs: rhsCoursename, with: matcher), lhsCoursename, rhsCoursename, "courseName"))
				return Matcher.ComparisonResult(results)

            case (.m_discussionTopicClicked__courseId_courseIdcourseName_courseNametopicId_topicIdtopicName_topicName(let lhsCourseid, let lhsCoursename, let lhsTopicid, let lhsTopicname), .m_discussionTopicClicked__courseId_courseIdcourseName_courseNametopicId_topicIdtopicName_topicName(let rhsCourseid, let rhsCoursename, let rhsTopicid, let rhsTopicname)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseId"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCoursename, rhs: rhsCoursename, with: matcher), lhsCoursename, rhsCoursename, "courseName"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsTopicid, rhs: rhsTopicid, with: matcher), lhsTopicid, rhsTopicid, "topicId"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsTopicname, rhs: rhsTopicname, with: matcher), lhsTopicname, rhsTopicname, "topicName"))
				return Matcher.ComparisonResult(results)

            case (.m_discussionCreateNewPost__courseID_courseIDtopicID_topicIDpostType_postTypefollowPost_followPostauthor_author(let lhsCourseid, let lhsTopicid, let lhsPosttype, let lhsFollowpost, let lhsAuthor), .m_discussionCreateNewPost__courseID_courseIDtopicID_topicIDpostType_postTypefollowPost_followPostauthor_author(let rhsCourseid, let rhsTopicid, let rhsPosttype, let rhsFollowpost, let rhsAuthor)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseID"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsTopicid, rhs: rhsTopicid, with: matcher), lhsTopicid, rhsTopicid, "topicID"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsPosttype, rhs: rhsPosttype, with: matcher), lhsPosttype, rhsPosttype, "postType"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsFollowpost, rhs: rhsFollowpost, with: matcher), lhsFollowpost, rhsFollowpost, "followPost"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsAuthor, rhs: rhsAuthor, with: matcher), lhsAuthor, rhsAuthor, "author"))
				return Matcher.ComparisonResult(results)

            case (.m_discussionResponseAdded__courseID_courseIDthreadID_threadIDresponseID_responseIDauthor_author(let lhsCourseid, let lhsThreadid, let lhsResponseid, let lhsAuthor), .m_discussionResponseAdded__courseID_courseIDthreadID_threadIDresponseID_responseIDauthor_author(let rhsCourseid, let rhsThreadid, let rhsResponseid, let rhsAuthor)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseID"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsThreadid, rhs: rhsThreadid, with: matcher), lhsThreadid, rhsThreadid, "threadID"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsResponseid, rhs: rhsResponseid, with: matcher), lhsResponseid, rhsResponseid, "responseID"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsAuthor, rhs: rhsAuthor, with: matcher), lhsAuthor, rhsAuthor, "author"))
				return Matcher.ComparisonResult(results)

            case (.m_discussionCommentAdded__courseID_courseIDthreadID_threadIDresponseID_responseIDcommentID_commentIDauthor_author(let lhsCourseid, let lhsThreadid, let lhsResponseid, let lhsCommentid, let lhsAuthor), .m_discussionCommentAdded__courseID_courseIDthreadID_threadIDresponseID_responseIDcommentID_commentIDauthor_author(let rhsCourseid, let rhsThreadid, let rhsResponseid, let rhsCommentid, let rhsAuthor)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseID"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsThreadid, rhs: rhsThreadid, with: matcher), lhsThreadid, rhsThreadid, "threadID"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsResponseid, rhs: rhsResponseid, with: matcher), lhsResponseid, rhsResponseid, "responseID"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCommentid, rhs: rhsCommentid, with: matcher), lhsCommentid, rhsCommentid, "commentID"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsAuthor, rhs: rhsAuthor, with: matcher), lhsAuthor, rhsAuthor, "author"))
				return Matcher.ComparisonResult(results)

            case (.m_discussionFollowToggle__courseID_courseIDthreadID_threadIDauthor_authorfollow_follow(let lhsCourseid, let lhsThreadid, let lhsAuthor, let lhsFollow), .m_discussionFollowToggle__courseID_courseIDthreadID_threadIDauthor_authorfollow_follow(let rhsCourseid, let rhsThreadid, let rhsAuthor, let rhsFollow)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseID"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsThreadid, rhs: rhsThreadid, with: matcher), lhsThreadid, rhsThreadid, "threadID"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsAuthor, rhs: rhsAuthor, with: matcher), lhsAuthor, rhsAuthor, "author"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsFollow, rhs: rhsFollow, with: matcher), lhsFollow, rhsFollow, "follow"))
				return Matcher.ComparisonResult(results)

            case (.m_discussionLikeToggle__courseID_courseIDthreadID_threadIDresponseID_responseIDcommentID_commentIDauthor_authordiscussionType_discussionTypelike_like(let lhsCourseid, let lhsThreadid, let lhsResponseid, let lhsCommentid, let lhsAuthor, let lhsDiscussiontype, let lhsLike), .m_discussionLikeToggle__courseID_courseIDthreadID_threadIDresponseID_responseIDcommentID_commentIDauthor_authordiscussionType_discussionTypelike_like(let rhsCourseid, let rhsThreadid, let rhsResponseid, let rhsCommentid, let rhsAuthor, let rhsDiscussiontype, let rhsLike)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseID"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsThreadid, rhs: rhsThreadid, with: matcher), lhsThreadid, rhsThreadid, "threadID"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsResponseid, rhs: rhsResponseid, with: matcher), lhsResponseid, rhsResponseid, "responseID"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCommentid, rhs: rhsCommentid, with: matcher), lhsCommentid, rhsCommentid, "commentID"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsAuthor, rhs: rhsAuthor, with: matcher), lhsAuthor, rhsAuthor, "author"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsDiscussiontype, rhs: rhsDiscussiontype, with: matcher), lhsDiscussiontype, rhsDiscussiontype, "discussionType"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsLike, rhs: rhsLike, with: matcher), lhsLike, rhsLike, "like"))
				return Matcher.ComparisonResult(results)

            case (.m_discussionReportToggle__courseID_courseIDthreadID_threadIDresponseID_responseIDcommentID_commentIDauthor_authordiscussionType_discussionTypereport_report(let lhsCourseid, let lhsThreadid, let lhsResponseid, let lhsCommentid, let lhsAuthor, let lhsDiscussiontype, let lhsReport), .m_discussionReportToggle__courseID_courseIDthreadID_threadIDresponseID_responseIDcommentID_commentIDauthor_authordiscussionType_discussionTypereport_report(let rhsCourseid, let rhsThreadid, let rhsResponseid, let rhsCommentid, let rhsAuthor, let rhsDiscussiontype, let rhsReport)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseID"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsThreadid, rhs: rhsThreadid, with: matcher), lhsThreadid, rhsThreadid, "threadID"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsResponseid, rhs: rhsResponseid, with: matcher), lhsResponseid, rhsResponseid, "responseID"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCommentid, rhs: rhsCommentid, with: matcher), lhsCommentid, rhsCommentid, "commentID"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsAuthor, rhs: rhsAuthor, with: matcher), lhsAuthor, rhsAuthor, "author"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsDiscussiontype, rhs: rhsDiscussiontype, with: matcher), lhsDiscussiontype, rhsDiscussiontype, "discussionType"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsReport, rhs: rhsReport, with: matcher), lhsReport, rhsReport, "report"))
				return Matcher.ComparisonResult(results)
            default: return .none
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_discussionAllPostsClicked__courseId_courseIdcourseName_courseName(p0, p1): return p0.intValue + p1.intValue
            case let .m_discussionFollowingClicked__courseId_courseIdcourseName_courseName(p0, p1): return p0.intValue + p1.intValue
            case let .m_discussionTopicClicked__courseId_courseIdcourseName_courseNametopicId_topicIdtopicName_topicName(p0, p1, p2, p3): return p0.intValue + p1.intValue + p2.intValue + p3.intValue
            case let .m_discussionCreateNewPost__courseID_courseIDtopicID_topicIDpostType_postTypefollowPost_followPostauthor_author(p0, p1, p2, p3, p4): return p0.intValue + p1.intValue + p2.intValue + p3.intValue + p4.intValue
            case let .m_discussionResponseAdded__courseID_courseIDthreadID_threadIDresponseID_responseIDauthor_author(p0, p1, p2, p3): return p0.intValue + p1.intValue + p2.intValue + p3.intValue
            case let .m_discussionCommentAdded__courseID_courseIDthreadID_threadIDresponseID_responseIDcommentID_commentIDauthor_author(p0, p1, p2, p3, p4): return p0.intValue + p1.intValue + p2.intValue + p3.intValue + p4.intValue
            case let .m_discussionFollowToggle__courseID_courseIDthreadID_threadIDauthor_authorfollow_follow(p0, p1, p2, p3): return p0.intValue + p1.intValue + p2.intValue + p3.intValue
            case let .m_discussionLikeToggle__courseID_courseIDthreadID_threadIDresponseID_responseIDcommentID_commentIDauthor_authordiscussionType_discussionTypelike_like(p0, p1, p2, p3, p4, p5, p6): return p0.intValue + p1.intValue + p2.intValue + p3.intValue + p4.intValue + p5.intValue + p6.intValue
            case let .m_discussionReportToggle__courseID_courseIDthreadID_threadIDresponseID_responseIDcommentID_commentIDauthor_authordiscussionType_discussionTypereport_report(p0, p1, p2, p3, p4, p5, p6): return p0.intValue + p1.intValue + p2.intValue + p3.intValue + p4.intValue + p5.intValue + p6.intValue
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_discussionAllPostsClicked__courseId_courseIdcourseName_courseName: return ".discussionAllPostsClicked(courseId:courseName:)"
            case .m_discussionFollowingClicked__courseId_courseIdcourseName_courseName: return ".discussionFollowingClicked(courseId:courseName:)"
            case .m_discussionTopicClicked__courseId_courseIdcourseName_courseNametopicId_topicIdtopicName_topicName: return ".discussionTopicClicked(courseId:courseName:topicId:topicName:)"
            case .m_discussionCreateNewPost__courseID_courseIDtopicID_topicIDpostType_postTypefollowPost_followPostauthor_author: return ".discussionCreateNewPost(courseID:topicID:postType:followPost:author:)"
            case .m_discussionResponseAdded__courseID_courseIDthreadID_threadIDresponseID_responseIDauthor_author: return ".discussionResponseAdded(courseID:threadID:responseID:author:)"
            case .m_discussionCommentAdded__courseID_courseIDthreadID_threadIDresponseID_responseIDcommentID_commentIDauthor_author: return ".discussionCommentAdded(courseID:threadID:responseID:commentID:author:)"
            case .m_discussionFollowToggle__courseID_courseIDthreadID_threadIDauthor_authorfollow_follow: return ".discussionFollowToggle(courseID:threadID:author:follow:)"
            case .m_discussionLikeToggle__courseID_courseIDthreadID_threadIDresponseID_responseIDcommentID_commentIDauthor_authordiscussionType_discussionTypelike_like: return ".discussionLikeToggle(courseID:threadID:responseID:commentID:author:discussionType:like:)"
            case .m_discussionReportToggle__courseID_courseIDthreadID_threadIDresponseID_responseIDcommentID_commentIDauthor_authordiscussionType_discussionTypereport_report: return ".discussionReportToggle(courseID:threadID:responseID:commentID:author:discussionType:report:)"
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }


    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func discussionAllPostsClicked(courseId: Parameter<String>, courseName: Parameter<String>) -> Verify { return Verify(method: .m_discussionAllPostsClicked__courseId_courseIdcourseName_courseName(`courseId`, `courseName`))}
        public static func discussionFollowingClicked(courseId: Parameter<String>, courseName: Parameter<String>) -> Verify { return Verify(method: .m_discussionFollowingClicked__courseId_courseIdcourseName_courseName(`courseId`, `courseName`))}
        public static func discussionTopicClicked(courseId: Parameter<String>, courseName: Parameter<String>, topicId: Parameter<String>, topicName: Parameter<String>) -> Verify { return Verify(method: .m_discussionTopicClicked__courseId_courseIdcourseName_courseNametopicId_topicIdtopicName_topicName(`courseId`, `courseName`, `topicId`, `topicName`))}
        public static func discussionCreateNewPost(courseID: Parameter<String>, topicID: Parameter<String>, postType: Parameter<String>, followPost: Parameter<Bool>, author: Parameter<String>) -> Verify { return Verify(method: .m_discussionCreateNewPost__courseID_courseIDtopicID_topicIDpostType_postTypefollowPost_followPostauthor_author(`courseID`, `topicID`, `postType`, `followPost`, `author`))}
        public static func discussionResponseAdded(courseID: Parameter<String>, threadID: Parameter<String>, responseID: Parameter<String>, author: Parameter<String>) -> Verify { return Verify(method: .m_discussionResponseAdded__courseID_courseIDthreadID_threadIDresponseID_responseIDauthor_author(`courseID`, `threadID`, `responseID`, `author`))}
        public static func discussionCommentAdded(courseID: Parameter<String>, threadID: Parameter<String>, responseID: Parameter<String>, commentID: Parameter<String>, author: Parameter<String>) -> Verify { return Verify(method: .m_discussionCommentAdded__courseID_courseIDthreadID_threadIDresponseID_responseIDcommentID_commentIDauthor_author(`courseID`, `threadID`, `responseID`, `commentID`, `author`))}
        public static func discussionFollowToggle(courseID: Parameter<String>, threadID: Parameter<String>, author: Parameter<String>, follow: Parameter<Bool>) -> Verify { return Verify(method: .m_discussionFollowToggle__courseID_courseIDthreadID_threadIDauthor_authorfollow_follow(`courseID`, `threadID`, `author`, `follow`))}
        public static func discussionLikeToggle(courseID: Parameter<String>, threadID: Parameter<String>, responseID: Parameter<String?>, commentID: Parameter<String?>, author: Parameter<String>, discussionType: Parameter<String>, like: Parameter<Bool>) -> Verify { return Verify(method: .m_discussionLikeToggle__courseID_courseIDthreadID_threadIDresponseID_responseIDcommentID_commentIDauthor_authordiscussionType_discussionTypelike_like(`courseID`, `threadID`, `responseID`, `commentID`, `author`, `discussionType`, `like`))}
        public static func discussionReportToggle(courseID: Parameter<String>, threadID: Parameter<String>, responseID: Parameter<String?>, commentID: Parameter<String?>, author: Parameter<String>, discussionType: Parameter<String>, report: Parameter<Bool>) -> Verify { return Verify(method: .m_discussionReportToggle__courseID_courseIDthreadID_threadIDresponseID_responseIDcommentID_commentIDauthor_authordiscussionType_discussionTypereport_report(`courseID`, `threadID`, `responseID`, `commentID`, `author`, `discussionType`, `report`))}
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func discussionAllPostsClicked(courseId: Parameter<String>, courseName: Parameter<String>, perform: @escaping (String, String) -> Void) -> Perform {
            return Perform(method: .m_discussionAllPostsClicked__courseId_courseIdcourseName_courseName(`courseId`, `courseName`), performs: perform)
        }
        public static func discussionFollowingClicked(courseId: Parameter<String>, courseName: Parameter<String>, perform: @escaping (String, String) -> Void) -> Perform {
            return Perform(method: .m_discussionFollowingClicked__courseId_courseIdcourseName_courseName(`courseId`, `courseName`), performs: perform)
        }
        public static func discussionTopicClicked(courseId: Parameter<String>, courseName: Parameter<String>, topicId: Parameter<String>, topicName: Parameter<String>, perform: @escaping (String, String, String, String) -> Void) -> Perform {
            return Perform(method: .m_discussionTopicClicked__courseId_courseIdcourseName_courseNametopicId_topicIdtopicName_topicName(`courseId`, `courseName`, `topicId`, `topicName`), performs: perform)
        }
        public static func discussionCreateNewPost(courseID: Parameter<String>, topicID: Parameter<String>, postType: Parameter<String>, followPost: Parameter<Bool>, author: Parameter<String>, perform: @escaping (String, String, String, Bool, String) -> Void) -> Perform {
            return Perform(method: .m_discussionCreateNewPost__courseID_courseIDtopicID_topicIDpostType_postTypefollowPost_followPostauthor_author(`courseID`, `topicID`, `postType`, `followPost`, `author`), performs: perform)
        }
        public static func discussionResponseAdded(courseID: Parameter<String>, threadID: Parameter<String>, responseID: Parameter<String>, author: Parameter<String>, perform: @escaping (String, String, String, String) -> Void) -> Perform {
            return Perform(method: .m_discussionResponseAdded__courseID_courseIDthreadID_threadIDresponseID_responseIDauthor_author(`courseID`, `threadID`, `responseID`, `author`), performs: perform)
        }
        public static func discussionCommentAdded(courseID: Parameter<String>, threadID: Parameter<String>, responseID: Parameter<String>, commentID: Parameter<String>, author: Parameter<String>, perform: @escaping (String, String, String, String, String) -> Void) -> Perform {
            return Perform(method: .m_discussionCommentAdded__courseID_courseIDthreadID_threadIDresponseID_responseIDcommentID_commentIDauthor_author(`courseID`, `threadID`, `responseID`, `commentID`, `author`), performs: perform)
        }
        public static func discussionFollowToggle(courseID: Parameter<String>, threadID: Parameter<String>, author: Parameter<String>, follow: Parameter<Bool>, perform: @escaping (String, String, String, Bool) -> Void) -> Perform {
            return Perform(method: .m_discussionFollowToggle__courseID_courseIDthreadID_threadIDauthor_authorfollow_follow(`courseID`, `threadID`, `author`, `follow`), performs: perform)
        }
        public static func discussionLikeToggle(courseID: Parameter<String>, threadID: Parameter<String>, responseID: Parameter<String?>, commentID: Parameter<String?>, author: Parameter<String>, discussionType: Parameter<String>, like: Parameter<Bool>, perform: @escaping (String, String, String?, String?, String, String, Bool) -> Void) -> Perform {
            return Perform(method: .m_discussionLikeToggle__courseID_courseIDthreadID_threadIDresponseID_responseIDcommentID_commentIDauthor_authordiscussionType_discussionTypelike_like(`courseID`, `threadID`, `responseID`, `commentID`, `author`, `discussionType`, `like`), performs: perform)
        }
        public static func discussionReportToggle(courseID: Parameter<String>, threadID: Parameter<String>, responseID: Parameter<String?>, commentID: Parameter<String?>, author: Parameter<String>, discussionType: Parameter<String>, report: Parameter<Bool>, perform: @escaping (String, String, String?, String?, String, String, Bool) -> Void) -> Perform {
            return Perform(method: .m_discussionReportToggle__courseID_courseIDthreadID_threadIDresponseID_responseIDcommentID_commentIDauthor_authordiscussionType_discussionTypereport_report(`courseID`, `threadID`, `responseID`, `commentID`, `author`, `discussionType`, `report`), performs: perform)
        }
    }

    public func given(_ method: Given) {
        methodReturnValues.append(method)
    }

    public func perform(_ method: Perform) {
        methodPerformValues.append(method)
        methodPerformValues.sort { $0.method.intValue() < $1.method.intValue() }
    }

    public func verify(_ method: Verify, count: Count = Count.moreOrEqual(to: 1), file: StaticString = #file, line: UInt = #line) {
        let fullMatches = matchingCalls(method, file: file, line: line)
        let success = count.matches(fullMatches)
        let assertionName = method.method.assertionName()
        let feedback: String = {
            guard !success else { return "" }
            return Utils.closestCallsMessage(
                for: self.invocations.map { invocation in
                    matcher.set(file: file, line: line)
                    defer { matcher.clearFileAndLine() }
                    return MethodType.compareParameters(lhs: invocation, rhs: method.method, matcher: matcher)
                },
                name: assertionName
            )
        }()
        MockyAssert(success, "Expected: \(count) invocations of `\(assertionName)`, but was: \(fullMatches).\(feedback)", file: file, line: line)
    }

    private func addInvocation(_ call: MethodType) {
        self.queue.sync { invocations.append(call) }
    }
    private func methodReturnValue(_ method: MethodType) throws -> StubProduct {
        matcher.set(file: self.file, line: self.line)
        defer { matcher.clearFileAndLine() }
        let candidates = sequencingPolicy.sorted(methodReturnValues, by: { $0.method.intValue() > $1.method.intValue() })
        let matched = candidates.first(where: { $0.isValid && MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher).isFullMatch })
        guard let product = matched?.getProduct(policy: self.stubbingPolicy) else { throw MockError.notStubed }
        return product
    }
    private func methodPerformValue(_ method: MethodType) -> Any? {
        matcher.set(file: self.file, line: self.line)
        defer { matcher.clearFileAndLine() }
        let matched = methodPerformValues.reversed().first { MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher).isFullMatch }
        return matched?.performs
    }
    private func matchingCalls(_ method: MethodType, file: StaticString?, line: UInt?) -> [MethodType] {
        matcher.set(file: file ?? self.file, line: line ?? self.line)
        defer { matcher.clearFileAndLine() }
        return invocations.filter { MethodType.compareParameters(lhs: $0, rhs: method, matcher: matcher).isFullMatch }
    }
    private func matchingCalls(_ method: Verify, file: StaticString?, line: UInt?) -> Int {
        return matchingCalls(method.method, file: file, line: line).count
    }
    private func givenGetterValue<T>(_ method: MethodType, _ message: String) -> T {
        do {
            return try methodReturnValue(method).casted()
        } catch {
            onFatalFailure(message)
            Failure(message)
        }
    }
    private func optionalGivenGetterValue<T>(_ method: MethodType, _ message: String) -> T? {
        do {
            return try methodReturnValue(method).casted()
        } catch {
            return nil
        }
    }
    private func onFatalFailure(_ message: String) {
        guard let file = self.file, let line = self.line else { return } // Let if fail if cannot handle gratefully
        SwiftyMockyTestObserver.handleFatalError(message: message, file: file, line: line)
    }
}

// MARK: - DiscussionInteractorProtocol

open class DiscussionInteractorProtocolMock: DiscussionInteractorProtocol, Mock {
    public init(sequencing sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst, stubbing stubbingPolicy: StubbingPolicy = .wrap, file: StaticString = #file, line: UInt = #line) {
        SwiftyMockyTestObserver.setup()
        self.sequencingPolicy = sequencingPolicy
        self.stubbingPolicy = stubbingPolicy
        self.file = file
        self.line = line
    }

    var matcher: Matcher = Matcher.default
    var stubbingPolicy: StubbingPolicy = .wrap
    var sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst

    private var queue = DispatchQueue(label: "com.swiftymocky.invocations", qos: .userInteractive)
    private var invocations: [MethodType] = []
    private var methodReturnValues: [Given] = []
    private var methodPerformValues: [Perform] = []
    private var file: StaticString?
    private var line: UInt?

    public typealias PropertyStub = Given
    public typealias MethodStub = Given
    public typealias SubscriptStub = Given

    /// Convenience method - call setupMock() to extend debug information when failure occurs
    public func setupMock(file: StaticString = #file, line: UInt = #line) {
        self.file = file
        self.line = line
    }

    /// Clear mock internals. You can specify what to reset (invocations aka verify, givens or performs) or leave it empty to clear all mock internals
    public func resetMock(_ scopes: MockScope...) {
        let scopes: [MockScope] = scopes.isEmpty ? [.invocation, .given, .perform] : scopes
        if scopes.contains(.invocation) { invocations = [] }
        if scopes.contains(.given) { methodReturnValues = [] }
        if scopes.contains(.perform) { methodPerformValues = [] }
    }





    open func getCourseDiscussionInfo(courseID: String) throws -> DiscussionInfo {
        addInvocation(.m_getCourseDiscussionInfo__courseID_courseID(Parameter<String>.value(`courseID`)))
		let perform = methodPerformValue(.m_getCourseDiscussionInfo__courseID_courseID(Parameter<String>.value(`courseID`))) as? (String) -> Void
		perform?(`courseID`)
		var __value: DiscussionInfo
		do {
		    __value = try methodReturnValue(.m_getCourseDiscussionInfo__courseID_courseID(Parameter<String>.value(`courseID`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for getCourseDiscussionInfo(courseID: String). Use given")
			Failure("Stub return value not specified for getCourseDiscussionInfo(courseID: String). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func getThreadsList(courseID: String, type: ThreadType, sort: SortType, filter: ThreadsFilter, page: Int) throws -> ThreadLists {
        addInvocation(.m_getThreadsList__courseID_courseIDtype_typesort_sortfilter_filterpage_page(Parameter<String>.value(`courseID`), Parameter<ThreadType>.value(`type`), Parameter<SortType>.value(`sort`), Parameter<ThreadsFilter>.value(`filter`), Parameter<Int>.value(`page`)))
		let perform = methodPerformValue(.m_getThreadsList__courseID_courseIDtype_typesort_sortfilter_filterpage_page(Parameter<String>.value(`courseID`), Parameter<ThreadType>.value(`type`), Parameter<SortType>.value(`sort`), Parameter<ThreadsFilter>.value(`filter`), Parameter<Int>.value(`page`))) as? (String, ThreadType, SortType, ThreadsFilter, Int) -> Void
		perform?(`courseID`, `type`, `sort`, `filter`, `page`)
		var __value: ThreadLists
		do {
		    __value = try methodReturnValue(.m_getThreadsList__courseID_courseIDtype_typesort_sortfilter_filterpage_page(Parameter<String>.value(`courseID`), Parameter<ThreadType>.value(`type`), Parameter<SortType>.value(`sort`), Parameter<ThreadsFilter>.value(`filter`), Parameter<Int>.value(`page`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for getThreadsList(courseID: String, type: ThreadType, sort: SortType, filter: ThreadsFilter, page: Int). Use given")
			Failure("Stub return value not specified for getThreadsList(courseID: String, type: ThreadType, sort: SortType, filter: ThreadsFilter, page: Int). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func getTopics(courseID: String) throws -> Topics {
        addInvocation(.m_getTopics__courseID_courseID(Parameter<String>.value(`courseID`)))
		let perform = methodPerformValue(.m_getTopics__courseID_courseID(Parameter<String>.value(`courseID`))) as? (String) -> Void
		perform?(`courseID`)
		var __value: Topics
		do {
		    __value = try methodReturnValue(.m_getTopics__courseID_courseID(Parameter<String>.value(`courseID`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for getTopics(courseID: String). Use given")
			Failure("Stub return value not specified for getTopics(courseID: String). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func getTopic(courseID: String, topicID: String) throws -> Topics {
        addInvocation(.m_getTopic__courseID_courseIDtopicID_topicID(Parameter<String>.value(`courseID`), Parameter<String>.value(`topicID`)))
		let perform = methodPerformValue(.m_getTopic__courseID_courseIDtopicID_topicID(Parameter<String>.value(`courseID`), Parameter<String>.value(`topicID`))) as? (String, String) -> Void
		perform?(`courseID`, `topicID`)
		var __value: Topics
		do {
		    __value = try methodReturnValue(.m_getTopic__courseID_courseIDtopicID_topicID(Parameter<String>.value(`courseID`), Parameter<String>.value(`topicID`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for getTopic(courseID: String, topicID: String). Use given")
			Failure("Stub return value not specified for getTopic(courseID: String, topicID: String). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func searchThreads(courseID: String, searchText: String, pageNumber: Int) throws -> ThreadLists {
        addInvocation(.m_searchThreads__courseID_courseIDsearchText_searchTextpageNumber_pageNumber(Parameter<String>.value(`courseID`), Parameter<String>.value(`searchText`), Parameter<Int>.value(`pageNumber`)))
		let perform = methodPerformValue(.m_searchThreads__courseID_courseIDsearchText_searchTextpageNumber_pageNumber(Parameter<String>.value(`courseID`), Parameter<String>.value(`searchText`), Parameter<Int>.value(`pageNumber`))) as? (String, String, Int) -> Void
		perform?(`courseID`, `searchText`, `pageNumber`)
		var __value: ThreadLists
		do {
		    __value = try methodReturnValue(.m_searchThreads__courseID_courseIDsearchText_searchTextpageNumber_pageNumber(Parameter<String>.value(`courseID`), Parameter<String>.value(`searchText`), Parameter<Int>.value(`pageNumber`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for searchThreads(courseID: String, searchText: String, pageNumber: Int). Use given")
			Failure("Stub return value not specified for searchThreads(courseID: String, searchText: String, pageNumber: Int). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func getThread(threadID: String) throws -> UserThread {
        addInvocation(.m_getThread__threadID_threadID(Parameter<String>.value(`threadID`)))
		let perform = methodPerformValue(.m_getThread__threadID_threadID(Parameter<String>.value(`threadID`))) as? (String) -> Void
		perform?(`threadID`)
		var __value: UserThread
		do {
		    __value = try methodReturnValue(.m_getThread__threadID_threadID(Parameter<String>.value(`threadID`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for getThread(threadID: String). Use given")
			Failure("Stub return value not specified for getThread(threadID: String). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func getDiscussionComments(threadID: String, page: Int) throws -> ([UserComment], Pagination) {
        addInvocation(.m_getDiscussionComments__threadID_threadIDpage_page(Parameter<String>.value(`threadID`), Parameter<Int>.value(`page`)))
		let perform = methodPerformValue(.m_getDiscussionComments__threadID_threadIDpage_page(Parameter<String>.value(`threadID`), Parameter<Int>.value(`page`))) as? (String, Int) -> Void
		perform?(`threadID`, `page`)
		var __value: ([UserComment], Pagination)
		do {
		    __value = try methodReturnValue(.m_getDiscussionComments__threadID_threadIDpage_page(Parameter<String>.value(`threadID`), Parameter<Int>.value(`page`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for getDiscussionComments(threadID: String, page: Int). Use given")
			Failure("Stub return value not specified for getDiscussionComments(threadID: String, page: Int). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func getQuestionComments(threadID: String, page: Int) throws -> ([UserComment], Pagination) {
        addInvocation(.m_getQuestionComments__threadID_threadIDpage_page(Parameter<String>.value(`threadID`), Parameter<Int>.value(`page`)))
		let perform = methodPerformValue(.m_getQuestionComments__threadID_threadIDpage_page(Parameter<String>.value(`threadID`), Parameter<Int>.value(`page`))) as? (String, Int) -> Void
		perform?(`threadID`, `page`)
		var __value: ([UserComment], Pagination)
		do {
		    __value = try methodReturnValue(.m_getQuestionComments__threadID_threadIDpage_page(Parameter<String>.value(`threadID`), Parameter<Int>.value(`page`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for getQuestionComments(threadID: String, page: Int). Use given")
			Failure("Stub return value not specified for getQuestionComments(threadID: String, page: Int). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func getCommentResponses(commentID: String, page: Int) throws -> ([UserComment], Pagination) {
        addInvocation(.m_getCommentResponses__commentID_commentIDpage_page(Parameter<String>.value(`commentID`), Parameter<Int>.value(`page`)))
		let perform = methodPerformValue(.m_getCommentResponses__commentID_commentIDpage_page(Parameter<String>.value(`commentID`), Parameter<Int>.value(`page`))) as? (String, Int) -> Void
		perform?(`commentID`, `page`)
		var __value: ([UserComment], Pagination)
		do {
		    __value = try methodReturnValue(.m_getCommentResponses__commentID_commentIDpage_page(Parameter<String>.value(`commentID`), Parameter<Int>.value(`page`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for getCommentResponses(commentID: String, page: Int). Use given")
			Failure("Stub return value not specified for getCommentResponses(commentID: String, page: Int). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func getResponse(responseID: String) throws -> UserComment {
        addInvocation(.m_getResponse__responseID_responseID(Parameter<String>.value(`responseID`)))
		let perform = methodPerformValue(.m_getResponse__responseID_responseID(Parameter<String>.value(`responseID`))) as? (String) -> Void
		perform?(`responseID`)
		var __value: UserComment
		do {
		    __value = try methodReturnValue(.m_getResponse__responseID_responseID(Parameter<String>.value(`responseID`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for getResponse(responseID: String). Use given")
			Failure("Stub return value not specified for getResponse(responseID: String). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func addCommentTo(threadID: String, rawBody: String, parentID: String?) throws -> Post {
        addInvocation(.m_addCommentTo__threadID_threadIDrawBody_rawBodyparentID_parentID(Parameter<String>.value(`threadID`), Parameter<String>.value(`rawBody`), Parameter<String?>.value(`parentID`)))
		let perform = methodPerformValue(.m_addCommentTo__threadID_threadIDrawBody_rawBodyparentID_parentID(Parameter<String>.value(`threadID`), Parameter<String>.value(`rawBody`), Parameter<String?>.value(`parentID`))) as? (String, String, String?) -> Void
		perform?(`threadID`, `rawBody`, `parentID`)
		var __value: Post
		do {
		    __value = try methodReturnValue(.m_addCommentTo__threadID_threadIDrawBody_rawBodyparentID_parentID(Parameter<String>.value(`threadID`), Parameter<String>.value(`rawBody`), Parameter<String?>.value(`parentID`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for addCommentTo(threadID: String, rawBody: String, parentID: String?). Use given")
			Failure("Stub return value not specified for addCommentTo(threadID: String, rawBody: String, parentID: String?). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func voteThread(voted: Bool, threadID: String) throws {
        addInvocation(.m_voteThread__voted_votedthreadID_threadID(Parameter<Bool>.value(`voted`), Parameter<String>.value(`threadID`)))
		let perform = methodPerformValue(.m_voteThread__voted_votedthreadID_threadID(Parameter<Bool>.value(`voted`), Parameter<String>.value(`threadID`))) as? (Bool, String) -> Void
		perform?(`voted`, `threadID`)
		do {
		    _ = try methodReturnValue(.m_voteThread__voted_votedthreadID_threadID(Parameter<Bool>.value(`voted`), Parameter<String>.value(`threadID`))).casted() as Void
		} catch MockError.notStubed {
			// do nothing
		} catch {
		    throw error
		}
    }

    open func voteResponse(voted: Bool, responseID: String) throws {
        addInvocation(.m_voteResponse__voted_votedresponseID_responseID(Parameter<Bool>.value(`voted`), Parameter<String>.value(`responseID`)))
		let perform = methodPerformValue(.m_voteResponse__voted_votedresponseID_responseID(Parameter<Bool>.value(`voted`), Parameter<String>.value(`responseID`))) as? (Bool, String) -> Void
		perform?(`voted`, `responseID`)
		do {
		    _ = try methodReturnValue(.m_voteResponse__voted_votedresponseID_responseID(Parameter<Bool>.value(`voted`), Parameter<String>.value(`responseID`))).casted() as Void
		} catch MockError.notStubed {
			// do nothing
		} catch {
		    throw error
		}
    }

    open func flagThread(abuseFlagged: Bool, threadID: String) throws {
        addInvocation(.m_flagThread__abuseFlagged_abuseFlaggedthreadID_threadID(Parameter<Bool>.value(`abuseFlagged`), Parameter<String>.value(`threadID`)))
		let perform = methodPerformValue(.m_flagThread__abuseFlagged_abuseFlaggedthreadID_threadID(Parameter<Bool>.value(`abuseFlagged`), Parameter<String>.value(`threadID`))) as? (Bool, String) -> Void
		perform?(`abuseFlagged`, `threadID`)
		do {
		    _ = try methodReturnValue(.m_flagThread__abuseFlagged_abuseFlaggedthreadID_threadID(Parameter<Bool>.value(`abuseFlagged`), Parameter<String>.value(`threadID`))).casted() as Void
		} catch MockError.notStubed {
			// do nothing
		} catch {
		    throw error
		}
    }

    open func flagComment(abuseFlagged: Bool, commentID: String) throws {
        addInvocation(.m_flagComment__abuseFlagged_abuseFlaggedcommentID_commentID(Parameter<Bool>.value(`abuseFlagged`), Parameter<String>.value(`commentID`)))
		let perform = methodPerformValue(.m_flagComment__abuseFlagged_abuseFlaggedcommentID_commentID(Parameter<Bool>.value(`abuseFlagged`), Parameter<String>.value(`commentID`))) as? (Bool, String) -> Void
		perform?(`abuseFlagged`, `commentID`)
		do {
		    _ = try methodReturnValue(.m_flagComment__abuseFlagged_abuseFlaggedcommentID_commentID(Parameter<Bool>.value(`abuseFlagged`), Parameter<String>.value(`commentID`))).casted() as Void
		} catch MockError.notStubed {
			// do nothing
		} catch {
		    throw error
		}
    }

    open func followThread(following: Bool, threadID: String) throws {
        addInvocation(.m_followThread__following_followingthreadID_threadID(Parameter<Bool>.value(`following`), Parameter<String>.value(`threadID`)))
		let perform = methodPerformValue(.m_followThread__following_followingthreadID_threadID(Parameter<Bool>.value(`following`), Parameter<String>.value(`threadID`))) as? (Bool, String) -> Void
		perform?(`following`, `threadID`)
		do {
		    _ = try methodReturnValue(.m_followThread__following_followingthreadID_threadID(Parameter<Bool>.value(`following`), Parameter<String>.value(`threadID`))).casted() as Void
		} catch MockError.notStubed {
			// do nothing
		} catch {
		    throw error
		}
    }

    open func createNewThread(newThread: DiscussionNewThread) throws {
        addInvocation(.m_createNewThread__newThread_newThread(Parameter<DiscussionNewThread>.value(`newThread`)))
		let perform = methodPerformValue(.m_createNewThread__newThread_newThread(Parameter<DiscussionNewThread>.value(`newThread`))) as? (DiscussionNewThread) -> Void
		perform?(`newThread`)
		do {
		    _ = try methodReturnValue(.m_createNewThread__newThread_newThread(Parameter<DiscussionNewThread>.value(`newThread`))).casted() as Void
		} catch MockError.notStubed {
			// do nothing
		} catch {
		    throw error
		}
    }

    open func readBody(threadID: String) throws {
        addInvocation(.m_readBody__threadID_threadID(Parameter<String>.value(`threadID`)))
		let perform = methodPerformValue(.m_readBody__threadID_threadID(Parameter<String>.value(`threadID`))) as? (String) -> Void
		perform?(`threadID`)
		do {
		    _ = try methodReturnValue(.m_readBody__threadID_threadID(Parameter<String>.value(`threadID`))).casted() as Void
		} catch MockError.notStubed {
			// do nothing
		} catch {
		    throw error
		}
    }


    fileprivate enum MethodType {
        case m_getCourseDiscussionInfo__courseID_courseID(Parameter<String>)
        case m_getThreadsList__courseID_courseIDtype_typesort_sortfilter_filterpage_page(Parameter<String>, Parameter<ThreadType>, Parameter<SortType>, Parameter<ThreadsFilter>, Parameter<Int>)
        case m_getTopics__courseID_courseID(Parameter<String>)
        case m_getTopic__courseID_courseIDtopicID_topicID(Parameter<String>, Parameter<String>)
        case m_searchThreads__courseID_courseIDsearchText_searchTextpageNumber_pageNumber(Parameter<String>, Parameter<String>, Parameter<Int>)
        case m_getThread__threadID_threadID(Parameter<String>)
        case m_getDiscussionComments__threadID_threadIDpage_page(Parameter<String>, Parameter<Int>)
        case m_getQuestionComments__threadID_threadIDpage_page(Parameter<String>, Parameter<Int>)
        case m_getCommentResponses__commentID_commentIDpage_page(Parameter<String>, Parameter<Int>)
        case m_getResponse__responseID_responseID(Parameter<String>)
        case m_addCommentTo__threadID_threadIDrawBody_rawBodyparentID_parentID(Parameter<String>, Parameter<String>, Parameter<String?>)
        case m_voteThread__voted_votedthreadID_threadID(Parameter<Bool>, Parameter<String>)
        case m_voteResponse__voted_votedresponseID_responseID(Parameter<Bool>, Parameter<String>)
        case m_flagThread__abuseFlagged_abuseFlaggedthreadID_threadID(Parameter<Bool>, Parameter<String>)
        case m_flagComment__abuseFlagged_abuseFlaggedcommentID_commentID(Parameter<Bool>, Parameter<String>)
        case m_followThread__following_followingthreadID_threadID(Parameter<Bool>, Parameter<String>)
        case m_createNewThread__newThread_newThread(Parameter<DiscussionNewThread>)
        case m_readBody__threadID_threadID(Parameter<String>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_getCourseDiscussionInfo__courseID_courseID(let lhsCourseid), .m_getCourseDiscussionInfo__courseID_courseID(let rhsCourseid)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseID"))
				return Matcher.ComparisonResult(results)

            case (.m_getThreadsList__courseID_courseIDtype_typesort_sortfilter_filterpage_page(let lhsCourseid, let lhsType, let lhsSort, let lhsFilter, let lhsPage), .m_getThreadsList__courseID_courseIDtype_typesort_sortfilter_filterpage_page(let rhsCourseid, let rhsType, let rhsSort, let rhsFilter, let rhsPage)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseID"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsType, rhs: rhsType, with: matcher), lhsType, rhsType, "type"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsSort, rhs: rhsSort, with: matcher), lhsSort, rhsSort, "sort"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsFilter, rhs: rhsFilter, with: matcher), lhsFilter, rhsFilter, "filter"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsPage, rhs: rhsPage, with: matcher), lhsPage, rhsPage, "page"))
				return Matcher.ComparisonResult(results)

            case (.m_getTopics__courseID_courseID(let lhsCourseid), .m_getTopics__courseID_courseID(let rhsCourseid)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseID"))
				return Matcher.ComparisonResult(results)

            case (.m_getTopic__courseID_courseIDtopicID_topicID(let lhsCourseid, let lhsTopicid), .m_getTopic__courseID_courseIDtopicID_topicID(let rhsCourseid, let rhsTopicid)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseID"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsTopicid, rhs: rhsTopicid, with: matcher), lhsTopicid, rhsTopicid, "topicID"))
				return Matcher.ComparisonResult(results)

            case (.m_searchThreads__courseID_courseIDsearchText_searchTextpageNumber_pageNumber(let lhsCourseid, let lhsSearchtext, let lhsPagenumber), .m_searchThreads__courseID_courseIDsearchText_searchTextpageNumber_pageNumber(let rhsCourseid, let rhsSearchtext, let rhsPagenumber)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseID"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsSearchtext, rhs: rhsSearchtext, with: matcher), lhsSearchtext, rhsSearchtext, "searchText"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsPagenumber, rhs: rhsPagenumber, with: matcher), lhsPagenumber, rhsPagenumber, "pageNumber"))
				return Matcher.ComparisonResult(results)

            case (.m_getThread__threadID_threadID(let lhsThreadid), .m_getThread__threadID_threadID(let rhsThreadid)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsThreadid, rhs: rhsThreadid, with: matcher), lhsThreadid, rhsThreadid, "threadID"))
				return Matcher.ComparisonResult(results)

            case (.m_getDiscussionComments__threadID_threadIDpage_page(let lhsThreadid, let lhsPage), .m_getDiscussionComments__threadID_threadIDpage_page(let rhsThreadid, let rhsPage)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsThreadid, rhs: rhsThreadid, with: matcher), lhsThreadid, rhsThreadid, "threadID"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsPage, rhs: rhsPage, with: matcher), lhsPage, rhsPage, "page"))
				return Matcher.ComparisonResult(results)

            case (.m_getQuestionComments__threadID_threadIDpage_page(let lhsThreadid, let lhsPage), .m_getQuestionComments__threadID_threadIDpage_page(let rhsThreadid, let rhsPage)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsThreadid, rhs: rhsThreadid, with: matcher), lhsThreadid, rhsThreadid, "threadID"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsPage, rhs: rhsPage, with: matcher), lhsPage, rhsPage, "page"))
				return Matcher.ComparisonResult(results)

            case (.m_getCommentResponses__commentID_commentIDpage_page(let lhsCommentid, let lhsPage), .m_getCommentResponses__commentID_commentIDpage_page(let rhsCommentid, let rhsPage)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCommentid, rhs: rhsCommentid, with: matcher), lhsCommentid, rhsCommentid, "commentID"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsPage, rhs: rhsPage, with: matcher), lhsPage, rhsPage, "page"))
				return Matcher.ComparisonResult(results)

            case (.m_getResponse__responseID_responseID(let lhsResponseid), .m_getResponse__responseID_responseID(let rhsResponseid)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsResponseid, rhs: rhsResponseid, with: matcher), lhsResponseid, rhsResponseid, "responseID"))
				return Matcher.ComparisonResult(results)

            case (.m_addCommentTo__threadID_threadIDrawBody_rawBodyparentID_parentID(let lhsThreadid, let lhsRawbody, let lhsParentid), .m_addCommentTo__threadID_threadIDrawBody_rawBodyparentID_parentID(let rhsThreadid, let rhsRawbody, let rhsParentid)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsThreadid, rhs: rhsThreadid, with: matcher), lhsThreadid, rhsThreadid, "threadID"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsRawbody, rhs: rhsRawbody, with: matcher), lhsRawbody, rhsRawbody, "rawBody"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsParentid, rhs: rhsParentid, with: matcher), lhsParentid, rhsParentid, "parentID"))
				return Matcher.ComparisonResult(results)

            case (.m_voteThread__voted_votedthreadID_threadID(let lhsVoted, let lhsThreadid), .m_voteThread__voted_votedthreadID_threadID(let rhsVoted, let rhsThreadid)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsVoted, rhs: rhsVoted, with: matcher), lhsVoted, rhsVoted, "voted"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsThreadid, rhs: rhsThreadid, with: matcher), lhsThreadid, rhsThreadid, "threadID"))
				return Matcher.ComparisonResult(results)

            case (.m_voteResponse__voted_votedresponseID_responseID(let lhsVoted, let lhsResponseid), .m_voteResponse__voted_votedresponseID_responseID(let rhsVoted, let rhsResponseid)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsVoted, rhs: rhsVoted, with: matcher), lhsVoted, rhsVoted, "voted"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsResponseid, rhs: rhsResponseid, with: matcher), lhsResponseid, rhsResponseid, "responseID"))
				return Matcher.ComparisonResult(results)

            case (.m_flagThread__abuseFlagged_abuseFlaggedthreadID_threadID(let lhsAbuseflagged, let lhsThreadid), .m_flagThread__abuseFlagged_abuseFlaggedthreadID_threadID(let rhsAbuseflagged, let rhsThreadid)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsAbuseflagged, rhs: rhsAbuseflagged, with: matcher), lhsAbuseflagged, rhsAbuseflagged, "abuseFlagged"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsThreadid, rhs: rhsThreadid, with: matcher), lhsThreadid, rhsThreadid, "threadID"))
				return Matcher.ComparisonResult(results)

            case (.m_flagComment__abuseFlagged_abuseFlaggedcommentID_commentID(let lhsAbuseflagged, let lhsCommentid), .m_flagComment__abuseFlagged_abuseFlaggedcommentID_commentID(let rhsAbuseflagged, let rhsCommentid)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsAbuseflagged, rhs: rhsAbuseflagged, with: matcher), lhsAbuseflagged, rhsAbuseflagged, "abuseFlagged"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCommentid, rhs: rhsCommentid, with: matcher), lhsCommentid, rhsCommentid, "commentID"))
				return Matcher.ComparisonResult(results)

            case (.m_followThread__following_followingthreadID_threadID(let lhsFollowing, let lhsThreadid), .m_followThread__following_followingthreadID_threadID(let rhsFollowing, let rhsThreadid)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsFollowing, rhs: rhsFollowing, with: matcher), lhsFollowing, rhsFollowing, "following"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsThreadid, rhs: rhsThreadid, with: matcher), lhsThreadid, rhsThreadid, "threadID"))
				return Matcher.ComparisonResult(results)

            case (.m_createNewThread__newThread_newThread(let lhsNewthread), .m_createNewThread__newThread_newThread(let rhsNewthread)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsNewthread, rhs: rhsNewthread, with: matcher), lhsNewthread, rhsNewthread, "newThread"))
				return Matcher.ComparisonResult(results)

            case (.m_readBody__threadID_threadID(let lhsThreadid), .m_readBody__threadID_threadID(let rhsThreadid)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsThreadid, rhs: rhsThreadid, with: matcher), lhsThreadid, rhsThreadid, "threadID"))
				return Matcher.ComparisonResult(results)
            default: return .none
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_getCourseDiscussionInfo__courseID_courseID(p0): return p0.intValue
            case let .m_getThreadsList__courseID_courseIDtype_typesort_sortfilter_filterpage_page(p0, p1, p2, p3, p4): return p0.intValue + p1.intValue + p2.intValue + p3.intValue + p4.intValue
            case let .m_getTopics__courseID_courseID(p0): return p0.intValue
            case let .m_getTopic__courseID_courseIDtopicID_topicID(p0, p1): return p0.intValue + p1.intValue
            case let .m_searchThreads__courseID_courseIDsearchText_searchTextpageNumber_pageNumber(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
            case let .m_getThread__threadID_threadID(p0): return p0.intValue
            case let .m_getDiscussionComments__threadID_threadIDpage_page(p0, p1): return p0.intValue + p1.intValue
            case let .m_getQuestionComments__threadID_threadIDpage_page(p0, p1): return p0.intValue + p1.intValue
            case let .m_getCommentResponses__commentID_commentIDpage_page(p0, p1): return p0.intValue + p1.intValue
            case let .m_getResponse__responseID_responseID(p0): return p0.intValue
            case let .m_addCommentTo__threadID_threadIDrawBody_rawBodyparentID_parentID(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
            case let .m_voteThread__voted_votedthreadID_threadID(p0, p1): return p0.intValue + p1.intValue
            case let .m_voteResponse__voted_votedresponseID_responseID(p0, p1): return p0.intValue + p1.intValue
            case let .m_flagThread__abuseFlagged_abuseFlaggedthreadID_threadID(p0, p1): return p0.intValue + p1.intValue
            case let .m_flagComment__abuseFlagged_abuseFlaggedcommentID_commentID(p0, p1): return p0.intValue + p1.intValue
            case let .m_followThread__following_followingthreadID_threadID(p0, p1): return p0.intValue + p1.intValue
            case let .m_createNewThread__newThread_newThread(p0): return p0.intValue
            case let .m_readBody__threadID_threadID(p0): return p0.intValue
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_getCourseDiscussionInfo__courseID_courseID: return ".getCourseDiscussionInfo(courseID:)"
            case .m_getThreadsList__courseID_courseIDtype_typesort_sortfilter_filterpage_page: return ".getThreadsList(courseID:type:sort:filter:page:)"
            case .m_getTopics__courseID_courseID: return ".getTopics(courseID:)"
            case .m_getTopic__courseID_courseIDtopicID_topicID: return ".getTopic(courseID:topicID:)"
            case .m_searchThreads__courseID_courseIDsearchText_searchTextpageNumber_pageNumber: return ".searchThreads(courseID:searchText:pageNumber:)"
            case .m_getThread__threadID_threadID: return ".getThread(threadID:)"
            case .m_getDiscussionComments__threadID_threadIDpage_page: return ".getDiscussionComments(threadID:page:)"
            case .m_getQuestionComments__threadID_threadIDpage_page: return ".getQuestionComments(threadID:page:)"
            case .m_getCommentResponses__commentID_commentIDpage_page: return ".getCommentResponses(commentID:page:)"
            case .m_getResponse__responseID_responseID: return ".getResponse(responseID:)"
            case .m_addCommentTo__threadID_threadIDrawBody_rawBodyparentID_parentID: return ".addCommentTo(threadID:rawBody:parentID:)"
            case .m_voteThread__voted_votedthreadID_threadID: return ".voteThread(voted:threadID:)"
            case .m_voteResponse__voted_votedresponseID_responseID: return ".voteResponse(voted:responseID:)"
            case .m_flagThread__abuseFlagged_abuseFlaggedthreadID_threadID: return ".flagThread(abuseFlagged:threadID:)"
            case .m_flagComment__abuseFlagged_abuseFlaggedcommentID_commentID: return ".flagComment(abuseFlagged:commentID:)"
            case .m_followThread__following_followingthreadID_threadID: return ".followThread(following:threadID:)"
            case .m_createNewThread__newThread_newThread: return ".createNewThread(newThread:)"
            case .m_readBody__threadID_threadID: return ".readBody(threadID:)"
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }


        public static func getCourseDiscussionInfo(courseID: Parameter<String>, willReturn: DiscussionInfo...) -> MethodStub {
            return Given(method: .m_getCourseDiscussionInfo__courseID_courseID(`courseID`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func getThreadsList(courseID: Parameter<String>, type: Parameter<ThreadType>, sort: Parameter<SortType>, filter: Parameter<ThreadsFilter>, page: Parameter<Int>, willReturn: ThreadLists...) -> MethodStub {
            return Given(method: .m_getThreadsList__courseID_courseIDtype_typesort_sortfilter_filterpage_page(`courseID`, `type`, `sort`, `filter`, `page`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func getTopics(courseID: Parameter<String>, willReturn: Topics...) -> MethodStub {
            return Given(method: .m_getTopics__courseID_courseID(`courseID`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func getTopic(courseID: Parameter<String>, topicID: Parameter<String>, willReturn: Topics...) -> MethodStub {
            return Given(method: .m_getTopic__courseID_courseIDtopicID_topicID(`courseID`, `topicID`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func searchThreads(courseID: Parameter<String>, searchText: Parameter<String>, pageNumber: Parameter<Int>, willReturn: ThreadLists...) -> MethodStub {
            return Given(method: .m_searchThreads__courseID_courseIDsearchText_searchTextpageNumber_pageNumber(`courseID`, `searchText`, `pageNumber`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func getThread(threadID: Parameter<String>, willReturn: UserThread...) -> MethodStub {
            return Given(method: .m_getThread__threadID_threadID(`threadID`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func getDiscussionComments(threadID: Parameter<String>, page: Parameter<Int>, willReturn: ([UserComment], Pagination)...) -> MethodStub {
            return Given(method: .m_getDiscussionComments__threadID_threadIDpage_page(`threadID`, `page`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func getQuestionComments(threadID: Parameter<String>, page: Parameter<Int>, willReturn: ([UserComment], Pagination)...) -> MethodStub {
            return Given(method: .m_getQuestionComments__threadID_threadIDpage_page(`threadID`, `page`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func getCommentResponses(commentID: Parameter<String>, page: Parameter<Int>, willReturn: ([UserComment], Pagination)...) -> MethodStub {
            return Given(method: .m_getCommentResponses__commentID_commentIDpage_page(`commentID`, `page`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func getResponse(responseID: Parameter<String>, willReturn: UserComment...) -> MethodStub {
            return Given(method: .m_getResponse__responseID_responseID(`responseID`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func addCommentTo(threadID: Parameter<String>, rawBody: Parameter<String>, parentID: Parameter<String?>, willReturn: Post...) -> MethodStub {
            return Given(method: .m_addCommentTo__threadID_threadIDrawBody_rawBodyparentID_parentID(`threadID`, `rawBody`, `parentID`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func getCourseDiscussionInfo(courseID: Parameter<String>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_getCourseDiscussionInfo__courseID_courseID(`courseID`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func getCourseDiscussionInfo(courseID: Parameter<String>, willProduce: (StubberThrows<DiscussionInfo>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_getCourseDiscussionInfo__courseID_courseID(`courseID`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (DiscussionInfo).self)
			willProduce(stubber)
			return given
        }
        public static func getThreadsList(courseID: Parameter<String>, type: Parameter<ThreadType>, sort: Parameter<SortType>, filter: Parameter<ThreadsFilter>, page: Parameter<Int>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_getThreadsList__courseID_courseIDtype_typesort_sortfilter_filterpage_page(`courseID`, `type`, `sort`, `filter`, `page`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func getThreadsList(courseID: Parameter<String>, type: Parameter<ThreadType>, sort: Parameter<SortType>, filter: Parameter<ThreadsFilter>, page: Parameter<Int>, willProduce: (StubberThrows<ThreadLists>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_getThreadsList__courseID_courseIDtype_typesort_sortfilter_filterpage_page(`courseID`, `type`, `sort`, `filter`, `page`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (ThreadLists).self)
			willProduce(stubber)
			return given
        }
        public static func getTopics(courseID: Parameter<String>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_getTopics__courseID_courseID(`courseID`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func getTopics(courseID: Parameter<String>, willProduce: (StubberThrows<Topics>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_getTopics__courseID_courseID(`courseID`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Topics).self)
			willProduce(stubber)
			return given
        }
        public static func getTopic(courseID: Parameter<String>, topicID: Parameter<String>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_getTopic__courseID_courseIDtopicID_topicID(`courseID`, `topicID`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func getTopic(courseID: Parameter<String>, topicID: Parameter<String>, willProduce: (StubberThrows<Topics>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_getTopic__courseID_courseIDtopicID_topicID(`courseID`, `topicID`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Topics).self)
			willProduce(stubber)
			return given
        }
        public static func searchThreads(courseID: Parameter<String>, searchText: Parameter<String>, pageNumber: Parameter<Int>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_searchThreads__courseID_courseIDsearchText_searchTextpageNumber_pageNumber(`courseID`, `searchText`, `pageNumber`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func searchThreads(courseID: Parameter<String>, searchText: Parameter<String>, pageNumber: Parameter<Int>, willProduce: (StubberThrows<ThreadLists>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_searchThreads__courseID_courseIDsearchText_searchTextpageNumber_pageNumber(`courseID`, `searchText`, `pageNumber`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (ThreadLists).self)
			willProduce(stubber)
			return given
        }
        public static func getThread(threadID: Parameter<String>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_getThread__threadID_threadID(`threadID`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func getThread(threadID: Parameter<String>, willProduce: (StubberThrows<UserThread>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_getThread__threadID_threadID(`threadID`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (UserThread).self)
			willProduce(stubber)
			return given
        }
        public static func getDiscussionComments(threadID: Parameter<String>, page: Parameter<Int>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_getDiscussionComments__threadID_threadIDpage_page(`threadID`, `page`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func getDiscussionComments(threadID: Parameter<String>, page: Parameter<Int>, willProduce: (StubberThrows<([UserComment], Pagination)>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_getDiscussionComments__threadID_threadIDpage_page(`threadID`, `page`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (([UserComment], Pagination)).self)
			willProduce(stubber)
			return given
        }
        public static func getQuestionComments(threadID: Parameter<String>, page: Parameter<Int>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_getQuestionComments__threadID_threadIDpage_page(`threadID`, `page`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func getQuestionComments(threadID: Parameter<String>, page: Parameter<Int>, willProduce: (StubberThrows<([UserComment], Pagination)>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_getQuestionComments__threadID_threadIDpage_page(`threadID`, `page`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (([UserComment], Pagination)).self)
			willProduce(stubber)
			return given
        }
        public static func getCommentResponses(commentID: Parameter<String>, page: Parameter<Int>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_getCommentResponses__commentID_commentIDpage_page(`commentID`, `page`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func getCommentResponses(commentID: Parameter<String>, page: Parameter<Int>, willProduce: (StubberThrows<([UserComment], Pagination)>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_getCommentResponses__commentID_commentIDpage_page(`commentID`, `page`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (([UserComment], Pagination)).self)
			willProduce(stubber)
			return given
        }
        public static func getResponse(responseID: Parameter<String>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_getResponse__responseID_responseID(`responseID`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func getResponse(responseID: Parameter<String>, willProduce: (StubberThrows<UserComment>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_getResponse__responseID_responseID(`responseID`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (UserComment).self)
			willProduce(stubber)
			return given
        }
        public static func addCommentTo(threadID: Parameter<String>, rawBody: Parameter<String>, parentID: Parameter<String?>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_addCommentTo__threadID_threadIDrawBody_rawBodyparentID_parentID(`threadID`, `rawBody`, `parentID`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func addCommentTo(threadID: Parameter<String>, rawBody: Parameter<String>, parentID: Parameter<String?>, willProduce: (StubberThrows<Post>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_addCommentTo__threadID_threadIDrawBody_rawBodyparentID_parentID(`threadID`, `rawBody`, `parentID`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Post).self)
			willProduce(stubber)
			return given
        }
        public static func voteThread(voted: Parameter<Bool>, threadID: Parameter<String>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_voteThread__voted_votedthreadID_threadID(`voted`, `threadID`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func voteThread(voted: Parameter<Bool>, threadID: Parameter<String>, willProduce: (StubberThrows<Void>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_voteThread__voted_votedthreadID_threadID(`voted`, `threadID`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Void).self)
			willProduce(stubber)
			return given
        }
        public static func voteResponse(voted: Parameter<Bool>, responseID: Parameter<String>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_voteResponse__voted_votedresponseID_responseID(`voted`, `responseID`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func voteResponse(voted: Parameter<Bool>, responseID: Parameter<String>, willProduce: (StubberThrows<Void>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_voteResponse__voted_votedresponseID_responseID(`voted`, `responseID`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Void).self)
			willProduce(stubber)
			return given
        }
        public static func flagThread(abuseFlagged: Parameter<Bool>, threadID: Parameter<String>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_flagThread__abuseFlagged_abuseFlaggedthreadID_threadID(`abuseFlagged`, `threadID`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func flagThread(abuseFlagged: Parameter<Bool>, threadID: Parameter<String>, willProduce: (StubberThrows<Void>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_flagThread__abuseFlagged_abuseFlaggedthreadID_threadID(`abuseFlagged`, `threadID`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Void).self)
			willProduce(stubber)
			return given
        }
        public static func flagComment(abuseFlagged: Parameter<Bool>, commentID: Parameter<String>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_flagComment__abuseFlagged_abuseFlaggedcommentID_commentID(`abuseFlagged`, `commentID`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func flagComment(abuseFlagged: Parameter<Bool>, commentID: Parameter<String>, willProduce: (StubberThrows<Void>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_flagComment__abuseFlagged_abuseFlaggedcommentID_commentID(`abuseFlagged`, `commentID`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Void).self)
			willProduce(stubber)
			return given
        }
        public static func followThread(following: Parameter<Bool>, threadID: Parameter<String>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_followThread__following_followingthreadID_threadID(`following`, `threadID`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func followThread(following: Parameter<Bool>, threadID: Parameter<String>, willProduce: (StubberThrows<Void>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_followThread__following_followingthreadID_threadID(`following`, `threadID`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Void).self)
			willProduce(stubber)
			return given
        }
        public static func createNewThread(newThread: Parameter<DiscussionNewThread>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_createNewThread__newThread_newThread(`newThread`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func createNewThread(newThread: Parameter<DiscussionNewThread>, willProduce: (StubberThrows<Void>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_createNewThread__newThread_newThread(`newThread`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Void).self)
			willProduce(stubber)
			return given
        }
        public static func readBody(threadID: Parameter<String>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_readBody__threadID_threadID(`threadID`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func readBody(threadID: Parameter<String>, willProduce: (StubberThrows<Void>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_readBody__threadID_threadID(`threadID`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Void).self)
			willProduce(stubber)
			return given
        }
    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func getCourseDiscussionInfo(courseID: Parameter<String>) -> Verify { return Verify(method: .m_getCourseDiscussionInfo__courseID_courseID(`courseID`))}
        public static func getThreadsList(courseID: Parameter<String>, type: Parameter<ThreadType>, sort: Parameter<SortType>, filter: Parameter<ThreadsFilter>, page: Parameter<Int>) -> Verify { return Verify(method: .m_getThreadsList__courseID_courseIDtype_typesort_sortfilter_filterpage_page(`courseID`, `type`, `sort`, `filter`, `page`))}
        public static func getTopics(courseID: Parameter<String>) -> Verify { return Verify(method: .m_getTopics__courseID_courseID(`courseID`))}
        public static func getTopic(courseID: Parameter<String>, topicID: Parameter<String>) -> Verify { return Verify(method: .m_getTopic__courseID_courseIDtopicID_topicID(`courseID`, `topicID`))}
        public static func searchThreads(courseID: Parameter<String>, searchText: Parameter<String>, pageNumber: Parameter<Int>) -> Verify { return Verify(method: .m_searchThreads__courseID_courseIDsearchText_searchTextpageNumber_pageNumber(`courseID`, `searchText`, `pageNumber`))}
        public static func getThread(threadID: Parameter<String>) -> Verify { return Verify(method: .m_getThread__threadID_threadID(`threadID`))}
        public static func getDiscussionComments(threadID: Parameter<String>, page: Parameter<Int>) -> Verify { return Verify(method: .m_getDiscussionComments__threadID_threadIDpage_page(`threadID`, `page`))}
        public static func getQuestionComments(threadID: Parameter<String>, page: Parameter<Int>) -> Verify { return Verify(method: .m_getQuestionComments__threadID_threadIDpage_page(`threadID`, `page`))}
        public static func getCommentResponses(commentID: Parameter<String>, page: Parameter<Int>) -> Verify { return Verify(method: .m_getCommentResponses__commentID_commentIDpage_page(`commentID`, `page`))}
        public static func getResponse(responseID: Parameter<String>) -> Verify { return Verify(method: .m_getResponse__responseID_responseID(`responseID`))}
        public static func addCommentTo(threadID: Parameter<String>, rawBody: Parameter<String>, parentID: Parameter<String?>) -> Verify { return Verify(method: .m_addCommentTo__threadID_threadIDrawBody_rawBodyparentID_parentID(`threadID`, `rawBody`, `parentID`))}
        public static func voteThread(voted: Parameter<Bool>, threadID: Parameter<String>) -> Verify { return Verify(method: .m_voteThread__voted_votedthreadID_threadID(`voted`, `threadID`))}
        public static func voteResponse(voted: Parameter<Bool>, responseID: Parameter<String>) -> Verify { return Verify(method: .m_voteResponse__voted_votedresponseID_responseID(`voted`, `responseID`))}
        public static func flagThread(abuseFlagged: Parameter<Bool>, threadID: Parameter<String>) -> Verify { return Verify(method: .m_flagThread__abuseFlagged_abuseFlaggedthreadID_threadID(`abuseFlagged`, `threadID`))}
        public static func flagComment(abuseFlagged: Parameter<Bool>, commentID: Parameter<String>) -> Verify { return Verify(method: .m_flagComment__abuseFlagged_abuseFlaggedcommentID_commentID(`abuseFlagged`, `commentID`))}
        public static func followThread(following: Parameter<Bool>, threadID: Parameter<String>) -> Verify { return Verify(method: .m_followThread__following_followingthreadID_threadID(`following`, `threadID`))}
        public static func createNewThread(newThread: Parameter<DiscussionNewThread>) -> Verify { return Verify(method: .m_createNewThread__newThread_newThread(`newThread`))}
        public static func readBody(threadID: Parameter<String>) -> Verify { return Verify(method: .m_readBody__threadID_threadID(`threadID`))}
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func getCourseDiscussionInfo(courseID: Parameter<String>, perform: @escaping (String) -> Void) -> Perform {
            return Perform(method: .m_getCourseDiscussionInfo__courseID_courseID(`courseID`), performs: perform)
        }
        public static func getThreadsList(courseID: Parameter<String>, type: Parameter<ThreadType>, sort: Parameter<SortType>, filter: Parameter<ThreadsFilter>, page: Parameter<Int>, perform: @escaping (String, ThreadType, SortType, ThreadsFilter, Int) -> Void) -> Perform {
            return Perform(method: .m_getThreadsList__courseID_courseIDtype_typesort_sortfilter_filterpage_page(`courseID`, `type`, `sort`, `filter`, `page`), performs: perform)
        }
        public static func getTopics(courseID: Parameter<String>, perform: @escaping (String) -> Void) -> Perform {
            return Perform(method: .m_getTopics__courseID_courseID(`courseID`), performs: perform)
        }
        public static func getTopic(courseID: Parameter<String>, topicID: Parameter<String>, perform: @escaping (String, String) -> Void) -> Perform {
            return Perform(method: .m_getTopic__courseID_courseIDtopicID_topicID(`courseID`, `topicID`), performs: perform)
        }
        public static func searchThreads(courseID: Parameter<String>, searchText: Parameter<String>, pageNumber: Parameter<Int>, perform: @escaping (String, String, Int) -> Void) -> Perform {
            return Perform(method: .m_searchThreads__courseID_courseIDsearchText_searchTextpageNumber_pageNumber(`courseID`, `searchText`, `pageNumber`), performs: perform)
        }
        public static func getThread(threadID: Parameter<String>, perform: @escaping (String) -> Void) -> Perform {
            return Perform(method: .m_getThread__threadID_threadID(`threadID`), performs: perform)
        }
        public static func getDiscussionComments(threadID: Parameter<String>, page: Parameter<Int>, perform: @escaping (String, Int) -> Void) -> Perform {
            return Perform(method: .m_getDiscussionComments__threadID_threadIDpage_page(`threadID`, `page`), performs: perform)
        }
        public static func getQuestionComments(threadID: Parameter<String>, page: Parameter<Int>, perform: @escaping (String, Int) -> Void) -> Perform {
            return Perform(method: .m_getQuestionComments__threadID_threadIDpage_page(`threadID`, `page`), performs: perform)
        }
        public static func getCommentResponses(commentID: Parameter<String>, page: Parameter<Int>, perform: @escaping (String, Int) -> Void) -> Perform {
            return Perform(method: .m_getCommentResponses__commentID_commentIDpage_page(`commentID`, `page`), performs: perform)
        }
        public static func getResponse(responseID: Parameter<String>, perform: @escaping (String) -> Void) -> Perform {
            return Perform(method: .m_getResponse__responseID_responseID(`responseID`), performs: perform)
        }
        public static func addCommentTo(threadID: Parameter<String>, rawBody: Parameter<String>, parentID: Parameter<String?>, perform: @escaping (String, String, String?) -> Void) -> Perform {
            return Perform(method: .m_addCommentTo__threadID_threadIDrawBody_rawBodyparentID_parentID(`threadID`, `rawBody`, `parentID`), performs: perform)
        }
        public static func voteThread(voted: Parameter<Bool>, threadID: Parameter<String>, perform: @escaping (Bool, String) -> Void) -> Perform {
            return Perform(method: .m_voteThread__voted_votedthreadID_threadID(`voted`, `threadID`), performs: perform)
        }
        public static func voteResponse(voted: Parameter<Bool>, responseID: Parameter<String>, perform: @escaping (Bool, String) -> Void) -> Perform {
            return Perform(method: .m_voteResponse__voted_votedresponseID_responseID(`voted`, `responseID`), performs: perform)
        }
        public static func flagThread(abuseFlagged: Parameter<Bool>, threadID: Parameter<String>, perform: @escaping (Bool, String) -> Void) -> Perform {
            return Perform(method: .m_flagThread__abuseFlagged_abuseFlaggedthreadID_threadID(`abuseFlagged`, `threadID`), performs: perform)
        }
        public static func flagComment(abuseFlagged: Parameter<Bool>, commentID: Parameter<String>, perform: @escaping (Bool, String) -> Void) -> Perform {
            return Perform(method: .m_flagComment__abuseFlagged_abuseFlaggedcommentID_commentID(`abuseFlagged`, `commentID`), performs: perform)
        }
        public static func followThread(following: Parameter<Bool>, threadID: Parameter<String>, perform: @escaping (Bool, String) -> Void) -> Perform {
            return Perform(method: .m_followThread__following_followingthreadID_threadID(`following`, `threadID`), performs: perform)
        }
        public static func createNewThread(newThread: Parameter<DiscussionNewThread>, perform: @escaping (DiscussionNewThread) -> Void) -> Perform {
            return Perform(method: .m_createNewThread__newThread_newThread(`newThread`), performs: perform)
        }
        public static func readBody(threadID: Parameter<String>, perform: @escaping (String) -> Void) -> Perform {
            return Perform(method: .m_readBody__threadID_threadID(`threadID`), performs: perform)
        }
    }

    public func given(_ method: Given) {
        methodReturnValues.append(method)
    }

    public func perform(_ method: Perform) {
        methodPerformValues.append(method)
        methodPerformValues.sort { $0.method.intValue() < $1.method.intValue() }
    }

    public func verify(_ method: Verify, count: Count = Count.moreOrEqual(to: 1), file: StaticString = #file, line: UInt = #line) {
        let fullMatches = matchingCalls(method, file: file, line: line)
        let success = count.matches(fullMatches)
        let assertionName = method.method.assertionName()
        let feedback: String = {
            guard !success else { return "" }
            return Utils.closestCallsMessage(
                for: self.invocations.map { invocation in
                    matcher.set(file: file, line: line)
                    defer { matcher.clearFileAndLine() }
                    return MethodType.compareParameters(lhs: invocation, rhs: method.method, matcher: matcher)
                },
                name: assertionName
            )
        }()
        MockyAssert(success, "Expected: \(count) invocations of `\(assertionName)`, but was: \(fullMatches).\(feedback)", file: file, line: line)
    }

    private func addInvocation(_ call: MethodType) {
        self.queue.sync { invocations.append(call) }
    }
    private func methodReturnValue(_ method: MethodType) throws -> StubProduct {
        matcher.set(file: self.file, line: self.line)
        defer { matcher.clearFileAndLine() }
        let candidates = sequencingPolicy.sorted(methodReturnValues, by: { $0.method.intValue() > $1.method.intValue() })
        let matched = candidates.first(where: { $0.isValid && MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher).isFullMatch })
        guard let product = matched?.getProduct(policy: self.stubbingPolicy) else { throw MockError.notStubed }
        return product
    }
    private func methodPerformValue(_ method: MethodType) -> Any? {
        matcher.set(file: self.file, line: self.line)
        defer { matcher.clearFileAndLine() }
        let matched = methodPerformValues.reversed().first { MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher).isFullMatch }
        return matched?.performs
    }
    private func matchingCalls(_ method: MethodType, file: StaticString?, line: UInt?) -> [MethodType] {
        matcher.set(file: file ?? self.file, line: line ?? self.line)
        defer { matcher.clearFileAndLine() }
        return invocations.filter { MethodType.compareParameters(lhs: $0, rhs: method, matcher: matcher).isFullMatch }
    }
    private func matchingCalls(_ method: Verify, file: StaticString?, line: UInt?) -> Int {
        return matchingCalls(method.method, file: file, line: line).count
    }
    private func givenGetterValue<T>(_ method: MethodType, _ message: String) -> T {
        do {
            return try methodReturnValue(method).casted()
        } catch {
            onFatalFailure(message)
            Failure(message)
        }
    }
    private func optionalGivenGetterValue<T>(_ method: MethodType, _ message: String) -> T? {
        do {
            return try methodReturnValue(method).casted()
        } catch {
            return nil
        }
    }
    private func onFatalFailure(_ message: String) {
        guard let file = self.file, let line = self.line else { return } // Let if fail if cannot handle gratefully
        SwiftyMockyTestObserver.handleFatalError(message: message, file: file, line: line)
    }
}

// MARK: - DiscussionRouter
@MainActor
open class DiscussionRouterMock: DiscussionRouter, Mock {
    public init(sequencing sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst, stubbing stubbingPolicy: StubbingPolicy = .wrap, file: StaticString = #file, line: UInt = #line) {
        SwiftyMockyTestObserver.setup()
        self.sequencingPolicy = sequencingPolicy
        self.stubbingPolicy = stubbingPolicy
        self.file = file
        self.line = line
    }

    var matcher: Matcher = Matcher.default
    var stubbingPolicy: StubbingPolicy = .wrap
    var sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst

    private var queue = DispatchQueue(label: "com.swiftymocky.invocations", qos: .userInteractive)
    private var invocations: [MethodType] = []
    private var methodReturnValues: [Given] = []
    private var methodPerformValues: [Perform] = []
    private var file: StaticString?
    private var line: UInt?

    public typealias PropertyStub = Given
    public typealias MethodStub = Given
    public typealias SubscriptStub = Given

    /// Convenience method - call setupMock() to extend debug information when failure occurs
    public func setupMock(file: StaticString = #file, line: UInt = #line) {
        self.file = file
        self.line = line
    }

    /// Clear mock internals. You can specify what to reset (invocations aka verify, givens or performs) or leave it empty to clear all mock internals
    public func resetMock(_ scopes: MockScope...) {
        let scopes: [MockScope] = scopes.isEmpty ? [.invocation, .given, .perform] : scopes
        if scopes.contains(.invocation) { invocations = [] }
        if scopes.contains(.given) { methodReturnValues = [] }
        if scopes.contains(.perform) { methodPerformValues = [] }
    }





    open func showUserDetails(username: String) {
        addInvocation(.m_showUserDetails__username_username(Parameter<String>.value(`username`)))
		let perform = methodPerformValue(.m_showUserDetails__username_username(Parameter<String>.value(`username`))) as? (String) -> Void
		perform?(`username`)
    }

    open func showThreads(courseID: String, topics: Topics, title: String, type: ThreadType, isBlackedOut: Bool, animated: Bool) {
        addInvocation(.m_showThreads__courseID_courseIDtopics_topicstitle_titletype_typeisBlackedOut_isBlackedOutanimated_animated(Parameter<String>.value(`courseID`), Parameter<Topics>.value(`topics`), Parameter<String>.value(`title`), Parameter<ThreadType>.value(`type`), Parameter<Bool>.value(`isBlackedOut`), Parameter<Bool>.value(`animated`)))
		let perform = methodPerformValue(.m_showThreads__courseID_courseIDtopics_topicstitle_titletype_typeisBlackedOut_isBlackedOutanimated_animated(Parameter<String>.value(`courseID`), Parameter<Topics>.value(`topics`), Parameter<String>.value(`title`), Parameter<ThreadType>.value(`type`), Parameter<Bool>.value(`isBlackedOut`), Parameter<Bool>.value(`animated`))) as? (String, Topics, String, ThreadType, Bool, Bool) -> Void
		perform?(`courseID`, `topics`, `title`, `type`, `isBlackedOut`, `animated`)
    }

    open func showThread(thread: UserThread, postStateSubject: CurrentValueSubject<PostState?, Never>, isBlackedOut: Bool, animated: Bool) {
        addInvocation(.m_showThread__thread_threadpostStateSubject_postStateSubjectisBlackedOut_isBlackedOutanimated_animated(Parameter<UserThread>.value(`thread`), Parameter<CurrentValueSubject<PostState?, Never>>.value(`postStateSubject`), Parameter<Bool>.value(`isBlackedOut`), Parameter<Bool>.value(`animated`)))
		let perform = methodPerformValue(.m_showThread__thread_threadpostStateSubject_postStateSubjectisBlackedOut_isBlackedOutanimated_animated(Parameter<UserThread>.value(`thread`), Parameter<CurrentValueSubject<PostState?, Never>>.value(`postStateSubject`), Parameter<Bool>.value(`isBlackedOut`), Parameter<Bool>.value(`animated`))) as? (UserThread, CurrentValueSubject<PostState?, Never>, Bool, Bool) -> Void
		perform?(`thread`, `postStateSubject`, `isBlackedOut`, `animated`)
    }

    open func showDiscussionsSearch(courseID: String, isBlackedOut: Bool) {
        addInvocation(.m_showDiscussionsSearch__courseID_courseIDisBlackedOut_isBlackedOut(Parameter<String>.value(`courseID`), Parameter<Bool>.value(`isBlackedOut`)))
		let perform = methodPerformValue(.m_showDiscussionsSearch__courseID_courseIDisBlackedOut_isBlackedOut(Parameter<String>.value(`courseID`), Parameter<Bool>.value(`isBlackedOut`))) as? (String, Bool) -> Void
		perform?(`courseID`, `isBlackedOut`)
    }

    open func showComments(courseID: String, commentID: String, parentComment: Post, threadStateSubject: CurrentValueSubject<ThreadPostState?, Never>, isBlackedOut: Bool, animated: Bool) {
        addInvocation(.m_showComments__courseID_courseIDcommentID_commentIDparentComment_parentCommentthreadStateSubject_threadStateSubjectisBlackedOut_isBlackedOutanimated_animated(Parameter<String>.value(`courseID`), Parameter<String>.value(`commentID`), Parameter<Post>.value(`parentComment`), Parameter<CurrentValueSubject<ThreadPostState?, Never>>.value(`threadStateSubject`), Parameter<Bool>.value(`isBlackedOut`), Parameter<Bool>.value(`animated`)))
		let perform = methodPerformValue(.m_showComments__courseID_courseIDcommentID_commentIDparentComment_parentCommentthreadStateSubject_threadStateSubjectisBlackedOut_isBlackedOutanimated_animated(Parameter<String>.value(`courseID`), Parameter<String>.value(`commentID`), Parameter<Post>.value(`parentComment`), Parameter<CurrentValueSubject<ThreadPostState?, Never>>.value(`threadStateSubject`), Parameter<Bool>.value(`isBlackedOut`), Parameter<Bool>.value(`animated`))) as? (String, String, Post, CurrentValueSubject<ThreadPostState?, Never>, Bool, Bool) -> Void
		perform?(`courseID`, `commentID`, `parentComment`, `threadStateSubject`, `isBlackedOut`, `animated`)
    }

    open func createNewThread(courseID: String, selectedTopic: String, onPostCreated: @escaping () -> Void) {
        addInvocation(.m_createNewThread__courseID_courseIDselectedTopic_selectedTopiconPostCreated_onPostCreated(Parameter<String>.value(`courseID`), Parameter<String>.value(`selectedTopic`), Parameter<() -> Void>.value(`onPostCreated`)))
		let perform = methodPerformValue(.m_createNewThread__courseID_courseIDselectedTopic_selectedTopiconPostCreated_onPostCreated(Parameter<String>.value(`courseID`), Parameter<String>.value(`selectedTopic`), Parameter<() -> Void>.value(`onPostCreated`))) as? (String, String, @escaping () -> Void) -> Void
		perform?(`courseID`, `selectedTopic`, `onPostCreated`)
    }

    open func backToRoot(animated: Bool) {
        addInvocation(.m_backToRoot__animated_animated(Parameter<Bool>.value(`animated`)))
		let perform = methodPerformValue(.m_backToRoot__animated_animated(Parameter<Bool>.value(`animated`))) as? (Bool) -> Void
		perform?(`animated`)
    }

    open func back(animated: Bool) {
        addInvocation(.m_back__animated_animated(Parameter<Bool>.value(`animated`)))
		let perform = methodPerformValue(.m_back__animated_animated(Parameter<Bool>.value(`animated`))) as? (Bool) -> Void
		perform?(`animated`)
    }

    open func backWithFade() {
        addInvocation(.m_backWithFade)
		let perform = methodPerformValue(.m_backWithFade) as? () -> Void
		perform?()
    }

    open func dismiss(animated: Bool) {
        addInvocation(.m_dismiss__animated_animated(Parameter<Bool>.value(`animated`)))
		let perform = methodPerformValue(.m_dismiss__animated_animated(Parameter<Bool>.value(`animated`))) as? (Bool) -> Void
		perform?(`animated`)
    }

    open func removeLastView(controllers: Int) {
        addInvocation(.m_removeLastView__controllers_controllers(Parameter<Int>.value(`controllers`)))
		let perform = methodPerformValue(.m_removeLastView__controllers_controllers(Parameter<Int>.value(`controllers`))) as? (Int) -> Void
		perform?(`controllers`)
    }

    open func showMainOrWhatsNewScreen(sourceScreen: LogistrationSourceScreen, postLoginData: PostLoginData?) {
        addInvocation(.m_showMainOrWhatsNewScreen__sourceScreen_sourceScreenpostLoginData_postLoginData(Parameter<LogistrationSourceScreen>.value(`sourceScreen`), Parameter<PostLoginData?>.value(`postLoginData`)))
		let perform = methodPerformValue(.m_showMainOrWhatsNewScreen__sourceScreen_sourceScreenpostLoginData_postLoginData(Parameter<LogistrationSourceScreen>.value(`sourceScreen`), Parameter<PostLoginData?>.value(`postLoginData`))) as? (LogistrationSourceScreen, PostLoginData?) -> Void
		perform?(`sourceScreen`, `postLoginData`)
    }

    open func showStartupScreen() {
        addInvocation(.m_showStartupScreen)
		let perform = methodPerformValue(.m_showStartupScreen) as? () -> Void
		perform?()
    }

    open func showLoginScreen(sourceScreen: LogistrationSourceScreen) {
        addInvocation(.m_showLoginScreen__sourceScreen_sourceScreen(Parameter<LogistrationSourceScreen>.value(`sourceScreen`)))
		let perform = methodPerformValue(.m_showLoginScreen__sourceScreen_sourceScreen(Parameter<LogistrationSourceScreen>.value(`sourceScreen`))) as? (LogistrationSourceScreen) -> Void
		perform?(`sourceScreen`)
    }

    open func showRegisterScreen(sourceScreen: LogistrationSourceScreen) {
        addInvocation(.m_showRegisterScreen__sourceScreen_sourceScreen(Parameter<LogistrationSourceScreen>.value(`sourceScreen`)))
		let perform = methodPerformValue(.m_showRegisterScreen__sourceScreen_sourceScreen(Parameter<LogistrationSourceScreen>.value(`sourceScreen`))) as? (LogistrationSourceScreen) -> Void
		perform?(`sourceScreen`)
    }

    open func showForgotPasswordScreen() {
        addInvocation(.m_showForgotPasswordScreen)
		let perform = methodPerformValue(.m_showForgotPasswordScreen) as? () -> Void
		perform?()
    }

    open func showDiscoveryScreen(searchQuery: String?, sourceScreen: LogistrationSourceScreen) {
        addInvocation(.m_showDiscoveryScreen__searchQuery_searchQuerysourceScreen_sourceScreen(Parameter<String?>.value(`searchQuery`), Parameter<LogistrationSourceScreen>.value(`sourceScreen`)))
		let perform = methodPerformValue(.m_showDiscoveryScreen__searchQuery_searchQuerysourceScreen_sourceScreen(Parameter<String?>.value(`searchQuery`), Parameter<LogistrationSourceScreen>.value(`sourceScreen`))) as? (String?, LogistrationSourceScreen) -> Void
		perform?(`searchQuery`, `sourceScreen`)
    }

    open func showWebBrowser(title: String, url: URL) {
        addInvocation(.m_showWebBrowser__title_titleurl_url(Parameter<String>.value(`title`), Parameter<URL>.value(`url`)))
		let perform = methodPerformValue(.m_showWebBrowser__title_titleurl_url(Parameter<String>.value(`title`), Parameter<URL>.value(`url`))) as? (String, URL) -> Void
		perform?(`title`, `url`)
    }

    open func showSSOWebBrowser(title: String) {
        addInvocation(.m_showSSOWebBrowser__title_title(Parameter<String>.value(`title`)))
		let perform = methodPerformValue(.m_showSSOWebBrowser__title_title(Parameter<String>.value(`title`))) as? (String) -> Void
		perform?(`title`)
    }

    open func presentAlert(alertTitle: String, alertMessage: String, positiveAction: String, onCloseTapped: @escaping () -> Void, firstButtonTapped: @escaping () -> Void, type: AlertViewType) {
        addInvocation(.m_presentAlert__alertTitle_alertTitlealertMessage_alertMessagepositiveAction_positiveActiononCloseTapped_onCloseTappedfirstButtonTapped_firstButtonTappedtype_type(Parameter<String>.value(`alertTitle`), Parameter<String>.value(`alertMessage`), Parameter<String>.value(`positiveAction`), Parameter<() -> Void>.value(`onCloseTapped`), Parameter<() -> Void>.value(`firstButtonTapped`), Parameter<AlertViewType>.value(`type`)))
		let perform = methodPerformValue(.m_presentAlert__alertTitle_alertTitlealertMessage_alertMessagepositiveAction_positiveActiononCloseTapped_onCloseTappedfirstButtonTapped_firstButtonTappedtype_type(Parameter<String>.value(`alertTitle`), Parameter<String>.value(`alertMessage`), Parameter<String>.value(`positiveAction`), Parameter<() -> Void>.value(`onCloseTapped`), Parameter<() -> Void>.value(`firstButtonTapped`), Parameter<AlertViewType>.value(`type`))) as? (String, String, String, @escaping () -> Void, @escaping () -> Void, AlertViewType) -> Void
		perform?(`alertTitle`, `alertMessage`, `positiveAction`, `onCloseTapped`, `firstButtonTapped`, `type`)
    }

    open func presentAlert(alertTitle: String, alertMessage: String, nextSectionName: String?, action: String, image: SwiftUI.Image, onCloseTapped: @escaping () -> Void, firstButtonTapped: @escaping () -> Void, nextSectionTapped: @escaping () -> Void) {
        addInvocation(.m_presentAlert__alertTitle_alertTitlealertMessage_alertMessagenextSectionName_nextSectionNameaction_actionimage_imageonCloseTapped_onCloseTappedfirstButtonTapped_firstButtonTappednextSectionTapped_nextSectionTapped(Parameter<String>.value(`alertTitle`), Parameter<String>.value(`alertMessage`), Parameter<String?>.value(`nextSectionName`), Parameter<String>.value(`action`), Parameter<SwiftUI.Image>.value(`image`), Parameter<() -> Void>.value(`onCloseTapped`), Parameter<() -> Void>.value(`firstButtonTapped`), Parameter<() -> Void>.value(`nextSectionTapped`)))
		let perform = methodPerformValue(.m_presentAlert__alertTitle_alertTitlealertMessage_alertMessagenextSectionName_nextSectionNameaction_actionimage_imageonCloseTapped_onCloseTappedfirstButtonTapped_firstButtonTappednextSectionTapped_nextSectionTapped(Parameter<String>.value(`alertTitle`), Parameter<String>.value(`alertMessage`), Parameter<String?>.value(`nextSectionName`), Parameter<String>.value(`action`), Parameter<SwiftUI.Image>.value(`image`), Parameter<() -> Void>.value(`onCloseTapped`), Parameter<() -> Void>.value(`firstButtonTapped`), Parameter<() -> Void>.value(`nextSectionTapped`))) as? (String, String, String?, String, SwiftUI.Image, @escaping () -> Void, @escaping () -> Void, @escaping () -> Void) -> Void
		perform?(`alertTitle`, `alertMessage`, `nextSectionName`, `action`, `image`, `onCloseTapped`, `firstButtonTapped`, `nextSectionTapped`)
    }

    open func presentView(transitionStyle: UIModalTransitionStyle, view: any View, completion: (() -> Void)?) {
        addInvocation(.m_presentView__transitionStyle_transitionStyleview_viewcompletion_completion(Parameter<UIModalTransitionStyle>.value(`transitionStyle`), Parameter<any View>.value(`view`), Parameter<(() -> Void)?>.value(`completion`)))
		let perform = methodPerformValue(.m_presentView__transitionStyle_transitionStyleview_viewcompletion_completion(Parameter<UIModalTransitionStyle>.value(`transitionStyle`), Parameter<any View>.value(`view`), Parameter<(() -> Void)?>.value(`completion`))) as? (UIModalTransitionStyle, any View, (() -> Void)?) -> Void
		perform?(`transitionStyle`, `view`, `completion`)
    }

    open func presentView(transitionStyle: UIModalTransitionStyle, animated: Bool, content: () -> any View) {
        addInvocation(.m_presentView__transitionStyle_transitionStyleanimated_animatedcontent_content(Parameter<UIModalTransitionStyle>.value(`transitionStyle`), Parameter<Bool>.value(`animated`), Parameter<() -> any View>.any))
		let perform = methodPerformValue(.m_presentView__transitionStyle_transitionStyleanimated_animatedcontent_content(Parameter<UIModalTransitionStyle>.value(`transitionStyle`), Parameter<Bool>.value(`animated`), Parameter<() -> any View>.any)) as? (UIModalTransitionStyle, Bool, () -> any View) -> Void
		perform?(`transitionStyle`, `animated`, `content`)
    }


    fileprivate enum MethodType {
        case m_showUserDetails__username_username(Parameter<String>)
        case m_showThreads__courseID_courseIDtopics_topicstitle_titletype_typeisBlackedOut_isBlackedOutanimated_animated(Parameter<String>, Parameter<Topics>, Parameter<String>, Parameter<ThreadType>, Parameter<Bool>, Parameter<Bool>)
        case m_showThread__thread_threadpostStateSubject_postStateSubjectisBlackedOut_isBlackedOutanimated_animated(Parameter<UserThread>, Parameter<CurrentValueSubject<PostState?, Never>>, Parameter<Bool>, Parameter<Bool>)
        case m_showDiscussionsSearch__courseID_courseIDisBlackedOut_isBlackedOut(Parameter<String>, Parameter<Bool>)
        case m_showComments__courseID_courseIDcommentID_commentIDparentComment_parentCommentthreadStateSubject_threadStateSubjectisBlackedOut_isBlackedOutanimated_animated(Parameter<String>, Parameter<String>, Parameter<Post>, Parameter<CurrentValueSubject<ThreadPostState?, Never>>, Parameter<Bool>, Parameter<Bool>)
        case m_createNewThread__courseID_courseIDselectedTopic_selectedTopiconPostCreated_onPostCreated(Parameter<String>, Parameter<String>, Parameter<() -> Void>)
        case m_backToRoot__animated_animated(Parameter<Bool>)
        case m_back__animated_animated(Parameter<Bool>)
        case m_backWithFade
        case m_dismiss__animated_animated(Parameter<Bool>)
        case m_removeLastView__controllers_controllers(Parameter<Int>)
        case m_showMainOrWhatsNewScreen__sourceScreen_sourceScreenpostLoginData_postLoginData(Parameter<LogistrationSourceScreen>, Parameter<PostLoginData?>)
        case m_showStartupScreen
        case m_showLoginScreen__sourceScreen_sourceScreen(Parameter<LogistrationSourceScreen>)
        case m_showRegisterScreen__sourceScreen_sourceScreen(Parameter<LogistrationSourceScreen>)
        case m_showForgotPasswordScreen
        case m_showDiscoveryScreen__searchQuery_searchQuerysourceScreen_sourceScreen(Parameter<String?>, Parameter<LogistrationSourceScreen>)
        case m_showWebBrowser__title_titleurl_url(Parameter<String>, Parameter<URL>)
        case m_showSSOWebBrowser__title_title(Parameter<String>)
        case m_presentAlert__alertTitle_alertTitlealertMessage_alertMessagepositiveAction_positiveActiononCloseTapped_onCloseTappedfirstButtonTapped_firstButtonTappedtype_type(Parameter<String>, Parameter<String>, Parameter<String>, Parameter<() -> Void>, Parameter<() -> Void>, Parameter<AlertViewType>)
        case m_presentAlert__alertTitle_alertTitlealertMessage_alertMessagenextSectionName_nextSectionNameaction_actionimage_imageonCloseTapped_onCloseTappedfirstButtonTapped_firstButtonTappednextSectionTapped_nextSectionTapped(Parameter<String>, Parameter<String>, Parameter<String?>, Parameter<String>, Parameter<SwiftUI.Image>, Parameter<() -> Void>, Parameter<() -> Void>, Parameter<() -> Void>)
        case m_presentView__transitionStyle_transitionStyleview_viewcompletion_completion(Parameter<UIModalTransitionStyle>, Parameter<any View>, Parameter<(() -> Void)?>)
        case m_presentView__transitionStyle_transitionStyleanimated_animatedcontent_content(Parameter<UIModalTransitionStyle>, Parameter<Bool>, Parameter<() -> any View>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_showUserDetails__username_username(let lhsUsername), .m_showUserDetails__username_username(let rhsUsername)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsUsername, rhs: rhsUsername, with: matcher), lhsUsername, rhsUsername, "username"))
				return Matcher.ComparisonResult(results)

            case (.m_showThreads__courseID_courseIDtopics_topicstitle_titletype_typeisBlackedOut_isBlackedOutanimated_animated(let lhsCourseid, let lhsTopics, let lhsTitle, let lhsType, let lhsIsblackedout, let lhsAnimated), .m_showThreads__courseID_courseIDtopics_topicstitle_titletype_typeisBlackedOut_isBlackedOutanimated_animated(let rhsCourseid, let rhsTopics, let rhsTitle, let rhsType, let rhsIsblackedout, let rhsAnimated)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseID"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsTopics, rhs: rhsTopics, with: matcher), lhsTopics, rhsTopics, "topics"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsTitle, rhs: rhsTitle, with: matcher), lhsTitle, rhsTitle, "title"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsType, rhs: rhsType, with: matcher), lhsType, rhsType, "type"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsIsblackedout, rhs: rhsIsblackedout, with: matcher), lhsIsblackedout, rhsIsblackedout, "isBlackedOut"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsAnimated, rhs: rhsAnimated, with: matcher), lhsAnimated, rhsAnimated, "animated"))
				return Matcher.ComparisonResult(results)

            case (.m_showThread__thread_threadpostStateSubject_postStateSubjectisBlackedOut_isBlackedOutanimated_animated(let lhsThread, let lhsPoststatesubject, let lhsIsblackedout, let lhsAnimated), .m_showThread__thread_threadpostStateSubject_postStateSubjectisBlackedOut_isBlackedOutanimated_animated(let rhsThread, let rhsPoststatesubject, let rhsIsblackedout, let rhsAnimated)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsThread, rhs: rhsThread, with: matcher), lhsThread, rhsThread, "thread"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsPoststatesubject, rhs: rhsPoststatesubject, with: matcher), lhsPoststatesubject, rhsPoststatesubject, "postStateSubject"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsIsblackedout, rhs: rhsIsblackedout, with: matcher), lhsIsblackedout, rhsIsblackedout, "isBlackedOut"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsAnimated, rhs: rhsAnimated, with: matcher), lhsAnimated, rhsAnimated, "animated"))
				return Matcher.ComparisonResult(results)

            case (.m_showDiscussionsSearch__courseID_courseIDisBlackedOut_isBlackedOut(let lhsCourseid, let lhsIsblackedout), .m_showDiscussionsSearch__courseID_courseIDisBlackedOut_isBlackedOut(let rhsCourseid, let rhsIsblackedout)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseID"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsIsblackedout, rhs: rhsIsblackedout, with: matcher), lhsIsblackedout, rhsIsblackedout, "isBlackedOut"))
				return Matcher.ComparisonResult(results)

            case (.m_showComments__courseID_courseIDcommentID_commentIDparentComment_parentCommentthreadStateSubject_threadStateSubjectisBlackedOut_isBlackedOutanimated_animated(let lhsCourseid, let lhsCommentid, let lhsParentcomment, let lhsThreadstatesubject, let lhsIsblackedout, let lhsAnimated), .m_showComments__courseID_courseIDcommentID_commentIDparentComment_parentCommentthreadStateSubject_threadStateSubjectisBlackedOut_isBlackedOutanimated_animated(let rhsCourseid, let rhsCommentid, let rhsParentcomment, let rhsThreadstatesubject, let rhsIsblackedout, let rhsAnimated)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseID"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCommentid, rhs: rhsCommentid, with: matcher), lhsCommentid, rhsCommentid, "commentID"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsParentcomment, rhs: rhsParentcomment, with: matcher), lhsParentcomment, rhsParentcomment, "parentComment"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsThreadstatesubject, rhs: rhsThreadstatesubject, with: matcher), lhsThreadstatesubject, rhsThreadstatesubject, "threadStateSubject"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsIsblackedout, rhs: rhsIsblackedout, with: matcher), lhsIsblackedout, rhsIsblackedout, "isBlackedOut"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsAnimated, rhs: rhsAnimated, with: matcher), lhsAnimated, rhsAnimated, "animated"))
				return Matcher.ComparisonResult(results)

            case (.m_createNewThread__courseID_courseIDselectedTopic_selectedTopiconPostCreated_onPostCreated(let lhsCourseid, let lhsSelectedtopic, let lhsOnpostcreated), .m_createNewThread__courseID_courseIDselectedTopic_selectedTopiconPostCreated_onPostCreated(let rhsCourseid, let rhsSelectedtopic, let rhsOnpostcreated)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseID"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsSelectedtopic, rhs: rhsSelectedtopic, with: matcher), lhsSelectedtopic, rhsSelectedtopic, "selectedTopic"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsOnpostcreated, rhs: rhsOnpostcreated, with: matcher), lhsOnpostcreated, rhsOnpostcreated, "onPostCreated"))
				return Matcher.ComparisonResult(results)

            case (.m_backToRoot__animated_animated(let lhsAnimated), .m_backToRoot__animated_animated(let rhsAnimated)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsAnimated, rhs: rhsAnimated, with: matcher), lhsAnimated, rhsAnimated, "animated"))
				return Matcher.ComparisonResult(results)

            case (.m_back__animated_animated(let lhsAnimated), .m_back__animated_animated(let rhsAnimated)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsAnimated, rhs: rhsAnimated, with: matcher), lhsAnimated, rhsAnimated, "animated"))
				return Matcher.ComparisonResult(results)

            case (.m_backWithFade, .m_backWithFade): return .match

            case (.m_dismiss__animated_animated(let lhsAnimated), .m_dismiss__animated_animated(let rhsAnimated)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsAnimated, rhs: rhsAnimated, with: matcher), lhsAnimated, rhsAnimated, "animated"))
				return Matcher.ComparisonResult(results)

            case (.m_removeLastView__controllers_controllers(let lhsControllers), .m_removeLastView__controllers_controllers(let rhsControllers)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsControllers, rhs: rhsControllers, with: matcher), lhsControllers, rhsControllers, "controllers"))
				return Matcher.ComparisonResult(results)

            case (.m_showMainOrWhatsNewScreen__sourceScreen_sourceScreenpostLoginData_postLoginData(let lhsSourcescreen, let lhsPostlogindata), .m_showMainOrWhatsNewScreen__sourceScreen_sourceScreenpostLoginData_postLoginData(let rhsSourcescreen, let rhsPostlogindata)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsSourcescreen, rhs: rhsSourcescreen, with: matcher), lhsSourcescreen, rhsSourcescreen, "sourceScreen"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsPostlogindata, rhs: rhsPostlogindata, with: matcher), lhsPostlogindata, rhsPostlogindata, "postLoginData"))
				return Matcher.ComparisonResult(results)

            case (.m_showStartupScreen, .m_showStartupScreen): return .match

            case (.m_showLoginScreen__sourceScreen_sourceScreen(let lhsSourcescreen), .m_showLoginScreen__sourceScreen_sourceScreen(let rhsSourcescreen)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsSourcescreen, rhs: rhsSourcescreen, with: matcher), lhsSourcescreen, rhsSourcescreen, "sourceScreen"))
				return Matcher.ComparisonResult(results)

            case (.m_showRegisterScreen__sourceScreen_sourceScreen(let lhsSourcescreen), .m_showRegisterScreen__sourceScreen_sourceScreen(let rhsSourcescreen)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsSourcescreen, rhs: rhsSourcescreen, with: matcher), lhsSourcescreen, rhsSourcescreen, "sourceScreen"))
				return Matcher.ComparisonResult(results)

            case (.m_showForgotPasswordScreen, .m_showForgotPasswordScreen): return .match

            case (.m_showDiscoveryScreen__searchQuery_searchQuerysourceScreen_sourceScreen(let lhsSearchquery, let lhsSourcescreen), .m_showDiscoveryScreen__searchQuery_searchQuerysourceScreen_sourceScreen(let rhsSearchquery, let rhsSourcescreen)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsSearchquery, rhs: rhsSearchquery, with: matcher), lhsSearchquery, rhsSearchquery, "searchQuery"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsSourcescreen, rhs: rhsSourcescreen, with: matcher), lhsSourcescreen, rhsSourcescreen, "sourceScreen"))
				return Matcher.ComparisonResult(results)

            case (.m_showWebBrowser__title_titleurl_url(let lhsTitle, let lhsUrl), .m_showWebBrowser__title_titleurl_url(let rhsTitle, let rhsUrl)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsTitle, rhs: rhsTitle, with: matcher), lhsTitle, rhsTitle, "title"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsUrl, rhs: rhsUrl, with: matcher), lhsUrl, rhsUrl, "url"))
				return Matcher.ComparisonResult(results)

            case (.m_showSSOWebBrowser__title_title(let lhsTitle), .m_showSSOWebBrowser__title_title(let rhsTitle)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsTitle, rhs: rhsTitle, with: matcher), lhsTitle, rhsTitle, "title"))
				return Matcher.ComparisonResult(results)

            case (.m_presentAlert__alertTitle_alertTitlealertMessage_alertMessagepositiveAction_positiveActiononCloseTapped_onCloseTappedfirstButtonTapped_firstButtonTappedtype_type(let lhsAlerttitle, let lhsAlertmessage, let lhsPositiveaction, let lhsOnclosetapped, let lhsFirstbuttontapped, let lhsType), .m_presentAlert__alertTitle_alertTitlealertMessage_alertMessagepositiveAction_positiveActiononCloseTapped_onCloseTappedfirstButtonTapped_firstButtonTappedtype_type(let rhsAlerttitle, let rhsAlertmessage, let rhsPositiveaction, let rhsOnclosetapped, let rhsFirstbuttontapped, let rhsType)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsAlerttitle, rhs: rhsAlerttitle, with: matcher), lhsAlerttitle, rhsAlerttitle, "alertTitle"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsAlertmessage, rhs: rhsAlertmessage, with: matcher), lhsAlertmessage, rhsAlertmessage, "alertMessage"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsPositiveaction, rhs: rhsPositiveaction, with: matcher), lhsPositiveaction, rhsPositiveaction, "positiveAction"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsOnclosetapped, rhs: rhsOnclosetapped, with: matcher), lhsOnclosetapped, rhsOnclosetapped, "onCloseTapped"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsFirstbuttontapped, rhs: rhsFirstbuttontapped, with: matcher), lhsFirstbuttontapped, rhsFirstbuttontapped, "firstButtonTapped"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsType, rhs: rhsType, with: matcher), lhsType, rhsType, "type"))
				return Matcher.ComparisonResult(results)

            case (.m_presentAlert__alertTitle_alertTitlealertMessage_alertMessagenextSectionName_nextSectionNameaction_actionimage_imageonCloseTapped_onCloseTappedfirstButtonTapped_firstButtonTappednextSectionTapped_nextSectionTapped(let lhsAlerttitle, let lhsAlertmessage, let lhsNextsectionname, let lhsAction, let lhsImage, let lhsOnclosetapped, let lhsFirstbuttontapped, let lhsNextsectiontapped), .m_presentAlert__alertTitle_alertTitlealertMessage_alertMessagenextSectionName_nextSectionNameaction_actionimage_imageonCloseTapped_onCloseTappedfirstButtonTapped_firstButtonTappednextSectionTapped_nextSectionTapped(let rhsAlerttitle, let rhsAlertmessage, let rhsNextsectionname, let rhsAction, let rhsImage, let rhsOnclosetapped, let rhsFirstbuttontapped, let rhsNextsectiontapped)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsAlerttitle, rhs: rhsAlerttitle, with: matcher), lhsAlerttitle, rhsAlerttitle, "alertTitle"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsAlertmessage, rhs: rhsAlertmessage, with: matcher), lhsAlertmessage, rhsAlertmessage, "alertMessage"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsNextsectionname, rhs: rhsNextsectionname, with: matcher), lhsNextsectionname, rhsNextsectionname, "nextSectionName"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsAction, rhs: rhsAction, with: matcher), lhsAction, rhsAction, "action"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsImage, rhs: rhsImage, with: matcher), lhsImage, rhsImage, "image"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsOnclosetapped, rhs: rhsOnclosetapped, with: matcher), lhsOnclosetapped, rhsOnclosetapped, "onCloseTapped"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsFirstbuttontapped, rhs: rhsFirstbuttontapped, with: matcher), lhsFirstbuttontapped, rhsFirstbuttontapped, "firstButtonTapped"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsNextsectiontapped, rhs: rhsNextsectiontapped, with: matcher), lhsNextsectiontapped, rhsNextsectiontapped, "nextSectionTapped"))
				return Matcher.ComparisonResult(results)

            case (.m_presentView__transitionStyle_transitionStyleview_viewcompletion_completion(let lhsTransitionstyle, let lhsView, let lhsCompletion), .m_presentView__transitionStyle_transitionStyleview_viewcompletion_completion(let rhsTransitionstyle, let rhsView, let rhsCompletion)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsTransitionstyle, rhs: rhsTransitionstyle, with: matcher), lhsTransitionstyle, rhsTransitionstyle, "transitionStyle"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsView, rhs: rhsView, with: matcher), lhsView, rhsView, "view"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCompletion, rhs: rhsCompletion, with: matcher), lhsCompletion, rhsCompletion, "completion"))
				return Matcher.ComparisonResult(results)

            case (.m_presentView__transitionStyle_transitionStyleanimated_animatedcontent_content(let lhsTransitionstyle, let lhsAnimated, let lhsContent), .m_presentView__transitionStyle_transitionStyleanimated_animatedcontent_content(let rhsTransitionstyle, let rhsAnimated, let rhsContent)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsTransitionstyle, rhs: rhsTransitionstyle, with: matcher), lhsTransitionstyle, rhsTransitionstyle, "transitionStyle"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsAnimated, rhs: rhsAnimated, with: matcher), lhsAnimated, rhsAnimated, "animated"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsContent, rhs: rhsContent, with: matcher), lhsContent, rhsContent, "content"))
				return Matcher.ComparisonResult(results)
            default: return .none
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_showUserDetails__username_username(p0): return p0.intValue
            case let .m_showThreads__courseID_courseIDtopics_topicstitle_titletype_typeisBlackedOut_isBlackedOutanimated_animated(p0, p1, p2, p3, p4, p5): return p0.intValue + p1.intValue + p2.intValue + p3.intValue + p4.intValue + p5.intValue
            case let .m_showThread__thread_threadpostStateSubject_postStateSubjectisBlackedOut_isBlackedOutanimated_animated(p0, p1, p2, p3): return p0.intValue + p1.intValue + p2.intValue + p3.intValue
            case let .m_showDiscussionsSearch__courseID_courseIDisBlackedOut_isBlackedOut(p0, p1): return p0.intValue + p1.intValue
            case let .m_showComments__courseID_courseIDcommentID_commentIDparentComment_parentCommentthreadStateSubject_threadStateSubjectisBlackedOut_isBlackedOutanimated_animated(p0, p1, p2, p3, p4, p5): return p0.intValue + p1.intValue + p2.intValue + p3.intValue + p4.intValue + p5.intValue
            case let .m_createNewThread__courseID_courseIDselectedTopic_selectedTopiconPostCreated_onPostCreated(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
            case let .m_backToRoot__animated_animated(p0): return p0.intValue
            case let .m_back__animated_animated(p0): return p0.intValue
            case .m_backWithFade: return 0
            case let .m_dismiss__animated_animated(p0): return p0.intValue
            case let .m_removeLastView__controllers_controllers(p0): return p0.intValue
            case let .m_showMainOrWhatsNewScreen__sourceScreen_sourceScreenpostLoginData_postLoginData(p0, p1): return p0.intValue + p1.intValue
            case .m_showStartupScreen: return 0
            case let .m_showLoginScreen__sourceScreen_sourceScreen(p0): return p0.intValue
            case let .m_showRegisterScreen__sourceScreen_sourceScreen(p0): return p0.intValue
            case .m_showForgotPasswordScreen: return 0
            case let .m_showDiscoveryScreen__searchQuery_searchQuerysourceScreen_sourceScreen(p0, p1): return p0.intValue + p1.intValue
            case let .m_showWebBrowser__title_titleurl_url(p0, p1): return p0.intValue + p1.intValue
            case let .m_showSSOWebBrowser__title_title(p0): return p0.intValue
            case let .m_presentAlert__alertTitle_alertTitlealertMessage_alertMessagepositiveAction_positiveActiononCloseTapped_onCloseTappedfirstButtonTapped_firstButtonTappedtype_type(p0, p1, p2, p3, p4, p5): return p0.intValue + p1.intValue + p2.intValue + p3.intValue + p4.intValue + p5.intValue
            case let .m_presentAlert__alertTitle_alertTitlealertMessage_alertMessagenextSectionName_nextSectionNameaction_actionimage_imageonCloseTapped_onCloseTappedfirstButtonTapped_firstButtonTappednextSectionTapped_nextSectionTapped(p0, p1, p2, p3, p4, p5, p6, p7): return p0.intValue + p1.intValue + p2.intValue + p3.intValue + p4.intValue + p5.intValue + p6.intValue + p7.intValue
            case let .m_presentView__transitionStyle_transitionStyleview_viewcompletion_completion(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
            case let .m_presentView__transitionStyle_transitionStyleanimated_animatedcontent_content(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_showUserDetails__username_username: return ".showUserDetails(username:)"
            case .m_showThreads__courseID_courseIDtopics_topicstitle_titletype_typeisBlackedOut_isBlackedOutanimated_animated: return ".showThreads(courseID:topics:title:type:isBlackedOut:animated:)"
            case .m_showThread__thread_threadpostStateSubject_postStateSubjectisBlackedOut_isBlackedOutanimated_animated: return ".showThread(thread:postStateSubject:isBlackedOut:animated:)"
            case .m_showDiscussionsSearch__courseID_courseIDisBlackedOut_isBlackedOut: return ".showDiscussionsSearch(courseID:isBlackedOut:)"
            case .m_showComments__courseID_courseIDcommentID_commentIDparentComment_parentCommentthreadStateSubject_threadStateSubjectisBlackedOut_isBlackedOutanimated_animated: return ".showComments(courseID:commentID:parentComment:threadStateSubject:isBlackedOut:animated:)"
            case .m_createNewThread__courseID_courseIDselectedTopic_selectedTopiconPostCreated_onPostCreated: return ".createNewThread(courseID:selectedTopic:onPostCreated:)"
            case .m_backToRoot__animated_animated: return ".backToRoot(animated:)"
            case .m_back__animated_animated: return ".back(animated:)"
            case .m_backWithFade: return ".backWithFade()"
            case .m_dismiss__animated_animated: return ".dismiss(animated:)"
            case .m_removeLastView__controllers_controllers: return ".removeLastView(controllers:)"
            case .m_showMainOrWhatsNewScreen__sourceScreen_sourceScreenpostLoginData_postLoginData: return ".showMainOrWhatsNewScreen(sourceScreen:postLoginData:)"
            case .m_showStartupScreen: return ".showStartupScreen()"
            case .m_showLoginScreen__sourceScreen_sourceScreen: return ".showLoginScreen(sourceScreen:)"
            case .m_showRegisterScreen__sourceScreen_sourceScreen: return ".showRegisterScreen(sourceScreen:)"
            case .m_showForgotPasswordScreen: return ".showForgotPasswordScreen()"
            case .m_showDiscoveryScreen__searchQuery_searchQuerysourceScreen_sourceScreen: return ".showDiscoveryScreen(searchQuery:sourceScreen:)"
            case .m_showWebBrowser__title_titleurl_url: return ".showWebBrowser(title:url:)"
            case .m_showSSOWebBrowser__title_title: return ".showSSOWebBrowser(title:)"
            case .m_presentAlert__alertTitle_alertTitlealertMessage_alertMessagepositiveAction_positiveActiononCloseTapped_onCloseTappedfirstButtonTapped_firstButtonTappedtype_type: return ".presentAlert(alertTitle:alertMessage:positiveAction:onCloseTapped:firstButtonTapped:type:)"
            case .m_presentAlert__alertTitle_alertTitlealertMessage_alertMessagenextSectionName_nextSectionNameaction_actionimage_imageonCloseTapped_onCloseTappedfirstButtonTapped_firstButtonTappednextSectionTapped_nextSectionTapped: return ".presentAlert(alertTitle:alertMessage:nextSectionName:action:image:onCloseTapped:firstButtonTapped:nextSectionTapped:)"
            case .m_presentView__transitionStyle_transitionStyleview_viewcompletion_completion: return ".presentView(transitionStyle:view:completion:)"
            case .m_presentView__transitionStyle_transitionStyleanimated_animatedcontent_content: return ".presentView(transitionStyle:animated:content:)"
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }


    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func showUserDetails(username: Parameter<String>) -> Verify { return Verify(method: .m_showUserDetails__username_username(`username`))}
        public static func showThreads(courseID: Parameter<String>, topics: Parameter<Topics>, title: Parameter<String>, type: Parameter<ThreadType>, isBlackedOut: Parameter<Bool>, animated: Parameter<Bool>) -> Verify { return Verify(method: .m_showThreads__courseID_courseIDtopics_topicstitle_titletype_typeisBlackedOut_isBlackedOutanimated_animated(`courseID`, `topics`, `title`, `type`, `isBlackedOut`, `animated`))}
        public static func showThread(thread: Parameter<UserThread>, postStateSubject: Parameter<CurrentValueSubject<PostState?, Never>>, isBlackedOut: Parameter<Bool>, animated: Parameter<Bool>) -> Verify { return Verify(method: .m_showThread__thread_threadpostStateSubject_postStateSubjectisBlackedOut_isBlackedOutanimated_animated(`thread`, `postStateSubject`, `isBlackedOut`, `animated`))}
        public static func showDiscussionsSearch(courseID: Parameter<String>, isBlackedOut: Parameter<Bool>) -> Verify { return Verify(method: .m_showDiscussionsSearch__courseID_courseIDisBlackedOut_isBlackedOut(`courseID`, `isBlackedOut`))}
        public static func showComments(courseID: Parameter<String>, commentID: Parameter<String>, parentComment: Parameter<Post>, threadStateSubject: Parameter<CurrentValueSubject<ThreadPostState?, Never>>, isBlackedOut: Parameter<Bool>, animated: Parameter<Bool>) -> Verify { return Verify(method: .m_showComments__courseID_courseIDcommentID_commentIDparentComment_parentCommentthreadStateSubject_threadStateSubjectisBlackedOut_isBlackedOutanimated_animated(`courseID`, `commentID`, `parentComment`, `threadStateSubject`, `isBlackedOut`, `animated`))}
        public static func createNewThread(courseID: Parameter<String>, selectedTopic: Parameter<String>, onPostCreated: Parameter<() -> Void>) -> Verify { return Verify(method: .m_createNewThread__courseID_courseIDselectedTopic_selectedTopiconPostCreated_onPostCreated(`courseID`, `selectedTopic`, `onPostCreated`))}
        public static func backToRoot(animated: Parameter<Bool>) -> Verify { return Verify(method: .m_backToRoot__animated_animated(`animated`))}
        public static func back(animated: Parameter<Bool>) -> Verify { return Verify(method: .m_back__animated_animated(`animated`))}
        public static func backWithFade() -> Verify { return Verify(method: .m_backWithFade)}
        public static func dismiss(animated: Parameter<Bool>) -> Verify { return Verify(method: .m_dismiss__animated_animated(`animated`))}
        public static func removeLastView(controllers: Parameter<Int>) -> Verify { return Verify(method: .m_removeLastView__controllers_controllers(`controllers`))}
        public static func showMainOrWhatsNewScreen(sourceScreen: Parameter<LogistrationSourceScreen>, postLoginData: Parameter<PostLoginData?>) -> Verify { return Verify(method: .m_showMainOrWhatsNewScreen__sourceScreen_sourceScreenpostLoginData_postLoginData(`sourceScreen`, `postLoginData`))}
        public static func showStartupScreen() -> Verify { return Verify(method: .m_showStartupScreen)}
        public static func showLoginScreen(sourceScreen: Parameter<LogistrationSourceScreen>) -> Verify { return Verify(method: .m_showLoginScreen__sourceScreen_sourceScreen(`sourceScreen`))}
        public static func showRegisterScreen(sourceScreen: Parameter<LogistrationSourceScreen>) -> Verify { return Verify(method: .m_showRegisterScreen__sourceScreen_sourceScreen(`sourceScreen`))}
        public static func showForgotPasswordScreen() -> Verify { return Verify(method: .m_showForgotPasswordScreen)}
        public static func showDiscoveryScreen(searchQuery: Parameter<String?>, sourceScreen: Parameter<LogistrationSourceScreen>) -> Verify { return Verify(method: .m_showDiscoveryScreen__searchQuery_searchQuerysourceScreen_sourceScreen(`searchQuery`, `sourceScreen`))}
        public static func showWebBrowser(title: Parameter<String>, url: Parameter<URL>) -> Verify { return Verify(method: .m_showWebBrowser__title_titleurl_url(`title`, `url`))}
        public static func showSSOWebBrowser(title: Parameter<String>) -> Verify { return Verify(method: .m_showSSOWebBrowser__title_title(`title`))}
        public static func presentAlert(alertTitle: Parameter<String>, alertMessage: Parameter<String>, positiveAction: Parameter<String>, onCloseTapped: Parameter<() -> Void>, firstButtonTapped: Parameter<() -> Void>, type: Parameter<AlertViewType>) -> Verify { return Verify(method: .m_presentAlert__alertTitle_alertTitlealertMessage_alertMessagepositiveAction_positiveActiononCloseTapped_onCloseTappedfirstButtonTapped_firstButtonTappedtype_type(`alertTitle`, `alertMessage`, `positiveAction`, `onCloseTapped`, `firstButtonTapped`, `type`))}
        public static func presentAlert(alertTitle: Parameter<String>, alertMessage: Parameter<String>, nextSectionName: Parameter<String?>, action: Parameter<String>, image: Parameter<SwiftUI.Image>, onCloseTapped: Parameter<() -> Void>, firstButtonTapped: Parameter<() -> Void>, nextSectionTapped: Parameter<() -> Void>) -> Verify { return Verify(method: .m_presentAlert__alertTitle_alertTitlealertMessage_alertMessagenextSectionName_nextSectionNameaction_actionimage_imageonCloseTapped_onCloseTappedfirstButtonTapped_firstButtonTappednextSectionTapped_nextSectionTapped(`alertTitle`, `alertMessage`, `nextSectionName`, `action`, `image`, `onCloseTapped`, `firstButtonTapped`, `nextSectionTapped`))}
        public static func presentView(transitionStyle: Parameter<UIModalTransitionStyle>, view: Parameter<any View>, completion: Parameter<(() -> Void)?>) -> Verify { return Verify(method: .m_presentView__transitionStyle_transitionStyleview_viewcompletion_completion(`transitionStyle`, `view`, `completion`))}
        public static func presentView(transitionStyle: Parameter<UIModalTransitionStyle>, animated: Parameter<Bool>, content: Parameter<() -> any View>) -> Verify { return Verify(method: .m_presentView__transitionStyle_transitionStyleanimated_animatedcontent_content(`transitionStyle`, `animated`, `content`))}
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func showUserDetails(username: Parameter<String>, perform: @escaping (String) -> Void) -> Perform {
            return Perform(method: .m_showUserDetails__username_username(`username`), performs: perform)
        }
        public static func showThreads(courseID: Parameter<String>, topics: Parameter<Topics>, title: Parameter<String>, type: Parameter<ThreadType>, isBlackedOut: Parameter<Bool>, animated: Parameter<Bool>, perform: @escaping (String, Topics, String, ThreadType, Bool, Bool) -> Void) -> Perform {
            return Perform(method: .m_showThreads__courseID_courseIDtopics_topicstitle_titletype_typeisBlackedOut_isBlackedOutanimated_animated(`courseID`, `topics`, `title`, `type`, `isBlackedOut`, `animated`), performs: perform)
        }
        public static func showThread(thread: Parameter<UserThread>, postStateSubject: Parameter<CurrentValueSubject<PostState?, Never>>, isBlackedOut: Parameter<Bool>, animated: Parameter<Bool>, perform: @escaping (UserThread, CurrentValueSubject<PostState?, Never>, Bool, Bool) -> Void) -> Perform {
            return Perform(method: .m_showThread__thread_threadpostStateSubject_postStateSubjectisBlackedOut_isBlackedOutanimated_animated(`thread`, `postStateSubject`, `isBlackedOut`, `animated`), performs: perform)
        }
        public static func showDiscussionsSearch(courseID: Parameter<String>, isBlackedOut: Parameter<Bool>, perform: @escaping (String, Bool) -> Void) -> Perform {
            return Perform(method: .m_showDiscussionsSearch__courseID_courseIDisBlackedOut_isBlackedOut(`courseID`, `isBlackedOut`), performs: perform)
        }
        public static func showComments(courseID: Parameter<String>, commentID: Parameter<String>, parentComment: Parameter<Post>, threadStateSubject: Parameter<CurrentValueSubject<ThreadPostState?, Never>>, isBlackedOut: Parameter<Bool>, animated: Parameter<Bool>, perform: @escaping (String, String, Post, CurrentValueSubject<ThreadPostState?, Never>, Bool, Bool) -> Void) -> Perform {
            return Perform(method: .m_showComments__courseID_courseIDcommentID_commentIDparentComment_parentCommentthreadStateSubject_threadStateSubjectisBlackedOut_isBlackedOutanimated_animated(`courseID`, `commentID`, `parentComment`, `threadStateSubject`, `isBlackedOut`, `animated`), performs: perform)
        }
        public static func createNewThread(courseID: Parameter<String>, selectedTopic: Parameter<String>, onPostCreated: Parameter<() -> Void>, perform: @escaping (String, String, @escaping () -> Void) -> Void) -> Perform {
            return Perform(method: .m_createNewThread__courseID_courseIDselectedTopic_selectedTopiconPostCreated_onPostCreated(`courseID`, `selectedTopic`, `onPostCreated`), performs: perform)
        }
        public static func backToRoot(animated: Parameter<Bool>, perform: @escaping (Bool) -> Void) -> Perform {
            return Perform(method: .m_backToRoot__animated_animated(`animated`), performs: perform)
        }
        public static func back(animated: Parameter<Bool>, perform: @escaping (Bool) -> Void) -> Perform {
            return Perform(method: .m_back__animated_animated(`animated`), performs: perform)
        }
        public static func backWithFade(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_backWithFade, performs: perform)
        }
        public static func dismiss(animated: Parameter<Bool>, perform: @escaping (Bool) -> Void) -> Perform {
            return Perform(method: .m_dismiss__animated_animated(`animated`), performs: perform)
        }
        public static func removeLastView(controllers: Parameter<Int>, perform: @escaping (Int) -> Void) -> Perform {
            return Perform(method: .m_removeLastView__controllers_controllers(`controllers`), performs: perform)
        }
        public static func showMainOrWhatsNewScreen(sourceScreen: Parameter<LogistrationSourceScreen>, postLoginData: Parameter<PostLoginData?>, perform: @escaping (LogistrationSourceScreen, PostLoginData?) -> Void) -> Perform {
            return Perform(method: .m_showMainOrWhatsNewScreen__sourceScreen_sourceScreenpostLoginData_postLoginData(`sourceScreen`, `postLoginData`), performs: perform)
        }
        public static func showStartupScreen(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_showStartupScreen, performs: perform)
        }
        public static func showLoginScreen(sourceScreen: Parameter<LogistrationSourceScreen>, perform: @escaping (LogistrationSourceScreen) -> Void) -> Perform {
            return Perform(method: .m_showLoginScreen__sourceScreen_sourceScreen(`sourceScreen`), performs: perform)
        }
        public static func showRegisterScreen(sourceScreen: Parameter<LogistrationSourceScreen>, perform: @escaping (LogistrationSourceScreen) -> Void) -> Perform {
            return Perform(method: .m_showRegisterScreen__sourceScreen_sourceScreen(`sourceScreen`), performs: perform)
        }
        public static func showForgotPasswordScreen(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_showForgotPasswordScreen, performs: perform)
        }
        public static func showDiscoveryScreen(searchQuery: Parameter<String?>, sourceScreen: Parameter<LogistrationSourceScreen>, perform: @escaping (String?, LogistrationSourceScreen) -> Void) -> Perform {
            return Perform(method: .m_showDiscoveryScreen__searchQuery_searchQuerysourceScreen_sourceScreen(`searchQuery`, `sourceScreen`), performs: perform)
        }
        public static func showWebBrowser(title: Parameter<String>, url: Parameter<URL>, perform: @escaping (String, URL) -> Void) -> Perform {
            return Perform(method: .m_showWebBrowser__title_titleurl_url(`title`, `url`), performs: perform)
        }
        public static func showSSOWebBrowser(title: Parameter<String>, perform: @escaping (String) -> Void) -> Perform {
            return Perform(method: .m_showSSOWebBrowser__title_title(`title`), performs: perform)
        }
        public static func presentAlert(alertTitle: Parameter<String>, alertMessage: Parameter<String>, positiveAction: Parameter<String>, onCloseTapped: Parameter<() -> Void>, firstButtonTapped: Parameter<() -> Void>, type: Parameter<AlertViewType>, perform: @escaping (String, String, String, @escaping () -> Void, @escaping () -> Void, AlertViewType) -> Void) -> Perform {
            return Perform(method: .m_presentAlert__alertTitle_alertTitlealertMessage_alertMessagepositiveAction_positiveActiononCloseTapped_onCloseTappedfirstButtonTapped_firstButtonTappedtype_type(`alertTitle`, `alertMessage`, `positiveAction`, `onCloseTapped`, `firstButtonTapped`, `type`), performs: perform)
        }
        public static func presentAlert(alertTitle: Parameter<String>, alertMessage: Parameter<String>, nextSectionName: Parameter<String?>, action: Parameter<String>, image: Parameter<SwiftUI.Image>, onCloseTapped: Parameter<() -> Void>, firstButtonTapped: Parameter<() -> Void>, nextSectionTapped: Parameter<() -> Void>, perform: @escaping (String, String, String?, String, SwiftUI.Image, @escaping () -> Void, @escaping () -> Void, @escaping () -> Void) -> Void) -> Perform {
            return Perform(method: .m_presentAlert__alertTitle_alertTitlealertMessage_alertMessagenextSectionName_nextSectionNameaction_actionimage_imageonCloseTapped_onCloseTappedfirstButtonTapped_firstButtonTappednextSectionTapped_nextSectionTapped(`alertTitle`, `alertMessage`, `nextSectionName`, `action`, `image`, `onCloseTapped`, `firstButtonTapped`, `nextSectionTapped`), performs: perform)
        }
        public static func presentView(transitionStyle: Parameter<UIModalTransitionStyle>, view: Parameter<any View>, completion: Parameter<(() -> Void)?>, perform: @escaping (UIModalTransitionStyle, any View, (() -> Void)?) -> Void) -> Perform {
            return Perform(method: .m_presentView__transitionStyle_transitionStyleview_viewcompletion_completion(`transitionStyle`, `view`, `completion`), performs: perform)
        }
        public static func presentView(transitionStyle: Parameter<UIModalTransitionStyle>, animated: Parameter<Bool>, content: Parameter<() -> any View>, perform: @escaping (UIModalTransitionStyle, Bool, () -> any View) -> Void) -> Perform {
            return Perform(method: .m_presentView__transitionStyle_transitionStyleanimated_animatedcontent_content(`transitionStyle`, `animated`, `content`), performs: perform)
        }
    }

    public func given(_ method: Given) {
        methodReturnValues.append(method)
    }

    public func perform(_ method: Perform) {
        methodPerformValues.append(method)
        methodPerformValues.sort { $0.method.intValue() < $1.method.intValue() }
    }

    public func verify(_ method: Verify, count: Count = Count.moreOrEqual(to: 1), file: StaticString = #file, line: UInt = #line) {
        let fullMatches = matchingCalls(method, file: file, line: line)
        let success = count.matches(fullMatches)
        let assertionName = method.method.assertionName()
        let feedback: String = {
            guard !success else { return "" }
            return Utils.closestCallsMessage(
                for: self.invocations.map { invocation in
                    matcher.set(file: file, line: line)
                    defer { matcher.clearFileAndLine() }
                    return MethodType.compareParameters(lhs: invocation, rhs: method.method, matcher: matcher)
                },
                name: assertionName
            )
        }()
        MockyAssert(success, "Expected: \(count) invocations of `\(assertionName)`, but was: \(fullMatches).\(feedback)", file: file, line: line)
    }

    private func addInvocation(_ call: MethodType) {
        self.queue.sync { invocations.append(call) }
    }
    private func methodReturnValue(_ method: MethodType) throws -> StubProduct {
        matcher.set(file: self.file, line: self.line)
        defer { matcher.clearFileAndLine() }
        let candidates = sequencingPolicy.sorted(methodReturnValues, by: { $0.method.intValue() > $1.method.intValue() })
        let matched = candidates.first(where: { $0.isValid && MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher).isFullMatch })
        guard let product = matched?.getProduct(policy: self.stubbingPolicy) else { throw MockError.notStubed }
        return product
    }
    private func methodPerformValue(_ method: MethodType) -> Any? {
        matcher.set(file: self.file, line: self.line)
        defer { matcher.clearFileAndLine() }
        let matched = methodPerformValues.reversed().first { MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher).isFullMatch }
        return matched?.performs
    }
    private func matchingCalls(_ method: MethodType, file: StaticString?, line: UInt?) -> [MethodType] {
        matcher.set(file: file ?? self.file, line: line ?? self.line)
        defer { matcher.clearFileAndLine() }
        return invocations.filter { MethodType.compareParameters(lhs: $0, rhs: method, matcher: matcher).isFullMatch }
    }
    private func matchingCalls(_ method: Verify, file: StaticString?, line: UInt?) -> Int {
        return matchingCalls(method.method, file: file, line: line).count
    }
    private func givenGetterValue<T>(_ method: MethodType, _ message: String) -> T {
        do {
            return try methodReturnValue(method).casted()
        } catch {
            onFatalFailure(message)
            Failure(message)
        }
    }
    private func optionalGivenGetterValue<T>(_ method: MethodType, _ message: String) -> T? {
        do {
            return try methodReturnValue(method).casted()
        } catch {
            return nil
        }
    }
    private func onFatalFailure(_ message: String) {
        guard let file = self.file, let line = self.line else { return } // Let if fail if cannot handle gratefully
        SwiftyMockyTestObserver.handleFatalError(message: message, file: file, line: line)
    }
}

