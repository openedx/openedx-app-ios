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
                        //Course banner
                        KFImage(URL(string: courseBanner))
                            .onFailureImage(CoreAssets.noCourseImage.image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(maxHeight: 250)
                            .cornerRadius(12)
                            .padding(.horizontal, 6)
                            .padding(.top, 7)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        //ProgressBar
                        if viewModel.isShowProgress {
                            ProgressBar(size: 40, lineWidth: 8)
                                .padding(.top, 50)
                                .frame(maxWidth: .infinity)
                        }
                        
                        if let progress = viewModel.progress {
                            ///LazyVStack - VStack that doesn’t create items until it needs to render them onscreen.
                            LazyVStack(alignment: .leading) {
                                //Overall course progress
                                HStack {
                                    Text("Overall course progress")
                                        .font(Theme.Fonts.titleMedium)
                                        .foregroundColor(CoreAssets.textPrimary.swiftUIColor)
                                    
                                    Spacer()
                                    
                                    Text("\(progress.progress)%")
                                        .font(Theme.Fonts.titleMedium)
                                        .foregroundColor(CoreAssets.textPrimary.swiftUIColor)
                                }.padding(.horizontal, 20)
                                    .padding(.top, 20)
                                
                                //CourseProgressBar
                                CourseProgressBar(progress: progress.progress)
                                    .frame(height: 20)
                                    .padding(.horizontal, 20)
                                    .padding(.bottom, 20)
                                
                                let sections = Array(progress.sections.enumerated())
                                ///Use ForEach to provide views based on a RandomAccessCollection.
                                ForEach(sections, id: \.offset) { _, section in
                                    //Section View
                                    VStack(alignment: .leading) {
                                        Text(section.displayName)
                                            .font(Theme.Fonts.bodyLarge)
                                            .foregroundColor(CoreAssets.textPrimary.swiftUIColor)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .padding(.horizontal, 20)
                                            .padding(.vertical, 5)
                                            .background(CoreAssets.accentColor.swiftUIColor.opacity(0.5))
                                        
                                        let subsections = Array(section.subsections.enumerated())
                                        ForEach(subsections, id: \.offset) { _, subsection in
                                            //Subsection View
                                            CourseSubsectionView(subsection: subsection)
                                        }.padding(.horizontal, 20)
                                    }
                                }
                                
                                Spacer()
                                    .frame(height: 20)
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
