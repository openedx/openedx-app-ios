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
                ThemeAssets.headerBackground.swiftUIImage
                    .resizable()
                    .edgesIgnoringSafeArea(.top)
            }
            .frame(maxWidth: .infinity, maxHeight: 200)
            .accessibilityIdentifier("auth_bg_image")
            
            // MARK: - Page name
            VStack(alignment: .center) {
                ZStack {
                    HStack {
                        Text(CoreLocalization.SignIn.registerBtn)
                            .titleSettings(color: Theme.Colors.loginNavigationText)
                            .accessibilityIdentifier("register_text")
                    }
                    VStack {
                        BackNavigationButton(
                            color: Theme.Colors.loginNavigationText,
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
                                    .foregroundColor(Theme.Colors.textPrimary)
                                    .padding(.bottom, 4)
                                    .accessibilityIdentifier("signup_text")
                                Text(AuthLocalization.SignUp.subtitle)
                                    .font(Theme.Fonts.titleSmall)
                                    .foregroundColor(Theme.Colors.textPrimary)
                                    .padding(.bottom, 20)
                                    .accessibilityIdentifier("signup_subtitle_text")
                                
                                if viewModel.thirdPartyAuthSuccess {
                                    Text(AuthLocalization.SignUp.successSigninLabel)
                                        .font(Theme.Fonts.titleMedium)
                                        .foregroundColor(Theme.Colors.textPrimary)
                                        .accessibilityIdentifier("social_auth_success_text")
                                    Text(AuthLocalization.SignUp.successSigninSublabel)
                                        .font(Theme.Fonts.titleSmall)
                                        .foregroundColor(Theme.Colors.textSecondary)
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
                                    .foregroundColor(Theme.Colors.accentXColor)
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
                                if viewModel.socialAuthEnabled,
                                    !requiredFields.isEmpty {
                                    SocialAuthView(
                                        authType: .register,
                                        viewModel: .init(
                                            config: viewModel.config
                                        ) { result in
                                            Task { await viewModel.register(with: result) }
                                        }
                                    )
                                    .padding(.bottom, 30)
                                }
                                Spacer()
                            }
                            .padding(.horizontal, 24)
                            .padding(.top, 24)
                            .frameLimit(width: proxy.size.width)
                        }
                        .roundedBackground(Theme.Colors.background)
                        .onRightSwipeGesture {
                            viewModel.router.back()
                        }
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
        .background(Theme.Colors.background.ignoresSafeArea(.all))
        .navigationBarHidden(true)
        .onFirstAppear {
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
