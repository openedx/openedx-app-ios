//
//  ResponsesView.swift
//  Discussion
//
//  Created by  Stepanok Ivan on 16.11.2022.
//

import SwiftUI
import Core
import Combine
import Theme

public struct ResponsesView: View {
    
    private let router: DiscussionRouter
    private var title: String
    private let commentID: String
    private let parentComment: Post
    
    @ObservedObject private var viewModel: ResponsesViewModel
    @State private var isShowProgress: Bool = true

    public init(
        commentID: String,
        viewModel: ResponsesViewModel,
        router: DiscussionRouter,
        parentComment: Post,
        isBlackedOut: Bool
    ) {
        self.commentID = commentID
        self.parentComment = parentComment
        self.title = DiscussionLocalization.Response.commentsResponses
        self.viewModel = viewModel
        self.router = router
        Task {
            await viewModel.getComments(commentID: commentID, parentComment: parentComment, page: 1)
        }
        viewModel.addCommentsIsVisible = false
        self.viewModel.isBlackedOut = isBlackedOut
    }
    
    public var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .top) {
                // MARK: - Page Body
                ScrollViewReader { scroll in
                    VStack {
                        ZStack(alignment: .top) {
                            RefreshableScrollViewCompat(action: {
                                viewModel.comments = []
                                _ = await viewModel.getComments(
                                    commentID: commentID,
                                    parentComment: parentComment,
                                    page: 1
                                )
                            }) {
                                VStack {
                                    if let comments = viewModel.postComments {
                                        ParentCommentView(
                                            comments: comments,
                                            isThread: false, onAvatarTap: { username in
                                                viewModel.router.showUserDetails(username: username)
                                            },
                                            onLikeTap: {
                                                Task {
                                                    if await viewModel.vote(
                                                        id: parentComment.commentID,
                                                        isThread: false,
                                                        voted: comments.voted,
                                                        index: nil
                                                    ) {
                                                        viewModel.sendThreadLikeState()
                                                    }
                                                }
                                            },
                                            onReportTap: {
                                                Task {
                                                    if await viewModel.flag(
                                                        id: parentComment.commentID,
                                                        isThread: false,
                                                        abuseFlagged: comments.abuseFlagged,
                                                        index: nil
                                                    ) {
                                                        viewModel.sendThreadReportState()
                                                    }
                                                    
                                                }
                                            },
                                            onFollowTap: {}
                                        )
                                        HStack {
                                            Text("\(viewModel.itemsCount)")
                                            Text(DiscussionLocalization.commentsCount(viewModel.itemsCount))
                                            Spacer()
                                        }
                                        .padding(.top, 20)
                                        .padding(.bottom, 14)
                                        .padding(.leading, 24)
                                        .font(Theme.Fonts.titleMedium)
                                        .foregroundColor(Theme.Colors.textPrimary)
                                        ForEach(
                                            Array(comments.comments.enumerated()), id: \.offset
                                        ) { index, comment in
                                            CommentCell(
                                                comment: comment,
                                                addCommentAvailable: false, leftLineEnabled: true,
                                                onAvatarTap: { username in
                                                    viewModel.router.showUserDetails(username: username)
                                                },
                                                onLikeTap: {
                                                    Task {
                                                        await viewModel.vote(
                                                            id: comment.commentID,
                                                            isThread: false,
                                                            voted: comment.voted,
                                                            index: index
                                                        )
                                                    }
                                                },
                                                onReportTap: {
                                                    Task {
                                                        await viewModel.flag(
                                                            id: comment.commentID,
                                                            isThread: false,
                                                            abuseFlagged: comment.abuseFlagged,
                                                            index: index
                                                        )
                                                    }
                                                },
                                                onCommentsTap: {},
                                                onFetchMore: {
                                                    Task {
                                                        await viewModel.fetchMorePosts(
                                                            commentID: commentID,
                                                            parentComment: parentComment,
                                                            index: index
                                                        )
                                                    }
                                                }
                                            )
                                            .id(index)
                                            .padding(.bottom, -8)
                                        }
                                        if viewModel.nextPage <= viewModel.totalPages {
                                            VStack(alignment: .center) {
                                                ProgressBar(size: 40, lineWidth: 8)
                                                    .padding(.top, 20)
                                            }.frame(maxWidth: .infinity,
                                                    maxHeight: .infinity)
                                        }
                                    }
                                    Spacer(minLength: 84)
                                }
                                .onRightSwipeGesture {
                                    viewModel.router.back()
                                }
                                .frameLimit(width: proxy.size.width)
                            }
                            if !(parentComment.closed  || viewModel.isBlackedOut) {
                                FlexibleKeyboardInputView(
                                    hint: DiscussionLocalization.Response.addComment,
                                    sendText: { commentText in
                                        if let threadID = viewModel.postComments?.threadID {
                                            Task {
                                                await viewModel.postComment(
                                                    threadID: threadID,
                                                    rawBody: commentText,
                                                    parentID: commentID
                                                )
                                            }
                                        }
                                    }
                                )
                                .ignoresSafeArea(.all, edges: .horizontal)
                            }
                        }
                    }
                    .onReceive(viewModel.addPostSubject, perform: { newComment in
                        guard let newComment else { return }
                        viewModel.sendThreadPostsCountState()
                        if viewModel.nextPage - 1 == viewModel.totalPages {
                            viewModel.addNewPost(newComment)
                            withAnimation {
                                guard let count = viewModel.postComments?.comments.count else { return }
                                scroll.scrollTo(count - 2, anchor: .top)
                            }
                        } else {
                            viewModel.alertMessage = DiscussionLocalization.Response.Alert.commentAdded
                            viewModel.showAlert = true
                        }
                    })
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }.scrollAvoidKeyboard(dismissKeyboardByTap: true)
                    .padding(.top, 8)
                // MARK: - Error Alert
                if viewModel.showError {
                    VStack {
                        Spacer()
                        SnackBarView(message: viewModel.errorMessage)
                    }
                    .transition(.move(edge: .bottom))
                    .onAppear {
                        doAfter(Theme.Timeout.snackbarMessageLongTimeout) {
                            viewModel.errorMessage = nil
                        }
                    }
                }
            }
            .ignoresSafeArea(.all, edges: .horizontal)
            .navigationBarHidden(false)
            .navigationBarBackButtonHidden(false)
            .navigationTitle(title)
            .edgesIgnoringSafeArea(.bottom)
            .background(
                Theme.Colors.background
                    .ignoresSafeArea()
            )
        }
    }
}

#if DEBUG
struct ResponsesView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = ResponsesViewModel(
            interactor: DiscussionInteractor(repository: DiscussionRepositoryMock()),
            router: DiscussionRouterMock(),
            config: ConfigMock(),
            threadStateSubject: .init(nil)
        )
        let post = Post(
            authorName: "Kirill",
            authorAvatar: "",
            postDate: Date(),
            postTitle: "Title",
            postBodyHtml: "Nice post, bro",
            postBody: "Nice post, bro",
            postVisible: true,
            voted: false,
            followed: true,
            votesCount: 213,
            responsesCount: 32,
            comments: [],
            threadID: "",
            commentID: "",
            parentID: "",
            abuseFlagged: false,
            closed: false
        )
        let router = DiscussionRouterMock()
        
        ResponsesView(
            commentID: "",
            viewModel: viewModel,
            router: router,
            parentComment: post,
            isBlackedOut: false
        )
        .loadFonts()
        .preferredColorScheme(.light)
        .previewDisplayName("ResponsesView Light")
        
        ResponsesView(
            commentID: "",
            viewModel: viewModel,
            router: router,
            parentComment: post,
            isBlackedOut: false
        )
        .loadFonts()
        .preferredColorScheme(.dark)
        .previewDisplayName("ResponsesView Dark")
    }
}
#endif
