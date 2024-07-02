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
        case noVideos(error: String, image: SwiftUI.Image)
        case noHandouts(error: String, image: SwiftUI.Image)
        case noAnnouncements(error: String, image: SwiftUI.Image)
        case noCourseDates(error: String, image: SwiftUI.Image)
        case noCourseware(error: String, image: SwiftUI.Image)
    }
    
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
        switch errorType {
        case .noVideos(error: let error, image: let image),
                .noHandouts(error: let error, image: let image),
                .noAnnouncements(error: let error, image: let image),
                .noCourseDates(error: let error, image: let image),
                .noCourseware(error: let error, image: let image):
            GeometryReader { proxy in
                VStack(spacing: 20) {
                    Spacer()
                    image
                        .resizable()
                        .renderingMode(.template)
                        .foregroundStyle(Theme.Colors.textSecondary)
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 72, maxHeight: 80)
                    
                    Text(error)
                        .font(Theme.Fonts.labelLarge)
                        .foregroundColor(Theme.Colors.textPrimary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 50)
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: proxy.size.height)
                .background(
                    Theme.Colors.background
                )
            }
        default:
            GeometryReader { proxy in
                VStack(spacing: 20) {
                    Spacer()
                    switch errorType {
                    case .noInternet, .noInternetWithReload:
                        CoreAssets.noWifi.swiftUIImage
                            .renderingMode(.template)
                            .foregroundStyle(Theme.Colors.textSecondary)
                            .scaledToFit()
                        
                        Text(CoreLocalization.Error.Internet.noInternetTitle)
                            .font(Theme.Fonts.labelLarge)
                            .foregroundColor(Theme.Colors.textPrimary)
                        
                        Text(CoreLocalization.Error.Internet.noInternetDescription)
                            .font(Theme.Fonts.labelLarge)
                            .foregroundColor(Theme.Colors.textPrimary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 50)
                    case .generic:
                        CoreAssets.notAvaliable.swiftUIImage
                            .renderingMode(.template)
                            .foregroundStyle(Theme.Colors.textSecondary)
                            .scaledToFit()
                        
                        Text(CoreLocalization.View.Snackbar.tryAgainBtn)
                            .font(Theme.Fonts.labelLarge)
                            .foregroundColor(Theme.Colors.textPrimary)
                        
                        Text(CoreLocalization.Error.unknownError)
                            .font(Theme.Fonts.labelLarge)
                            .foregroundColor(Theme.Colors.textPrimary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 50)
                    default: EmptyView()
                    }
                    
                    if errorType != .noInternet {
                        UnitButtonView(
                            type: .reload,
                            action: {
                                self.action()
                            }
                        )
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
}

#if DEBUG
struct FullScreenErrorView_Previews: PreviewProvider {
    static var previews: some View {
        FullScreenErrorView(type: .noInternetWithReload)
    }
}
#endif
