//
//  AllContentView.swift
//  Course
//
//  Created by  Stepanok Ivan on 24.06.2025.
//

import SwiftUI
import Core
import OEXFoundation
import Kingfisher
import Theme

struct AllContentView: View {
    
    @StateObject private var viewModel: CourseContainerViewModel
    private let title: String
    private let courseID: String
    private let dateTabIndex: Int
    
    private let proxy: GeometryProxy
    @State private var expandedChapters: [String: Bool] = [:]
    @State private var showingDownloads: Bool = false
    @State private var showingVideoDownloadQuality: Bool = false
    @State private var showingNoWifiMessage: Bool = false
    
    init(
        viewModel: CourseContainerViewModel,
        proxy: GeometryProxy,
        title: String,
        courseID: String,
        dateTabIndex: Int
    ) {
        self.title = title
        self._viewModel = StateObject(wrappedValue: { viewModel }())
        self.proxy = proxy
        self.courseID = courseID
        self.dateTabIndex = dateTabIndex
    }
    
    var body: some View {
            VStack(spacing: 0) {
                // MARK: - Error View
                if viewModel.showError {
                    VStack {
                        SnackBarView(message: viewModel.errorMessage)
                    }
                    .transition(.move(edge: .bottom))
                    .onAppear {
                        doAfter(Theme.Timeout.snackbarMessageLongTimeout) {
                            viewModel.errorMessage = nil
                        }
                    }
                }
                
                ZStack(alignment: .center) {
                    // MARK: - Page Body
                    if viewModel.isShowProgress && !viewModel.isShowRefresh {
                        HStack(alignment: .center) {
                            ProgressBar(size: 40, lineWidth: 8)
                                .padding(.top, 200)
                                .padding(.horizontal)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        VStack(alignment: .leading) {
                            if let course = viewModel.courseStructure {
                                
                                Spacer(minLength: 16)
                                // MARK: Course Progress
                                if let progress = course.courseProgress,
                                   progress.totalAssignmentsCount != 0 {
                                    CourseProgressView(progress: progress)
                                        .padding(.horizontal, 24)
                                }
                                Spacer(minLength: 16)
                                
                                // MARK: Continue Unit
                                if let continueWith = viewModel.continueWith,
                                   let courseStructure = viewModel.courseStructure {
                                    let chapter = courseStructure.childs[continueWith.chapterIndex]
                                    let sequential = chapter.childs[continueWith.sequentialIndex]
                                    let continueUnit = sequential.childs[continueWith.verticalIndex]
                                    
                                    ContinueWithView(
                                        data: continueWith,
                                        courseContinueUnit: continueUnit
                                    ) {
                                        viewModel.openLastVisitedBlock()
                                    }
                                }
                                
                                // MARK: - Sections
                                CustomDisclosureGroup(
                                    course: course,
                                    proxy: proxy,
                                    viewModel: viewModel
                                )
                                
                            } else {
                                if let courseStart = viewModel.courseStart {
                                    Text(
                                        courseStart > Date()
                                        ? CourseLocalization.Outline.courseHasntStarted
                                        : ""
                                    )
                                    .frame(maxWidth: .infinity)
                                    .frame(maxHeight: .infinity)
                                    .padding(.top, 100)
                                }
                            }
                            Spacer(minLength: 200)
                        }
                    }
                }
            }
        .onReceive(NotificationCenter.default.publisher(for: .onBlockCompletion)) { _ in
            Task {
                await viewModel.getCourseBlocks(courseID: courseID, withProgress: false)
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}

#if DEBUG
#Preview {
    let viewModel = CourseContainerViewModel(
        interactor: CourseInteractor.mock,
        authInteractor: AuthInteractor.mock,
        router: CourseRouterMock(),
        analytics: CourseAnalyticsMock(),
        config: ConfigMock(),
        connectivity: Connectivity(),
        manager: DownloadManagerMock(),
        storage: CourseStorageMock(),
        isActive: true,
        courseStart: Date(),
        courseEnd: nil,
        enrollmentStart: Date(),
        enrollmentEnd: nil,
        lastVisitedBlockID: nil,
        coreAnalytics: CoreAnalyticsMock(),
        courseHelper: CourseDownloadHelper(courseStructure: nil, manager: DownloadManagerMock())
    )
    
    GeometryReader { proxy in
        AllContentView(
            viewModel: viewModel,
            proxy: proxy,
            title: "Course title",
            courseID: "",
            dateTabIndex: 2
        )
    }
}
#endif
