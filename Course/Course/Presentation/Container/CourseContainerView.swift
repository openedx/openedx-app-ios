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
import Kingfisher

public struct CourseContainerView: View {
    
    @ObservedObject
    public var viewModel: CourseContainerViewModel
    @State private var isAnimatingForTap: Bool = false
    public var courseID: String
    private var title: String
    private var org: String
    @State private var coordinate: CGFloat = .zero
    @State private var lastCoordinate: CGFloat = .zero
    @State private var collapsed: Bool = false
    @Environment(\.isHorizontal) private var isHorizontal
    @Namespace private var animationNamespace
    private var idiom: UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    
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
        title: String,
        org: String
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
        self.org = org
    }
    
    public var body: some View {
        ZStack(alignment: .top) {
            content
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(false)
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
                            topHeader(containerWidth: proxy.size.width)
                        } .offset(y: coordinate)
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
                    Button(action: {
                        viewModel.router.back(animated: true)
                    }, label: {
                        ZStack {
                            VisualEffectView(effect: UIBlurEffect(style: .regular))
                                .clipShape(Circle())
                                .frame(width: 30, height: 30)
                            Image(systemName: "arrow.left")
                                .foregroundStyle(Theme.Colors.textPrimary)
                                .matchedGeometryEffect(id: GeometryName.backButton, in: animationNamespace)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 24)
                            
                        }
                    })
                    .foregroundStyle(Color.black)
                    .padding(.top, 55)
                    Spacer()
                }
            }
        }.frameLimit(width: containerWidth)
    }
    
    private func topHeader(containerWidth: CGFloat) -> some View {
        ZStack(alignment: .bottomLeading) {
            if let banner = viewModel.courseStructure?.media.image.raw
                .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                ScrollView {
                    KFImage(URL(string: viewModel.config.baseURL.absoluteString + banner))
                        .onFailureImage(CoreAssets.noCourseImage.image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .allowsHitTesting(false)
                        .clipped()
                }
                .disabled(true)
                .ignoresSafeArea()
                
            }
            VStack(alignment: .leading) {
                if collapsed {
                    VStack {
                        HStack {
                            Button(action: {
                                viewModel.router.back(animated: true)
                            }, label: {
                                Image(systemName: "arrow.left")
                                    .foregroundStyle(Theme.Colors.textPrimary)
                                    .padding(.vertical, 8)
                                    .matchedGeometryEffect(id: GeometryName.backButton, in: animationNamespace)
                            })
                            .foregroundStyle(Color.black)
                            Text(title)
                                .lineLimit(1)
                                .foregroundStyle(Theme.Colors.textPrimary)
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                .clipped()
                                .font(Theme.Fonts.bodyLarge)
                        }
                        .padding(.top, 46)
                        .padding(.horizontal, 24)
                        topTabBar(containerWidth: containerWidth)
                            .matchedGeometryEffect(id: GeometryName.topTabBar, in: animationNamespace)
                            .padding(.bottom, 12)
                    }.background {
                        ZStack(alignment: .bottom) {
                            Rectangle()
                                .padding(.top, 24)
                                .foregroundStyle(Theme.Colors.primaryHeaderColor)
                                .matchedGeometryEffect(id: GeometryName.blurPrimaryBg, in: animationNamespace)
                            Rectangle().frame(height: 36)
                                .foregroundStyle(Theme.Colors.secondaryHeaderColor)
                                .matchedGeometryEffect(id: GeometryName.blurSecondaryBg, in: animationNamespace)
                            VisualEffectView(effect: UIBlurEffect(style: .regular))
                                .matchedGeometryEffect(id: GeometryName.blurBg, in: animationNamespace)
                                .ignoresSafeArea()
                        }
                    }
                } else {
                    ZStack(alignment: .bottomLeading) {
                        VStack {
                            Text(org)
                                .font(Theme.Fonts.labelLarge)
                                .foregroundStyle(Theme.Colors.textPrimary)
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                .multilineTextAlignment(.leading)
                                .padding(.horizontal, 24)
                                .padding(.top, 16)
                                .allowsHitTesting(false)
                                .frameLimit(width: containerWidth)
                            Text(title)
                                .lineLimit(3)
                                .font(Theme.Fonts.titleLarge)
                                .foregroundStyle(Theme.Colors.textPrimary)
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                .multilineTextAlignment(.leading)
                                .padding(.horizontal, 24)
                                .allowsHitTesting(false)
                                .frameLimit(width: containerWidth)
                            topTabBar(containerWidth: containerWidth)
                                .matchedGeometryEffect(id: GeometryName.topTabBar, in: animationNamespace)
                                .padding(.bottom, 12)
                        }.background {
                            ZStack(alignment: .bottom) {
                                Rectangle()
                                    .padding(.top, 24)
                                    .foregroundStyle(Theme.Colors.primaryHeaderColor)
                                    .matchedGeometryEffect(id: GeometryName.blurPrimaryBg, in: animationNamespace)
                                Rectangle().frame(height: 36)
                                    .foregroundStyle(Theme.Colors.secondaryHeaderColor)
                                    .matchedGeometryEffect(id: GeometryName.blurSecondaryBg, in: animationNamespace)
                                VisualEffectView(effect: UIBlurEffect(style: .regular))
                                    .matchedGeometryEffect(id: GeometryName.blurBg, in: animationNamespace)
                                    .allowsHitTesting(false)
                                    .ignoresSafeArea()
                            }
                        }
                    }
                }
            }
        }
        .frame(height: collapsed ? (isHorizontal ? 230 : 260) : 300)
        .ignoresSafeArea(edges: .top)
    }
    
    private func topTabBar(containerWidth: CGFloat) -> some View {
        ScrollSlidingTabBar(
            selection: $viewModel.selection,
            tabs: CourseTab.allCases.map { ($0.title, $0.image) },
            containerWidth: containerWidth
        ) { newValue in
            isAnimatingForTap = true
            viewModel.selection = newValue
            DispatchQueue.main.asyncAfter(deadline: .now().advanced(by: .milliseconds(300))) {
                isAnimatingForTap = false
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
        .onFirstAppear {
            Task {
                await viewModel.tryToRefreshCookies()
            }
        }
    }
    
    private func didSelect(_ selection: Int) {
        lastCoordinate = .zero
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
        switch coordinate {
        case -90...160:
            withAnimation(.spring(response: 0.4, dampingFraction: 0.6, blendDuration: 0.6)) {
                collapsed = false
            }
        default:
            withAnimation(.spring(response: 0.4, dampingFraction: 0.6, blendDuration: 0.6)) {
                collapsed = true
            }
        }
        lastCoordinate = coordinate
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
                coreAnalytics: CoreAnalyticsMock()
            ),
            courseID: "", title: "Title of Course", org: "organization")
    }
}
#endif
