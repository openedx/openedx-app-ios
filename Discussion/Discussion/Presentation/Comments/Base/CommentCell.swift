//
//  CommentCell.swift
//  Discussion
//
//  Created by  Stepanok Ivan on 09.11.2022.
//

import SwiftUI
import Core
import Kingfisher
import Theme

public struct CommentCell: View {
    
    private let comment: Post
    private let addCommentAvailable: Bool
    private let useRelativeDates: Bool
    private var onAvatarTap: ((String) -> Void)
    private var onLikeTap: (() -> Void)
    private var onReportTap: (() -> Void)
    private var onCommentsTap: (() -> Void)
    private var onFetchMore: (() -> Void)
    private var leftLineEnabled: Bool
    
    @State private var isImageVisible = true
    
    public init(
        comment: Post,
        addCommentAvailable: Bool,
        useRelativeDates: Bool,
        leftLineEnabled: Bool = false,
        onAvatarTap: @escaping (String) -> Void,
        onLikeTap: @escaping () -> Void,
        onReportTap: @escaping () -> Void,
        onCommentsTap: @escaping () -> Void,
        onFetchMore: @escaping () -> Void
    ) {
        self.comment = comment
        self.addCommentAvailable = addCommentAvailable
        self.useRelativeDates = useRelativeDates
        self.leftLineEnabled = leftLineEnabled
        self.onAvatarTap = onAvatarTap
        self.onLikeTap = onLikeTap
        self.onReportTap = onReportTap
        self.onCommentsTap = onCommentsTap
        self.onFetchMore = onFetchMore
    }
    
    public var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Button(action: {
                    onAvatarTap(comment.authorName)
                }, label: {
                KFImage(URL(string: comment.authorAvatar))
                    .onFailureImage(KFCrossPlatformImage(systemName: "person.circle"))
                    .resizable()
                    .frame(width: 32, height: 32)
                    .cornerRadius(16)
                    .overlay {
                        Circle()
                            .stroke(Theme.Colors.avatarStroke, lineWidth: 1)
                    }
                })
                
                VStack(alignment: .leading) {
                    Text(comment.authorName)
                        .font(Theme.Fonts.titleSmall)
                    Text(comment.postDate.dateToString(style: .lastPost, useRelativeDates: useRelativeDates))
                        .font(Theme.Fonts.labelSmall)
                        .foregroundColor(Theme.Colors.textSecondary)
                }
                Spacer()
                Button(action: {
                    onReportTap()
                }, label: {
                    let icon = comment.abuseFlagged
                    ? CoreAssets.reported.swiftUIImage
                    : CoreAssets.report.swiftUIImage
                    icon.renderingMode(.template)
                        
                    Text(comment.abuseFlagged
                         ? DiscussionLocalization.Comment.unreport
                         : DiscussionLocalization.Comment.report)
                    .font(Theme.Fonts.labelMedium)
                }).foregroundColor(comment.abuseFlagged
                                   ? Theme.Colors.irreversibleAlert
                                      : Theme.Colors.textSecondaryLight)
            }
            Text(comment.postBodyHtml.hideHtmlTagsAndUrls())
                .font(Theme.Fonts.bodyMedium)
                .padding(.bottom, 8)
                    
            ForEach(Array(comment.postBody.extractURLs().enumerated()), id: \.offset) { _, url in
                if url.isImage() {
                    if isImageVisible {
                        KFAnimatedImage(url)
                            .onFailure { _ in
                                isImageVisible = false
                            }
                            .scaledToFit()
                    }
                } else {
                    HStack(alignment: .top) {
                        Image(systemName: "globe")
                        Link(destination: url) {
                            Text(url.absoluteString)
                            .multilineTextAlignment(.leading)
                        }
                    }
                    .foregroundColor(Theme.Colors.accentColor)
                    .font(Theme.Fonts.bodyMedium)
                }
            }
            
            LazyVStack {
                VStack {}
                    .frame(height: 1)
                    .overlay(Theme.Colors.cardViewStroke)
                    .padding(.horizontal, 24)
                    .onAppear {
                        onFetchMore()
                    }
            }
            HStack {
                Button(action: {
                    onLikeTap()
                }, label: {
                    comment.voted
                    ? (CoreAssets.voted.swiftUIImage.renderingMode(.template))
                    : CoreAssets.vote.swiftUIImage.renderingMode(.template)
                    Text("\(comment.votesCount)")
                    Text(DiscussionLocalization.votesCount(comment.votesCount))
                }).foregroundColor(comment.voted
                                   ? Theme.Colors.accentColor
                                   : Theme.Colors.textSecondaryLight)
                .font(Theme.Fonts.labelLarge)

                Spacer()
                if addCommentAvailable {
                        HStack {
                            Image(systemName: "message.fill")
                                .renderingMode(.template)
                            Text("\(comment.responsesCount)")
                            Text(DiscussionLocalization.commentsCount(comment.responsesCount))
                        }
                        .foregroundColor(Theme.Colors.textSecondary)
                        .font(Theme.Fonts.labelLarge)
                }
            }.foregroundColor(Theme.Colors.accentColor)
                .font(Theme.Fonts.labelMedium)
            
        }.cardStyle(top: leftLineEnabled ? 0 : 8, leftLineEnabled: leftLineEnabled,
                    bgColor: Theme.Colors.commentCellBackground)
            .onTapGesture {
                if addCommentAvailable {
                    onCommentsTap()
                }
            }
    }
}

struct CommentView_Previews: PreviewProvider {
    static var previews: some View {
        let comment = Post(
            authorName: "Bill Clinton",
            authorAvatar: "",
            postDate: Date(),
            postTitle: "Time to test",
            postBodyHtml: "Link with long title",
            postBody: #"""
"<a href= "https://google.com/mainthread/links/images-with-super-long-title">Link</a> https://google.com/
"""#,
            postVisible: false,
            voted: true,
            followed: true,
            
            votesCount: 12,
            responsesCount: 312,
            comments: [],
            threadID: "",
            commentID: "",
            parentID: nil,
            abuseFlagged: true,
            closed: false
        )
        
        VStack(spacing: 0) {
            CommentCell(
                comment: comment,
                addCommentAvailable: true,
                useRelativeDates: true,
                leftLineEnabled: false,
                onAvatarTap: { _ in },
                onLikeTap: {},
                onReportTap: {},
                onCommentsTap: {},
                onFetchMore: {})
            CommentCell(
                comment: comment,
                addCommentAvailable: true,
                useRelativeDates: true,
                leftLineEnabled: false,
                onAvatarTap: {_ in},
                onLikeTap: {},
                onReportTap: {},
                onCommentsTap: {},
                onFetchMore: {})
        }
        .loadFonts()
        .preferredColorScheme(.light)
        .previewDisplayName("CommentCell Light")
        
        VStack(spacing: 0) {
            CommentCell(
                comment: comment,
                addCommentAvailable: true,
                useRelativeDates: true,
                leftLineEnabled: false,
                onAvatarTap: {_ in},
                onLikeTap: {},
                onReportTap: {},
                onCommentsTap: {},
                onFetchMore: {})
            CommentCell(
                comment: comment,
                addCommentAvailable: true,
                useRelativeDates: true,
                leftLineEnabled: false,
                onAvatarTap: {_ in},
                onLikeTap: {},
                onReportTap: {},
                onCommentsTap: {},
                onFetchMore: {})
        }
        .loadFonts()
        .preferredColorScheme(.dark)
        .previewDisplayName("CommentCell Dark")
    }
}
