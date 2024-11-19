//
//  AppReviewViewModel.swift
//  Core
//
//  Created by  Stepanok Ivan on 27.10.2023.
//

import SwiftUI
import StoreKit

@MainActor
public class AppReviewViewModel: ObservableObject {
    
    enum ReviewState {
        case vote
        case feedback
        case thanksForVote
        case thanksForFeedback
        
        var title: String {
            switch self {
            case .vote:
                CoreLocalization.Review.voteTitle
            case .feedback:
                CoreLocalization.Review.feedbackTitle
            case .thanksForVote, .thanksForFeedback:
                CoreLocalization.Review.thanksForVoteTitle
            }
        }
        
        var description: String {
            switch self {
            case .vote:
                CoreLocalization.Review.voteDescription
            case .feedback:
                CoreLocalization.Review.feedbackDescription
            case .thanksForVote:
                CoreLocalization.Review.thanksForVoteDescription
            case .thanksForFeedback:
                CoreLocalization.Review.thanksForFeedbackDescription
            }
        }
    }
    
    @Published var state: ReviewState = .vote
    @Published var rating: Int = 0
    @Published var showReview: Bool = false
    @Published var showSelectMailClientView: Bool = false
    @Published var feedback: String = ""
    @Published var clients: [ThirdPartyMailClient] = []
    let allClients = ThirdPartyMailClient.clients
    
    private let config: ConfigProtocol
    var storage: CoreStorage
    private let analytics: CoreAnalytics
    
    public init(config: ConfigProtocol, storage: CoreStorage, analytics: CoreAnalytics) {
        self.config = config
        self.storage = storage
        self.analytics = analytics
    }
    
    public func shouldShowRatingView() -> Bool {
        guard let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
            return false
        }
        guard let lastShownVersion = storage.reviewLastShownVersion else {
            storage.reviewLastShownVersion = currentVersion
            
            if let lastReviewDate = storage.lastReviewDate {
                return hasPassedFourMonths(from: lastReviewDate)
            } else {
                return true
            }
        }
        return isNewerVersion(currentVersion: currentVersion, lastVersion: lastShownVersion)
    }
    
    private func hasPassedFourMonths(from date: Date) -> Bool {
        let currentDate = Date()
        let calendar = Calendar.current
         
        if let futureDate = calendar.date(byAdding: .month, value: 4, to: date) {
          return currentDate >= futureDate
        }
         
        return false
      }
    
    func reviewAction() {
        withAnimation(Animation.easeIn(duration: 0.2)) {
            if rating <= 3 {
                state = .feedback
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation(Animation.easeIn(duration: 0.1)) {
                        self.showReview = true
                    }
                }
            } else {
                state = .thanksForVote
            }
        }
    }
    
    func writeFeedbackToMail() {
        self.clients = allClients.filter({ ThirdPartyMailer.isMailClientAvailable($0) })
        if !clients.isEmpty {
            withAnimation(Animation.bouncy(duration: 0.2)) {
                showSelectMailClientView = true
            }
        } else {
            openMailClient(ThirdPartyMailClient.systemDefault)
        }
    }
    
    func openMailClient(_ with: ThirdPartyMailClient) {
        
        let osVersion = UIDevice.current.systemVersion
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        let deviceModel = UIDevice.current.model
        let feedbackDetails = "\n\n OS version: \(osVersion)\nApp version: \(appVersion)\nDevice model: \(deviceModel)"
        
        let mailUrl = with.composeURL(
            to: config.feedbackEmail,
            subject: "Feedback",
            body: feedback + feedbackDetails,
            cc: nil,
            bcc: nil
        )
        UIApplication.shared.open(mailUrl)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.showSelectMailClientView = false
            self.state = .thanksForFeedback
        }
    }
    
    private func isNewerVersion(currentVersion: String, lastVersion: String) -> Bool {
        // Split versions into components
        let currentComponents = currentVersion.split(separator: ".").compactMap { Int($0) }
        let lastComponents = lastVersion.split(separator: ".").compactMap { Int($0) }
        
        // Check that the number of components is the same
        guard currentComponents.count == lastComponents.count else {
            return false
        }
        
        // Check the condition
        if currentComponents[0] > lastComponents[0] + 1 {
            return true  // Greater by one major version
        } else if currentComponents[0] == lastComponents[0] + 1 {
            return true  // Equal to the major version but greater by two minor versions
        } else if currentComponents[1] > lastComponents[1] + 1 {
            return true  // Greater by two minor versions
        }
        
        return false
    }
    
    func trackAppReviewAction(_ action: String? = nil) {
        analytics.appreview(.appreviewPopupAction, biValue: .appreviewPopupAction, action: action, rating: rating)
    }
    
    func trackAppReviewViewed() {
        analytics.appreview(.appreviewPopupViewed, biValue: .appreviewPopupViewed, action: nil, rating: rating)
    }
}
