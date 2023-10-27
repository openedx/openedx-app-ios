//
//  AppReviewView.swift
//  Core
//
//  Created by  Stepanok Ivan on 26.10.2023.
//

import SwiftUI

public struct AppReviewView: View {
    
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
    
    @ObservedObject private var viewModel: AppReviewViewModel
    
    @State private var state: ReviewState = .vote
    @State private var rating = 0
    
    @Environment (\.isHorizontal) private var isHorizontal
    @Environment (\.presentationMode) private var presentationMode
    private let config: Config
    
    public init(config: Config, viewModel: AppReviewViewModel) {
        self.config = config
        self.viewModel = viewModel
    }
    
    public var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .ignoresSafeArea()
                .onTapGesture {
                    presentationMode.wrappedValue.dismiss()
                }
            VStack(spacing: 30) {
                if state == .thanksForFeedback && state == .thanksForVote {
                    Image(systemName: "arrow.up.circle")
                        .resizable()
                        .frame(width: isHorizontal ? 50 : 110,
                               height: isHorizontal ? 50 : 110)
                        .foregroundColor(Theme.Colors.accentColor)
                        .padding(.bottom, isHorizontal ? 0 : 20)
                }
                Text(state.title)
                    .font(Theme.Fonts.titleMedium)
                Text(state.description)
                    .font(Theme.Fonts.titleSmall)
                    .foregroundColor(Theme.Colors.avatarStroke)
                    .multilineTextAlignment(.center)
                StarRatingView(rating: $rating)
                
                HStack(spacing: 28) {
                    Text("Not Now")
                        .font(Theme.Fonts.labelLarge)
                        .foregroundColor(Theme.Colors.accentColor)
                    
                    AppReviewButton(type: .submit, action: {
                        
                    }, isLoading: .constant(false))
                }

            }.padding(isHorizontal ? 40 : 40)
                .background(Theme.Colors.background)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .frame(maxWidth: 400, maxHeight: 400)
                .padding(24)
                .shadow(color: Color.black.opacity(0.4), radius: 12, x: 0, y: 0)
        }
    }
}

struct AppReviewView_Previews: PreviewProvider {
    static var previews: some View {
        AppReviewView(config: ConfigMock(), viewModel: AppReviewViewModel())
    }
}

struct StarRatingView: View {
    @Binding var rating: Int
    
    var body: some View {
        HStack {
            ForEach(1 ..< 6) { index in
                Group {
                    if index <= rating {
                        CoreAssets.star.swiftUIImage
                            .resizable()
                            .frame(width: 48, height: 48)
                    } else {
                        CoreAssets.starOutline.swiftUIImage
                            .resizable()
                            .frame(width: 48, height: 48)
                            .foregroundColor(Theme.Colors.textPrimary)
                    }
                }
                    .onTapGesture {
                        self.rating = index
                    }
            }
        }
    }
}

struct AppReviewButton: View {
    let type: ButtonType
    let action: () -> Void
    @Binding var isLoading: Bool
    
    enum ButtonType {
        case submit, shareFeedback, done
    }
    
    var body: some View {
        Group {
            HStack(spacing: 4) {
                Text(type == .submit ? "Submit"
                     : (type == .shareFeedback ? "Share Feedback" : "Rate Us" ))
                .foregroundColor(Color.white)
                .font(Theme.Fonts.labelLarge)
                .padding(3)
                
                if type == .shareFeedback {
                    CoreAssets.arrowLeft.swiftUIImage
                        .renderingMode(.template)
                        .rotationEffect(Angle(degrees: 180))
                        .foregroundColor(Color.white)
                }
                
                if type == .done {
                    CoreAssets.checkmark.swiftUIImage
                        .renderingMode(.template)
                        .foregroundColor(Color.white)
                }
            }.padding(.horizontal, 20)
                .padding(.vertical, 9)
        }.fixedSize()
            .background(isLoading
                        ? Theme.Colors.background
                        : Theme.Colors.accentColor)
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(type == .submit ? "WhatsNewLocalization.buttonPrevious"
                                : (type == .shareFeedback ? "WhatsNewLocalization.buttonNext" : "WhatsNewLocalization.buttonDone" ))
            .cornerRadius(8)
            .onTapGesture { action() }
    }
}
