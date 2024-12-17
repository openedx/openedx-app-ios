//
//  DiscoveryWebviewViewModel.swift
//  Discovery
//
//  Created by SaeedBashir on 12/16/23.
//

import Foundation
import Core
import SwiftUI
import WebKit

@MainActor
public final class DiscoveryWebviewViewModel: ObservableObject {
    @Published var courseDetails: CourseDetails?
    @Published private(set) var showProgress = false
    @Published var showError: Bool = false
    @Published var webViewError: Bool = false

    var errorMessage: String? {
        didSet {
            withAnimation {
                showError = errorMessage != nil
            }
        }
    }
    
    let router: DiscoveryRouter
    let config: ConfigProtocol
    let connectivity: ConnectivityProtocol
    private let interactor: DiscoveryInteractorProtocol
    private let analytics: DiscoveryAnalytics
    var request: URLRequest?
    private let storage: CoreStorage
    var sourceScreen: LogistrationSourceScreen
    
    var userloggedIn: Bool {
        return storage.user?.username?.isEmpty == false
    }
    
    public init(
        router: DiscoveryRouter,
        config: ConfigProtocol,
        interactor: DiscoveryInteractorProtocol,
        connectivity: ConnectivityProtocol,
        analytics: DiscoveryAnalytics,
        storage: CoreStorage,
        sourceScreen: LogistrationSourceScreen = .default
    ) {
        self.router = router
        self.config = config
        self.interactor = interactor
        self.connectivity = connectivity
        self.analytics = analytics
        self.storage = storage
        self.sourceScreen = sourceScreen
    }
    
    @MainActor
    func getCourseDetail(courseID: String) async throws -> CourseDetails? {
        return try await interactor.getCourseDetails(courseID: courseID)
    }
    
    @MainActor
    func enrollTo(courseID: String) async {
        do {
            guard userloggedIn else {
                router.showRegisterScreen(sourceScreen: .discovery)
                return
            }
            
            showProgress = true
            if courseDetails == nil {
                courseDetails = try await getCourseDetail(courseID: courseID)
            }
            
            if courseDetails?.isEnrolled ?? false || courseState == .alreadyEnrolled {
                showProgress = false
                await showCourseDetails()
                return
            }
            
            analytics.courseEnrollClicked(courseId: courseID, courseName: courseDetails?.courseTitle ?? "")
            _ = try await interactor.enrollToCourse(courseID: courseID)
            analytics.courseEnrollSuccess(courseId: courseID, courseName: courseDetails?.courseTitle ?? "")
            courseDetails?.isEnrolled = true
            showProgress = false
            NotificationCenter.default.post(name: .onCourseEnrolled, object: courseID)
            await showCourseDetails()
        } catch let error {
            showProgress = false
            if error.isInternetError || error is NoCachedDataError {
                errorMessage = CoreLocalization.Error.slowOrNoInternetConnection
            } else {
                errorMessage = CoreLocalization.Error.unknownError
            }
        }
    }
    
    private var courseState: CourseState? {
        guard courseDetails?.isEnrolled == false else { return nil }
        
        if let enrollmentStart = courseDetails?.enrollmentStart, let enrollmentEnd = courseDetails?.enrollmentEnd {
            let enrollmentsRange = DateInterval(start: enrollmentStart, end: enrollmentEnd)
            if enrollmentsRange.contains(Date()) {
                return .enrollOpen
            } else {
                return .enrollClose
            }
        } else {
            return .enrollOpen
        }
    }
}

extension DiscoveryWebviewViewModel: WebViewNavigationDelegate {
    @MainActor
    public func webView(
        _ webView: WKWebView,
        shouldLoad request: URLRequest,
        navigationAction: WKNavigationAction
    ) async -> Bool {
        guard let URL = request.url else { return false }
        
        if let urlAction = urlAction(from: URL),
           await handleNavigation(url: URL, urlAction: urlAction) {
            return true
        }
        
        let capturedLink = navigationAction.navigationType == .linkActivated
        let outsideLink = (request.mainDocumentURL?.host != self.request?.url?.host)
        var externalLink = false
        
        if let queryParameters = request.url?.queryParameters,
            let externalLinkValue = queryParameters["external_link"] as? String,
           externalLinkValue.caseInsensitiveCompare("true") == .orderedSame {
            externalLink = true
        }
        
        if let url = request.url, outsideLink || capturedLink || externalLink, UIApplication.shared.canOpenURL(url) {
            analytics.externalLinkOpen(url: url.absoluteString, screen: sourceScreen.value ?? "")
            router.presentAlert(
                alertTitle: DiscoveryLocalization.Alert.leavingAppTitle,
                alertMessage: DiscoveryLocalization.Alert.leavingAppMessage,
                positiveAction: CoreLocalization.Webview.Alert.continue,
                onCloseTapped: { [weak self] in
                    self?.router.dismiss(animated: true)
                    self?.analytics.externalLinkOpenAction(
                        url: url.absoluteString,
                        screen: self?.sourceScreen.value ?? "",
                        action: "cancel"
                    )
                }, okTapped: { [weak self] in
                    UIApplication.shared.open(url, options: [:])
                    self?.analytics.externalLinkOpenAction(
                        url: url.absoluteString,
                        screen: self?.sourceScreen.value ?? "",
                        action: "continue"
                    )
                }, type: .default(positiveAction: CoreLocalization.Webview.Alert.continue, image: nil)
            )
            return true
        }
        
        return false
    }
    
    private func urlAction(from url: URL) -> WebviewActions? {
        guard isValidAppURLScheme(url),
                let url = WebviewActions(rawValue: url.appURLHost) else { return nil }
        return url
    }
    
    @MainActor
    private func handleNavigation(url: URL, urlAction: WebviewActions) async -> Bool {
        switch urlAction {
        case .courseEnrollment:
            if let urlData = parse(url: url), let courseID = urlData.courseId {
                await enrollTo(courseID: courseID)
            }
        case .courseDetail:
            guard let pathID = detailPathID(from: url) else { return false }
            analytics.discoveryScreenEvent(event: .viewCourseClicked, biValue: .viewCourseClicked)
            router.showWebDiscoveryDetails(
                pathID: pathID,
                discoveryType: .courseDetail(pathID),
                sourceScreen: sourceScreen
            )
        case .enrolledCourseDetail:
            return await showCourseDetails()
            
        case .programDetail:
            guard let pathID = programDetailPathId(from: url) else { return false }
            analytics.discoveryScreenEvent(event: .discoveryProgramInfo, biValue: .discoveryProgramInfo)
            router.showWebDiscoveryDetails(
                pathID: pathID,
                discoveryType: .programDetail(pathID),
                sourceScreen: sourceScreen
            )
            
        default:
            break
        }
        
        return true
    }
    
    private func detailPathID(from url: URL) -> String? {
        guard isValidAppURLScheme(url),
              let path = url.queryParameters?[URLParameterKeys.pathId] as? String,
              url.appURLHost == WebviewActions.courseDetail.rawValue else { return nil }
        
        return path
    }
    
    private func parse(url: URL) -> (courseId: String?, emailOptIn: Bool)? {
        guard isValidAppURLScheme(url) else { return nil }
        
        let courseId = url.queryParameters?[URLParameterKeys.courseId] as? String
        let emailOptIn = (url.queryParameters?[URLParameterKeys.emailOptIn] as? String).flatMap {Bool($0)}
        
        return (courseId, emailOptIn ?? false)
    }
    
    private func programDetailPathId(from url: URL) -> String? {
        guard isValidAppURLScheme(url),
              let path = url.queryParameters?[URLParameterKeys.pathId] as? String,
              url.appURLHost == WebviewActions.programDetail.rawValue else { return nil }
        
        return path
    }
    
    @discardableResult private func showCourseDetails() async -> Bool {
        guard let courseDetails = courseDetails else { return false }
        
        router.showCourseScreens(
            courseID: courseDetails.courseID,
            hasAccess: nil,
            courseStart: courseDetails.courseStart,
            courseEnd: courseDetails.courseEnd,
            enrollmentStart: courseDetails.enrollmentStart,
            enrollmentEnd: courseDetails.enrollmentEnd,
            title: courseDetails.courseTitle,
            courseRawImage: courseDetails.courseRawImage,
            showDates: false,
            lastVisitedBlockID: nil
        )
        
        return true
    }
    
    private func isValidAppURLScheme(_ url: URL) -> Bool {
        return url.scheme ?? "" == config.URIScheme
    }

    public func showWebViewError() {
        self.webViewError = true
    }
}
