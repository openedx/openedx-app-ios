//
//  ViewExtension.swift
//  Core
//
//  Created by  Stepanok Ivan on 16.09.2022.
//

import Foundation
@_spi(Advanced) import SwiftUIIntrospect
import SwiftUI
import Theme

public extension View {
    func cardStyle(
        top: CGFloat? = 0,
        bottom: CGFloat? = 0,
        paddingAll: CGFloat? = 20,
        leftLineEnabled: Bool = false,
        bgColor: Color = Theme.Colors.background,
        strokeColor: Color = Theme.Colors.cardViewStroke,
        textColor: Color = Theme.Colors.textPrimary
    ) -> some View {
        return self
            .padding(.all, paddingAll)
            .padding(.vertical, leftLineEnabled ? 0 : 6)
            .font(Theme.Fonts.titleMedium)
            .frame(minWidth: 0,
                   maxWidth: .infinity,
                   alignment: .topLeading)
            .background(Theme.Shapes.cardShape
                .fill(leftLineEnabled ? .clear : bgColor)
                        
            )
            .overlay(
                GeometryReader { proxy in
                    if leftLineEnabled {
                        Rectangle()
                            .size(width: 1, height: proxy.size.height)
                            .foregroundColor(strokeColor)
                    } else {
                        RoundedRectangle(cornerRadius: 8)
                            .size(width: proxy.size.width, height: proxy.size.height)
                            .stroke(style: .init(lineWidth: 1, lineCap: .round, lineJoin: .round, miterLimit: 1))
                            .foregroundColor(strokeColor)
                    }
                }
            )
            .foregroundColor(textColor)
            .padding(.horizontal, 24)
            .padding(.top, top)
            .padding(.bottom, bottom)
    }
    
    func shadowCardStyle(
        top: CGFloat? = 0,
        bottom: CGFloat? = 0,
        bgColor: Color = Theme.Colors.cardViewBackground,
        textColor: Color = Theme.Colors.textPrimary
    ) -> some View {
        return self
            .padding(.all, 16)
            .padding(.vertical, 6)
            .font(Theme.Fonts.titleMedium)
            .frame(minWidth: 0,
                   maxWidth: .infinity,
                   alignment: .topLeading)
            .background(Theme.Shapes.cardShape
                .fill(bgColor)
                .shadow(color: Theme.Colors.shadowColor,
                        radius: 12, y: 4))
            .foregroundColor(textColor)
            .padding(.horizontal, 24)
            .padding(.top, top)
            .padding(.bottom, bottom)
        
    }
    
    func titleSettings(
        top: CGFloat? = 10,
        bottom: CGFloat? = 20,
        color: Color = Theme.Colors.textPrimary
    ) -> some View {
        return self
            .lineLimit(1)
            .truncationMode(.tail)
            .font(Theme.Fonts.titleMedium)
            .foregroundColor(color)
            .padding(.top, top)
            .padding(.bottom, bottom)
            .padding(.horizontal, 48)
    }
    
    func frameLimit(width: CGFloat? = nil) -> some View {
        modifier(ReadabilityModifier(width: width))
    }
    
    @ViewBuilder
    func adaptiveHStack<Content: View>(
        spacing: CGFloat = 0,
        currentOrientation: UIInterfaceOrientation,
        @ViewBuilder content: () -> Content
    ) -> some View {
        if currentOrientation.isLandscape && UIDevice.current.userInterfaceIdiom != .pad {
            VStack(alignment: .center, spacing: spacing, content: content)
        } else if currentOrientation.isPortrait && UIDevice.current.userInterfaceIdiom != .pad {
            HStack(spacing: spacing, content: content)
        } else if UIDevice.current.userInterfaceIdiom != .phone {
            HStack(spacing: spacing, content: content)
        }
    }
    
    @ViewBuilder
    func adaptiveStack<Content: View>(
        spacing: CGFloat = 0,
        isHorizontal: Bool,
        @ViewBuilder content: () -> Content
    ) -> some View {
        if isHorizontal, UIDevice.current.userInterfaceIdiom != .pad {
            HStack(spacing: spacing, content: content)
        } else {
            VStack(alignment: .center, spacing: spacing, content: content)
        }
    }
    
    @ViewBuilder
    func adaptiveNavigationStack<Content: View>(
        spacing: CGFloat = 0,
        isHorizontal: Bool,
        @ViewBuilder content: () -> Content
    ) -> some View {
        if UIDevice.current.userInterfaceIdiom == .pad {
            HStack(spacing: spacing, content: content)
        } else {
            if isHorizontal {
                HStack(alignment: .top, spacing: spacing, content: content)
            } else {
                VStack(alignment: .center, spacing: spacing, content: content)
            }
        }
    }
    
    func roundedBackground(
        _ color: Color = Theme.Colors.background,
        strokeColor: Color = Theme.Colors.backgroundStroke,
        ipadMaxHeight: CGFloat = .infinity,
        maxIpadWidth: CGFloat = 420
    ) -> some View {
        return ZStack {
            RoundedCorners(tl: 24, tr: 24)
                .offset(y: 1)
                .stroke(style: StrokeStyle(lineWidth: 1))
                .foregroundColor(strokeColor)
            RoundedCorners(tl: 24, tr: 24)
                .offset(y: 2)
                .foregroundColor(color)
            self
                .offset(y: 2)
        }
    }
    
    func roundedBackgroundWeb(
        _ color: Color = Theme.Colors.background,
        strokeColor: Color = Theme.Colors.backgroundStroke,
        ipadMaxHeight: CGFloat = .infinity,
        maxIpadWidth: CGFloat = 420
    ) -> some View {
        var idiom: UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
        return VStack {
            VStack {}.frame(height: 1)
            ZStack {
                self
                    .frame(maxWidth: maxIpadWidth, maxHeight: idiom == .pad ? ipadMaxHeight : .infinity)
                    .clipShape(RoundedCorners(tl: 24, tr: 24))
                RoundedCorners(tl: 24, tr: 24)
                    .stroke(style: StrokeStyle(lineWidth: 1))
                    .foregroundColor(strokeColor)
                    .offset(y: -1)
            }
        }
    }
    
    func hideNavigationBar() -> some View {
        if #available(iOS 16.0, *) {
            return self.navigationBarHidden(true)
        } else {
            return self.introspect(
                .navigationView(style: .stack),
                on: .iOS(.v15...),
                scope: .ancestor) {
                    $0.isNavigationBarHidden = true
                }
        }
    }

    func hideScrollContentBackground() -> some View {
        if #available(iOS 16.0, *) {
            return self.scrollContentBackground(.hidden)
        } else {
            return self.onAppear {
                UITextView.appearance().backgroundColor = .clear
            }
        }
    }
    
    func onRightSwipeGesture(perform action: @escaping () -> Void) -> some View {
        self.gesture(
            DragGesture(minimumDistance: 20, coordinateSpace: .local)
                .onEnded { value in
                    if value.translation.width > 0 && abs(value.translation.height) < 50 {
                        action()
                    }
                }
        )
    }
    
    func onBackground(_ f: @escaping () -> Void) -> some View {
        self.onReceive(
            NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification),
            perform: { _ in f() }
        )
    }
    
    func onForeground(_ f: @escaping () -> Void) -> some View {
        self.onReceive(
            NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification),
            perform: { _ in f() }
        )
    }
    
    func onFirstAppear(_ action: @escaping () -> Void) -> some View {
        modifier(FirstAppear(action: action))
    }
    
    func backViewStyle(topPadding: CGFloat = -10) -> some View {
        return self
            .frame(height: 24)
            .padding(.horizontal, 8)
            .offset(y: topPadding)
    }
    
    @ViewBuilder
    private func onTapBackgroundContent(enabled: Bool, _ action: @escaping () -> Void) -> some View {
        if enabled {
            Color.clear
                .frame(width: UIScreen.main.bounds.width * 2, height: UIScreen.main.bounds.height * 2)
                .contentShape(Rectangle())
                .onTapGesture(perform: action)
        }
    }

    func onTapBackground(enabled: Bool, _ action: @escaping () -> Void) -> some View {
        background(
            onTapBackgroundContent(enabled: enabled, action)
        )
    }
}

public extension View {
    /// Applies the given transform if the given condition evaluates to `true`.
    /// - Parameters:
    ///   - condition: The condition to evaluate.
    ///   - transform: The transform to apply to the source `View`.
    /// - Returns: Either the original `View` or the modified `View` if the condition is `true`.
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

public extension View {
    @ViewBuilder
    func sheetNavigation(isSheet: Bool, onDismiss: (() -> Void)? = nil) -> some View {
        if isSheet {
            NavigationView {
                ZStack {
                    Theme.Colors.background
                        .ignoresSafeArea()
                    self
                        .if(onDismiss != nil) { view in
                            view
                                .toolbar {
                                    ToolbarItem(placement: .navigationBarTrailing) {
                                        Button {
                                            onDismiss?()
                                        } label: {
                                            Image(systemName: "xmark")
                                                .foregroundColor(Theme.Colors.accentColor)
                                        }
                                        .accessibilityIdentifier("close_button")
                                    }
                                }
                        }
                }
            }
        } else {
            self
        }
    }
}

private struct FirstAppear: ViewModifier {
    let action: () -> Void
    
    // Use this to only fire your block one time
    @State private var hasAppeared = false
    
    func body(content: Content) -> some View {
        // And then, track it here
        content.onAppear {
            guard !hasAppeared else { return }
            hasAppeared = true
            action()
        }
    }
}

public extension Image {
    func backButtonStyle(topPadding: CGFloat = -10, color: Color = Theme.Colors.accentColor) -> some View {
        return self
            .renderingMode(.template)
            .resizable()
            .scaledToFit()
            .foregroundColor(color)
            .backViewStyle(topPadding: topPadding)
    }
}

public extension EnvironmentValues {
    var isHorizontal: Bool {
        if UIDevice.current.userInterfaceIdiom != .pad {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                return windowScene.windows.first?.windowScene?.interfaceOrientation.isLandscape ?? true
            }
        }
        return false
    }
}
