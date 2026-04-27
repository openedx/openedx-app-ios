//
//  SandboxSplashView.swift
//  Authorization
//

import SwiftUI
import Core
import Theme

public struct SandboxSplashView: View {

    @Environment(\.isHorizontal) private var isHorizontal

    private let router: AuthorizationRouter

    public init(router: AuthorizationRouter) {
        self.router = router
    }

    public var body: some View {
        ZStack(alignment: .top) {
            VStack {
                ThemeAssets.headerBackground.swiftUIImage
                    .resizable()
                    .edgesIgnoringSafeArea(.top)
                    .accessibilityIdentifier("sandbox_splash_bg_image")
            }
            .frame(maxWidth: .infinity, maxHeight: 200)

            VStack(alignment: .center) {
                ThemeAssets.appLogo.swiftUIImage
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 263, maxHeight: 76)
                    .padding(.top, isHorizontal ? 20 : 40)
                    .padding(.bottom, isHorizontal ? 10 : 40)
                    .accessibilityIdentifier("sandbox_splash_logo")

                GeometryReader { proxy in
                    ScrollView {
                        VStack(alignment: .center, spacing: 16) {
                            Text("Welcome to the Open edX\u{00AE} Mobile App")
                                .font(Theme.Fonts.displaySmall)
                                .foregroundColor(Theme.Colors.textPrimary)
                                .multilineTextAlignment(.center)
                                .padding(.top, 8)
                                .accessibilityIdentifier("sandbox_splash_title")

                            Text(
                                "This app was built for you to explore the Open edX\u{00AE} Mobile App. "
                                + "Courses are for demonstration purposes only."
                            )
                            .font(Theme.Fonts.titleSmall)
                            .foregroundColor(Theme.Colors.textPrimary)
                            .multilineTextAlignment(.center)
                            .accessibilityIdentifier("sandbox_splash_subtitle")

                            StyledButton(
                                "Start Exploring",
                                action: {
                                    router.showLoginScreen(sourceScreen: .default)
                                },
                                iconImage: CoreAssets.arrowRight16.swiftUIImage,
                                iconPosition: .right
                            )
                            .frame(maxWidth: .infinity)
                            .padding(.top, 24)
                            .accessibilityIdentifier("sandbox_splash_start_button")

                            Spacer()
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 50)
                        .frameLimit(width: proxy.size.width)
                    }
                    .roundedBackground(Theme.Colors.loginBackground)
                }
            }
        }
        .navigationBarHidden(true)
        .ignoresSafeArea(.all, edges: .horizontal)
        .background(Theme.Colors.background.ignoresSafeArea(.all))
    }
}

#if DEBUG
struct SandboxSplashView_Previews: PreviewProvider {
    static var previews: some View {
        SandboxSplashView(router: AuthorizationRouterMock())
            .preferredColorScheme(.light)
            .previewDisplayName("SandboxSplashView Light")
            .loadFonts()

        SandboxSplashView(router: AuthorizationRouterMock())
            .preferredColorScheme(.dark)
            .previewDisplayName("SandboxSplashView Dark")
            .loadFonts()
    }
}
#endif
