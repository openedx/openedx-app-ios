//
//  DateCell.swift
//  AppDates
//
//  Created by Ivan Stepanok on 15.02.2025.
//

import SwiftUI
import Theme
import Core

public struct DateCell: View, Equatable {
    
    nonisolated public static func == (lhs: DateCell, rhs: DateCell) -> Bool {
        return lhs.courseDate.location == rhs.courseDate.location
    }
    
    private let courseDate: CourseDate
    private let isFirst: Bool
    private let isLast: Bool
    private let groupType: DateGroupType
    
    public init(
        courseDate: CourseDate,
        groupType: DateGroupType,
        isFirst: Bool = false,
        isLast: Bool = false
    ) {
        self.courseDate = courseDate
        self.groupType = groupType
        self.isFirst = isFirst
        self.isLast = isLast
    }
    
    public var body: some View {
        HStack(spacing: 0) {
            Rectangle()
                .fill(groupType.color)
                .frame(width: 8)
                .clipShape(
                    .rect(
                        topLeadingRadius: isFirst ? 4 : 0,
                        bottomLeadingRadius: isLast ? 4 : 0,
                        bottomTrailingRadius: isLast ? 4 : 0,
                        topTrailingRadius: isFirst ? 4 : 0
                    )
                )
            
            HStack(alignment: .center) {
                VStack(alignment: .leading) {
                    if !courseDate.date.isToday {
                        Text(courseDate.date.dateToString(style: .shortWeekdayMonthDayYear, useRelativeDates: true))
                            .font(Theme.Fonts.labelMedium)
                            .foregroundColor(Theme.Colors.textPrimary)
                    }
                    HStack {
                        CoreAssets.assignmentIcon.swiftUIImage
                        Text(courseDate.title)
                            .font(Theme.Fonts.titleMedium)
                            .lineLimit(1)
                            .multilineTextAlignment(.leading)
                    }
                    .foregroundColor(Theme.Colors.textPrimary)
                    
                    Text(courseDate.courseName)
                        .font(Theme.Fonts.labelMedium)
                        .foregroundColor(Theme.Colors.textSecondaryLight)
                }
                
                .padding(.leading, 12)
                Spacer()
                CoreAssets.chevronRight.swiftUIImage
                    .flipsForRightToLeftLayoutDirection(true)
                    .foregroundColor(Theme.Colors.textPrimary)
            }
            .padding(.vertical, 8)
        }
    }
}

#if DEBUG
#Preview {
    DateCell(
        courseDate: CourseDate(
            location: "123",
            date: Date(),
            title: "Assignment Title",
            courseName: "Course Name"
        ),
        groupType: .pastDue
    )
}
#endif
