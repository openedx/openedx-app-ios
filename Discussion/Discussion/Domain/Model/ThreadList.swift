//
//  ThreadList.swift
//  Discussion
//
//  Created by  Stepanok Ivan on 25.10.2022.
//

import Foundation
import Core

public extension DataLayer.ThreadList {
    var domain: UserComment {
        UserComment(authorName: author ?? DiscussionLocalization.anonymous,
                    authorAvatar: users?.userName?.profile?.image?.imageURLLarge ?? "",
                    postDate: Date(iso8601: createdAt),
                    postTitle: title,
                    postBody: rawBody,
                    postBodyHtml: renderedBody,
                    postVisible: true,
                    voted: voted,
                    followed: following,
                    votesCount: voteCount,
                    responsesCount: commentCount,
                    threadID: id,
                    commentID: courseID,
                    parentID: nil,
                    abuseFlagged: abuseFlagged)
    }
}
