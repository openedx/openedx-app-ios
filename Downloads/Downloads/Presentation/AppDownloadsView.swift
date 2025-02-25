//
//  AppDownloadsView.swift
//  Downloads
//
//  Created by Ivan Stepanok on 22.02.2025.
//

import SwiftUI
import Theme
import OEXFoundation
import Core

// swiftlint:disable line_length
public struct AppDownloadsView: View {
    
    @Environment(\.isHorizontal) private var isHorizontal
    private var idiom: UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    
    @State private var courses: [CourseDemoModel] = [
        CourseDemoModel(
            course_id: "my_course_id_2024",
               course_name: "My Course 2024",
               course_banner: "https://axim-mobile.raccoongang.net/asset-v1:OpenedX+DemoX+DemoCourse+type@asset+block@thumbnail_demox.jpeg",
               total_size: 20_531_502
        ),
        CourseDemoModel(
            course_id: "another_course_2025",
               course_name: "Another Course 2025",
               course_banner: "https://axim-mobile.raccoongang.net/asset-v1:OpenedX+DemoX+DemoCourse+type@asset+block@thumbnail_demox.jpeg",
               total_size: 15_000_000
        )
    ]

    @State private var downloadedSizes: [String: Int] = [:]
    
    private func columns() -> [GridItem] {
        isHorizontal || idiom == .pad
        ? [
            GridItem(.flexible(), spacing: 0),
            GridItem(.flexible(), spacing: 0)
        ]
        : [
            GridItem(.flexible(), spacing: 0)
        ]
    }
    
    public init() {}

    public var body: some View {
        GeometryReader { proxy in
            ZStack {
                Theme.Colors.background
                    .ignoresSafeArea()
                ScrollView {
                    StyledButton(
                        "Manage Download Settings",
                        action: {},
                        color: .clear,
                        textColor: Theme.Colors.accentColor,
                        borderColor: Theme.Colors.accentColor
                    )
                    .padding(.horizontal, 16)
                    .padding(.top, 1)
                    .padding(.bottom, 16)
                    
                    LazyVGrid(columns: columns(), spacing: 16) {
                        ForEach(courses) { course in
                            DownloadCourseCell(
                                course: course,
                                downloadedSize: Binding(
                                    get: { downloadedSizes[course.course_id] ?? 0 },
                                    set: { downloadedSizes[course.course_id] = $0 }
                                ),
                                onDownloadTap: {
                                    let current = downloadedSizes[course.course_id] ?? 0
                                    let newValue = min(current + 2_000_000, course.total_size)
                                    downloadedSizes[course.course_id] = newValue
                                },
                                onRemoveTap: {
                                    downloadedSizes[course.course_id] = 0
                                }, onCancelTap: {
                                    downloadedSizes[course.course_id] = 0
                                }
                            )
                        }
                    }
                    Spacer(minLength: 100)
                }
                .frameLimit(width: proxy.size.width)
                .accessibilityAction {}
                .padding(.top, 8)
                .navigationBarHidden(false)
                .navigationBarBackButtonHidden(false)
                .navigationTitle("Downloads")
            }
        }
    }
}

#Preview {
    AppDownloadsView()
}
// swiftlint:enable line_length
