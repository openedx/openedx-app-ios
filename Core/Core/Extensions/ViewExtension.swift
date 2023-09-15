//
//  ViewExtension.swift
//  Core
//
//  Created by  Stepanok Ivan on 16.09.2022.
//

import Foundation
import SwiftUIIntrospect
import SwiftUI

public extension View {
    
    func cardStyle(
        top: CGFloat? = 0,
        bottom: CGFloat? = 0,
        leftLineEnabled: Bool = false,
        bgColor: Color = Theme.Colors.background,
        strokeColor: Color = Theme.Colors.cardViewStroke,
        textColor: Color = Theme.Colors.textPrimary
    ) -> some View {
        return self
            .padding(.all, 20)
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
    
    func frameLimit(sizePortrait: CGFloat = 560, sizeLandscape: CGFloat = 648) -> some View {
        return HStack {
            Spacer(minLength: 0)
            self.frame(maxWidth: UIDevice.current.orientation == .portrait ? sizePortrait : sizeLandscape)
            Spacer(minLength: 0)
        }
    }
    
    func roundedBackground(
        _ color: Color = Theme.Colors.background,
        strokeColor: Color = Theme.Colors.backgroundStroke,
        ipadMaxHeight: CGFloat = .infinity,
        maxIpadWidth: CGFloat = 420
    ) -> some View {
        var idiom: UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
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
                .frame(maxWidth: maxIpadWidth, maxHeight: idiom == .pad ? ipadMaxHeight : .infinity)
        }
    }
    
    func hideNavigationBar() -> some View {
        if #available(iOS 16.0, *) {
            return self.navigationBarHidden(true)
        } else {
            return self.introspect(
                .navigationView(style: .stack),
                on: .iOS(.v14, .v15, .v16, .v17),
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
            .frame(height: 24)
            .padding(.horizontal, 8)
            .padding(.top, topPadding)
            .foregroundColor(color)
    }
}
