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
    @Binding private var coordinate: CGFloat
    @Binding private var collapsed: Bool
    @State private var runOnce: Bool = false
    
    public init(
        courseID: String,
        coordinate: Binding<CGFloat>,
        collapsed: Binding<Bool>,
        viewModel: DiscussionTopicsViewModel,
        router: DiscussionRouter
    ) {
        self._viewModel = StateObject(wrappedValue: { viewModel }())
        self.courseID = courseID
        self._coordinate = coordinate
        self._collapsed = collapsed
        self.router = router
    }
    
    public var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .center) {
                VStack(alignment: .center) {
                    RefreshableScrollViewCompat(action: {
                        await viewModel.getTopics(courseID: self.courseID, withProgress: false)
                    }) {
                        DynamicOffsetView(
                            coordinate: $coordinate,
                            collapsed: $collapsed
                        )
                        RefreshProgressView(isShowRefresh: $viewModel.isShowRefresh)
                        // MARK: - Search fake field
                        if viewModel.isBlackedOut {
                            bannerDiscussionsDisabled
                        }
                        
                        HStack(spacing: 11) {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(Theme.Colors.textInputTextColor)
                                .padding(.leading, 16)
                                .padding(.top, 1)
                            Text(DiscussionLocalization.Topics.search)
                                .foregroundColor(Theme.Colors.textInputTextColor)
                                .font(Theme.Fonts.bodyMedium)
                            Spacer()
                        }
                        .frame(minHeight: 48)
                        .background(
                            Theme.Shapes.textInputShape
                                .fill(Theme.Colors.textInputBackground)
                        )
                        .overlay(
                            Theme.Shapes.textInputShape
                                .stroke(lineWidth: 1)
                                .fill(Theme.Colors.textInputUnfocusedStroke)
                        )
                        .onTapGesture {
                            viewModel.router.showDiscussionsSearch(
                                courseID: courseID,
                                isBlackedOut: viewModel.isBlackedOut
                            )
                        }
                        .frameLimit(width: proxy.size.width)
                        .padding(.horizontal, 24)
                        .padding(.top, 10)
                        .accessibilityElement(children: .ignore)
                        .accessibilityLabel(DiscussionLocalization.Topics.search)
                        
                        // MARK: - Page Body
                        VStack {
                            ZStack(alignment: .top) {
                                VStack {
                                    if let topics = viewModel.discussionTopics {
                                        HStack {
                                            Text(DiscussionLocalization.Topics.mainCategories)
                                                .font(Theme.Fonts.titleMedium)
                                                .foregroundColor(Theme.Colors.textSecondary)
                                                .padding(.horizontal, 24)
                                                .padding(.top, 10)
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
                                                        CoreAssets.allPosts.swiftUIImage.renderingMode(.template)
                                                            .foregroundColor(Theme.Colors.textPrimary)
                                                        Text(allTopics.name)
                                                            .font(Theme.Fonts.titleSmall)
                                                            .foregroundColor(Theme.Colors.textPrimary)
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
                                                        CoreAssets.followed.swiftUIImage.renderingMode(.template)
                                                            .foregroundColor(Theme.Colors.textPrimary)
                                                        Text(followed.name)
                                                            .font(Theme.Fonts.titleSmall)
                                                            .foregroundColor(Theme.Colors.textPrimary)
                                                        Spacer(minLength: 0)
                                                    }
                                                    .frame(maxWidth: .infinity)
                                                }).cardStyle(bgColor: Theme.Colors.textInputUnfocusedBackground)
                                                    .padding(.leading, -20)
                                                
                                            }
                                        }.padding(.bottom, 16)
                                        ForEach(Array(topics.enumerated()), id: \.offset) { _, topic in
                                            if topic.name != DiscussionLocalization.Topics.allPosts
                                                && topic.name != DiscussionLocalization.Topics.postImFollowing {
                                                
                                                if topic.style == .title {
                                                    HStack {
                                                        Text("\(topic.name):")
                                                            .font(Theme.Fonts.titleMedium)
                                                            .foregroundColor(Theme.Colors.textSecondary)
                                                        Spacer()
                                                    }.padding(.top, 12)
                                                        .padding(.bottom, 8)
                                                        .padding(.horizontal, 24)
                                                } else {
                                                    VStack {
                                                        TopicCell(topic: topic)
                                                            .padding(.vertical, 10)
                                                        Divider()
                                                    }.padding(.horizontal, 24)
                                                }
                                            }
                                        }
                                        
                                    }
                                    Spacer(minLength: 200)
                                }
                                .frameLimit(width: proxy.size.width)
                            }
                            .onRightSwipeGesture {
                                router.back()
                            }
                            
                        }
                    }.frame(maxWidth: .infinity)
                }.padding(.top, 8)
                if viewModel.isShowProgress {
                    ProgressBar(size: 40, lineWidth: 8)
                        .padding(.horizontal)
                        .padding(.top, 100)
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
    
    private var bannerDiscussionsDisabled: some View {
        HStack {
            Spacer()
            Text(DiscussionLocalization.Banner.discussionsIsDisabled)
                .font(Theme.Fonts.titleSmall)
                .foregroundStyle(.black)
                .multilineTextAlignment(.center)
                .padding(.vertical, 10)
            Spacer()
        }
        .background(Theme.Colors.warning)
        .padding(.bottom, 10)
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
            config: ConfigMock()
        )
        let router = DiscussionRouterMock()
        
        DiscussionTopicsView(
            courseID: "",
            coordinate: .constant(0),
            collapsed: .constant(false),
            viewModel: vm,
            router: router
        )
        .preferredColorScheme(.light)
        .previewDisplayName("DiscussionTopicsView Light")
        .loadFonts()
        
        DiscussionTopicsView(
            courseID: "",
            coordinate: .constant(0),
            collapsed: .constant(false),
            viewModel: vm,
            router: router
        )
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
                    .multilineTextAlignment(.leading)
                Spacer()
                Image(systemName: "chevron.right")
                    .flipsForRightToLeftLayoutDirection(true)
                    .foregroundColor(Theme.Colors.accentColor)
            }
        })
        
    }
}
