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

public struct CourseContainerView: View {
    
    enum CourseTab {
        case course
        case videos
        case discussion
        case handounds
    }
    
    @ObservedObject
    private var viewModel: CourseContainerViewModel
    @State private var selection: CourseTab = .course
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
            if let courseStart = viewModel.courseStart {
                if courseStart > Date() {
                    CourseOutlineView(
                        viewModel: viewModel,
                        title: title,
                        courseID: courseID,
                        isVideo: false
                    )
                } else {
                    TabView(selection: $selection) {
                        CourseOutlineView(
                            viewModel: self.viewModel,
                            title: title,
                            courseID: courseID,
                            isVideo: false
                        )
                        .tabItem {
                            CoreAssets.bookCircle.swiftUIImage.renderingMode(.template)
                            Text(CourseLocalization.CourseContainer.course)
                        }
                        .tag(CourseTab.course)
                        
                        CourseOutlineView(
                            viewModel: self.viewModel,
                            title: title,
                            courseID: courseID,
                            isVideo: true
                        )
                        .tabItem {
                            CoreAssets.videoCircle.swiftUIImage.renderingMode(.template)
                            Text(CourseLocalization.CourseContainer.videos)
                        }
                        .tag(CourseTab.videos)
                        
                        CourseDatesView(courseID: courseID,
                                        viewModel: Container.shared.resolve(CourseDatesViewModel.self,
                                                                            argument: courseID)!)
                        .tabItem {
                            CoreAssets.bookCircle.swiftUIImage.renderingMode(.template)
                            Text("Dates")
                        }
                        .tag("Dates")
                        
                        DiscussionTopicsView(courseID: courseID,
                                             viewModel: Container.shared.resolve(DiscussionTopicsViewModel.self,
                                                                                 argument: title)!,
                                             router: Container.shared.resolve(DiscussionRouter.self)!)
                        .tabItem {
                            CoreAssets.bubbleLeftCircle.swiftUIImage.renderingMode(.template)
                            Text(CourseLocalization.CourseContainer.discussion)
                        }
                        .tag(CourseTab.discussion)
                        
                        HandoutsView(courseID: courseID,
                                     viewModel: Container.shared.resolve(HandoutsViewModel.self, argument: courseID)!)
                        .tabItem {
                            CoreAssets.docCircle.swiftUIImage.renderingMode(.template)
                            Text(CourseLocalization.CourseContainer.handouts)
                        }
                        .tag(CourseTab.handounds)
                    }
                    .onFirstAppear {
                        Task {
                            await viewModel.tryToRefreshCookies()
                        }
                    }
                }
            }
        }
        .navigationBarHidden(false)
        .navigationBarBackButtonHidden(false)
        .navigationTitle(titleBar())
        .onChange(of: selection, perform: { selection in
            viewModel.trackSelectedTab(
                selection: selection,
                courseId: courseID,
                courseName: title
            )
        })
    }
    
    private func titleBar() -> String {
        switch selection {
        case .course:
            return self.title
        case .videos:
            return self.title
        case .discussion:
            return DiscussionLocalization.title
        case .handounds:
            return CourseLocalization.CourseContainer.handouts
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
