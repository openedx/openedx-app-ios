//
//  SignUpView.swift
//  Authorization
//
//  Created by  Stepanok Ivan on 24.10.2022.
//

import SwiftUI
import Core
import Theme

public struct SignUpView: View {
    
    @State
    private var disclosureGroupOpen: Bool = false
    
    @Environment (\.isHorizontal) private var isHorizontal
    
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
                ThemeAssets.authBackground.swiftUIImage
                    .resizable()
                    .edgesIgnoringSafeArea(.top)
            }.frame(maxWidth: .infinity, maxHeight: 200)
            
            // MARK: - Page name
            VStack(alignment: .center) {
                ZStack {
                    HStack {
                        Text(AuthLocalization.SignIn.registerBtn)
                            .titleSettings(color: Theme.Colors.white)
                    }
                    VStack {
                        Button(action: { viewModel.router.back() }, label: {
                            CoreAssets.arrowLeft.swiftUIImage.renderingMode(.template)
                                .backButtonStyle(color: Theme.Colors.white)
                        })
                        .foregroundColor(Theme.Colors.styledButtonText)
                        .padding(.leading, isHorizontal ? 48 : 0)
                        
                    }.frame(minWidth: 0,
                            maxWidth: .infinity,
                            alignment: .topLeading)
                }
                
                GeometryReader { proxy in
                    ScrollViewReader { scroll in
                        ScrollView {
                            VStack(alignment: .leading) {
                                
                                Text(AuthLocalization.SignUp.title)
                                    .font(Theme.Fonts.displaySmall)
                                    .foregroundColor(Theme.Colors.textPrimary)
                                    .padding(.bottom, 4)
                                Text(AuthLocalization.SignUp.subtitle)
                                    .font(Theme.Fonts.titleSmall)
                                    .foregroundColor(Theme.Colors.textPrimary)
                                    .padding(.bottom, 20)

                                if viewModel.thirdPartyAuthSuccess {
                                    Text(AuthLocalization.SignUp.successSigninLabel)
                                        .font(Theme.Fonts.titleMedium)
                                        .foregroundColor(Theme.Colors.textPrimary)
                                    Text(AuthLocalization.SignUp.successSigninSublabel)
                                        .font(Theme.Fonts.titleSmall)
                                        .foregroundColor(Theme.Colors.textSecondary)
                                        .padding(.bottom, 20)
                                }

                                let requiredFields = viewModel.fields.filter {$0.field.required}
                                let nonRequiredFields = viewModel.fields.filter {!$0.field.required}
                                
                                FieldsView(fields: requiredFields,
                                           router: viewModel.router,
                                           config: viewModel.config,
                                           cssInjector: viewModel.cssInjector,
                                           proxy: proxy)
                                
                                if !viewModel.isShowProgress {
                                    DisclosureGroup(isExpanded: $disclosureGroupOpen, content: {
                                        FieldsView(fields: nonRequiredFields,
                                                   router: viewModel.router,
                                                   config: viewModel.config,
                                                   cssInjector: viewModel.cssInjector,
                                                   proxy: proxy).padding(.horizontal, 1)
                                    }, label: {
                                        Text(disclosureGroupOpen
                                             ? AuthLocalization.SignUp.hideFields
                                             : AuthLocalization.SignUp.showFields)
                                    })
                                }
                                
                                if viewModel.isShowProgress {
                                    HStack(alignment: .center) {
                                        ProgressBar(size: 40, lineWidth: 8)
                                            .padding(20)
                                    }.frame(maxWidth: .infinity)
                                } else {
                                    StyledButton(AuthLocalization.SignUp.createAccountBtn) {
                                        viewModel.thirdPartyAuthSuccess = false
                                        Task {
                                            await viewModel.registerUser()
                                        }
                                        viewModel.trackCreateAccountClicked()
                                    }
                                    .padding(.top, 40)
                                    .frame(maxWidth: .infinity)
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
                            
                        }.roundedBackground(Theme.Colors.background)
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
        .hideNavigationBar()
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
            validator: Validator()
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
