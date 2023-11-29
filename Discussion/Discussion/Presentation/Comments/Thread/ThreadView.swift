//
//  ThreadView.swift
//  Discussion
//
//  Created by  Stepanok Ivan on 18.10.2022.
//

import SwiftUI
import Core
import Theme

public struct ThreadView: View {
    
    private var title: String
    private let thread: UserThread
    private var onBackTapped: (() -> Void) = {}
    
    @ObservedObject private var viewModel: ThreadViewModel
    @Environment(\.colorScheme) var colorScheme
    @State private var isShowProgress: Bool = true
    @State private var commentText: String = ""
    @State private var commentSize: CGFloat = .init(64)
    
    public init(thread: UserThread,
                viewModel: ThreadViewModel) {
        self.thread = thread
        self.title = thread.title
        self.viewModel = viewModel
    }
    
    public var body: some View {
        ZStack(alignment: .top) {
            
            // MARK: - Page Body
            ScrollViewReader { scroll in
                VStack {
                    ZStack(alignment: .top) {
                        RefreshableScrollViewCompat(action: {
                            _ = await viewModel.getPosts(thread: thread, page: 1)
                        }) {
                            VStack {
                                if let comments = viewModel.postComments {
                                    ParentCommentView(
                                        comments: comments,
                                        isThread: true, 
                                        onAvatarTap: { username in
                                            viewModel.router.showUserDetails(username: username)
                                        },
                                        onLikeTap: {
                                            Task {
                                                if await viewModel.vote(
                                                    id: comments.threadID,
                                                    isThread: true,
                                                    voted: comments.voted,
                                                    index: nil
                                                ) {
                                                    viewModel.sendPostLikedState()
                                                }
                                            }
                                        },
                                        onReportTap: {
                                            Task {
                                                if await viewModel.flag(
                                                    id: comments.threadID,
                                                    isThread: true,
                                                    abuseFlagged: comments.abuseFlagged,
                                                    index: nil
                                                ) {
                                                    viewModel.sendReportedState()
                                                }
                                            }
                                        },
                                        onFollowTap: {
                                            Task {
                                                if await viewModel.followThread(
                                                    following: comments.followed,
                                                    threadID: comments.threadID
                                                ) {
                                                    viewModel.sendPostFollowedState()
                                                }
                                            }
                                        }
                                    )
                                    
                                    HStack {
                                        Text("\(viewModel.itemsCount)")
                                        Text(DiscussionLocalization.responsesCount(viewModel.itemsCount))
                                        Spacer()
                                    }.padding(.top, 40)
                                        .padding(.bottom, 14)
                                        .padding(.leading, 24)
                                        .font(Theme.Fonts.titleMedium)
                                    
                                    ForEach(Array(comments.comments.enumerated()), id: \.offset) { index, comment in
                                        CommentCell(
                                            comment: comment,
                                            addCommentAvailable: true,
                                            onAvatarTap: { username in
                                                viewModel.router.showUserDetails(username: username)
                                            }, onLikeTap: {
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
                                            onCommentsTap: {
                                                viewModel.router.showComments(
                                                    commentID: comment.commentID,
                                                    parentComment: comment,
                                                    threadStateSubject: viewModel.threadStateSubject
                                                )
                                            },
                                            onFetchMore: {
                                                Task {
                                                    await viewModel.fetchMorePosts(thread: thread,
                                                                                   index: index)
                                                }
                                            }
                                        )
                                        .id(index)
                                    }
                                    if viewModel.nextPage <= viewModel.totalPages {
                                        VStack(alignment: .center) {
                                            ProgressBar(size: 40, lineWidth: 8)
                                                .padding(.top, 20)
                                        }
                                    }
                                    Spacer(minLength: 84)
                                }
                            }
                            .frameLimit()
                            .onRightSwipeGesture {
                                viewModel.router.back()
                                onBackTapped()
                                viewModel.sendUpdateUnreadState()
                            }
                        }
                        if !thread.closed {
                            FlexibleKeyboardInputView(
                                hint: DiscussionLocalization.Thread.addResponse,
                                sendText: { commentText in
                                    if let threadID = viewModel.postComments?.threadID {
                                        Task {
                                            await viewModel.postComment(
                                                threadID: threadID,
                                                rawBody: commentText,
                                                parentID: viewModel.postComments?.parentID
                                            )
                                        }
                                    }
                                }
                            ).ignoresSafeArea(.all, edges: .horizontal)
                        }
                    }
                    .onReceive(viewModel.addPostSubject, perform: { newComment in
                        guard let newComment else { return }
                        viewModel.sendPostRepliesCountState()
                        if viewModel.nextPage - 1 == viewModel.totalPages {
                            viewModel.addNewPost(newComment)
                            withAnimation {
                                guard let count = viewModel.postComments?.comments.count else { return }
                                scroll.scrollTo(count - 2, anchor: .top)
                            }
                        } else {
                            viewModel.alertMessage = DiscussionLocalization.Thread.Alert.commentAdded
                            viewModel.showAlert = true
                        }
                    })
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }.scrollAvoidKeyboard(dismissKeyboardByTap: true)
            }
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
            
            // MARK: - Alert
            if viewModel.showAlert {
                VStack {
                    Text(viewModel.alertMessage ?? "")
                        .shadowCardStyle(
                            bgColor: Theme.Colors.accentColor,
                            textColor: Theme.Colors.white
                        )
                        .padding(.top, 80)
                    Spacer()
                    
                }
                .transition(.move(edge: .top))
                .onAppear {
                    doAfter(Theme.Timeout.snackbarMessageLongTimeout) {
                        viewModel.alertMessage = nil
                    }
                }
            }
        }
        .ignoresSafeArea(.all, edges: .horizontal)
        .navigationBarHidden(false)
        .navigationBarBackButtonHidden(false)
        .navigationTitle(title)
        .onFirstAppear {
            Task {
                await viewModel.getPosts(thread: thread, page: 1)
            }
        }
        .onDisappear {
            onBackTapped()
            viewModel.sendUpdateUnreadState()
        }
        .edgesIgnoringSafeArea(.bottom)
        .background(
            Theme.Colors.background
                .ignoresSafeArea()
        )
    }
    
    private func reloadPage(onSuccess: @escaping () -> Void) {
        Task {
            if await viewModel.getPosts(thread: thread,
                                        page: viewModel.nextPage-1) { onSuccess() }
        }
    }
}

#if DEBUG
struct CommentsView_Previews: PreviewProvider {
    static var previews: some View {
        let userThread = UserThread(id: "",
                                    author: "Peter Parker",
                                    authorLabel: "Peter",
                                    createdAt: Date(),
                                    updatedAt: Date(),
                                    rawBody: "Hello world!",
                                    renderedBody: "Hello world!",
                                    voted: false,
                                    voteCount: 3,
                                    courseID: "",
                                    type: .discussion,
                                    title: "Demo title",
                                    pinned: false,
                                    closed: false,
                                    following: true,
                                    commentCount: 23,
                                    avatar: "",
                                    unreadCommentCount: 4,
                                    abuseFlagged: true,
                                    hasEndorsed: true,
                                    numPages: 3)
        let vm = ThreadViewModel(interactor: DiscussionInteractor.mock,
                                 router: DiscussionRouterMock(),
                                 config: ConfigMock(),
                                 postStateSubject: .init(nil))
        
        ThreadView(thread: userThread, viewModel: vm)
            .preferredColorScheme(.light)
            .previewDisplayName("ThreadView Light")
        
        ThreadView(thread: userThread, viewModel: vm)
            .preferredColorScheme(.dark)
            .previewDisplayName("ThreadView Dark")
        
    }
}
#endif
