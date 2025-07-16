// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
public enum CourseLocalization {
  /// Plural format key: "%#@due_in@"
  public static func dueIn(_ p1: Int) -> String {
    return CourseLocalization.tr("Localizable", "due_in", p1, fallback: "Plural format key: \"%#@due_in@\"")
  }
  /// Plural format key: "%#@past_due@"
  public static func pastDue(_ p1: Int) -> String {
    return CourseLocalization.tr("Localizable", "past_due", p1, fallback: "Plural format key: \"%#@past_due@\"")
  }
  public enum Accessibility {
    /// Assignment item
    public static let assignmentItem = CourseLocalization.tr("Localizable", "ACCESSIBILITY.ASSIGNMENT_ITEM", fallback: "Assignment item")
    /// %@, %@ of %@ complete, %@ out of %@ percent of grade
    public static func assignmentProgressDetails(_ p1: Any, _ p2: Any, _ p3: Any, _ p4: Any, _ p5: Any) -> String {
      return CourseLocalization.tr("Localizable", "ACCESSIBILITY.ASSIGNMENT_PROGRESS_DETAILS", String(describing: p1), String(describing: p2), String(describing: p3), String(describing: p4), String(describing: p5), fallback: "%@, %@ of %@ complete, %@ out of %@ percent of grade")
    }
    /// Cancel download
    public static let cancelDownload = CourseLocalization.tr("Localizable", "ACCESSIBILITY.CANCEL_DOWNLOAD", fallback: "Cancel download")
    /// Delete download
    public static let deleteDownload = CourseLocalization.tr("Localizable", "ACCESSIBILITY.DELETE_DOWNLOAD", fallback: "Delete download")
    /// Download
    public static let download = CourseLocalization.tr("Localizable", "ACCESSIBILITY.DOWNLOAD", fallback: "Download")
    /// Grade details section
    public static let gradeDetailsSection = CourseLocalization.tr("Localizable", "ACCESSIBILITY.GRADE_DETAILS_SECTION", fallback: "Grade details section")
    /// Overall grade section
    public static let overallGradeSection = CourseLocalization.tr("Localizable", "ACCESSIBILITY.OVERALL_GRADE_SECTION", fallback: "Overall grade section")
    /// %@ percent completed
    public static func progressPercentageCompleted(_ p1: Any) -> String {
      return CourseLocalization.tr("Localizable", "ACCESSIBILITY.PROGRESS_PERCENTAGE_COMPLETED", String(describing: p1), fallback: "%@ percent completed")
    }
    /// Course completion progress ring
    public static let progressRing = CourseLocalization.tr("Localizable", "ACCESSIBILITY.PROGRESS_RING", fallback: "Course completion progress ring")
    /// Required grade to pass indicator
    public static let requiredGradeIndicator = CourseLocalization.tr("Localizable", "ACCESSIBILITY.REQUIRED_GRADE_INDICATOR", fallback: "Required grade to pass indicator")
    /// %@ percent required to pass
    public static func requiredGradeToPass(_ p1: Any) -> String {
      return CourseLocalization.tr("Localizable", "ACCESSIBILITY.REQUIRED_GRADE_TO_PASS", String(describing: p1), fallback: "%@ percent required to pass")
    }
  }
  public enum Alert {
    /// Are you sure you want to delete all video(s) for
    public static let deleteAllVideos = CourseLocalization.tr("Localizable", "ALERT.DELETE_ALL_VIDEOS", fallback: "Are you sure you want to delete all video(s) for")
    /// Are you sure you want to delete video(s) for
    public static let deleteVideos = CourseLocalization.tr("Localizable", "ALERT.DELETE_VIDEOS", fallback: "Are you sure you want to delete video(s) for")
    /// Rotate your device to view this video in full screen.
    public static let rotateDevice = CourseLocalization.tr("Localizable", "ALERT.ROTATE_DEVICE", fallback: "Rotate your device to view this video in full screen.")
    /// Turning off the switch will stop downloading and delete all downloaded videos for
    public static let stopDownloading = CourseLocalization.tr("Localizable", "ALERT.STOP_DOWNLOADING", fallback: "Turning off the switch will stop downloading and delete all downloaded videos for")
    /// Warning
    public static let warning = CourseLocalization.tr("Localizable", "ALERT.WARNING", fallback: "Warning")
  }
  public enum CalendarSyncStatus {
    /// Calendar Sync Failed
    public static let failed = CourseLocalization.tr("Localizable", "CALENDAR_SYNC_STATUS.FAILED", fallback: "Calendar Sync Failed")
    /// Offline
    public static let offline = CourseLocalization.tr("Localizable", "CALENDAR_SYNC_STATUS.OFFLINE", fallback: "Offline")
    /// Synced to Calendar
    public static let synced = CourseLocalization.tr("Localizable", "CALENDAR_SYNC_STATUS.SYNCED", fallback: "Synced to Calendar")
  }
  public enum Course {
    /// Due Today
    public static let dueToday = CourseLocalization.tr("Localizable", "COURSE.DUE_TODAY", fallback: "Due Today")
    /// Due Tomorrow
    public static let dueTomorrow = CourseLocalization.tr("Localizable", "COURSE.DUE_TOMORROW", fallback: "Due Tomorrow")
    /// %@ of %@ assignments complete
    public static func progressCompleted(_ p1: Any, _ p2: Any) -> String {
      return CourseLocalization.tr("Localizable", "COURSE.PROGRESS_COMPLETED", String(describing: p1), String(describing: p2), fallback: "%@ of %@ assignments complete")
    }
    public enum LargestDownloads {
      /// Done
      public static let done = CourseLocalization.tr("Localizable", "COURSE.LARGEST_DOWNLOADS.DONE", fallback: "Done")
      /// Edit
      public static let edit = CourseLocalization.tr("Localizable", "COURSE.LARGEST_DOWNLOADS.EDIT", fallback: "Edit")
      /// Remove all downloads
      public static let removeDownloads = CourseLocalization.tr("Localizable", "COURSE.LARGEST_DOWNLOADS.REMOVE_DOWNLOADS", fallback: "Remove all downloads")
      /// Largest Downloads
      public static let title = CourseLocalization.tr("Localizable", "COURSE.LARGEST_DOWNLOADS.TITLE", fallback: "Largest Downloads")
    }
    public enum Offline {
      /// %@%% of this course can be completed offline.
      public static func canBeCompleted(_ p1: Any) -> String {
        return CourseLocalization.tr("Localizable", "COURSE.OFFLINE.CAN_BE_COMPLETED", String(describing: p1), fallback: "%@%% of this course can be completed offline.")
      }
      /// Cancel Course Download
      public static let cancelCourseDownload = CourseLocalization.tr("Localizable", "COURSE.OFFLINE.CANCEL_COURSE_DOWNLOAD", fallback: "Cancel Course Download")
      /// Download all
      public static let downloadAll = CourseLocalization.tr("Localizable", "COURSE.OFFLINE.DOWNLOAD_ALL", fallback: "Download all")
      /// %@%% of this course is downloadable.
      public static func downloadable(_ p1: Any) -> String {
        return CourseLocalization.tr("Localizable", "COURSE.OFFLINE.DOWNLOADABLE", String(describing: p1), fallback: "%@%% of this course is downloadable.")
      }
      /// %@%% of this course is visible on mobile.
      public static func visible(_ p1: Any) -> String {
        return CourseLocalization.tr("Localizable", "COURSE.OFFLINE.VISIBLE", String(describing: p1), fallback: "%@%% of this course is visible on mobile.")
      }
      /// You can download course content offline to learn on the go, without requiring an active internet connection or using mobile data.
      public static let youCanDownload = CourseLocalization.tr("Localizable", "COURSE.OFFLINE.YOU_CAN_DOWNLOAD", fallback: "You can download course content offline to learn on the go, without requiring an active internet connection or using mobile data.")
      /// None of this course’s content is currently avaliable to download offline.
      public static let youCantDownload = CourseLocalization.tr("Localizable", "COURSE.OFFLINE.YOU_CANT_DOWNLOAD", fallback: "None of this course’s content is currently avaliable to download offline.")
    }
    public enum TotalProgress {
      /// Available to Download
      public static let avaliableToDownload = CourseLocalization.tr("Localizable", "COURSE.TOTAL_PROGRESS.AVALIABLE_TO_DOWNLOAD", fallback: "Available to Download")
      /// Downloaded
      public static let downloaded = CourseLocalization.tr("Localizable", "COURSE.TOTAL_PROGRESS.DOWNLOADED", fallback: "Downloaded")
      /// Downloading
      public static let downloading = CourseLocalization.tr("Localizable", "COURSE.TOTAL_PROGRESS.DOWNLOADING", fallback: "Downloading")
      /// Ready to Download
      public static let readyToDownload = CourseLocalization.tr("Localizable", "COURSE.TOTAL_PROGRESS.READY_TO_DOWNLOAD", fallback: "Ready to Download")
    }
  }
  public enum Courseware {
    /// Back to outline
    public static let backToOutline = CourseLocalization.tr("Localizable", "COURSEWARE.BACK_TO_OUTLINE", fallback: "Back to outline")
    /// Continue
    public static let `continue` = CourseLocalization.tr("Localizable", "COURSEWARE.CONTINUE", fallback: "Continue")
    /// Course content
    public static let courseContent = CourseLocalization.tr("Localizable", "COURSEWARE.COURSE_CONTENT", fallback: "Course content")
    /// Course units
    public static let courseUnits = CourseLocalization.tr("Localizable", "COURSEWARE.COURSE_UNITS", fallback: "Course units")
    /// Finish
    public static let finish = CourseLocalization.tr("Localizable", "COURSEWARE.FINISH", fallback: "Finish")
    /// Good job!
    public static let goodWork = CourseLocalization.tr("Localizable", "COURSEWARE.GOOD_WORK", fallback: "Good job!")
    /// “.
    public static let isFinished = CourseLocalization.tr("Localizable", "COURSEWARE.IS_FINISHED", fallback: "“.")
    /// Next
    public static let next = CourseLocalization.tr("Localizable", "COURSEWARE.NEXT", fallback: "Next")
    /// Prev
    public static let previous = CourseLocalization.tr("Localizable", "COURSEWARE.PREVIOUS", fallback: "Prev")
    /// Resume with:
    public static let resumeWith = CourseLocalization.tr("Localizable", "COURSEWARE.RESUME_WITH", fallback: "Resume with:")
    /// You've completed “
    public static let section = CourseLocalization.tr("Localizable", "COURSEWARE.SECTION", fallback: "You've completed “")
  }
  public enum CourseCarousel {
    /// All Content
    public static let allContent = CourseLocalization.tr("Localizable", "COURSE_CAROUSEL.ALL_CONTENT", fallback: "All Content")
    /// Grades
    public static let grades = CourseLocalization.tr("Localizable", "COURSE_CAROUSEL.GRADES", fallback: "Grades")
    /// This represents your weighted grade against the grade needed to pass this course.
    public static let gradesDescription = CourseLocalization.tr("Localizable", "COURSE_CAROUSEL.GRADES_DESCRIPTION", fallback: "This represents your weighted grade against the grade needed to pass this course.")
    /// You have completed %@%% of the course progress
    public static func progressCompletion(_ p1: Any) -> String {
      return CourseLocalization.tr("Localizable", "COURSE_CAROUSEL.PROGRESS_COMPLETION", String(describing: p1), fallback: "You have completed %@%% of the course progress")
    }
  }
  public enum CourseContainer {
    /// Dates
    public static let dates = CourseLocalization.tr("Localizable", "COURSE_CONTAINER.DATES", fallback: "Dates")
    /// Discussions
    public static let discussions = CourseLocalization.tr("Localizable", "COURSE_CONTAINER.DISCUSSIONS", fallback: "Discussions")
    /// More
    public static let handouts = CourseLocalization.tr("Localizable", "COURSE_CONTAINER.HANDOUTS", fallback: "More")
    /// Handouts In developing
    public static let handoutsInDeveloping = CourseLocalization.tr("Localizable", "COURSE_CONTAINER.HANDOUTS_IN_DEVELOPING", fallback: "Handouts In developing")
    /// Home
    public static let home = CourseLocalization.tr("Localizable", "COURSE_CONTAINER.HOME", fallback: "Home")
    /// Offline
    public static let offline = CourseLocalization.tr("Localizable", "COURSE_CONTAINER.OFFLINE", fallback: "Offline")
    /// Progress
    public static let progress = CourseLocalization.tr("Localizable", "COURSE_CONTAINER.PROGRESS", fallback: "Progress")
    /// Videos
    public static let videos = CourseLocalization.tr("Localizable", "COURSE_CONTAINER.VIDEOS", fallback: "Videos")
    public enum Progress {
      /// Assignment Type
      public static let assignmentType = CourseLocalization.tr("Localizable", "COURSE_CONTAINER.PROGRESS.ASSIGNMENT_TYPE", fallback: "Assignment Type")
      /// Complete
      public static let complete = CourseLocalization.tr("Localizable", "COURSE_CONTAINER.PROGRESS.COMPLETE", fallback: "Complete")
      /// Completed
      public static let completed = CourseLocalization.tr("Localizable", "COURSE_CONTAINER.PROGRESS.COMPLETED", fallback: "Completed")
      /// Current / Max %%
      public static let currentMaxPercent = CourseLocalization.tr("Localizable", "COURSE_CONTAINER.PROGRESS.CURRENT_MAX_PERCENT", fallback: "Current / Max %%")
      /// Current Overall Weighted Grade:
      public static let currentOverallWeightedGrade = CourseLocalization.tr("Localizable", "COURSE_CONTAINER.PROGRESS.CURRENT_OVERALL_WEIGHTED_GRADE", fallback: "Current Overall Weighted Grade:")
      /// This represents how much of the course content you have completed. Note that some content may not yet be released.
      public static let description = CourseLocalization.tr("Localizable", "COURSE_CONTAINER.PROGRESS.DESCRIPTION", fallback: "This represents how much of the course content you have completed. Note that some content may not yet be released.")
      /// Grade Details
      public static let gradeDetails = CourseLocalization.tr("Localizable", "COURSE_CONTAINER.PROGRESS.GRADE_DETAILS", fallback: "Grade Details")
      /// Grade Progress
      public static let gradeProgress = CourseLocalization.tr("Localizable", "COURSE_CONTAINER.PROGRESS.GRADE_PROGRESS", fallback: "Grade Progress")
      /// Locked
      public static let locked = CourseLocalization.tr("Localizable", "COURSE_CONTAINER.PROGRESS.LOCKED", fallback: "Locked")
      /// This course does not contain graded assignments.
      public static let noGradedAssignments = CourseLocalization.tr("Localizable", "COURSE_CONTAINER.PROGRESS.NO_GRADED_ASSIGNMENTS", fallback: "This course does not contain graded assignments.")
      /// No progress available
      public static let noProgressAvailable = CourseLocalization.tr("Localizable", "COURSE_CONTAINER.PROGRESS.NO_PROGRESS_AVAILABLE", fallback: "No progress available")
      /// Not Passing
      public static let notPassing = CourseLocalization.tr("Localizable", "COURSE_CONTAINER.PROGRESS.NOT_PASSING", fallback: "Not Passing")
      /// of Grade
      public static let ofGrade = CourseLocalization.tr("Localizable", "COURSE_CONTAINER.PROGRESS.OF_GRADE", fallback: "of Grade")
      /// Overall Grade
      public static let overallGrade = CourseLocalization.tr("Localizable", "COURSE_CONTAINER.PROGRESS.OVERALL_GRADE", fallback: "Overall Grade")
      /// This represents your weighted grade against the grade needed to pass this course.
      public static let overallGradeDescription = CourseLocalization.tr("Localizable", "COURSE_CONTAINER.PROGRESS.OVERALL_GRADE_DESCRIPTION", fallback: "This represents your weighted grade against the grade needed to pass this course.")
      /// Overall Progress
      public static let overallProgress = CourseLocalization.tr("Localizable", "COURSE_CONTAINER.PROGRESS.OVERALL_PROGRESS", fallback: "Overall Progress")
      /// Passing
      public static let passing = CourseLocalization.tr("Localizable", "COURSE_CONTAINER.PROGRESS.PASSING", fallback: "Passing")
      /// Remaining
      public static let remaining = CourseLocalization.tr("Localizable", "COURSE_CONTAINER.PROGRESS.REMAINING", fallback: "Remaining")
      /// Required
      public static let `required` = CourseLocalization.tr("Localizable", "COURSE_CONTAINER.PROGRESS.REQUIRED", fallback: "Required")
      /// Sections Progress
      public static let sectionsProgress = CourseLocalization.tr("Localizable", "COURSE_CONTAINER.PROGRESS.SECTIONS_PROGRESS", fallback: "Sections Progress")
      /// Start learning to see your progress here
      public static let startLearning = CourseLocalization.tr("Localizable", "COURSE_CONTAINER.PROGRESS.START_LEARNING", fallback: "Start learning to see your progress here")
      /// Course Completion
      public static let title = CourseLocalization.tr("Localizable", "COURSE_CONTAINER.PROGRESS.TITLE", fallback: "Course Completion")
      /// View Certificate
      public static let viewCertificate = CourseLocalization.tr("Localizable", "COURSE_CONTAINER.PROGRESS.VIEW_CERTIFICATE", fallback: "View Certificate")
      /// A weighted grade of %@%% is required to pass this course
      public static func weightedGradeRequired(_ p1: Any) -> String {
        return CourseLocalization.tr("Localizable", "COURSE_CONTAINER.PROGRESS.WEIGHTED_GRADE_REQUIRED", String(describing: p1), fallback: "A weighted grade of %@%% is required to pass this course")
      }
    }
  }
  public enum CourseDates {
    /// Would you like to add the %@ calendar "%@" ? 
    ///  You can edit or remove the course calendar any time in Calendar or Settings
    public static func addCalendarPrompt(_ p1: Any, _ p2: Any) -> String {
      return CourseLocalization.tr("Localizable", "COURSE_DATES.ADD_CALENDAR_PROMPT", String(describing: p1), String(describing: p2), fallback: "Would you like to add the %@ calendar \"%@\" ? \n You can edit or remove the course calendar any time in Calendar or Settings")
    }
    /// Add calendar
    public static let addCalendarTitle = CourseLocalization.tr("Localizable", "COURSE_DATES.ADD_CALENDAR_TITLE", fallback: "Add calendar")
    /// Calendar events
    public static let calendarEvents = CourseLocalization.tr("Localizable", "COURSE_DATES.CALENDAR_EVENTS", fallback: "Calendar events")
    /// Your course calendar has been added.
    public static let calendarEventsAdded = CourseLocalization.tr("Localizable", "COURSE_DATES.CALENDAR_EVENTS_ADDED", fallback: "Your course calendar has been added.")
    /// Your course calendar has been removed.
    public static let calendarEventsRemoved = CourseLocalization.tr("Localizable", "COURSE_DATES.CALENDAR_EVENTS_REMOVED", fallback: "Your course calendar has been removed.")
    /// Your course calendar has been updated.
    public static let calendarEventsUpdated = CourseLocalization.tr("Localizable", "COURSE_DATES.CALENDAR_EVENTS_UPDATED", fallback: "Your course calendar has been updated.")
    /// Your course calendar is out of date
    public static let calendarOutOfDate = CourseLocalization.tr("Localizable", "COURSE_DATES.CALENDAR_OUT_OF_DATE", fallback: "Your course calendar is out of date")
    /// %@ does not have calendar permission. Please go to settings and give calender permission.
    public static func calendarPermissionNotDetermined(_ p1: Any) -> String {
      return CourseLocalization.tr("Localizable", "COURSE_DATES.CALENDAR_PERMISSION_NOT_DETERMINED", String(describing: p1), fallback: "%@ does not have calendar permission. Please go to settings and give calender permission.")
    }
    /// Your course dates have been shifted and your course calendar is no longer up to date with your new schedule.
    public static let calendarShiftMessage = CourseLocalization.tr("Localizable", "COURSE_DATES.CALENDAR_SHIFT_MESSAGE", fallback: "Your course dates have been shifted and your course calendar is no longer up to date with your new schedule.")
    /// Update now
    public static let calendarShiftPromptUpdateNow = CourseLocalization.tr("Localizable", "COURSE_DATES.CALENDAR_SHIFT_PROMPT_UPDATE_NOW", fallback: "Update now")
    /// Syncing calendar...
    public static let calendarSyncMessage = CourseLocalization.tr("Localizable", "COURSE_DATES.CALENDAR_SYNC_MESSAGE", fallback: "Syncing calendar...")
    /// View Events
    public static let calendarViewEvents = CourseLocalization.tr("Localizable", "COURSE_DATES.CALENDAR_VIEW_EVENTS", fallback: "View Events")
    /// Completed
    public static let completed = CourseLocalization.tr("Localizable", "COURSE_DATES.COMPLETED", fallback: "Completed")
    /// "%@" has been added to your calendar.
    public static func datesAddedAlertMessage(_ p1: Any) -> String {
      return CourseLocalization.tr("Localizable", "COURSE_DATES.DATES_ADDED_ALERT_MESSAGE", String(describing: p1), fallback: "\"%@\" has been added to your calendar.")
    }
    /// Due next
    public static let dueNext = CourseLocalization.tr("Localizable", "COURSE_DATES.DUE_NEXT", fallback: "Due next")
    /// Item Hidden
    public static let itemHidden = CourseLocalization.tr("Localizable", "COURSE_DATES.ITEM_HIDDEN", fallback: "Item Hidden")
    /// Items Hidden
    public static let itemsHidden = CourseLocalization.tr("Localizable", "COURSE_DATES.ITEMS_HIDDEN", fallback: "Items Hidden")
    /// Open Settings
    public static let openSettings = CourseLocalization.tr("Localizable", "COURSE_DATES.OPEN_SETTINGS", fallback: "Open Settings")
    /// Past due
    public static let pastDue = CourseLocalization.tr("Localizable", "COURSE_DATES.PAST_DUE", fallback: "Past due")
    /// Would you like to remove the %@ calendar "%@" ?
    public static func removeCalendarPrompt(_ p1: Any, _ p2: Any) -> String {
      return CourseLocalization.tr("Localizable", "COURSE_DATES.REMOVE_CALENDAR_PROMPT", String(describing: p1), String(describing: p2), fallback: "Would you like to remove the %@ calendar \"%@\" ?")
    }
    /// Remove calendar
    public static let removeCalendarTitle = CourseLocalization.tr("Localizable", "COURSE_DATES.REMOVE_CALENDAR_TITLE", fallback: "Remove calendar")
    /// Settings
    public static let settings = CourseLocalization.tr("Localizable", "COURSE_DATES.SETTINGS", fallback: "Settings")
    /// Sync to calendar
    public static let syncToCalendar = CourseLocalization.tr("Localizable", "COURSE_DATES.SYNC_TO_CALENDAR", fallback: "Sync to calendar")
    /// Automatically sync all deadlines and due dates for this course to your calendar.
    public static let syncToCalendarMessage = CourseLocalization.tr("Localizable", "COURSE_DATES.SYNC_TO_CALENDAR_MESSAGE", fallback: "Automatically sync all deadlines and due dates for this course to your calendar.")
    /// Your due dates have been successfully shifted to help you stay on track.
    public static let toastSuccessMessage = CourseLocalization.tr("Localizable", "COURSE_DATES.TOAST_SUCCESS_MESSAGE", fallback: "Your due dates have been successfully shifted to help you stay on track.")
    /// Due dates shifted
    public static let toastSuccessTitle = CourseLocalization.tr("Localizable", "COURSE_DATES.TOAST_SUCCESS_TITLE", fallback: "Due dates shifted")
    /// Today
    public static let today = CourseLocalization.tr("Localizable", "COURSE_DATES.TODAY", fallback: "Today")
    /// Unreleased
    public static let unreleased = CourseLocalization.tr("Localizable", "COURSE_DATES.UNRELEASED", fallback: "Unreleased")
    /// Verified Only
    public static let verifiedOnly = CourseLocalization.tr("Localizable", "COURSE_DATES.VERIFIED_ONLY", fallback: "Verified Only")
    /// View all dates
    public static let viewAllDates = CourseLocalization.tr("Localizable", "COURSE_DATES.VIEW_ALL_DATES", fallback: "View all dates")
    public enum ResetDate {
      /// Your dates could not be shifted. Please try again.
      public static let errorMessage = CourseLocalization.tr("Localizable", "COURSE_DATES.RESET_DATE.ERROR_MESSAGE", fallback: "Your dates could not be shifted. Please try again.")
      /// Your dates have been successfully shifted.
      public static let successMessage = CourseLocalization.tr("Localizable", "COURSE_DATES.RESET_DATE.SUCCESS_MESSAGE", fallback: "Your dates have been successfully shifted.")
      /// Course Dates
      public static let title = CourseLocalization.tr("Localizable", "COURSE_DATES.RESET_DATE.TITLE", fallback: "Course Dates")
    }
  }
  public enum Download {
    /// All videos downloaded
    public static let allVideosDownloaded = CourseLocalization.tr("Localizable", "DOWNLOAD.ALL_VIDEOS_DOWNLOADED", fallback: "All videos downloaded")
    /// You cannot change the download video quality when all videos are downloading
    public static let changeQualityAlert = CourseLocalization.tr("Localizable", "DOWNLOAD.CHANGE_QUALITY_ALERT", fallback: "You cannot change the download video quality when all videos are downloading")
    /// Download to device
    public static let downloadToDevice = CourseLocalization.tr("Localizable", "DOWNLOAD.DOWNLOAD_TO_DEVICE", fallback: "Download to device")
    /// Downloading videos...
    public static let downloadingVideos = CourseLocalization.tr("Localizable", "DOWNLOAD.DOWNLOADING_VIDEOS", fallback: "Downloading videos...")
    /// Downloads
    public static let downloads = CourseLocalization.tr("Localizable", "DOWNLOAD.DOWNLOADS", fallback: "Downloads")
    /// Your current download settings only allow downloads over Wi-Fi.
    /// Please connect to a Wi-Fi network or change your download settings.
    public static let noWifiMessage = CourseLocalization.tr("Localizable", "DOWNLOAD.NO_WIFI_MESSAGE", fallback: "Your current download settings only allow downloads over Wi-Fi.\nPlease connect to a Wi-Fi network or change your download settings.")
    /// Remaining
    public static let remaining = CourseLocalization.tr("Localizable", "DOWNLOAD.REMAINING", fallback: "Remaining")
    /// Total
    public static let total = CourseLocalization.tr("Localizable", "DOWNLOAD.TOTAL", fallback: "Total")
    /// Untitled
    public static let untitled = CourseLocalization.tr("Localizable", "DOWNLOAD.UNTITLED", fallback: "Untitled")
    /// Videos
    public static let videos = CourseLocalization.tr("Localizable", "DOWNLOAD.VIDEOS", fallback: "Videos")
  }
  public enum Error {
    /// There are currently no announcements for this course.
    public static let announcementsUnavailable = CourseLocalization.tr("Localizable", "ERROR.ANNOUNCEMENTS_UNAVAILABLE", fallback: "There are currently no announcements for this course.")
    /// Course component not found, please reload
    public static let componentNotFount = CourseLocalization.tr("Localizable", "ERROR.COMPONENT_NOT_FOUNT", fallback: "Course component not found, please reload")
    /// Course dates are not currently available.
    public static let courseDateUnavailable = CourseLocalization.tr("Localizable", "ERROR.COURSE_DATE_UNAVAILABLE", fallback: "Course dates are not currently available.")
    /// No course content is currently available.
    public static let coursewareUnavailable = CourseLocalization.tr("Localizable", "ERROR.COURSEWARE_UNAVAILABLE", fallback: "No course content is currently available.")
    /// There are currently no handouts for this course.
    public static let handoutsUnavailable = CourseLocalization.tr("Localizable", "ERROR.HANDOUTS_UNAVAILABLE", fallback: "There are currently no handouts for this course.")
    /// You are not connected to the Internet. Please check your Internet connection.
    public static let noInternet = CourseLocalization.tr("Localizable", "ERROR.NO_INTERNET", fallback: "You are not connected to the Internet. Please check your Internet connection.")
    /// Reload
    public static let reload = CourseLocalization.tr("Localizable", "ERROR.RELOAD", fallback: "Reload")
    /// There are currently no vidoes for this course.
    public static let videosUnavailable = CourseLocalization.tr("Localizable", "ERROR.VIDEOS_UNAVAILABLE", fallback: "There are currently no vidoes for this course.")
  }
  public enum HandoutsCellAnnouncements {
    /// Keep up with the latest news
    public static let description = CourseLocalization.tr("Localizable", "HANDOUTS_CELL_ANNOUNCEMENTS.DESCRIPTION", fallback: "Keep up with the latest news")
    /// Announcements
    public static let title = CourseLocalization.tr("Localizable", "HANDOUTS_CELL_ANNOUNCEMENTS.TITLE", fallback: "Announcements")
  }
  public enum HandoutsCellHandouts {
    /// Find important course information
    public static let description = CourseLocalization.tr("Localizable", "HANDOUTS_CELL_HANDOUTS.DESCRIPTION", fallback: "Find important course information")
    /// Handouts
    public static let title = CourseLocalization.tr("Localizable", "HANDOUTS_CELL_HANDOUTS.TITLE", fallback: "Handouts")
  }
  public enum NotAvaliable {
    /// Open in browser
    public static let button = CourseLocalization.tr("Localizable", "NOT_AVALIABLE.BUTTON", fallback: "Open in browser")
    /// Explore other parts of this course or view this on web.
    public static let description = CourseLocalization.tr("Localizable", "NOT_AVALIABLE.DESCRIPTION", fallback: "Explore other parts of this course or view this on web.")
    /// This interactive component isn't available on mobile
    public static let title = CourseLocalization.tr("Localizable", "NOT_AVALIABLE.TITLE", fallback: "This interactive component isn't available on mobile")
  }
  public enum Offline {
    public enum NotAvaliable {
      /// Explore other parts of this course or view this when you reconnect.
      public static let description = CourseLocalization.tr("Localizable", "OFFLINE.NOT_AVALIABLE.DESCRIPTION", fallback: "Explore other parts of this course or view this when you reconnect.")
      /// This component is not yet available offline
      public static let title = CourseLocalization.tr("Localizable", "OFFLINE.NOT_AVALIABLE.TITLE", fallback: "This component is not yet available offline")
    }
    public enum NotDownloaded {
      /// Explore other parts of this course or download this when you reconnect.
      public static let description = CourseLocalization.tr("Localizable", "OFFLINE.NOT_DOWNLOADED.DESCRIPTION", fallback: "Explore other parts of this course or download this when you reconnect.")
      /// This component is not downloaded
      public static let title = CourseLocalization.tr("Localizable", "OFFLINE.NOT_DOWNLOADED.TITLE", fallback: "This component is not downloaded")
    }
  }
  public enum Outline {
    /// Certificate
    public static let certificate = CourseLocalization.tr("Localizable", "OUTLINE.CERTIFICATE", fallback: "Certificate")
    /// This course hasn't started yet.
    public static let courseHasntStarted = CourseLocalization.tr("Localizable", "OUTLINE.COURSE_HASNT_STARTED", fallback: "This course hasn't started yet.")
    /// Course videos
    public static let courseVideos = CourseLocalization.tr("Localizable", "OUTLINE.COURSE_VIDEOS", fallback: "Course videos")
    /// Localizable.strings
    ///   Course
    /// 
    ///   Created by  Stepanok Ivan on 26.09.2022.
    public static func passedTheCourse(_ p1: Any) -> String {
      return CourseLocalization.tr("Localizable", "OUTLINE.PASSED_THE_COURSE", String(describing: p1), fallback: "Congratulations, you have earned this course certificate in “%@.”")
    }
    /// View certificate
    public static let viewCertificate = CourseLocalization.tr("Localizable", "OUTLINE.VIEW_CERTIFICATE", fallback: "View certificate")
  }
  public enum Subtitles {
    /// Subtitles
    public static let title = CourseLocalization.tr("Localizable", "SUBTITLES.TITLE", fallback: "Subtitles")
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension CourseLocalization {
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
