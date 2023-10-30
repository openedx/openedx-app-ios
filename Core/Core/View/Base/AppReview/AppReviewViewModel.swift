//
//  AppReviewViewModel.swift
//  Core
//
//  Created by  Stepanok Ivan on 27.10.2023.
//

import SwiftUI

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
    @Published var feedback: String = ""
    
    public init() {}
    
    func reviewAction() {
        withAnimation(Animation.easeIn(duration: 0.2)) {
            if rating <= 3 {
                state = .feedback
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    withAnimation(Animation.easeIn(duration: 0.1)) {
                        self.showReview = true
                    }
                }
            } else {
                state = .thanksForVote
            }
        }
    }
    
    func showThanksForFeedback() {
        withAnimation(Animation.easeIn(duration: 0.2)) {
            showReview = false
                self.state = .thanksForFeedback
        }
    }
}
