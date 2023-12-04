//
//  AppReviewView.swift
//  Core
//
//  Created by  Stepanok Ivan on 26.10.2023.
//

import SwiftUI
import StoreKit
import Theme

public struct AppReviewView: View {
        
    @ObservedObject private var viewModel: AppReviewViewModel

    @Environment (\.isHorizontal) private var isHorizontal
    @Environment (\.presentationMode) private var presentationMode
    
    public init(viewModel: AppReviewViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .ignoresSafeArea()
                .onTapGesture {
                    presentationMode.wrappedValue.dismiss()
                }
            if viewModel.showSelectMailClientView {
                SelectMailClientView(clients: viewModel.clients, onMailTapped: { client in
                    viewModel.openMailClient(client)
                })
            } else {
                VStack(spacing: 20) {
                    if viewModel.state == .thanksForFeedback || viewModel.state == .thanksForVote {
                        CoreAssets.favorite.swiftUIImage
                            .resizable()
                            .frame(width: isHorizontal ? 50 : 100,
                                   height: isHorizontal ? 50 : 100)
                            .foregroundColor(Theme.Colors.accentColor)
                            .onForeground {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                    self.presentationMode.wrappedValue.dismiss()
                                }
                            }
                    }
                    Text(viewModel.state.title)
                        .font(Theme.Fonts.titleMedium)
                    Text(viewModel.state.description)
                        .font(Theme.Fonts.titleSmall)
                        .foregroundColor(Theme.Colors.avatarStroke)
                        .multilineTextAlignment(.center)
                    switch viewModel.state {
                    case .vote:
                        StarRatingView(rating: $viewModel.rating)
                        
                        HStack(spacing: 28) {
                            Text(CoreLocalization.Review.notNow)
                                .font(Theme.Fonts.labelLarge)
                                .foregroundColor(Theme.Colors.accentColor)
                                .onTapGesture { presentationMode.wrappedValue.dismiss() }
                            
                            AppReviewButton(type: .submit, action: {
                                viewModel.reviewAction()
                            }, isActive: .constant(viewModel.rating != 0))
                        }
                        
                    case .feedback:
                        TextEditor(text: $viewModel.feedback)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 4)
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
                                        Text(CoreLocalization.Review.better)
                                            .font(Theme.Fonts.bodyMedium)
                                            .foregroundColor(Theme.Colors.textSecondary)
                                            .padding(16)
                                    }
                                }
                            )
                            .frame(height: viewModel.showReview ? (isHorizontal ? 80 : 162) : 0)
                            .opacity(viewModel.showReview ? 1 : 0)
                        
                        HStack(spacing: 28) {
                            Text(CoreLocalization.Review.notNow)
                                .font(Theme.Fonts.labelLarge)
                                .foregroundColor(Theme.Colors.accentColor)
                                .onTapGesture { presentationMode.wrappedValue.dismiss() }
                            
                            AppReviewButton(type: .shareFeedback, action: {
                                viewModel.writeFeedbackToMail()
                            }, isActive: .constant(viewModel.feedback.count >= 3))
                        }
                        
                    case .thanksForVote, .thanksForFeedback:
                        HStack(spacing: 28) {
                            Text(CoreLocalization.Review.notNow)
                                .font(Theme.Fonts.labelLarge)
                                .foregroundColor(Theme.Colors.accentColor)
                                .onTapGesture { presentationMode.wrappedValue.dismiss() }
                            
                            AppReviewButton(type: .rateUs, action: {
                                presentationMode.wrappedValue.dismiss()
                                SKStoreReviewController.requestReviewInCurrentScene()
                                viewModel.storage.lastReviewDate = Date()
                            }, isActive: .constant(true))
                        }
                    }
                    
                }.onTapGesture {
                    UIApplication.shared.sendAction(
                        #selector(UIResponder.resignFirstResponder),
                        to: nil, from: nil, for: nil
                    )
                }
                .padding(isHorizontal ? 20 : 40)
                    .background(Theme.Colors.background)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .frame(maxWidth: 400)
                    .padding(isHorizontal ? 14 : 24)
                    .shadow(color: Color.black.opacity(0.4), radius: 12, x: 0, y: 0)
            }
        }
    }
}

#if DEBUG
struct AppReviewView_Previews: PreviewProvider {
    static var previews: some View {
        AppReviewView(viewModel: AppReviewViewModel(config: ConfigMock(), storage: CoreStorageMock()))
    }
}
#endif
