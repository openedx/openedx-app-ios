//
//  CourseScreensView.swift
//  Course
//
//  Created by  Stepanok Ivan on 10.10.2022.
//

import SwiftUI
import Core
import Discussion
import Swinject
import Theme

public struct CourseContainerView: View {
    
    @ObservedObject
    public var viewModel: CourseContainerViewModel
    @State private var isAnimatingForTap: Bool = false
    public var courseID: String
    private var title: String
    @State private var ignoreOffset: Bool = false
    @State private var coordinate: CGFloat = .zero
    @State private var lastCoordinate: CGFloat = .zero
    @State private var collapsed: Bool = false
    @Environment(\.isHorizontal) private var isHorizontal
    @Namespace private var animationNamespace
    private var idiom: UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    
    private let coordinateBoundaryLower: CGFloat = -115
    private let coordinateBoundaryHigher: CGFloat = 40
    
    private struct GeometryName {
        static let backButton = "backButton"
        static let topTabBar = "topTabBar"
        static let blurSecondaryBg = "blurSecondaryBg"
        static let blurPrimaryBg = "blurPrimaryBg"
        static let blurBg = "blurBg"
    }
    
    public init(
        viewModel: CourseContainerViewModel,
        courseID: String,
        title: String
    ) {
        self.viewModel = viewModel
        Task {
            await withTaskGroup(of: Void.self) { group in
                group.addTask {
                    await viewModel.getCourseBlocks(courseID: courseID)
                }
                group.addTask {
                    await viewModel.getCourseDeadlineInfo(courseID: courseID, withProgress: false)
                }
            }
        }
        self.courseID = courseID
        self.title = title
    }
    
    public var body: some View {
        ZStack(alignment: .top) {
            content
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .navigationTitle(title)
        .onChange(of: viewModel.selection, perform: didSelect)
        .onChange(of: coordinate, perform: collapseHeader)
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
                    isVideo: false,
                    selection: $viewModel.selection,
                    coordinate: $coordinate,
                    collapsed: $collapsed,
                    dateTabIndex: CourseTab.dates.rawValue
                )
            } else {
                ZStack(alignment: .top) {
                    tabs
                    GeometryReader { proxy in
                        VStack(spacing: 0) {
                            CourseHeaderView(
                                viewModel: viewModel,
                                title: title,
                                collapsed: $collapsed,
                                containerWidth: proxy.size.width,
                                animationNamespace: animationNamespace,
                                isAnimatingForTap: $isAnimatingForTap
                            )
                        }
                        .offset(
                            y: ignoreOffset
                            ? (collapsed ? coordinateBoundaryLower : .zero)
                            : ((coordinateBoundaryLower...coordinateBoundaryHigher).contains(coordinate)
                               ? coordinate
                               : (collapsed ? coordinateBoundaryLower : .zero))
                        )
                        backButton(containerWidth: proxy.size.width)
                    }
                }.ignoresSafeArea(edges: idiom == .pad ? .leading : .top)
                    .onAppear {
                        self.collapsed = isHorizontal
                    }
            }
        }
    }
    
    private func backButton(containerWidth: CGFloat) -> some View {
        ZStack(alignment: .topLeading) {
            if !collapsed {
                HStack {
                    ZStack(alignment: .bottom) {
                        VisualEffectView(effect: UIBlurEffect(style: .regular))
                            .clipShape(Circle())
                        BackNavigationButton(
                            color: Theme.Colors.textPrimary,
                            action: {
                                viewModel.router.back()
                            }
                        )
                        .backViewStyle()
                        .matchedGeometryEffect(id: GeometryName.backButton, in: animationNamespace)
                        .offset(y: 7)
                    }
                    .frame(width: 30, height: 30)
                    .padding(.vertical, 8)
                    .padding(.leading, 12)
                    .padding(.top, idiom == .pad ? 0 : 55)
                    Spacer()
                }
            }
        }
    }
    
    private var tabs: some View {
        TabView(selection: $viewModel.selection) {
            ForEach(CourseTab.allCases) { tab in
                switch tab {
                case .course:
                    CourseOutlineView(
                        viewModel: viewModel,
                        title: title,
                        courseID: courseID,
                        isVideo: false,
                        selection: $viewModel.selection,
                        coordinate: $coordinate,
                        collapsed: $collapsed,
                        dateTabIndex: CourseTab.dates.rawValue
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
                        isVideo: true,
                        selection: $viewModel.selection,
                        coordinate: $coordinate,
                        collapsed: $collapsed,
                        dateTabIndex: CourseTab.dates.rawValue
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
                        coordinate: $coordinate,
                        collapsed: $collapsed,
                        viewModel: Container.shared.resolve(CourseDatesViewModel.self,
                                                            arguments: courseID, title)!
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
                        coordinate: $coordinate,
                        collapsed: $collapsed,
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
                        coordinate: $coordinate,
                        collapsed: $collapsed,
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
        .tabViewStyle(.page(indexDisplayMode: .never))
        .introspect(.scrollView, on: .iOS(.v15, .v16, .v17), customize: { tabView in
            tabView.isScrollEnabled = false
        })
        .onFirstAppear {
            Task {
                await viewModel.tryToRefreshCookies()
            }
        }
    }
    
    private func didSelect(_ selection: Int) {
        lastCoordinate = .zero
        ignoreOffset = true
        CourseTab(rawValue: selection).flatMap {
            viewModel.trackSelectedTab(
                selection: $0,
                courseId: courseID,
                courseName: title
            )
        }
    }
    
    private func collapseHeader(_ coordinate: CGFloat) {
        guard !isHorizontal else { return collapsed = true }
        let lowerBound: CGFloat = -90
        let upperBound: CGFloat = 160
        
        switch coordinate {
        case lowerBound...upperBound:
            if shouldAnimateHeader(coordinate: coordinate) {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.6, blendDuration: 0.6)) {
                    ignoreOffset = false
                    collapsed = false
                }
            } else {
                lastCoordinate = coordinate
            }
        default:
            if shouldAnimateHeader(coordinate: coordinate) {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.6, blendDuration: 0.6)) {
                    ignoreOffset = false
                    collapsed = true
                }
            } else {
                lastCoordinate = coordinate
            }
        }
    }
    
    private func shouldAnimateHeader(coordinate: CGFloat) -> Bool {
        let ignoringOffset: CGFloat = 120
        
        guard coordinate <= ignoringOffset, lastCoordinate != 0 else {
            return false
        }
        
        if collapsed && lastCoordinate > coordinate {
            return false
        }
        
        if !collapsed && lastCoordinate < coordinate {
            return false
        }
        
        return true
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
                enrollmentEnd: nil,
                lastVisitedBlockID: nil,
                coreAnalytics: CoreAnalyticsMock()
            ),
            courseID: "",
            title: "Title of Course"
        )
    }
}
#endif
