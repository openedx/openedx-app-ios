//
//  SignInView.swift
//  Authorization
//
//  Created by Vladimir Chekyrta on 13.09.2022.
//

import SwiftUI
import Core
import OEXFoundation
import Theme
import Swinject

public struct SignInView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @State private var email: String = ""
    @State private var password: String = ""
    
    @Environment(\.isHorizontal) private var isHorizontal
    
    @ObservedObject
    private var viewModel: SignInViewModel
    
    @ObservedObject var tenantViewModel: TenantViewModel
    @State var isSuperUser: Bool = false

    func showSuperUserLoginView() {
        isSuperUser.toggle()
    }

    public init(viewModel: SignInViewModel, tenantViewModel: TenantViewModel) {
        self.viewModel = viewModel
        self.tenantViewModel = tenantViewModel
    }
    
    public var body: some View {
        if tenantViewModel.selectedTenant != nil {
            ZStack(alignment: .top) {
                VStack {
                    #if RIYADAH
                    ThemeAssets.riyadahAuthBackground.swiftUIImage
                        .resizable()
                        .edgesIgnoringSafeArea(.top)
                        .accessibilityIdentifier("auth_bg_image")
#elseif NELC
                    themeManager.theme.bgColor
                        .resizable()
                        .edgesIgnoringSafeArea(.top)
                        .accessibilityIdentifier("auth_bg_image")
                    #else
                    ThemeAssets.riyadahAuthBackground.swiftUIImage
                        .resizable()
                        .edgesIgnoringSafeArea(.top)
                        .accessibilityIdentifier("auth_bg_image")
                    #endif
                }.frame(maxWidth: .infinity, maxHeight: 200)
                if viewModel.config.features.startupScreenEnabled ||
                    tenantViewModel.config.tenantsConfig.tenants.count > 1 {
                    VStack {
                        BackNavigationButton(
                            color: themeManager.theme.colors.loginNavigationText,
                            action: {
                                tenantViewModel.config.tenantsConfig.tenants.count > 1 ?
                                tenantViewModel.resetSelectedTenant() :
                                viewModel.router.back(animated: true)
                            }
                        )
                        .environmentObject(themeManager)
                        .backViewStyle()
                        .padding(.leading, isHorizontal ? 48 : 0)
                        .padding(.top, 11)
                        
                    }.frame(maxWidth: .infinity, alignment: .topLeading)
                        .padding(.top, isHorizontal ? 20 : 0)
                }
                
                VStack(alignment: .center) {

#if RIYADAH
                    ThemeAssets.riyadahloginLogoWhite.swiftUIImage
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 189, maxHeight: 89)
                        .padding(.top, isHorizontal ? 20 : 40)
                        .padding(.bottom, isHorizontal ? 10 : 40)
                        .accessibilityIdentifier("logo_image")
                        .onTapGesture(count: 10, perform: {
                            showSuperUserLoginView()
                        })
#elseif NELC
                    themeManager.theme.appLogo
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 189, maxHeight: 89)
                        .padding(.top, isHorizontal ? 20 : 40)
                        .padding(.bottom, isHorizontal ? 10 : 40)
                        .accessibilityIdentifier("logo_image")
                        .onTapGesture(count: 10, perform: {
                            showSuperUserLoginView()
                        })
#else
                    ThemeAssets.appLogo.swiftUIImage
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 189, maxHeight: 89)
                        .padding(.top, isHorizontal ? 20 : 40)
                        .padding(.bottom, isHorizontal ? 10 : 40)
                        .accessibilityIdentifier("logo_image")
                        .onTapGesture(count: 10, perform: {
                            showSuperUserLoginView()
                        })
#endif
                    
                    GeometryReader { _ in
                        ScrollView {
                            VStack {
                                VStack(alignment: .center) {
                                    if self.tenantViewModel.selectedTenant?.uiComponents?.loginRegistrationEnabled ?? false
                                        || isSuperUser{
                                        VStack(alignment: .leading) {
                                            Text(AuthLocalization.SignIn.logInTitle)
                                                .font(Theme.Fonts.displaySmall)
                                                .foregroundColor(themeManager.theme.colors.accentColor)
                                                .padding(.bottom, 4)
                                                .accessibilityIdentifier("signin_text")
                                            Text(AuthLocalization.SignIn.welcomeBack)
                                                .font(Theme.Fonts.titleSmall)
                                                .foregroundColor(themeManager.theme.colors.textPrimary)
                                                .padding(.bottom, 20)
                                                .accessibilityIdentifier("welcome_back_text")
                                            
                                            Text(AuthLocalization.SignIn.emailOrUsername)
                                                .font(Theme.Fonts.labelLarge)
                                                .foregroundColor(themeManager.theme.colors.textPrimary)
                                                .accessibilityIdentifier("username_text")
                                            TextField(AuthLocalization.SignIn.emailOrUsername, text: $email)
                                                .font(Theme.Fonts.bodyLarge)
                                                .foregroundColor(themeManager.theme.colors.textPrimary)
                                                .keyboardType(.emailAddress)
                                                .textContentType(.emailAddress)
                                                .autocapitalization(.none)
                                                .autocorrectionDisabled()
                                                .padding(.all, 14)
                                                .background(
                                                    Theme.Shapes.textInputShape
                                                        .fill(themeManager.theme.colors.textInputBackground)
                                                )
                                                .overlay(
                                                    Theme.Shapes.textInputShape
                                                        .stroke(lineWidth: 1)
                                                        .fill(themeManager.theme.colors.textInputStroke)
                                                )
                                                .accessibilityIdentifier("username_textfield")
                                            
                                            Text(AuthLocalization.SignIn.password)
                                                .font(Theme.Fonts.labelLarge)
                                                .foregroundColor(themeManager.theme.colors.textPrimary)
                                                .padding(.top, 18)
                                                .accessibilityIdentifier("password_text")
                                            SecureField(AuthLocalization.SignIn.password, text: $password)
                                                .font(Theme.Fonts.bodyLarge)
                                                .foregroundColor(themeManager.theme.colors.textPrimary)
                                                .padding(.all, 14)
                                                .background(
                                                    Theme.Shapes.textInputShape
                                                        .fill(themeManager.theme.colors.textInputBackground)
                                                )
                                                .overlay(
                                                    Theme.Shapes.textInputShape
                                                        .stroke(lineWidth: 1)
                                                        .fill(themeManager.theme.colors.textInputStroke)
                                                )
                                                .accessibilityIdentifier("password_textfield")
                                            if !isSuperUser {
                                                HStack {
                                                    if !viewModel.config.features.startupScreenEnabled {
                                                        Button(CoreLocalization.register) {
                                                            viewModel.router.showRegisterScreen(sourceScreen: viewModel.sourceScreen)
                                                        }
                                                        .foregroundColor(themeManager.theme.colors.accentColor)
                                                        .accessibilityIdentifier("register_button")
                                                        
                                                        Spacer()
                                                    }
                                                    
                                                    Button(AuthLocalization.SignIn.forgotPassBtn) {
                                                        viewModel.trackForgotPasswordClicked()
                                                        viewModel.router.showForgotPasswordScreen()
                                                    }
                                                    .font(Theme.Fonts.bodyLarge)
                                                    .foregroundColor(themeManager.theme.colors.accentXColor)
                                                    .padding(.top, 0)
                                                    .accessibilityIdentifier("forgot_password_button")
                                                }
                                            }
                                            
                                            if viewModel.isShowProgress {
                                                HStack(alignment: .center) {
                                                    ProgressBar(size: 40, lineWidth: 8)
                                                        .padding(20)
                                                        .accessibilityIdentifier("progressbar")
                                                }.frame(maxWidth: .infinity)
                                            } else {
                                                StyledButton(CoreLocalization.SignIn.logInBtn, action: {
                                                    Task {
                                                        await viewModel.login(username: email, password: password)
                                                    }
                                                }, color: themeManager.theme.colors.accentColor)
                                                .frame(maxWidth: .infinity)
                                                .padding(.top, 40)
                                                .accessibilityIdentifier("signin_button")
                                                
                                            }
                                        }
                                    }
                                    
                                    if self.tenantViewModel.selectedTenant?.uiComponents?.SAMLSSOLoginEnabled ?? false{
                                        if self.tenantViewModel.selectedTenant?.uiComponents?.loginRegistrationEnabled ?? false{
                                            VStack(alignment: .center) {
                                                Text(AuthLocalization.SignIn.ssoHeading)
                                                    .font(Theme.Fonts.headlineSmall)
                                                    .multilineTextAlignment(.center)
                                                    .foregroundColor(themeManager.theme.colors.textPrimary)
                                                    .padding(.bottom, 4)
                                                    .padding(.horizontal, 20)
                                                    .accessibilityIdentifier("signin_sso_heading")
                                            }
                                            
                                            Divider()
                                            
                                            VStack(alignment: .center) {
                                                ThemeAssets.ssoHeader.swiftUIImage
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(maxWidth: 88, maxHeight: 38)
                                                    .padding(.top, isHorizontal ? 20 : 20)
                                                    .padding(.bottom, isHorizontal ? 10 : 20)
                                                    .accessibilityIdentifier("sso_header")
                                                
                                                Text(AuthLocalization.SignIn.ssoLogInTitle)
                                                    .font(Theme.Fonts.headlineSmall)
                                                    .multilineTextAlignment(.center)
                                                    .foregroundColor(themeManager.theme.colors.textPrimary)
                                                    .padding(.bottom, 10)
                                                    .padding(.horizontal, 20)
                                                    .accessibilityIdentifier("signin_sso_login_title")
                                                
                                                Text(AuthLocalization.SignIn.ssoLogInSubtitle)
                                                    .font(Theme.Fonts.titleMedium)
                                                    .multilineTextAlignment(.center)
                                                    .foregroundColor(themeManager.theme.colors.textSecondaryLight)
                                                    .padding(.bottom, 10)
                                                    .padding(.horizontal, 20)
                                                    .accessibilityIdentifier("signin_sso_login_subtitle")
                                            }
                                        }
                                        
                                        VStack(alignment: .center) {
                                            
                                            if viewModel.isShowProgress && !isSuperUser {
                                                HStack(alignment: .center) {
                                                    ProgressBar(size: 40, lineWidth: 8)
                                                        .padding(20)
                                                        .accessibilityIdentifier("progressbar")
                                                }.frame(maxWidth: .infinity)
                                            } else {
                                                let languageCode = Locale.current.languageCode ?? "en"
                                                if self.tenantViewModel.selectedTenant?.uiComponents?.SAMLSSODefaultLoginButton ?? false {
                                                    Text(AuthLocalization.SignIn.logInTitle)
                                                        .font(Theme.Fonts.displaySmall)
                                                        .foregroundColor(themeManager.theme.colors.accentColor)
                                                        .padding(.bottom, 4)
                                                        .accessibilityIdentifier("signin_text")
                                                    
                                                    Divider()
                                                    
                                                    StyledButton(viewModel.config.ssoButtonTitle[languageCode] as! String,
                                                                 action: {
                                                        viewModel.router.showSSOWebBrowser(title: CoreLocalization.SignIn.logInBtn)
                                                    },
                                                                 color: themeManager.theme.colors.accentColor)
                                                    .frame(maxWidth: .infinity)
                                                    .padding(.top, 20)
                                                    .accessibilityIdentifier("signin_SSO_button")
                                                } else {
                                                    StyledButton(viewModel.config.ssoButtonTitle[languageCode] as! String, action: {
                                                        viewModel.router.showSSOWebBrowser(title: CoreLocalization.SignIn.logInBtn)
                                                    },
                                                                 color: .white,
                                                                 textColor: themeManager.theme.colors.accentColor,
                                                                 borderColor: themeManager.theme.colors.accentColor)
                                                    .frame(maxWidth: .infinity)
                                                    .padding(.top, 20)
                                                    .accessibilityIdentifier("signin_SSO_button")
                                                }
                                                
                                            }
                                        }
                                    }
                                }
                                if viewModel.socialAuthEnabled {
                                    SocialAuthView(
                                        viewModel: .init(
                                            config: viewModel.config
                                        ) { result in
                                            Task { await viewModel.login(with: result) }
                                        }
                                    )
                                }
                                agreements
                                Spacer()
                            }
                            .padding(.horizontal, 24)
                            .padding(.top, 25)
                        }.roundedBackground(themeManager.theme.colors.loginBackground)
                            .scrollAvoidKeyboard(dismissKeyboardByTap: true)
                    }
                }
                
                // MARK: - Alert
                if viewModel.showAlert {
                    VStack {
                        Text(viewModel.alertMessage ?? "")
                            .shadowCardStyle(bgColor: themeManager.theme.colors.accentColor,
                                             textColor: themeManager.theme.colors.white)
                            .padding(.top, 80)
                        Spacer()
                        
                    }
                    .transition(.move(edge: .top))
                    .onAppear {
                        doAfter(Theme.Timeout.snackbarMessageLongTimeout) {
                            viewModel.alertMessage = nil
                        }
                    }
                }
                
                // MARK: - Show error
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
            .navigationBarHidden(true)
            .ignoresSafeArea(.all, edges: .horizontal)
            .background(themeManager.theme.colors.background.ignoresSafeArea(.all))
            .onFirstAppear {
                viewModel.trackScreenEvent()
            }
            .onAppear() {
                tenantViewModel.loadFromUserDefaults()
                NavigationAppearanceManager.shared.updateAppearance(
                    backgroundColor: themeManager.theme.colors.navigationBarColor.uiColor(),
                    titleColor: Color.red.uiColor()
                                )
            }
        } else {
//            ProgressView("Loading tenant...")
        }
    }

    @ViewBuilder
    private var agreements: some View {
        if let eulaURL = viewModel.config.agreement.eulaURL,
            let tosURL =  viewModel.config.agreement.tosURL,
            let policy = viewModel.config.agreement.privacyPolicyURL {
            let text = AuthLocalization.SignIn.agreement(
                "\(viewModel.config.platformName)",
                eulaURL,
                "\(viewModel.config.platformName)",
                tosURL,
                "\(viewModel.config.platformName)",
                policy
            )
            Text(.init(text))
                .tint(themeManager.theme.colors.infoColor)
                .foregroundStyle(themeManager.theme.colors.textSecondaryLight)
                .font(Theme.Fonts.labelSmall)
                .padding(.top, viewModel.socialAuthEnabled ? 0 : 15)
                .padding(.bottom, 15)
                .environment(\.openURL, OpenURLAction(handler: handleURL))
        }
    }

    private func handleURL(_ url: URL) -> OpenURLAction.Result {
        viewModel.router.showWebBrowser(title: url.host ?? "", url: url)
        return .handled
    }
}

#if DEBUG
struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        let vm = SignInViewModel(
            interactor: AuthInteractor.mock,
            router: AuthorizationRouterMock(),
            config: ConfigMock(),
            analytics: AuthorizationAnalyticsMock(),
            validator: Validator(),
            sourceScreen: .default
        )
        let tenantVM = TenantViewModel(
            interactor: AuthInteractor.mock,
            router: AuthorizationRouterMock(),
            config: ConfigMock(),
            analytics: AuthorizationAnalyticsMock()
        )
        SignInView(viewModel: vm, tenantViewModel: tenantVM)
            .preferredColorScheme(.light)
            .previewDisplayName("SignInView Light")
            .loadFonts()
        
        SignInView(viewModel: vm, tenantViewModel: tenantVM)
            .preferredColorScheme(.dark)
            .previewDisplayName("SignInView Dark")
            .loadFonts()
    }
}
#endif
