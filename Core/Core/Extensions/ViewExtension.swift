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

@MainActor
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

public extension Image {
    @MainActor
    func backButtonStyle(topPadding: CGFloat = -10, color: Color = Theme.Colors.accentColor) -> some View {
        return self
            .renderingMode(.template)
            .resizable()
            .scaledToFit()
            .foregroundColor(color)
            .backViewStyle(topPadding: topPadding)
    }
}
