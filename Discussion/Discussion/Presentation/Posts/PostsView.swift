//
//  PostsView.swift
//  Discussion
//
//  Created by  Stepanok Ivan on 13.10.2022.
//

import Foundation
import SwiftUI
import Core

public struct PostsView: View {
    
    @ObservedObject private var viewModel: PostsViewModel
    @State private var isShowProgress: Bool = true
    @State private var showingAlert = false
    private let router: DiscussionRouter
    private let title: String
    private let currentBlockID: String
    private let courseID: String
    private var showTopMenu: Bool
    
    public init(courseID: String, currentBlockID: String, topics: Topics, title: String, type: ThreadType,
                viewModel: PostsViewModel, router: DiscussionRouter, showTopMenu: Bool = true) {
        self.courseID = courseID
        self.title = title
        self.currentBlockID = currentBlockID
        self.router = router
        self.showTopMenu = showTopMenu
        self.viewModel = viewModel
        self.viewModel.courseID = courseID
        self.viewModel.topics = topics
        viewModel.type = type
    }
    
    public init(courseID: String, router: DiscussionRouter, viewModel: PostsViewModel) {
        self.courseID = courseID
        self.title = ""
        self.currentBlockID = ""
        self.router = router
        self.viewModel = viewModel
        self.showTopMenu = true
        self.viewModel.courseID = courseID
    }
    
    public var body: some View {
        ZStack(alignment: .top) {
            // MARK: - Page Body
            ScrollViewReader { scroll in
                VStack {
                    ZStack(alignment: .top) {
                        VStack {
                            VStack {
                                HStack {
                                    Group {
                                        Button(action: {
                                            viewModel.generateButtons(type: .filter)
                                            showingAlert = true
                                        }, label: {
                                            CoreAssets.filter.swiftUIImage
                                            Text(viewModel.filterTitle.localizedValue)
                                        })
                                        Spacer()
                                        Button(action: {
                                            viewModel.generateButtons(type: .sort)
                                            showingAlert = true
                                        }, label: {
                                            CoreAssets.sort.swiftUIImage
                                            Text(viewModel.sortTitle.localizedValue)
                                        })
                                    }.foregroundColor(Theme.Colors.accentColor)
                                } .font(Theme.Fonts.labelMedium)
                                    .padding(.horizontal, 24)
                                    .padding(.vertical, 12)
                                    .shadow(color: Theme.Colors.shadowColor,
                                            radius: 12, y: 4)
                                    .background(
                                        Theme.Colors.background
                                    )
                                Divider().offset(y: -8)
                            }
                            .frameLimit()
                            RefreshableScrollViewCompat(action: {
                                viewModel.resetPosts()
                                _ = await viewModel.getPosts(
                                    pageNumber: 1,
                                    withProgress: false
                                )
                            }) {
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
                                                .foregroundColor(.white)
                                                .background(
                                                    Circle()
                                                        .foregroundColor(Theme.Colors.accentColor)
                                                )
                                            })
                                        }
                                        .padding(.horizontal, 24)
                                        
                                        ForEach(posts, id: \.offset) { index, post in
                                            PostCell(post: post).padding(24)
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
                                            Text(DiscussionLocalization.Posts.NoDiscussion.description)
                                                .font(Theme.Fonts.bodyLarge)
                                                .multilineTextAlignment(.center)
                                                .frame(maxWidth: .infinity)
                                                .padding(.top, 12)
                                            StyledButton(
                                                DiscussionLocalization.Posts.NoDiscussion.createbutton,
                                                action: {
                                                    router.createNewThread(courseID: courseID,
                                                                           selectedTopic: currentBlockID,
                                                                           onPostCreated: {
                                                        reloadPage(onSuccess: {
                                                            withAnimation {
                                                                scroll.scrollTo(
                                                                    1
                                                                )
                                                            }
                                                        })
                                                    })
                                                },
                                                isTransparent: true).frame(width: 215).padding(.top, 40)
                                                .colorMultiply(.accentColor)

                                        }.padding(24)
                                            .padding(.top, 100)
                                    }
                                }
                            }
                        }.frameLimit()
                            .animation(nil)
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
        // MARK: - Action Sheet
        .actionSheet(isPresented: $showingAlert, content: {
            ActionSheet(title: Text(DiscussionLocalization.Posts.Alert.makeSelection), buttons: viewModel.filterButtons)
        })
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
            config: ConfigMock()
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
                    CoreAssets.responses.swiftUIImage
                    Text("\(post.replies - 1)")
                    Text(DiscussionLocalization.responsesCount(post.replies - 1))
                        .font(Theme.Fonts.labelLarge)
                }
                .foregroundColor(Theme.Colors.accentColor)
            }
        })
    }
}
