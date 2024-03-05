//
//  DiscussionTopicsView.swift
//  Discussion
//
//  Created by  Stepanok Ivan on 13.10.2022.
//

import Foundation
import SwiftUI
import Core
import Theme

public struct DiscussionTopicsView: View {
    
    @StateObject private var viewModel: DiscussionTopicsViewModel
    private let router: DiscussionRouter
    private let courseID: String

    public init(courseID: String, viewModel: DiscussionTopicsViewModel, router: DiscussionRouter) {
        self._viewModel = StateObject(wrappedValue: { viewModel }())
        self.courseID = courseID
        self.router = router
    }
    
    public var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .center) {
                VStack(alignment: .center) {
                    // MARK: - Search fake field
                    HStack(spacing: 11) {
                        Image(systemName: "magnifyingglass")
                            .padding(.leading, 16)
                            .padding(.top, 1)
                        Text(DiscussionLocalization.Topics.search)
                            .foregroundColor(Theme.Colors.textSecondary)
                        Spacer()
                    }
                    .frame(minHeight: 48)
                    .background(
                        Theme.Shapes.textInputShape
                            .fill(Theme.Colors.textInputUnfocusedBackground)
                    )
                    .overlay(
                        Theme.Shapes.textInputShape
                            .stroke(lineWidth: 1)
                            .fill(Theme.Colors.textInputUnfocusedStroke)
                    )
                    .onTapGesture {
                        viewModel.router.showDiscussionsSearch(courseID: courseID)
                    }
                    .frameLimit(width: proxy.size.width)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 20)
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel(DiscussionLocalization.Topics.search)
                    
                    // MARK: - Page Body
                    VStack {
                        ZStack(alignment: .top) {
                            RefreshableScrollViewCompat(action: {
                                await viewModel.getTopics(courseID: self.courseID, withProgress: false)
                            }) {
                                VStack {
                                    if let topics = viewModel.discussionTopics {
                                        HStack {
                                            Text(DiscussionLocalization.Topics.mainCategories)
                                                .font(Theme.Fonts.titleMedium)
                                                .foregroundColor(Theme.Colors.textSecondary)
                                                .padding(.horizontal, 24)
                                                .padding(.top, 40)
                                            Spacer()
                                        }
                                        HStack(spacing: 8) {
                                            if let allTopics = topics.first(where: {
                                                $0.name == DiscussionLocalization.Topics.allPosts }) {
                                                Button(action: {
                                                    allTopics.action()
                                                }, label: {
                                                    VStack {
                                                        Spacer(minLength: 0)
                                                        CoreAssets.allPosts.swiftUIImage
                                                        Text(allTopics.name)
                                                            .font(Theme.Fonts.titleSmall)
                                                        Spacer(minLength: 0)
                                                    }
                                                    .frame(maxWidth: .infinity)
                                                }).cardStyle(bgColor: Theme.Colors.textInputUnfocusedBackground)
                                                    .padding(.trailing, -20)
                                            }
                                            if let followed = topics.first(where: {
                                                $0.name == DiscussionLocalization.Topics.postImFollowing}) {
                                                Button(action: {
                                                    followed.action()
                                                }, label: {
                                                    VStack(alignment: .center) {
                                                        Spacer(minLength: 0)
                                                        CoreAssets.followed.swiftUIImage
                                                        Text(followed.name)
                                                            .font(Theme.Fonts.titleSmall)
                                                        Spacer(minLength: 0)
                                                    }
                                                    .frame(maxWidth: .infinity)
                                                }).cardStyle(bgColor: Theme.Colors.textInputUnfocusedBackground)
                                                    .padding(.leading, -20)
                                                
                                            }
                                        }.padding(.bottom, 26)
                                        ForEach(Array(topics.enumerated()), id: \.offset) { _, topic in
                                            if topic.name != DiscussionLocalization.Topics.allPosts
                                                && topic.name != DiscussionLocalization.Topics.postImFollowing {
                                                
                                                if topic.style == .title {
                                                    HStack {
                                                        Text("\(topic.name):")
                                                            .font(Theme.Fonts.titleMedium)
                                                            .foregroundColor(Theme.Colors.textSecondary)
                                                        Spacer()
                                                    }.padding(.top, 32)
                                                        .padding(.bottom, 8)
                                                        .padding(.horizontal, 24)
                                                } else {
                                                    VStack {
                                                        TopicCell(topic: topic)
                                                            .padding(.vertical, 24)
                                                        Divider()
                                                    }.padding(.horizontal, 24)
                                                }
                                            }
                                        }
                                        
                                    }
                                    Spacer(minLength: 84)
                                }
                                .frameLimit(width: proxy.size.width)
                                Spacer(minLength: 84)
                            }
                        }
                        .onRightSwipeGesture {
                            router.back()
                        }
                        
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(.top, 8)
                if viewModel.isShowProgress {
                    ProgressBar(size: 40, lineWidth: 8)
                        .padding(.horizontal)
                }
            }
            .onFirstAppear {
                Task {
                    await viewModel.getTopics(courseID: courseID)
                }
            }
            .navigationBarHidden(false)
            .navigationBarBackButtonHidden(false)
            .navigationTitle(viewModel.title)
            .background(
                Theme.Colors.background
                    .ignoresSafeArea()
            )
        }
    }
}

#if DEBUG
// swiftlint:disable all
struct DiscussionView_Previews: PreviewProvider {
    static var previews: some View {
        let vm = DiscussionTopicsViewModel(
            title: "Course name",
            interactor: DiscussionInteractor.mock,
            router: DiscussionRouterMock(),
            analytics: DiscussionAnalyticsMock(),
            config: ConfigMock())
        let router = DiscussionRouterMock()
        
        DiscussionTopicsView(courseID: "",
                             viewModel: vm,
                             router: router)
        .preferredColorScheme(.light)
        .previewDisplayName("DiscussionTopicsView Light")
        .loadFonts()
        
        DiscussionTopicsView(courseID: "",
                             viewModel: vm,
                             router: router)
        .preferredColorScheme(.dark)
        .previewDisplayName("DiscussionTopicsView Dark")
        .loadFonts()
    }
}
// swiftlint:enable all
#endif

public struct TopicCell: View {
    
    private let topic: DiscussionTopic
    
    public init(topic: DiscussionTopic) {
        self.topic = topic
    }
    
    public var body: some View {
        Button(action: {
            topic.action()
        }, label: {
            HStack {
                Text(topic.name)
                    .font(Theme.Fonts.titleMedium)
                    .foregroundColor(Theme.Colors.textPrimary)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(Theme.Colors.accentColor)
            }
        })
        
    }
}
