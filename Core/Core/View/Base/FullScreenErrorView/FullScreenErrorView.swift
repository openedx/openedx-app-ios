//
//  FullScreenErrorView.swift
//  Course
//
//  Created by Shafqat Muneer on 5/14/24.
//

import SwiftUI
import Theme

public struct FullScreenErrorView: View {
    
    public enum ErrorType: Equatable {
        case noInternet
        case noInternetWithReload
        case generic
        case noContent(_ message: String, image: SwiftUI.Image)
    }
    @EnvironmentObject var themeManager: ThemeManager
    private let errorType: ErrorType
    private var action: () -> Void = {}
    
    public init(
        type: ErrorType
    ) {
        self.errorType = type
    }
    
    public init(
        type: ErrorType,
        action: @escaping () -> Void
    ) {
        self.errorType = type
        self.action = action
    }
    
    public var body: some View {
        VStack(spacing: 20) {
            Spacer()
            switch errorType {
            case .noContent(let message, image: let image):
                image
                    .resizable()
                    .renderingMode(.template)
                    .foregroundStyle(themeManager.theme.colors.textSecondary)
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 72, maxHeight: 80)
                
                Text(message)
                    .font(Theme.Fonts.labelLarge)
                    .foregroundColor(themeManager.theme.colors.textPrimary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 50)
            case .noInternet,
                    .noInternetWithReload:
                CoreAssets.noWifi.swiftUIImage
                    .renderingMode(.template)
                    .foregroundStyle(themeManager.theme.colors.textSecondary)
                    .scaledToFit()
                
                Text(CoreLocalization.Error.Internet.noInternetTitle)
                    .font(Theme.Fonts.labelLarge)
                    .foregroundColor(themeManager.theme.colors.textPrimary)
                
                Text(CoreLocalization.Error.Internet.noInternetDescription)
                    .font(Theme.Fonts.labelLarge)
                    .foregroundColor(themeManager.theme.colors.textPrimary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 50)
            case .generic:
                CoreAssets.notAvaliable.swiftUIImage
                    .renderingMode(.template)
                    .foregroundStyle(themeManager.theme.colors.textSecondary)
                    .scaledToFit()
                
                Text(CoreLocalization.View.Snackbar.tryAgainBtn)
                    .font(Theme.Fonts.labelLarge)
                    .foregroundColor(themeManager.theme.colors.textPrimary)
                
                Text(CoreLocalization.Error.unknownError)
                    .font(Theme.Fonts.labelLarge)
                    .foregroundColor(themeManager.theme.colors.textPrimary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 50)
                
            }
            if errorType == .noInternetWithReload || errorType == .generic {
                UnitButtonView(
                    type: .reload,
                    action: {
                        self.action()
                    }
                )
                .environmentObject(themeManager)
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            themeManager.theme.colors.background
        )
    }
}

#if DEBUG
struct FullScreenErrorView_Previews: PreviewProvider {
    static var previews: some View {
        FullScreenErrorView(type: .noInternetWithReload)
    }
}
#endif
