//
//  FullScreenErrorView.swift
//  Course
//
//  Created by Shafqat Muneer on 5/14/24.
//

import SwiftUI
import Theme

public struct FullScreenErrorView: View {
    
    public enum ErrorType {
        case noInternet
        case noInternetWithReload
        case generic
    }
    
    private let errorType: ErrorType
    private var reloadAction: () -> Void = {}
    
    public init(
        type: ErrorType
    ) {
        self.errorType = type
    }
    
    public init(
        type: ErrorType,
        reloadAction: @escaping () -> Void
    ) {
        self.errorType = type
        self.reloadAction = reloadAction
    }
    
    public var body: some View {
        GeometryReader { proxy in
            VStack(spacing: 28) {
                Spacer()
                switch errorType {
                case .noInternet, .noInternetWithReload:
                    CoreAssets.noWifi.swiftUIImage
                        .renderingMode(.template)
                        .foregroundStyle(Color.primary)
                        .scaledToFit()
                    
                    Text(CoreLocalization.Error.Internet.noInternetTitle)
                        .font(Theme.Fonts.titleLarge)
                        .foregroundColor(Theme.Colors.textPrimary)
                    
                    Text(CoreLocalization.Error.Internet.noInternetDescription)
                        .font(Theme.Fonts.bodyLarge)
                        .foregroundColor(Theme.Colors.textPrimary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 50)
                case .generic:
                    CoreAssets.notAvaliable.swiftUIImage
                        .renderingMode(.template)
                        .foregroundStyle(Color.primary)
                        .scaledToFit()
                    
                    Text(CoreLocalization.View.Snackbar.tryAgainBtn)
                        .font(Theme.Fonts.titleLarge)
                        .foregroundColor(Theme.Colors.textPrimary)
                    
                    Text(CoreLocalization.Error.unknownError)
                        .font(Theme.Fonts.bodyLarge)
                        .foregroundColor(Theme.Colors.textPrimary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 50)
                }
                
                if errorType != .noInternet {
                    UnitButtonView(type: .reload, action: {
                        self.reloadAction()
                    })
                }
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: proxy.size.height)
            .background(
                Theme.Colors.background
            )
        }
    }
}

#if DEBUG
struct FullScreenErrorView_Previews: PreviewProvider {
    static var previews: some View {
        FullScreenErrorView(type: .noInternetWithReload)
    }
}
#endif
