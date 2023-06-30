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
    
    @ObservedObject
    private var viewModel: CourseContainerViewModel
    @State private var selection: CourseTab = .course
    private var courseID: String
    private var title: String
    
    public enum CourseTab {
        case course
        case videos
        case discussion
        case handounds
    }
    
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
        ZStack {
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
                        .hideNavigationBar()
                        
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
                        .hideNavigationBar()
                        
                        DiscussionTopicsView(courseID: courseID,
                                             viewModel: Container.shared.resolve(DiscussionTopicsViewModel.self,
                                                                                 argument: title)!,
                                             router: Container.shared.resolve(DiscussionRouter.self)!)
                        .tabItem {
                            CoreAssets.bubbleLeftCircle.swiftUIImage.renderingMode(.template)
                            Text(CourseLocalization.CourseContainer.discussion)
                        }
                        .tag(CourseTab.discussion)
                        .hideNavigationBar()
                        
                        HandoutsView(courseID: courseID,
                                     viewModel: Container.shared.resolve(HandoutsViewModel.self, argument: courseID)!)
                        .tabItem {
                            CoreAssets.docCircle.swiftUIImage.renderingMode(.template)
                            Text(CourseLocalization.CourseContainer.handouts)
                        }
                        .tag(CourseTab.handounds)
                        .hideNavigationBar()
                    }
                    .navigationBarHidden(true)
                    .introspectViewController { vc in
                        vc.navigationController?.setNavigationBarHidden(true, animated: false)
                    }
                    .onFirstAppear {
                        Task {
                            await viewModel.tryToRefreshCookies()
                        }
                    }
                }
            }
        }.onChange(of: selection, perform: { selection in
            switch selection {
            case .course:
                viewModel.analyticsManager.courseOutlineCourseTabClicked(courseId: courseID,
                                                                         courseName: title)
            case .videos:
                viewModel.analyticsManager.courseOutlineVideosTabClicked(courseId: courseID,
                                                                         courseName: title)
            case .discussion:
                viewModel.analyticsManager.courseOutlineDiscussionTabClicked(courseId: courseID,
                                                                             courseName: title)
            case .handounds:
                viewModel.analyticsManager.courseOutlineHandoutsTabClicked(courseId: courseID,
                                                                           courseName: title)
            }
        })
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
                analyticsManager: CourseAnalyticsMock(),
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
