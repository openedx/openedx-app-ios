//
//  SignUpView.swift
//  Authorization
//
//  Created by  Stepanok Ivan on 24.10.2022.
//

import SwiftUI
import Core
import OEXFoundation
import Theme

public struct SignUpView: View {
    
    @State
    private var disclosureGroupOpen: Bool = false
    
    @Environment(\.isHorizontal) private var isHorizontal
    @Environment(\.layoutDirection) var layoutDirection
    @EnvironmentObject var themeManager: ThemeManager
    
    @ObservedObject
    private var viewModel: SignUpViewModel
    
    public init(viewModel: SignUpViewModel) {
        self.viewModel = viewModel
        Task {
           await viewModel.getRegistrationFields()
        }
    }
    
    public var body: some View {
        ZStack(alignment: .top) {
            VStack {
            #if RIYADAH
            ThemeAssets.headerBackground.swiftUIImage
                .resizable()
                .edgesIgnoringSafeArea(.top)
#elseif NELC
                ThemeAssets.headerBackground.swiftUIImage
                    .resizable()
                    .edgesIgnoringSafeArea(.top)
            #else
                ThemeAssets.headerBackground.swiftUIImage
                .resizable()
                .edgesIgnoringSafeArea(.top)
            #endif
            }
            .frame(maxWidth: .infinity, maxHeight: 200)
            .accessibilityIdentifier("auth_bg_image")
            
            // MARK: - Page name
            VStack(alignment: .center) {
                ZStack {
                    HStack {
                        Text(CoreLocalization.SignIn.registerBtn)
                            .titleSettings(color: themeManager.theme.colors.loginNavigationText)
                            .accessibilityIdentifier("register_text")
                    }
                    VStack {
                        BackNavigationButton(
                            color: themeManager.theme.colors.loginNavigationText,
                            action: {
                                viewModel.router.back()
                            }
                        )
                        .backViewStyle()
                        .padding(.leading, isHorizontal ? 48 : 0)
                        
                    }.frame(minWidth: 0,
                            maxWidth: .infinity,
                            alignment: .topLeading)
                }
                
                GeometryReader { proxy in
                    ScrollViewReader { scroll in
                        ScrollView {
                            VStack(alignment: .leading) {
                                
                                Text(CoreLocalization.SignIn.registerBtn)
                                    .font(Theme.Fonts.displaySmall)
                                    .foregroundColor(themeManager.theme.colors.textPrimary)
                                    .padding(.bottom, 4)
                                    .accessibilityIdentifier("signup_text")
                                Text(AuthLocalization.SignUp.subtitle)
                                    .font(Theme.Fonts.titleSmall)
                                    .foregroundColor(themeManager.theme.colors.textPrimary)
                                    .padding(.bottom, 20)
                                    .accessibilityIdentifier("signup_subtitle_text")

                                if viewModel.thirdPartyAuthSuccess {
                                    Text(AuthLocalization.SignUp.successSigninLabel)
                                        .font(Theme.Fonts.titleMedium)
                                        .foregroundColor(themeManager.theme.colors.textPrimary)
                                        .accessibilityIdentifier("social_auth_success_text")
                                    Text(AuthLocalization.SignUp.successSigninSublabel)
                                        .font(Theme.Fonts.titleSmall)
                                        .foregroundColor(themeManager.theme.colors.textSecondary)
                                        .padding(.bottom, 20)
                                        .accessibilityIdentifier("social_auth_success_subtext_text")
                                }

                                let requiredFields = viewModel.requiredFields
                                let optionalFields = viewModel.optionalFields

                                FieldsView(
                                    fields: requiredFields,
                                    router: viewModel.router,
                                    config: viewModel.config,
                                    cssInjector: viewModel.cssInjector,
                                    proxy: proxy
                                )

                                if !viewModel.isShowProgress {
                                    DisclosureGroup(isExpanded: $disclosureGroupOpen) {
                                        FieldsView(
                                            fields: optionalFields,
                                                   router: viewModel.router,
                                                   config: viewModel.config,
                                                   cssInjector: viewModel.cssInjector,
                                                   proxy: proxy
                                        )
                                        .padding(.horizontal, 1)
                                    } label: {
                                        Text(disclosureGroupOpen
                                             ? AuthLocalization.SignUp.hideFields
                                             : AuthLocalization.SignUp.showFields)
                                        .font(Theme.Fonts.labelLarge)
                                    }
                                    .accessibilityLabel("optional_fields_text")
                                    .padding(.top, 10)
                                    .foregroundColor(themeManager.theme.colors.accentXColor)
                                }

                                FieldsView(
                                    fields: viewModel.agreementsFields,
                                    router: viewModel.router,
                                    config: viewModel.config,
                                    cssInjector: viewModel.cssInjector,
                                    proxy: proxy
                                )
                                .transaction { transaction in
                                    transaction.animation = nil
                                }

                                if viewModel.isShowProgress {
                                    HStack(alignment: .center) {
                                        ProgressBar(size: 40, lineWidth: 8)
                                            .padding(20)
                                            .accessibilityLabel("progressbar")
                                    }.frame(maxWidth: .infinity)
                                } else {
                                    StyledButton(AuthLocalization.SignUp.createAccountBtn) {
                                        viewModel.thirdPartyAuthSuccess = false
                                        Task {
                                            await viewModel.registerUser(authMetod: viewModel.authMethod)
                                        }
                                        viewModel.trackCreateAccountClicked()
                                    }
                                    .padding(.top, 30)
                                    .frame(maxWidth: .infinity)
                                    .accessibilityLabel("signup_button")
                                }
                                Spacer()
                            }
                            .padding(.horizontal, 24)
                            .padding(.top, 24)
                            .frameLimit(width: proxy.size.width)
                        }
                        .roundedBackground(themeManager.theme.colors.background)
                        .onSwipeGesture(
                            onLeftSwipe: {
                                if layoutDirection == .rightToLeft {
                                    viewModel.router.back()
                                }
                            },
                            onRightSwipe: {
                                if layoutDirection == .leftToRight {
                                    viewModel.router.back()
                                }
                            }
                        )
                        .scrollAvoidKeyboard(dismissKeyboardByTap: true)
                        .onChange(of: viewModel.scrollTo, perform: { index in
                            withAnimation {
                                scroll.scrollTo(index, anchor: .center)
                                viewModel.scrollTo = nil
                            }
                        })
                    }
                }
            }
            
            if viewModel.showError {
                VStack {
                    Spacer()
                    SnackBarView(message: viewModel.errorMessage)
                }.transition(.move(edge: .bottom))
                    .onAppear {
                        doAfter(Theme.Timeout.snackbarMessageLongTimeout) {
                            viewModel.errorMessage = nil
                        }
                    }
            }
        }
        .ignoresSafeArea(.all, edges: .horizontal)
        .background(themeManager.theme.colors.background.ignoresSafeArea(.all))
        .navigationBarHidden(true)
        .onFirstAppear{
            viewModel.trackScreenEvent()
        }
    }
}

#if DEBUG
struct SignUpView_Previews: PreviewProvider {
    
    static var previews: some View {
        let vm = SignUpViewModel(
            interactor: AuthInteractor.mock,
            router: AuthorizationRouterMock(),
            analytics: AuthorizationAnalyticsMock(),
            config: ConfigMock(),
            cssInjector: CSSInjectorMock(),
            validator: Validator(),
            storage: CoreStorageMock(),
            sourceScreen: .default
        )
        
        SignUpView(viewModel: vm)
            .preferredColorScheme(.light)
            .previewDisplayName("SignUpView Light")
            .loadFonts()
        
        SignUpView(viewModel: vm)
            .preferredColorScheme(.dark)
            .previewDisplayName("SignUpView Dark")
            .loadFonts()
    }
}
#endif
