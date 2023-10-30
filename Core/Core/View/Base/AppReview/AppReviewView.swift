//
//  AppReviewView.swift
//  Core
//
//  Created by  Stepanok Ivan on 26.10.2023.
//

import SwiftUI

public struct AppReviewView: View {
        
    @ObservedObject private var viewModel: AppReviewViewModel

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
            VStack(spacing: 20) {
                if viewModel.state == .thanksForFeedback || viewModel.state == .thanksForVote {
                    CoreAssets.favorite.swiftUIImage
                        .resizable()
                        .frame(width: isHorizontal ? 50 : 100,
                               height: isHorizontal ? 50 : 100)
                        .foregroundColor(Theme.Colors.accentColor)
                }
                Text(viewModel.state.title)
                    .font(Theme.Fonts.titleMedium)
                Text(viewModel.state.description)
                    .font(Theme.Fonts.titleSmall)
                    .foregroundColor(Theme.Colors.avatarStroke)
                    .multilineTextAlignment(.center)
                if viewModel.state == .vote {
                    StarRatingView(rating: $viewModel.rating)
                    
                    HStack(spacing: 28) {
                        Text("Not Now")
                            .font(Theme.Fonts.labelLarge)
                            .foregroundColor(Theme.Colors.accentColor)
                            .onTapGesture { presentationMode.wrappedValue.dismiss() }
                        
                        AppReviewButton(type: .submit, action: {
                            viewModel.reviewAction()
                        }, isActive: .constant(viewModel.rating != 0))
                    }
                } else if viewModel.state == .feedback {
                    TextEditor(text: $viewModel.feedback)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .frame(height: viewModel.showReview ? 162 : 0)
                        .hideScrollContentBackground()
                        .background(
                            Theme.Shapes.textInputShape
                                .fill(Theme.Colors.commentCellBackground)
                        )
                        .overlay(
                            ZStack(alignment: .topLeading) {
                                Theme.Shapes.textInputShape
                                    .stroke(lineWidth: 1)
                                    .fill(
                                        Theme.Colors.textInputStroke
                                    )
                                if viewModel.feedback.isEmpty {
                                    Text("What could have been better?")
                                        .font(Theme.Fonts.bodyMedium)
                                        .foregroundColor(Theme.Colors.textSecondary)
                                        .padding(16)
                                }
                            }
                        )
                    
                    HStack(spacing: 28) {
                        Text("Not Now")
                            .font(Theme.Fonts.labelLarge)
                            .foregroundColor(Theme.Colors.accentColor)
                            .onTapGesture { presentationMode.wrappedValue.dismiss() }
                        
                        AppReviewButton(type: .shareFeedback, action: {
                            viewModel.showThanksForFeedback()
                        }, isActive: .constant(viewModel.feedback.count >= 3))
                    }
                } else if viewModel.state == .thanksForVote {
                    HStack(spacing: 28) {
                        Text("Not Now")
                            .font(Theme.Fonts.labelLarge)
                            .foregroundColor(Theme.Colors.accentColor)
                            .onTapGesture { presentationMode.wrappedValue.dismiss() }
                        
                        AppReviewButton(type: .rateUs, action: {
                            
                        }, isActive: .constant(true))
                    }
                }

            }.padding(isHorizontal ? 40 : 40)
                .background(Theme.Colors.background)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .frame(maxWidth: 400)
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
    @Binding var isActive: Bool
    
    enum ButtonType {
        case submit, shareFeedback, rateUs
    }
    
    var body: some View {
        Button(action: {
            if isActive { action() }
        }, label: {
        Group {
            HStack(spacing: 4) {
                Text(type == .submit ? "Submit"
                     : (type == .shareFeedback ? "Share Feedback" : "Rate Us" ))
                .foregroundColor(isActive ? Color.white : Color.black.opacity(0.6))
                .font(Theme.Fonts.labelLarge)
                .padding(3)
                
            }.padding(.horizontal, 20)
                .padding(.vertical, 9)
        }.fixedSize()
            .background(isActive
                        ? Theme.Colors.accentColor
                        : Theme.Colors.cardViewStroke)
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(type == .submit ? "WhatsNewLocalization.buttonPrevious"
                                : (type == .shareFeedback ? "WhatsNewLocalization.buttonNext" : "WhatsNewLocalization.buttonDone" ))
            .cornerRadius(8)
        })
    }
}
