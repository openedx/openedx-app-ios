//
//  PostsView.swift
//  Discussion
//
//  Created by  Stepanok Ivan on 13.10.2022.
//

import Foundation
import SwiftUI
import Core
import Theme

public struct PostsView: View {
    
    @ObservedObject private var viewModel: PostsViewModel
    @State private var showFilterSheet = false
    @State private var showSortSheet = false
    private let router: DiscussionRouter
    private let title: String
    private let currentBlockID: String
    private let courseID: String
    private var showTopMenu: Bool
    private var isPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    public init(
        courseID: String,
        currentBlockID: String,
        topics: Topics,
        title: String,
        type: ThreadType,
        viewModel: PostsViewModel,
        router: DiscussionRouter,
        showTopMenu: Bool = true,
        isBlackedOut: Bool? = nil
    ) {
        self.courseID = courseID
        self.title = title
        self.currentBlockID = currentBlockID
        self.router = router
        self.showTopMenu = showTopMenu
        self.viewModel = viewModel
        self.viewModel.isBlackedOut = isBlackedOut
        self.viewModel.courseID = courseID
        self.viewModel.topics = topics
        viewModel.type = type
    }
    
    public init(
        courseID: String,
        router: DiscussionRouter,
        viewModel: PostsViewModel,
        isBlackedOut: Bool = false
    ) {
        self.courseID = courseID
        self.title = ""
        self.currentBlockID = ""
        self.router = router
        self.viewModel = viewModel
        self.showTopMenu = true
        self.viewModel.isBlackedOut = isBlackedOut
        self.viewModel.courseID = courseID
    }

    public var topicID: String? {
        if case .courseTopics(let topicID) = viewModel.type {
            return topicID
        }
        return nil
    }

    public var type: ThreadType? {
        viewModel.type
    }

    public var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .top) {
                // MARK: - Page Body
                ScrollViewReader { scroll in
                    VStack {
                        ZStack(alignment: .top) {
                            VStack {
                                VStack {
                                    HStack {
                                        Group {
                                            filterButton
                                            Spacer()
                                            sortButton
                                        }.foregroundColor(Theme.Colors.accentColor)
                                    }
                                    .font(Theme.Fonts.labelMedium)
                                    .padding(.horizontal, 24)
                                    .padding(.vertical, 12)
                                    .shadow(color: Theme.Colors.shadowColor,
                                            radius: 12, y: 4)
                                    .background(
                                        Theme.Colors.background
                                    )
                                    .frameLimit(width: proxy.size.width)
                                    Divider().offset(y: -8)
                                }

                                ScrollView {
                                    let posts = Array(viewModel.filteredPosts.enumerated())
                                    if posts.count >= 1 {
                                        LazyVStack {
                                            VStack {}.frame(height: 1)
                                                .id(1)
                                            HStack(alignment: .center) {
                                                Text(title)
                                                    .font(Theme.Fonts.titleLarge)
                                                    .foregroundColor(Theme.Colors.textPrimary)
                                                Spacer()
                                                if !(viewModel.isBlackedOut ?? false) {
                                                    Button(action: {
                                                        router.createNewThread(
                                                            courseID: courseID,
                                                            selectedTopic: currentBlockID,
                                                            onPostCreated: {
                                                                reloadPage(onSuccess: {
                                                                    withAnimation {
                                                                        scroll.scrollTo(1)
                                                                    }
                                                                })
                                                            })
                                                    }, label: {
                                                        VStack {
                                                            CoreAssets.addComment.swiftUIImage
                                                                .font(Theme.Fonts.labelLarge)
                                                                .padding(6)
                                                        }
                                                        .foregroundColor(Theme.Colors.white)
                                                        .background(
                                                            Circle()
                                                                .foregroundColor(Theme.Colors.accentButtonColor)
                                                        )
                                                    })
                                                }
                                            }
                                            .padding(.horizontal, 24)
                                            
                                            ForEach(posts, id: \.offset) { index, post in
                                                PostCell(post: post)
                                                    .padding(.horizontal, 24)
                                                    .padding(.vertical, 10)
                                                    .id(UUID())
                                                    .onAppear {
                                                        Task {
                                                            await viewModel.getPostsPagination(
                                                                index: index
                                                            )
                                                        }
                                                    }
                                                if posts.last?.element != post {
                                                    Divider().padding(.horizontal, 24)
                                                }
                                            }
                                            Spacer(minLength: 84)
                                        }
                                        .frameLimit(width: proxy.size.width)
                                    } else {
                                        if !viewModel.fetchInProgress {
                                            VStack(spacing: 0) {
                                                CoreAssets.discussionIcon.swiftUIImage
                                                    .renderingMode(.template)
                                                    .foregroundColor(Theme.Colors.textPrimary)
                                                Text(DiscussionLocalization.Posts.NoDiscussion.title)
                                                    .font(Theme.Fonts.titleLarge)
                                                    .multilineTextAlignment(.center)
                                                    .frame(maxWidth: .infinity)
                                                    .padding(.top, 40)
                                                if !(viewModel.isBlackedOut ?? false) {
                                                    Text(DiscussionLocalization.Posts.NoDiscussion.description)
                                                        .font(Theme.Fonts.bodyLarge)
                                                        .multilineTextAlignment(.center)
                                                        .frame(maxWidth: .infinity)
                                                        .padding(.top, 12)
                                                    StyledButton(
                                                        DiscussionLocalization.Posts.NoDiscussion.addPost,
                                                        action: {
                                                            router.createNewThread(courseID: courseID,
                                                                                   selectedTopic: currentBlockID,
                                                                                   onPostCreated: {
                                                                reloadPage(onSuccess: {
                                                                    withAnimation {
                                                                        scroll.scrollTo(1)
                                                                    }
                                                                })
                                                            })
                                                        },
                                                        isTransparent: true)
                                                    .frame(width: 215)
                                                    .padding(.top, 40)
                                                    .colorMultiply(Theme.Colors.accentColor)
                                                    .disabled(viewModel.isBlackedOut ?? false)
                                                }
                                            }
                                            .padding(24)
                                            .padding(.top, 100)
                                            .frameLimit(width: proxy.size.width)
                                        }
                                    }
                                }
                                .refreshable {
                                    viewModel.resetPosts()
                                    Task {
                                        _ = await viewModel.getPosts(
                                            pageNumber: 1,
                                            withProgress: false
                                        )
                                    }
                                }
                            }
                            .accessibilityAction {}
                            .onRightSwipeGesture {
                                router.back()
                            }
                        }
                    }.frame(maxWidth: .infinity)
                }
                .padding(.top, 8)
                if viewModel.isShowProgress {
                    VStack(alignment: .center) {
                        ProgressBar(size: 40, lineWidth: 8)
                            .padding(.horizontal)
                    }.frame(maxWidth: .infinity,
                            maxHeight: .infinity)
                }
            }
            .onFirstAppear {
                Task {
                    await viewModel.getPosts(
                        pageNumber: 1,
                        withProgress: true
                    )
                }
            }
            .navigationBarHidden(!showTopMenu)
            .navigationBarBackButtonHidden(!showTopMenu)
            .navigationTitle(title)
            .background(
                Theme.Colors.background
                    .ignoresSafeArea()
            )
        }
    }
    
    private var filterButton: some View {
        Button(
            action: {
                showFilterSheet = true
            },
            label: {
                CoreAssets.filter.swiftUIImage
                    .renderingMode(.template)
                    .foregroundColor(Theme.Colors.accentXColor)
                Text(viewModel.filterTitle.localizedValue)
            }
        )
        .confirmationDialog(
            DiscussionLocalization.Posts.Alert.makeSelection,
            isPresented: $showFilterSheet,
            titleVisibility: isPad ? .automatic : .visible,
            actions: {
                ForEach(viewModel.filterInfos) { info in
                    Button(
                        action: {
                            viewModel.filter(by: info)
                        },
                        label: {
                            Text(info.localizedValue)
                        }
                    )
                }
            }
        )
    }
    
    private var sortButton: some View {
        Button(
            action: {
                showSortSheet = true
            },
            label: {
                CoreAssets.sort.swiftUIImage.renderingMode(.template)
                    .foregroundColor(Theme.Colors.accentXColor)
                Text(viewModel.sortTitle.localizedValue)
            }
        )
        .confirmationDialog(
            DiscussionLocalization.Posts.Alert.makeSelection,
            isPresented: $showSortSheet,
            titleVisibility: isPad ? .automatic : .visible,
            actions: {
                ForEach(viewModel.sortInfos) { info in
                    Button(
                        action: {
                            viewModel.sort(by: info)
                        },
                        label: {
                            Text(info.localizedValue)
                        }
                    )
                }
            }
        )
    }
    
    @MainActor
    private func reloadPage(onSuccess: @escaping () -> Void) {
        Task {
            viewModel.resetPosts()
            _ = await viewModel.getPosts(
                pageNumber: 1,
                withProgress: false
            )
            onSuccess()
        }
    }
}

#if DEBUG
struct PostsView_Previews: PreviewProvider {
    static var previews: some View {
        let topics = Topics(coursewareTopics: [], nonCoursewareTopics: [])
        let router = DiscussionRouterMock()
        let vm = PostsViewModel(
            interactor: DiscussionInteractor.mock,
            router: router,
            config: ConfigMock(),
            storage: CoreStorageMock()
        )
        
        PostsView(courseID: "course_id",
                  currentBlockID: "123",
                  topics: topics,
                  title: "Lesson question",
                  type: .allPosts,
                  viewModel: vm,
                  router: router)
        .preferredColorScheme(.light)
        .previewDisplayName("PostsView Light")
        .loadFonts()
        
        PostsView(courseID: "course_id",
                  currentBlockID: "123",
                  topics: topics,
                  title: "Lesson question",
                  type: .allPosts,
                  viewModel: vm,
                  router: router)
        .preferredColorScheme(.dark)
        .previewDisplayName("PostsView Dark")
        .loadFonts()
        
    }
}
#endif

public struct PostCell: View {
    
    private var post: DiscussionPost
    
    public init(post: DiscussionPost) {
        self.post = post
    }
    
    public var body: some View {
        Button(action: {
            post.action()
        }, label: {
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 4) {
                    post.type.getImage()
                        .foregroundColor(Theme.Colors.accentColor)
                    Text(post.type.localizedValue.capitalized)
                    Spacer()
                    if post.unreadCommentCount - 1 > 0 {
                        CoreAssets.unread.swiftUIImage
                        Text("\(post.unreadCommentCount - 1)")
                        Text(DiscussionLocalization.missedPostsCount(post.unreadCommentCount - 1))
                    }
                }.font(Theme.Fonts.labelSmall)
                    .foregroundColor(Theme.Colors.textSecondary)
                Text(post.title)
                    .multilineTextAlignment(.leading)
                    .font(Theme.Fonts.labelLarge)
                    .foregroundColor(Theme.Colors.textPrimary)
                Text("\(DiscussionLocalization.Post.lastPost) \(post.lastPostDateFormatted)")
                    .font(Theme.Fonts.labelSmall)
                    .foregroundColor(Theme.Colors.textSecondary)
                HStack {
                    CoreAssets.responses.swiftUIImage.renderingMode(.template)
                        .foregroundColor(Theme.Colors.accentXColor)
                    Text("\(post.replies - 1)")
                    Text(DiscussionLocalization.responsesCount(post.replies - 1))
                        .font(Theme.Fonts.labelLarge)
                }
                .foregroundColor(Theme.Colors.accentColor)
            }
        })
    }
}
