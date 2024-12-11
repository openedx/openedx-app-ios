//
//  CourseCellView.swift
//  Discovery
//
//  Created by  Stepanok Ivan on 15.09.2022.
//

import SwiftUI
import Kingfisher
import Theme

public enum CellType {
    case dashboard
    case discovery
}

public struct CourseCellView: View {
    
    @State private var showView = false
    private var courseImage: String
    private var courseName: String
    private var courseOrg: String
    private var courseStart: String
    private var courseEnd: String
    private var type: CellType
    private var index: Double
    private var cellsCount: Int
    private var idiom: UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    
    public init(model: CourseItem, type: CellType, index: Int, cellsCount: Int, useRelativeDates: Bool) {
        self.type = type
        self.courseImage = model.imageURL
        self.courseName = model.name
        self.courseStart = model.courseStart?.dateToString(
            style: .startDDMonthYear,
            useRelativeDates: useRelativeDates
        ) ?? ""
        self.courseEnd = model.courseEnd?.dateToString(
            style: .endedMonthDay,
            useRelativeDates: useRelativeDates
        ) ?? ""
        self.courseOrg =  model.org
        self.index = Double(index) + 1
        self.cellsCount = cellsCount
    }
    
    public var body: some View {
        VStack {
            HStack {
                KFImage(URL(string: courseImage))
                    .onFailureImage(CoreAssets.noCourseImage.image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: idiom == .pad ? 171 : 105, height: 105)
                    .cornerRadius(8)
                    .clipShape(RoundedRectangle(cornerRadius: Theme.Shapes.cardImageRadius))
                    .padding(.leading, 3)
                    .accessibilityElement(children: .ignore)
                    .accessibilityIdentifier("course_image")
                
                VStack(alignment: .leading) {
                    Text(courseOrg)
                        .font(Theme.Fonts.labelMedium)
                        .foregroundColor(Theme.Colors.textSecondary)
                        .multilineTextAlignment(.leading)
                        .accessibilityIdentifier("org_text")
                    
                    Text(courseName)
                        .font(Theme.Fonts.titleSmall)
                        .foregroundColor(Theme.Colors.textPrimary)
                        .lineLimit(type == .discovery ? 3 : 2)
                        .multilineTextAlignment(.leading)
                        .padding(.top, 1)
                        .accessibilityIdentifier("course_name_text")
                    Spacer()
                    if type == .dashboard {
                        HStack {
                            if courseEnd != "" {
                                Text(courseEnd)
                                    .font(Theme.Fonts.labelMedium)
                                    .foregroundColor(Theme.Colors.textSecondary)
                                    .accessibilityIdentifier("course_end_text")
                            } else {
                                Text(courseStart)
                                    .font(Theme.Fonts.labelMedium)
                                    .foregroundColor(Theme.Colors.textSecondary)
                                    .accessibilityIdentifier("course_start_text")
                            }
                            Spacer()
                            CoreAssets.arrowRight16.swiftUIImage.renderingMode(.template)
                                .resizable()
                                .frame(width: 16, height: 16)
                                .offset(x: 15)
                                .foregroundColor(Theme.Colors.accentXColor)
                                .accessibilityIdentifier("arrow_image")
                        }
                    }
                }.padding(.horizontal, 10)
                    .padding(.vertical, type == .discovery ? 10 : 0)
                Spacer()
            }
            
        }.frame(height: 105)
            .background(Theme.Colors.background)
            .opacity(showView ? 1 : 0)
            .offset(y: showView ? 0 : 20)
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(
                courseName + " " + (
                    type == .dashboard
                    ? (courseEnd == "" ? courseStart : courseEnd)
                    : ""
                )
            )
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    withAnimation(.easeInOut(duration: (index <= 5 ? 0.3 : 0.1))
                        .delay((index <= 5 ? index : 0) * 0.05)) {
                            showView = true
                        }
                }
            }
        
        VStack {
            if Int(index) != cellsCount {
                Divider()
                    .frame(height: 1)
                    .overlay(Theme.Colors.cardViewStroke)
                    .padding(.vertical, 18)
                    .padding(.horizontal, 3)
                    .accessibilityIdentifier("divider")
            }
        }
    }
}

// swiftlint:disable all
struct CourseCellView_Previews: PreviewProvider {
    
    private static let course = CourseItem(
        name: "Demonstration Course with extra long name who contains tree lines",
        org: "Edx",
        shortDescription: "",
        imageURL: "https://thumbs.dreamstime.com/b/logo-edx-samsung-tablet-edx-massive-open-online-course-mooc-provider-hosts-online-university-level-courses-wide-117763805.jpg",
        hasAccess: true,
        courseStart: Date(iso8601: "2032-05-26T12:13:14Z"),
        courseEnd: Date(iso8601: "2033-05-26T12:13:14Z"),
        enrollmentStart: nil,
        enrollmentEnd: nil,
        courseID: "1",
        numPages: 1,
        coursesCount: 10,
        courseRawImage: nil,
        progressEarned: 4,
        progressPossible: 10
    )
    
    static var previews: some View {
        ZStack {
            Color.red
                .ignoresSafeArea()
            VStack(spacing: 0) {
//                Divider()
                CourseCellView(model: course, type: .discovery, index: 1, cellsCount: 3, useRelativeDates: true)
                    .previewLayout(.fixed(width: 180, height: 260))
//                Divider()
                CourseCellView(model: course, type: .discovery, index: 2, cellsCount: 3, useRelativeDates: false)
                    .previewLayout(.fixed(width: 180, height: 260))
//                Divider()
            }
        }
    }
}
// swiftlint:enable all
