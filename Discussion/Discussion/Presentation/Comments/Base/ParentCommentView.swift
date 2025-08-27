//
//  MainCommentView.swift
//  Discussion
//
//  Created by  Stepanok Ivan on 09.11.2022.
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
    
    @EnvironmentObject var themeManager: ThemeManager
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
                            .stroke(themeManager.theme.colors.avatarStroke, lineWidth: 1)
                    }
                    
                })
                VStack(alignment: .leading) {
                    Text(comments.authorName)
                        .font(Theme.Fonts.titleMedium)
                        .foregroundColor(themeManager.theme.colors.textPrimary)
                    Text(comments.postDate
                        .dateToString(style: .lastPost, useRelativeDates: useRelativeDates))
                    .font(Theme.Fonts.labelSmall)
                    .foregroundColor(themeManager.theme.colors.textSecondaryLight)
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
                                       ? themeManager.theme.colors.accentColor
                                       : themeManager.theme.colors.textSecondaryLight)
                }
            }.padding(.top, 15)
            Text(comments.postTitle)
                .font(Theme.Fonts.titleLarge)
                .foregroundColor(themeManager.theme.colors.textPrimary)
            ZStack(alignment: .topLeading) {
                HTMLContentView(
                    html: comments.postBodyHtml,
                    textColor: themeManager.theme.colors.textPrimary
                )
                .id(comments.commentID)
            }
            .padding(.bottom, 8)
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
                                   ? themeManager.theme.colors.accentColor
                                   : themeManager.theme.colors.textSecondaryLight)
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
                         ? themeManager.theme.colors.irreversibleAlert
                         : themeManager.theme.colors.textSecondaryLight)
                .font(Theme.Fonts.labelLarge)
        }
        .padding(.horizontal, 24)
        if isThread {
            Divider()
                .frame(height: 1)
                .overlay(themeManager.theme.colors.cardViewStroke)
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
