//
//  CourseCardView.swift
//  Dashboard
//
//  Created by  Stepanok Ivan on 17.04.2024.
//

import SwiftUI
import Theme
import Kingfisher
import Core

struct CourseCardView: View {
    
    private let courseName: String
    private let courseImage: String
    private let progressEarned: Int
    private let progressPossible: Int
    private let courseStartDate: Date?
    private let courseEndDate: Date?
    private let hasAccess: Bool
    private let showProgress: Bool
    private let useRelativeDates: Bool
    
    init(
        courseName: String,
        courseImage: String,
        progressEarned: Int,
        progressPossible: Int,
        courseStartDate: Date?,
        courseEndDate: Date?,
        hasAccess: Bool,
        showProgress: Bool,
        useRelativeDates: Bool
    ) {
        self.courseName = courseName
        self.courseImage = courseImage
        self.progressEarned = progressEarned
        self.progressPossible = progressPossible
        self.courseStartDate = courseStartDate
        self.courseEndDate = courseEndDate
        self.hasAccess = hasAccess
        self.showProgress = showProgress
        self.useRelativeDates = useRelativeDates
    }
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(alignment: .leading, spacing: 0) {
                courseBanner
                if showProgress {
                    ProgressLineView(
                        progressEarned: progressEarned,
                        progressPossible: progressPossible,
                        height: 4
                    )
                }
                courseTitle
            }
            if !hasAccess {
                ZStack(alignment: .center) {
                    Circle()
                        .foregroundStyle(Theme.Colors.primaryHeaderColor)
                        .opacity(0.7)
                        .frame(width: 24, height: 24)
                    CoreAssets.lockIcon.swiftUIImage
                        .foregroundStyle(Theme.Colors.textPrimary)
                }
                .padding(8)
            }
        }
        .background(Theme.Colors.courseCardBackground)
        .cornerRadius(8)
        .shadow(color: Theme.Colors.courseCardShadow, radius: 6, x: 2, y: 2)
    }
    
    private var courseBanner: some View {
        return KFImage(URL(string: courseImage))
            .onFailureImage(CoreAssets.noCourseImage.image)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(minWidth: 120, minHeight: 90, maxHeight: 100)
            .clipped()
            .accessibilityElement(children: .ignore)
            .accessibilityIdentifier("course_image")
    }
    
    private var courseTitle: some View {
        VStack(alignment: .leading, spacing: 3) {
            if let courseEndDate {
                Text(courseEndDate.dateToString(style: .courseEndsMonthDDYear, useRelativeDates: useRelativeDates))
                    .font(Theme.Fonts.labelSmall)
                    .foregroundStyle(Theme.Colors.textSecondaryLight)
                    .multilineTextAlignment(.leading)
            } else if let courseStartDate {
                Text(courseStartDate.dateToString(style: .courseStartsMonthDDYear, useRelativeDates: useRelativeDates))
                    .font(Theme.Fonts.labelSmall)
                    .foregroundStyle(Theme.Colors.textSecondaryLight)
                    .multilineTextAlignment(.leading)
            }
            Text(courseName)
                .font(Theme.Fonts.labelMedium)
                .foregroundStyle(Theme.Colors.textPrimary)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
        }
        .frame(height: showProgress ? 51 : 40, alignment: .topLeading)
        .fixedSize(horizontal: false, vertical: true)
        .padding(.top, 10)
        .padding(.horizontal, 12)
        .padding(.bottom, 16)
    }
}

//swiftlint:disable line_length
#if DEBUG
#Preview {
    CourseCardView(
        courseName: "Six Sigma Part 2: Analyze, Improve, Control",
        courseImage: "https://thumbs.dreamstime.com/b/logo-edx-samsung-tablet-edx-massive-open-online-course-mooc-provider-hosts-online-university-level-courses-wide-117763805.jpg",
        progressEarned: 4,
        progressPossible: 8,
        courseStartDate: nil,
        courseEndDate: Date(),
        hasAccess: true,
        showProgress: true,
        useRelativeDates: true
    ).frame(width: 170)
}
#endif
//swiftlint:enable line_length
