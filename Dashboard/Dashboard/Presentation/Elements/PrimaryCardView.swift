//
//  PrimaryCardView.swift
//  Dashboard
//
//  Created by  Stepanok Ivan on 16.04.2024.
//

import SwiftUI
import Kingfisher
import Theme
import Core

public struct PrimaryCardView: View {
    
    private let courseName: String
    private let org: String
    private let courseImage: String
    private let courseStartDate: Date?
    private let courseEndDate: Date?
    private var futureAssignments: [Assignment]
    private let pastAssignments: [Assignment]
    private let progressEarned: Int
    private let progressPossible: Int
    private let canResume: Bool
    private let resumeTitle: String?
    private var assignmentAction: (String?) -> Void
    private var openCourseAction: () -> Void
    private var resumeAction: () -> Void
    
    public init(
        courseName: String,
        org: String,
        courseImage: String,
        courseStartDate: Date?,
        courseEndDate: Date?,
        futureAssignments: [Assignment],
        pastAssignments: [Assignment],
        progressEarned: Int,
        progressPossible: Int,
        canResume: Bool,
        resumeTitle: String?,
        assignmentAction: @escaping (String?) -> Void,
        openCourseAction: @escaping () -> Void,
        resumeAction: @escaping () -> Void
    ) {
        self.courseName = courseName
        self.org = org
        self.courseImage = courseImage
        self.courseStartDate = courseStartDate
        self.courseEndDate = courseEndDate
        self.futureAssignments = futureAssignments
        self.pastAssignments = pastAssignments
        self.progressEarned = progressEarned
        self.progressPossible = progressPossible
        self.canResume = canResume
        self.resumeTitle = resumeTitle
        self.assignmentAction = assignmentAction
        self.openCourseAction = openCourseAction
        self.resumeAction = resumeAction
    }
    
    public var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 0) {
                Group {
                    courseBanner
                    ProgressLineView(progressEarned: progressEarned, progressPossible: progressPossible)
                    courseTitle
                }
                .onTapGesture {
                    openCourseAction()
                }
                assignments
            }
        }
        .background(Theme.Colors.background)
        .cornerRadius(8)
        .shadow(color: Theme.Colors.courseCardShadow, radius: 4, x: 0, y: 3)
        .padding(20)
    }
    
    private var assignments: some View {
        VStack(alignment: .leading, spacing: 8) {
            // pastAssignments
            if pastAssignments.count == 1, let pastAssignment = pastAssignments.first {
                courseButton(
                    title: pastAssignment.title,
                    description: DashboardLocalization.Learn.PrimaryCard.onePastAssignment,
                    icon: CoreAssets.warning.swiftUIImage,
                    selected: false,
                    action: { assignmentAction(pastAssignments.first?.firstComponentBlockId) }
                )
            } else if pastAssignments.count > 1 {
                courseButton(
                    title: DashboardLocalization.Learn.PrimaryCard.viewAssignments,
                    description: DashboardLocalization.Learn.PrimaryCard.pastAssignments(pastAssignments.count),
                    icon: CoreAssets.warning.swiftUIImage,
                    selected: false,
                    action: { assignmentAction(nil) }
                )
            }
            
            // futureAssignment
            if !futureAssignments.isEmpty {
                if futureAssignments.count == 1, let futureAssignment = futureAssignments.first {
                    let daysRemaining = Calendar.current.dateComponents(
                        [.day],
                        from: Date(),
                        to: futureAssignment.date
                    ).day ?? 0
                    courseButton(
                        title: futureAssignment.title,
                        description: DashboardLocalization.Learn.PrimaryCard.dueDays(
                            futureAssignment.type,
                            daysRemaining
                        ),
                        icon: CoreAssets.chapter.swiftUIImage,
                        selected: false,
                        action: {
                            assignmentAction(futureAssignments.first?.firstComponentBlockId)
                        }
                    )
                } else if futureAssignments.count > 1 {
                    if let firtsData = futureAssignments.sorted(by: { $0.date < $1.date }).first {
                        courseButton(
                            title: DashboardLocalization.Learn.PrimaryCard.futureAssignments(
                                futureAssignments.count,
                                firtsData.date.dateToString(style: .lastPost)
                            ),
                            description: nil,
                            icon: CoreAssets.chapter.swiftUIImage,
                            selected: false,
                            action: {
                                assignmentAction(nil)
                            }
                        )
                    }
                }
            }
            
            // ResumeButton
            if canResume {
                courseButton(
                    title: resumeTitle ?? "",
                    description: DashboardLocalization.Learn.PrimaryCard.resume,
                    icon: CoreAssets.resumeCourse.swiftUIImage,
                    selected: true,
                    action: { resumeAction() }
                )
            } else {
                courseButton(
                    title: DashboardLocalization.Learn.PrimaryCard.startCourse,
                    description: nil,
                    icon: CoreAssets.resumeCourse.swiftUIImage,
                    selected: true,
                    action: { resumeAction() }
                )
            }
        }
    }
    
    private func courseButton(
        title: String,
        description: String?,
        icon: Image,
        selected: Bool,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: {
            action()
        }, label: {
            ZStack(alignment: .top) {
                Rectangle().frame(height: selected ? 0 : 1)
                    .foregroundStyle(Theme.Colors.cardViewStroke)
                HStack(alignment: .center) {
                    VStack(alignment: .leading) {
                        HStack(spacing: 0) {
                            icon
                                .renderingMode(.template)
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundStyle(
                                    selected ? Theme.Colors.white : Theme.Colors.textPrimary
                                )
                                .padding(12)
                            
                            VStack(alignment: .leading, spacing: 6) {
                                if let description {
                                    Text(description)
                                        .font(Theme.Fonts.labelSmall)
                                        .multilineTextAlignment(.leading)
                                        .lineLimit(1)
                                        .foregroundStyle(selected ? Theme.Colors.white : Theme.Colors.textPrimary)
                                }
                                Text(title)
                                    .font(Theme.Fonts.titleSmall)
                                    .multilineTextAlignment(.leading)
                                    .lineLimit(1)
                                    .foregroundStyle(selected ? Theme.Colors.white : Theme.Colors.textPrimary)
                            }
                            .padding(.top, 2)
                        }
                    }
                    Spacer()
                    CoreAssets.chevronRight.swiftUIImage
                        .foregroundStyle(selected ? Theme.Colors.white : Theme.Colors.textPrimary)
                        .padding(8)
                }
                .padding(.top, 8)
                .padding(.bottom, selected ? 10 : 0)
            }.background(selected ? Theme.Colors.accentColor : .clear)
        })
    }
    
    private var courseBanner: some View {
        return KFImage(URL(string: courseImage))
            .onFailureImage(CoreAssets.noCourseImage.image)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(height: 140)
            .clipped()
            .accessibilityElement(children: .ignore)
            .accessibilityIdentifier("course_image")
    }
    
    private var courseTitle: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(org)
                .font(Theme.Fonts.labelMedium)
                .foregroundStyle(Theme.Colors.textSecondaryLight)
            Text(courseName)
                .font(Theme.Fonts.titleLarge)
                .foregroundStyle(Theme.Colors.textPrimary)
                .lineLimit(3)
            if let courseEndDate {
                Text(courseEndDate.dateToString(style: .courseEndsMonthDDYear))
                    .font(Theme.Fonts.labelMedium)
                    .foregroundStyle(Theme.Colors.textSecondaryLight)
            } else if let courseStartDate {
                Text(courseStartDate.dateToString(style: .courseStartsMonthDDYear))
                    .font(Theme.Fonts.labelMedium)
                    .foregroundStyle(Theme.Colors.textSecondaryLight)
            }
        }
        .padding(.top, 10)
        .padding(.horizontal, 12)
        .padding(.bottom, 16)
    }
}

#if DEBUG
struct PrimaryCardView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Theme.Colors.background
            PrimaryCardView(
                courseName: "Course Title",
                org: "Organization",
                courseImage: "https://thumbs.dreamstime.com/b/logo-edx-samsung-tablet-edx-massive-open-online-course-mooc-provider-hosts-online-university-level-courses-wide-117763805.jpg",
                courseStartDate: nil,
                courseEndDate: Date(),
                futureAssignments: [],
                pastAssignments: [],
                progressEarned: 10,
                progressPossible: 45,
                canResume: true,
                resumeTitle: "Course Chapter 1",
                assignmentAction: {_ in },
                openCourseAction: {},
                resumeAction: {}
            )
            .loadFonts()
        }
    }
}
#endif
