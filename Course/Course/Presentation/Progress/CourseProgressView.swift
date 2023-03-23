//Only for the tutorial, don't disable linter it in the real project.
// swiftlint:disable all
//
//  CourseProgressView.swift
//  Course
//
//  Created by Vladimir Chekyrta on 22.03.2023.
//

import SwiftUI
import Core
import Kingfisher

public struct CourseProgressView: View {
    
    @ObservedObject
    private var viewModel: CourseProgressViewModel
    private var title: String
    private var courseBanner: String
    
    public init(
        viewModel: CourseProgressViewModel,
        title: String,
        courseBanner: String
    ) {
        self.viewModel = viewModel
        self.title = title
        self.courseBanner = courseBanner
        
        Task {
            await viewModel.getProgress()
        }
    }
    
    public var body: some View {
        ZStack(alignment: .top) {
            VStack(alignment: .center) {
                NavigationBar(
                    title: title,
                    leftButtonAction: { viewModel.router.back() }
                )
                
                // MARK: - Page Body
                RefreshableScrollViewCompat(action: {
                    await viewModel.getProgress(withProgress: isIOS14)
                }) {
                    ///A view that arranges its subviews in a vertical line.
                    VStack(alignment: .leading) {
                        //Start implementation
                        Text("Implementation here")
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                        //TODO Course banner
                        
                        //TODO ProgressBar
                        
                        if let progress = viewModel.progress {
                            ///LazyVStack - VStack that doesn’t create items until it needs to render them onscreen.
                            LazyVStack(alignment: .leading) {
                                //TODO Overall course progress
                                
                                //TODO CourseProgressBar
                                
                                let sections = Array(progress.sections.enumerated())
                                ///Use ForEach to provide views based on a RandomAccessCollection.
                                ForEach(sections, id: \.offset) { _, section in
                                    //TODO Section View
                                    
                                    let subsections = Array(section.subsections.enumerated())
                                    ForEach(subsections, id: \.offset) { _, subsection in
                                        //TODO Subsection View
                                    }
                                }
                            }
                        }
                    }
                }
            }.frameLimit()
                .onRightSwipeGesture {
                    viewModel.router.back()
                }
            
            // MARK: - Error Alert
            if viewModel.showError {
                VStack {
                    Spacer()
                    SnackBarView(message: viewModel.errorMessage)
                }
                .transition(.move(edge: .bottom))
                .onAppear {
                    doAfter(Theme.Timeout.snackbarMessageLongTimeout) {
                        viewModel.errorMessage = nil
                    }
                }
            }
        }.background(
            CoreAssets.background.swiftUIColor.ignoresSafeArea()
        )
    }
}

struct CourseProgressView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = CourseProgressViewModel(
            courseID: "courseID",
            interactor: CourseInteractor.mock,
            router: CourseRouterMock()
        )
        
        return Group {
            CourseProgressView(
                viewModel: viewModel,
                title: "Course For Conf",
                courseBanner: ""
            )
            .preferredColorScheme(.light)
            .previewDisplayName("CourseProgressView Light")
            
            CourseProgressView(
                viewModel: viewModel,
                title: "Course For Conf",
                courseBanner: ""
            )
            .preferredColorScheme(.dark)
            .previewDisplayName("CourseProgressView Dark")
        }.onAppear {
            Task {
                await viewModel.getProgress()
            }
        }
    }
}
