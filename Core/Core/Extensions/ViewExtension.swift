//
//  ViewExtension.swift
//  Core
//
//  Created by  Stepanok Ivan on 16.09.2022.
//

import Foundation
import Introspect
import SwiftUI

public extension View {
    func introspectCollectionView(customize: @escaping (UICollectionView) -> Void) -> some View {
        return inject(UIKitIntrospectionView(
            selector: { introspectionView in
                guard let viewHost = Introspect.findViewHost(from: introspectionView) else {
                    return nil
                }
                return Introspect.previousSibling(containing: UICollectionView.self, from: viewHost)
            },
            customize: customize
        ))
    }
    
    func introspectCollectionViewWithClipping(customize: @escaping (UICollectionView) -> Void) -> some View {
        return inject(UIKitIntrospectionView(
            selector: { introspectionView in
                guard let viewHost = Introspect.findViewHost(from: introspectionView) else {
                    return nil
                }
                // first run Introspect as normal
                if let selectedView = Introspect.previousSibling(containing: UICollectionView.self,
                                                                 from: viewHost) {
                    return selectedView
                } else if let superView = viewHost.superview {
                    // if no view was found and a superview exists, search the superview as well
                    return Introspect.previousSibling(containing: UICollectionView.self, from: superView)
                } else {
                    // no view found at all
                    return nil
                }
            },
            customize: customize
        ))
    }
    
    func cardStyle(top: CGFloat? = 0,
                   bottom: CGFloat? = 0,
                   leftLineEnabled: Bool = false,
                   bgColor: Color = CoreAssets.background.swiftUIColor,
                   strokeColor: Color = CoreAssets.cardViewStroke.swiftUIColor,
                   textColor: Color = CoreAssets.textPrimary.swiftUIColor) -> some View {
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
    
    func shadowCardStyle(top: CGFloat? = 0,
                         bottom: CGFloat? = 0,
                         bgColor: Color = CoreAssets.cardViewBackground.swiftUIColor,
                         textColor: Color = CoreAssets.textPrimary.swiftUIColor) -> some View {
        return self
            .padding(.all, 16)
            .padding(.vertical, 6)
            .font(Theme.Fonts.titleMedium)
            .frame(minWidth: 0,
                   maxWidth: .infinity,
                   alignment: .topLeading)
            .background(Theme.Shapes.cardShape
                .fill(bgColor)
                .shadow(color: CoreAssets.shadowColor.swiftUIColor,
                        radius: 12, y: 4))
            .foregroundColor(textColor)
            .padding(.horizontal, 24)
            .padding(.top, top)
            .padding(.bottom, bottom)
        
    }
    
    func titleSettings(top: CGFloat? = 10, bottom: CGFloat? = 20,
                       color: Color = CoreAssets.textPrimary.swiftUIColor) -> some View {
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
    
    func roundedBackground(_ color: Color = CoreAssets.background.swiftUIColor,
                           strokeColor: Color = CoreAssets.backgroundStroke.swiftUIColor,
                           ipadMaxHeight: CGFloat = .infinity,
                           maxIpadWidth: CGFloat = 420) -> some View {
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
            return self.introspectNavigationController { $0.isNavigationBarHidden = true }
                .navigationBarHidden(true)
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
    
    var isIOS14: Bool {
        if #available(iOS 15.0, *) {
            return false
        } else {
            return true
        }
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
    func backButtonStyle(topPadding: CGFloat = -10, color: Color = CoreAssets.accentColor.swiftUIColor) -> some View {
        return self
            .renderingMode(.template)
            .resizable()
            .scaledToFit()
            .frame(height: 24)
            .padding(.horizontal)
            .padding(.top, topPadding)
            .foregroundColor(color)
    }
}
