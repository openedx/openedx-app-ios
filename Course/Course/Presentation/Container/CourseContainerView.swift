//
//  CourseScreensView.swift
//  Course
//
//  Created by  Stepanok Ivan on 10.10.2022.
//

import SwiftUI
import Core
import Discussion
import Swinject
import Theme

public struct CourseContainerView: View {
    
    enum CourseTab: Int, CaseIterable, Identifiable {
        var id: Int {
            rawValue
        }

        case course
        case videos
        case discussion
        case dates
        case handounds

        var title: String {
            switch self {
            case .course:
                return CourseLocalization.CourseContainer.course
            case .videos:
                return CourseLocalization.CourseContainer.videos
            case .dates:
                return CourseLocalization.CourseContainer.dates
            case .discussion:
                return CourseLocalization.CourseContainer.discussions
            case .handounds:
                return CourseLocalization.CourseContainer.handouts
            }
        }

        var image: Image {
            switch self {
            case .course:
                return CoreAssets.bookCircle.swiftUIImage.renderingMode(.template)
            case .videos:
                return CoreAssets.videoCircle.swiftUIImage.renderingMode(.template)
            case .dates:
                return Image(systemName: "calendar").renderingMode(.template)
            case .discussion:
                return  CoreAssets.bubbleLeftCircle.swiftUIImage.renderingMode(.template)
            case .handounds:
                return CoreAssets.docCircle.swiftUIImage.renderingMode(.template)
            }
        }

    }
    
    @ObservedObject
    private var viewModel: CourseContainerViewModel
    @State private var selection: Int = CourseTab.course.rawValue
    @State private var isAnimatingForTap: Bool = false
    private var courseID: String
    private var title: String
    
    public init(
        viewModel: CourseContainerViewModel,
        courseID: String,
        title: String
    ) {
        self.viewModel = viewModel
        Task {
            await viewModel.getCourseBlocks(courseID: courseID)
        }
        self.courseID = courseID
        self.title = title
    }
    
    public var body: some View {
        ZStack(alignment: .top) {
            content
        }
        .navigationBarHidden(false)
        .navigationBarBackButtonHidden(false)
        .navigationTitle(titleBar())
        .onChange(of: selection, perform: didSelect)
        .background(Theme.Colors.background)
    }

    @ViewBuilder
    private var content: some View {
        if let courseStart = viewModel.courseStart {
            if courseStart > Date() {
                CourseOutlineView(
                    viewModel: viewModel,
                    title: title,
                    courseID: courseID,
                    isVideo: false
                )
            } else {
                VStack(spacing: 0) {
                    if viewModel.config.uiComponents.courseTopTabBarEnabled {
                        topTabBar
                    }
                    tabs
                }
            }
        }
    }

    private var topTabBar: some View {
        ScrollSlidingTabBar(
            selection: $selection,
            tabs: CourseTab.allCases.map { $0.title }
        ) { newValue in
            isAnimatingForTap = true
            selection = newValue
            DispatchQueue.main.asyncAfter(deadline: .now().advanced(by: .milliseconds(300))) {
                isAnimatingForTap = false
            }
        }
    }

    private var tabs: some View {
        TabView(selection: $selection) {
            ForEach(CourseTab.allCases) { tab in
                switch tab {
                case .course:
                    CourseOutlineView(
                        viewModel: viewModel,
                        title: title,
                        courseID: courseID,
                        isVideo: false
                    )
                    .tabItem {
                        tab.image
                        Text(tab.title)
                    }
                    .tag(tab)
                    .accentColor(Theme.Colors.accentColor)
                case .videos:
                    CourseOutlineView(
                        viewModel: viewModel,
                        title: title,
                        courseID: courseID,
                        isVideo: true
                    )
                    .tabItem {
                        tab.image
                        Text(tab.title)
                    }
                    .tag(tab)
                    .accentColor(Theme.Colors.accentColor)
                case .dates:
                    CourseDatesView(
                        courseID: courseID,
                        viewModel: Container.shared.resolve(CourseDatesViewModel.self,
                                                            argument: courseID)!
                    )
                    .tabItem {
                        tab.image
                        Text(tab.title)
                    }
                    .tag(tab)
                    .accentColor(Theme.Colors.accentColor)
                case .discussion:
                    DiscussionTopicsView(
                        courseID: courseID,
                        viewModel: Container.shared.resolve(DiscussionTopicsViewModel.self,
                                                            argument: title)!,
                        router: Container.shared.resolve(DiscussionRouter.self)!
                    )
                    .tabItem {
                        tab.image
                        Text(tab.title)
                    }
                    .tag(tab)
                    .accentColor(Theme.Colors.accentColor)
                case .handounds:
                    HandoutsView(
                        courseID: courseID,
                        viewModel: Container.shared.resolve(HandoutsViewModel.self, argument: courseID)!
                    )
                    .tabItem {
                        tab.image
                        Text(tab.title)
                    }
                    .tag(tab)
                    .accentColor(Theme.Colors.accentColor)
                }
            }
        }
        .if(viewModel.config.uiComponents.courseTopTabBarEnabled) { view in
            view
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.default, value: selection)
        }
        .onFirstAppear {
            Task {
                await viewModel.tryToRefreshCookies()
            }
        }
    }

    private func didSelect(_ selection: Int) {
        CourseTab(rawValue: selection).flatMap {
            viewModel.trackSelectedTab(
                selection: $0,
                courseId: courseID,
                courseName: title
            )
        }
    }

    private func titleBar() -> String {
        switch CourseTab(rawValue: selection) {
        case .course:
            return self.title
        case .videos:
            return self.title
        case .dates:
            return CourseLocalization.CourseContainer.dates
        case .discussion:
            return DiscussionLocalization.title
        case .handounds:
            return CourseLocalization.CourseContainer.handouts
        default:
            return ""
        }
    }
}

#if DEBUG
struct CourseScreensView_Previews: PreviewProvider {
    static var previews: some View {
        CourseContainerView(
            viewModel: CourseContainerViewModel(
                interactor: CourseInteractor.mock,
                authInteractor: AuthInteractor.mock,
                router: CourseRouterMock(),
                analytics: CourseAnalyticsMock(),
                config: ConfigMock(),
                connectivity: Connectivity(),
                manager: DownloadManagerMock(),
                storage: CourseStorageMock(),
                isActive: true,
                courseStart: nil,
                courseEnd: nil,
                enrollmentStart: nil,
                enrollmentEnd: nil
            ),
            courseID: "", title: "Title of Course")
    }
}
#endif
