//
//  MainCommentView.swift
//  Discussion
//
//  Created by  Stepanok Ivan on 09.11.2022.
//

import SwiftUI
import Core
import Kingfisher
import Theme

public struct ParentCommentView: View {
    
    private let comments: Post
    private var isThread: Bool
    private let useRelativeDates: Bool
    private var onAvatarTap: ((String) -> Void)
    private var onLikeTap: (() -> Void)
    private var onReportTap: (() -> Void)
    private var onFollowTap: (() -> Void)
    
    @State private var isImageVisible = true
    
    public init(
        comments: Post,
        isThread: Bool,
        useRelativeDates: Bool,
        onAvatarTap: @escaping (String) -> Void,
        onLikeTap: @escaping () -> Void,
        onReportTap: @escaping () -> Void,
        onFollowTap: @escaping () -> Void
    ) {
        self.comments = comments
        self.isThread = isThread
        self.useRelativeDates = useRelativeDates
        self.onAvatarTap = onAvatarTap
        self.onLikeTap = onLikeTap
        self.onReportTap = onReportTap
        self.onFollowTap = onFollowTap
    }
    
    public var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Button(action: {
                    onAvatarTap(comments.authorName)
                }, label: {
                KFImage(URL(string: comments.authorAvatar))
                    .onFailureImage(KFCrossPlatformImage(systemName: "person"))
                    .resizable()
                    .frame(width: 48, height: 48)
                    .cornerRadius(24)
                    .overlay {
                        Circle()
                            .stroke(Theme.Colors.avatarStroke, lineWidth: 1)
                    }
                    
                })
                VStack(alignment: .leading) {
                    Text(comments.authorName)
                        .font(Theme.Fonts.titleMedium)
                        .foregroundColor(Theme.Colors.textPrimary)
                    Text(comments.postDate
                        .dateToString(style: .lastPost, useRelativeDates: useRelativeDates))
                    .font(Theme.Fonts.labelSmall)
                    .foregroundColor(Theme.Colors.textSecondaryLight)
                }
                Spacer()
                if isThread {
                    Button(action: {
                        onFollowTap()
                    }, label: {
                        Image(systemName: comments.followed ? "star.fill" : "star")
                            .renderingMode(.template)
                        Text(comments.followed
                             ? DiscussionLocalization.Comment.unfollow
                             : DiscussionLocalization.Comment.follow)
                        .font(Theme.Fonts.bodyMedium)
                    }).foregroundColor(comments.followed
                                       ? Theme.Colors.accentColor
                                       : Theme.Colors.textSecondaryLight)
                }
            }.padding(.top, 15)
            Text(comments.postTitle)
                .font(Theme.Fonts.titleLarge)
                .foregroundColor(Theme.Colors.textPrimary)
            Text(comments.postBodyHtml.hideHtmlTagsAndUrls())
                .font(Theme.Fonts.bodyMedium)
                .foregroundColor(Theme.Colors.textPrimary)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.bottom, 8)
            ForEach(Array(comments.postBody.extractURLs().enumerated()), id: \.offset) { _, url in
                if url.isImage() {
                    if isImageVisible {
                        KFAnimatedImage(url)
                            .onFailure { _ in
                                isImageVisible = false
                            }
                            .scaledToFit()
                    }
                } else {
                    HStack {
                        Image(systemName: "globe").renderingMode(.template)
                        Link(destination: url) {
                            Text(url.absoluteString)
                            .multilineTextAlignment(.leading)
                        }
                    }.foregroundColor(Theme.Colors.accentXColor)
                        .font(Theme.Fonts.bodyMedium)
                }
            }
            HStack {
                Button(action: {
                    onLikeTap()
                }, label: {
                    comments.voted
                    ? (CoreAssets.voted.swiftUIImage.renderingMode(.template))
                    : CoreAssets.vote.swiftUIImage.renderingMode(.template)
                    
                    Text("\(comments.votesCount)")
                    Text(DiscussionLocalization.votesCount(comments.votesCount))
                        .font(Theme.Fonts.labelLarge)
                    
                }).foregroundColor(comments.voted
                                   ? Theme.Colors.accentColor
                                   : Theme.Colors.textSecondaryLight)
                Spacer()
                Button(action: {
                    onReportTap()
                }, label: {
                    let icon = comments.abuseFlagged
                    ? CoreAssets.reported.swiftUIImage
                    : CoreAssets.report.swiftUIImage
                    icon.renderingMode(.template)
                    
                    Text(comments.abuseFlagged
                         ? DiscussionLocalization.Comment.unreport
                         : DiscussionLocalization.Comment.report)
                })
            }
            .accentColor(comments.abuseFlagged
                         ? Theme.Colors.irreversibleAlert
                         : Theme.Colors.textSecondaryLight)
                .font(Theme.Fonts.labelLarge)
        }
        .padding(.horizontal, 24)
        if isThread {
            Divider()
                .frame(height: 1)
                .overlay(Theme.Colors.cardViewStroke)
                .padding(.horizontal, 24)
        }
    }
}

struct ParentCommentView_Previews: PreviewProvider {
    static var previews: some View {
        let comment = Post(
            authorName: "Thomas Mraz",
            authorAvatar: "",
            postDate: Date(),
            postTitle: "Concert program",
            postBodyHtml: "Hello everyone. This is my concert program: 1. Sing a song. 2 Dance a dance. Thats all.",
            postBody: "https://thomasmr4z.com https://alloha.com",
            postVisible: true,
            voted: true,
            followed: false,
            votesCount: 12,
            responsesCount: 12,
            comments: [],
            threadID: "",
            commentID: "",
            parentID: nil,
            abuseFlagged: true,
            closed: false
        )
        
        return VStack {
            ParentCommentView(
                comments: comment,
                isThread: true,
                useRelativeDates: true,
                onAvatarTap: {_ in},
                onLikeTap: {},
                onReportTap: {},
                onFollowTap: {}
            )
            Spacer()
        }.loadFonts()
    }
}
