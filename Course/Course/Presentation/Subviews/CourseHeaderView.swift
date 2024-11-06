//
//  TopHeaderView.swift
//  Course
//
//  Created by  Stepanok Ivan on 04.04.2024.
//

import SwiftUI
import Kingfisher
import Core
import Theme

struct CourseHeaderView: View {
    
    @ObservedObject var viewModel: CourseContainerViewModel
    private var title: String
    private var containerWidth: CGFloat
    private var animationNamespace: Namespace.ID
    @Binding private var collapsed: Bool
    @Binding private var isAnimatingForTap: Bool
    @Environment(\.isHorizontal) private var isHorizontal
    
    private let collapsedHorizontalHeight: CGFloat = 230
    private let collapsedVerticalHeight: CGFloat = 260
    private let expandedHeight: CGFloat = 300
    
    private enum GeometryName {
        case backButton
        case topTabBar
        case blurSecondaryBg
        case blurPrimaryBg
        case blurBg
    }
    
    init(
        viewModel: CourseContainerViewModel,
        title: String,
        collapsed: Binding<Bool>,
        containerWidth: CGFloat,
        animationNamespace: Namespace.ID,
        isAnimatingForTap: Binding<Bool>
    ) {
        self.viewModel = viewModel
        self.title = title
        self._collapsed = collapsed
        self.containerWidth = containerWidth
        self.animationNamespace = animationNamespace
        self._isAnimatingForTap = isAnimatingForTap
    }
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            ScrollView {
                if let banner = viewModel.courseStructure?.media.image.raw
                    .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                    KFImage(courseBannerURL(for: banner))
                        .onFailureImage(CoreAssets.noCourseImage.image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(maxHeight: expandedHeight, alignment: .center)
                        .allowsHitTesting(false)
                        .clipped()
                        .background(Theme.Colors.background)
                }
            }
            .disabled(true)
            .ignoresSafeArea()
            VStack(alignment: .leading) {
                if collapsed {
                    VStack {
                        HStack {
                            BackNavigationButton(
                                color: Theme.Colors.textPrimary,
                                action: {
                                    viewModel.router.back()
                                }
                            )
                            .backViewStyle()
                            .matchedGeometryEffect(id: GeometryName.backButton, in: animationNamespace)
                            .frame(width: 30, height: 30)
                            .offset(y: 10)
                            Text(title)
                                .lineLimit(1)
                                .foregroundStyle(Theme.Colors.textPrimary)
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                .clipped()
                                .font(Theme.Fonts.bodyLarge)
                        }
                        .padding(.top, 46)
                        .padding(.leading, 12)
                        courseMenuBar(containerWidth: containerWidth)
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
                            if let org = viewModel.courseStructure?.org {
                                Text(org)
                                    .font(Theme.Fonts.labelLarge)
                                    .foregroundStyle(Theme.Colors.textPrimary)
                                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                    .multilineTextAlignment(.leading)
                                    .padding(.horizontal, 24)
                                    .padding(.top, 16)
                                    .allowsHitTesting(false)
                                    .frameLimit(width: containerWidth)
                            }
                            Text(title)
                                .lineLimit(3)
                                .font(Theme.Fonts.titleLarge)
                                .foregroundStyle(Theme.Colors.textPrimary)
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                .multilineTextAlignment(.leading)
                                .padding(.horizontal, 24)
                                .allowsHitTesting(false)
                                .frameLimit(width: containerWidth)
                            courseMenuBar(containerWidth: containerWidth)
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
        .background(Theme.Colors.background)
        .frame(
            height: collapsed ? (
                isHorizontal ? collapsedHorizontalHeight : collapsedVerticalHeight
            ) : expandedHeight
        )
        .ignoresSafeArea(edges: .top)
    }
    
    private func courseBannerURL(for path: String) -> URL? {
        if path.contains("http://") || path.contains("https://") {
            return URL(string: path)
        }
        return URL(string: viewModel.config.baseURL.absoluteString + path)
    }
    
    private func courseMenuBar(containerWidth: CGFloat) -> some View {
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
}
