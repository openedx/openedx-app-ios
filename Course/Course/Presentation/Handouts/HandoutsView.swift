//
//  HandoutsView.swift
//  Course
//
//  Created by  Stepanok Ivan on 27.02.2023.
//

import SwiftUI
import Core
import Theme

struct HandoutsView: View {
    
    private let courseID: String
    @Binding private var coordinate: CGFloat
    @Binding private var collapsed: Bool
    
    @StateObject
    private var viewModel: HandoutsViewModel
    
    public init(
        courseID: String,
        coordinate: Binding<CGFloat>,
        collapsed: Binding<Bool>,
        viewModel: HandoutsViewModel
    ) {
        self.courseID = courseID
        self._coordinate = coordinate
        self._collapsed = collapsed
        self._viewModel = StateObject(wrappedValue: { viewModel }())
    }
    
    public var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .top) {
                VStack(alignment: .center) {
                    // MARK: - Page Body
                    ScrollView {
                        DynamicOffsetView(
                            coordinate: $coordinate,
                            collapsed: $collapsed
                        )
                        if viewModel.isShowProgress {
                            HStack(alignment: .center) {
                                ProgressBar(size: 40, lineWidth: 8)
                                    .padding(.top, 200)
                                    .padding(.horizontal)
                            }
                        } else {
                            VStack(alignment: .leading) {
                                HandoutsItemCell(type: .handouts, onTapAction: {
                                    viewModel.router.showHandoutsUpdatesView(
                                        handouts: viewModel.handouts,
                                        announcements: nil,
                                        router: viewModel.router,
                                        cssInjector: viewModel.cssInjector)
                                    viewModel.analytics.trackCourseEvent(
                                        .courseHandouts,
                                        biValue: .courseHandouts,
                                        courseID: courseID
                                    )
                                })
                                Divider()
                                HandoutsItemCell(type: .announcements, onTapAction: {
                                    if !viewModel.updates.isEmpty {
                                        viewModel.router.showHandoutsUpdatesView(
                                            handouts: nil,
                                            announcements: viewModel.updates,
                                            router: viewModel.router,
                                            cssInjector: viewModel.cssInjector)
                                        viewModel.analytics.trackCourseEvent(
                                            .courseAnnouncement,
                                            biValue: .courseAnnouncement,
                                            courseID: courseID
                                        )
                                    }
                                })
                            }.padding(.horizontal, 32)
                            Spacer(minLength: 84)
                        }
                    }
                }
                .frameLimit(width: proxy.size.width)
                // MARK: - Offline mode SnackBar
                OfflineSnackBarView(
                    connectivity: viewModel.connectivity,
                    reloadAction: {
                        Task {
                            await viewModel.getHandouts(courseID: courseID)
                            await viewModel.getUpdates(courseID: courseID)
                        }
                    }
                )
                
                // MARK: - Error Alert
                if viewModel.showError {
                    VStack {
                        Spacer()
                        SnackBarView(message: viewModel.errorMessage)
                    }
                    .padding(.bottom, viewModel.connectivity.isInternetAvaliable
                             ? 0 : OfflineSnackBarView.height)
                    .transition(.move(edge: .bottom))
                    .onAppear {
                        doAfter(Theme.Timeout.snackbarMessageLongTimeout) {
                            viewModel.errorMessage = nil
                        }
                    }
                }
            }
            
            .onFirstAppear {
                Task {
                    await viewModel.getHandouts(courseID: courseID)
                    await viewModel.getUpdates(courseID: courseID)
                }
            }
            .background(
                Theme.Colors.background
                    .ignoresSafeArea()
            )
        }
    }
}

#if DEBUG
struct HandoutsView_Previews: PreviewProvider {
    static var previews: some View {
        
        let viewModel = HandoutsViewModel(interactor: CourseInteractor.mock,
                                          router: CourseRouterMock(),
                                          cssInjector: CSSInjectorMock(),
                                          connectivity: Connectivity(),
                                          courseID: "",
                                          analytics: CourseAnalyticsMock())
        HandoutsView(
            courseID: "",
            coordinate: .constant(0),
            collapsed: .constant(false),
            viewModel: viewModel
        )
    }
}
#endif

struct HandoutsItemCell: View {
    
    enum ItemType {
        case handouts
        case announcements
        
        var title: String {
            switch self {
            case .handouts:
                return CourseLocalization.HandoutsCellHandouts.title
            case .announcements:
                return CourseLocalization.HandoutsCellAnnouncements.title
            }
        }
        
        var description: String {
            switch self {
            case .handouts:
                return CourseLocalization.HandoutsCellHandouts.description
            case .announcements:
                return CourseLocalization.HandoutsCellAnnouncements.description
            }
        }
        
        var image: Image {
            switch self {
            case .handouts:
                return CoreAssets.handouts.swiftUIImage
            case .announcements:
                return CoreAssets.announcements.swiftUIImage
            }
        }
    }
    
    private let type: ItemType
    private let onTapAction: () -> Void
    
    public init(type: ItemType, onTapAction: @escaping () -> Void) {
        self.type = type
        self.onTapAction = onTapAction
    }
    
    public var body: some View {
        Button(action: {
            onTapAction()
        }, label: {
            HStack(spacing: 12) {
                type.image.renderingMode(.template)
                    .foregroundColor(Theme.Colors.textPrimary)
                    .frame(width: 24, height: 24)
                VStack(alignment: .leading) {
                    Text(type.title)
                        .foregroundColor(Theme.Colors.textPrimary)
                        .font(Theme.Fonts.titleSmall)
                    Text(type.description)
                        .foregroundColor(Theme.Colors.textSecondary)
                        .font(Theme.Fonts.labelSmall)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .flipsForRightToLeftLayoutDirection(true)
                    .resizable()
                    .frame(width: 7, height: 12)
                    .foregroundColor(Theme.Colors.accentColor)
            }
        }).padding(.vertical, 16)
        
    }
}
