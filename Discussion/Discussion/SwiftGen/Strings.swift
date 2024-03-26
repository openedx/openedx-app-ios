// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
public enum DiscussionLocalization {
  /// Anonymous
  public static let anonymous = DiscussionLocalization.tr("Localizable", "ANONYMOUS", fallback: "Anonymous")
  /// Plural format key: "%#@comments@"
  public static func commentsCount(_ p1: Int) -> String {
    return DiscussionLocalization.tr("Localizable", "comments_count", p1, fallback: "Plural format key: \"%#@comments@\"")
  }
  /// Plural format key: "%#@missed@"
  public static func missedPostsCount(_ p1: Int) -> String {
    return DiscussionLocalization.tr("Localizable", "missed_posts_count", p1, fallback: "Plural format key: \"%#@missed@\"")
  }
  /// Plural format key: "%#@responses@"
  public static func responsesCount(_ p1: Int) -> String {
    return DiscussionLocalization.tr("Localizable", "responses_count", p1, fallback: "Plural format key: \"%#@responses@\"")
  }
  /// Search
  public static let search = DiscussionLocalization.tr("Localizable", "SEARCH", fallback: "Search")
  /// Plural format key: "%#@topics@"
  public static func searchResultsDescription(_ p1: Int) -> String {
    return DiscussionLocalization.tr("Localizable", "searchResultsDescription", p1, fallback: "Plural format key: \"%#@topics@\"")
  }
  /// Localizable.strings
  ///   Discussion
  /// 
  ///   Created by  Stepanok Ivan on 12.10.2022.
  public static let title = DiscussionLocalization.tr("Localizable", "TITLE", fallback: "Discussions")
  /// Plural format key: "%#@votes@"
  public static func votesCount(_ p1: Int) -> String {
    return DiscussionLocalization.tr("Localizable", "votes_count", p1, fallback: "Plural format key: \"%#@votes@\"")
  }
  public enum Banner {
    /// Posting in discussions is disabled by the course team
    public static let discussionsIsDisabled = DiscussionLocalization.tr("Localizable", "BANNER.DISCUSSIONS_IS_DISABLED", fallback: "Posting in discussions is disabled by the course team")
  }
  public enum Comment {
    /// Follow
    public static let follow = DiscussionLocalization.tr("Localizable", "COMMENT.FOLLOW", fallback: "Follow")
    /// Report
    public static let report = DiscussionLocalization.tr("Localizable", "COMMENT.REPORT", fallback: "Report")
    /// Unfollow
    public static let unfollow = DiscussionLocalization.tr("Localizable", "COMMENT.UNFOLLOW", fallback: "Unfollow")
    /// Unreport
    public static let unreport = DiscussionLocalization.tr("Localizable", "COMMENT.UNREPORT", fallback: "Unreport")
  }
  public enum CreateThread {
    /// Create new discussion
    public static let createDiscussion = DiscussionLocalization.tr("Localizable", "CREATE_THREAD.CREATE_DISCUSSION", fallback: "Create new discussion")
    /// Create new question
    public static let createQuestion = DiscussionLocalization.tr("Localizable", "CREATE_THREAD.CREATE_QUESTION", fallback: "Create new question")
    /// Follow this discussion
    public static let followDiscussion = DiscussionLocalization.tr("Localizable", "CREATE_THREAD.FOLLOW_DISCUSSION", fallback: "Follow this discussion")
    /// Follow this question
    public static let followQuestion = DiscussionLocalization.tr("Localizable", "CREATE_THREAD.FOLLOW_QUESTION", fallback: "Follow this question")
    /// Create new post
    public static let newPost = DiscussionLocalization.tr("Localizable", "CREATE_THREAD.NEW_POST", fallback: "Create new post")
    /// Select post type
    public static let selectPostType = DiscussionLocalization.tr("Localizable", "CREATE_THREAD.SELECT_POST_TYPE", fallback: "Select post type")
    /// Title
    public static let title = DiscussionLocalization.tr("Localizable", "CREATE_THREAD.TITLE", fallback: "Title")
    /// Topic
    public static let topic = DiscussionLocalization.tr("Localizable", "CREATE_THREAD.TOPIC", fallback: "Topic")
  }
  public enum Post {
    /// Last post:
    public static let lastPost = DiscussionLocalization.tr("Localizable", "POST.LAST_POST", fallback: "Last post:")
  }
  public enum Posts {
    /// Create new post
    public static let createNewPost = DiscussionLocalization.tr("Localizable", "POSTS.CREATE_NEW_POST", fallback: "Create new post")
    public enum Alert {
      /// Make a selection
      public static let makeSelection = DiscussionLocalization.tr("Localizable", "POSTS.ALERT.MAKE_SELECTION", fallback: "Make a selection")
    }
    public enum Filter {
      /// All Posts
      public static let allPosts = DiscussionLocalization.tr("Localizable", "POSTS.FILTER.ALL_POSTS", fallback: "All Posts")
      /// Unanswered
      public static let unanswered = DiscussionLocalization.tr("Localizable", "POSTS.FILTER.UNANSWERED", fallback: "Unanswered")
      /// Unread
      public static let unread = DiscussionLocalization.tr("Localizable", "POSTS.FILTER.UNREAD", fallback: "Unread")
    }
    public enum NoDiscussion {
      /// Add a post
      public static let addPost = DiscussionLocalization.tr("Localizable", "POSTS.NO_DISCUSSION.ADD_POST", fallback: "Add a post")
      /// Create discussion
      public static let createbutton = DiscussionLocalization.tr("Localizable", "POSTS.NO_DISCUSSION.CREATEBUTTON", fallback: "Create discussion")
      /// Click the button below to create your first discussion.
      public static let description = DiscussionLocalization.tr("Localizable", "POSTS.NO_DISCUSSION.DESCRIPTION", fallback: "Click the button below to create your first discussion.")
      /// No discussions yet
      public static let title = DiscussionLocalization.tr("Localizable", "POSTS.NO_DISCUSSION.TITLE", fallback: "No discussions yet")
    }
    public enum Sort {
      /// Most Activity
      public static let mostActivity = DiscussionLocalization.tr("Localizable", "POSTS.SORT.MOST_ACTIVITY", fallback: "Most Activity")
      /// Most Votes
      public static let mostVotes = DiscussionLocalization.tr("Localizable", "POSTS.SORT.MOST_VOTES", fallback: "Most Votes")
      /// Recent Activity
      public static let recentActivity = DiscussionLocalization.tr("Localizable", "POSTS.SORT.RECENT_ACTIVITY", fallback: "Recent Activity")
    }
  }
  public enum PostType {
    /// discussion
    public static let discussion = DiscussionLocalization.tr("Localizable", "POST_TYPE.DISCUSSION", fallback: "discussion")
    /// question
    public static let question = DiscussionLocalization.tr("Localizable", "POST_TYPE.QUESTION", fallback: "question")
  }
  public enum Response {
    /// Add a comment
    public static let addComment = DiscussionLocalization.tr("Localizable", "RESPONSE.ADD_COMMENT", fallback: "Add a comment")
    /// Comment
    public static let commentsResponses = DiscussionLocalization.tr("Localizable", "RESPONSE.COMMENTS_RESPONSES", fallback: "Comment")
    public enum Alert {
      /// Comment added
      public static let commentAdded = DiscussionLocalization.tr("Localizable", "RESPONSE.ALERT.COMMENT_ADDED", fallback: "Comment added")
    }
  }
  public enum Search {
    /// Start typing to find the topics
    public static let emptyDescription = DiscussionLocalization.tr("Localizable", "SEARCH.EMPTY_DESCRIPTION", fallback: "Start typing to find the topics")
    /// Search results
    public static let title = DiscussionLocalization.tr("Localizable", "SEARCH.TITLE", fallback: "Search results")
  }
  public enum Thread {
    /// Add a response
    public static let addResponse = DiscussionLocalization.tr("Localizable", "THREAD.ADD_RESPONSE", fallback: "Add a response")
    public enum Alert {
      /// Comment added
      public static let commentAdded = DiscussionLocalization.tr("Localizable", "THREAD.ALERT.COMMENT_ADDED", fallback: "Comment added")
    }
  }
  public enum Topics {
    /// All Posts
    public static let allPosts = DiscussionLocalization.tr("Localizable", "TOPICS.ALL_POSTS", fallback: "All Posts")
    /// Main categories
    public static let mainCategories = DiscussionLocalization.tr("Localizable", "TOPICS.MAIN_CATEGORIES", fallback: "Main categories")
    /// Posts I'm following
    public static let postImFollowing = DiscussionLocalization.tr("Localizable", "TOPICS.POST_IM_FOLLOWING", fallback: "Posts I'm following")
    /// Search all posts
    public static let search = DiscussionLocalization.tr("Localizable", "TOPICS.SEARCH", fallback: "Search all posts")
    /// Unnamed subcategory
    public static let unnamed = DiscussionLocalization.tr("Localizable", "TOPICS.UNNAMED", fallback: "Unnamed subcategory")
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension DiscussionLocalization {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
