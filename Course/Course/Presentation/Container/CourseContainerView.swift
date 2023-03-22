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
    private var courseBanner: String
    private var certificate: Certificate?
    
    public enum CourseTab {
        case course
        case videos
        case discussion
        case handounds
    }
    
    public init(
        viewModel: CourseContainerViewModel,
        courseID: String,
        title: String,
        courseBanner: String,
        certificate: Certificate?
    ) {
        self.viewModel = viewModel
        Task {
            await viewModel.getCourseBlocks(courseID: courseID)
        }
        self.courseID = courseID
        self.title = title
        self.courseBanner = courseBanner
        self.certificate = certificate
    }
    
    public var body: some View {
        if let courseStart = viewModel.courseStart {
            if courseStart > Date() {
                CourseOutlineView(
                    viewModel: viewModel,
                    title: title,
                    courseBanner: courseBanner,
                    certificate: certificate,
                    courseID: courseID,
                    isVideo: false
                )
            } else {
                TabView(selection: $selection) {
                    CourseOutlineView(
                        viewModel: self.viewModel,
                        title: title,
                        courseBanner: courseBanner,
                        certificate: certificate,
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
                        courseBanner: courseBanner,
                        certificate: certificate,
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
                                         viewModel: Container.shared.resolve(DiscussionTopicsViewModel.self)!,
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
            }
        }
    }
}

#if DEBUG
struct CourseScreensView_Previews: PreviewProvider {
    static var previews: some View {
        CourseContainerView(
            viewModel: CourseContainerViewModel(
                interactor: CourseInteractor.mock,
                router: CourseRouterMock(),
                config: ConfigMock(),
                connectivity: Connectivity(),
                manager: DownloadManagerMock(),
                isActive: true,
                courseStart: nil,
                courseEnd: nil,
                enrollmentStart: nil,
                enrollmentEnd: nil
            ),
            courseID: "", title: "Title of Course", courseBanner: "", certificate: nil)
    }
}
#endif
