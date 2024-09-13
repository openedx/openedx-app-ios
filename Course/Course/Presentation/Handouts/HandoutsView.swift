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
    @Binding private var viewHeight: CGFloat
    
    @StateObject
    private var viewModel: HandoutsViewModel
    
    public init(
        courseID: String,
        coordinate: Binding<CGFloat>,
        collapsed: Binding<Bool>,
        viewHeight: Binding<CGFloat>,
        viewModel: HandoutsViewModel
    ) {
        self.courseID = courseID
        self._coordinate = coordinate
        self._collapsed = collapsed
        self._viewHeight = viewHeight
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
                            collapsed: $collapsed,
                            viewHeight: $viewHeight
                        )
                        if viewModel.isShowProgress {
                            HStack(alignment: .center) {
                                ProgressBar(size: 40, lineWidth: 8)
                                    .padding(.top, 200)
                                    .padding(.horizontal)
                            }
                        } else {
                            VStack(alignment: .leading) {
                                HandoutsItemCell(type: .handouts, onTapAction: { type in
                                    viewModel.router.showHandoutsUpdatesView(
                                        handouts: viewModel.handouts,
                                        announcements: nil,
                                        router: viewModel.router,
                                        cssInjector: viewModel.cssInjector,
                                        type: type
                                    )
                                    viewModel.analytics.trackCourseScreenEvent(
                                        .courseHandouts,
                                        biValue: .courseHandouts,
                                        courseID: courseID
                                    )
                                })
                                Divider()
                                    .frame(height: 1)
                                    .overlay(Theme.Colors.cardViewStroke)
                                    .accessibilityIdentifier("divider")
                                HandoutsItemCell(type: .announcements, onTapAction: { type in
                                    viewModel.router.showHandoutsUpdatesView(
                                        handouts: nil,
                                        announcements: viewModel.updates,
                                        router: viewModel.router,
                                        cssInjector: viewModel.cssInjector,
                                        type: type
                                    )
                                    viewModel.analytics.trackCourseScreenEvent(
                                        .courseAnnouncement,
                                        biValue: .courseAnnouncement,
                                        courseID: courseID
                                    )
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
            viewHeight: .constant(0),
            viewModel: viewModel
        )
    }
}
#endif

public enum HandoutsItemType: String {
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

struct HandoutsItemCell: View {
    private let type: HandoutsItemType
    private let onTapAction: (HandoutsItemType) -> Void
    
    public init(type: HandoutsItemType, onTapAction: @escaping (HandoutsItemType) -> Void) {
        self.type = type
        self.onTapAction = onTapAction
    }
    
    public var body: some View {
        Button(action: {
            onTapAction(type)
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
                    .resizable()
                    .flipsForRightToLeftLayoutDirection(true)
                    .frame(width: 7, height: 12)
                    .foregroundColor(Theme.Colors.accentColor)
            }
        }).padding(.vertical, 16)
        
    }
}
