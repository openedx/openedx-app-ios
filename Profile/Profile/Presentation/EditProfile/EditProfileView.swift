//
//  EditProfileView.swift
//  Profile
//
//  Created by  Stepanok Ivan on 26.11.2022.
//

import SwiftUI
import Core
import Theme

public struct EditProfileView: View {
    
    @ObservedObject public var viewModel: EditProfileViewModel
    @State private var showingImagePicker = false
    @State private var showingBottomSheet = false
    
    public init(
        viewModel: EditProfileViewModel,
        avatar: UIImage?,
        profileDidEdit: @escaping ((UserProfile?, UIImage?)) -> Void
    ) {
        self.viewModel = viewModel
        self.viewModel.profileDidEdit = profileDidEdit
        self.viewModel.inputImage = avatar
        self.viewModel.oldAvatar = avatar
        self.viewModel.loadLocationsAndSpokenLanguages()
    }
    
    public var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .top) {
                // MARK: - Page Body
                ScrollView {
                    VStack {
                        Text(viewModel.profileChanges.profileType.localizedValue.capitalized)
                            .font(Theme.Fonts.titleSmall)
                            .foregroundColor(Theme.Colors.textSecondary)
                            .accessibilityIdentifier("profile_type_text")
                        Button(action: {
                            withAnimation {
                                showingBottomSheet.toggle()
                            }
                        }, label: {
                            UserAvatar(url: viewModel.userModel.avatarUrl, image: $viewModel.inputImage)
                                .padding(.top, 30)
                                .overlay(
                                    ZStack {
                                        Circle().frame(width: 36, height: 36)
                                            .foregroundColor(Theme.Colors.accentXColor)
                                        CoreAssets.addPhoto.swiftUIImage.renderingMode(.template)
                                            .foregroundColor(Theme.Colors.primaryButtonTextColor)
                                    }.offset(x: 36, y: 50)
                                )
                        })
                        .accessibilityIdentifier("change_profile_image_button")
                        
                        Text(viewModel.userModel.name)
                            .font(Theme.Fonts.headlineSmall)
                            .accessibilityIdentifier("username_text")
                        
                        Button(ProfileLocalization.switchTo + " " +
                               viewModel.profileChanges.profileType.switchToButtonTitle,
                               action: {
                            viewModel.switchProfile()
                        })
                        .padding(.vertical, 24)
                        .font(Theme.Fonts.labelLarge)
                        .accessibilityIdentifier("switch_profile_button")
                        
                        Group {
                            PickerView(
                                config: viewModel.yearsConfiguration,
                                router: viewModel.router
                            )
                            if viewModel.isEditable {
                                VStack(alignment: .leading) {
                                    PickerView(config: viewModel.countriesConfiguration,
                                               router: viewModel.router)
                                    
                                    PickerView(config: viewModel.spokenLanguageConfiguration,
                                               router: viewModel.router)
                                    
                                    Text(ProfileLocalization.Edit.Fields.aboutMe)
                                        .font(Theme.Fonts.titleMedium)
                                        .accessibilityIdentifier("about_text")
                                    TextEditor(text: $viewModel.profileChanges.shortBiography)
                                        .font(Theme.Fonts.bodyMedium)
                                        .foregroundColor(Theme.Colors.textInputTextColor)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 4)
                                        .frame(height: 200)
                                        .hideScrollContentBackground()
                                        .background(
                                            Theme.Shapes.textInputShape
                                                .fill(Theme.Colors.textInputBackground)
                                        )
                                        .overlay(
                                            Theme.Shapes.textInputShape
                                                .stroke(lineWidth: 1)
                                                .fill(
                                                    Theme.Colors.textInputStroke
                                                )
                                        )
                                        .accessibilityIdentifier("short_bio_textarea")
                                }
                            }
                        }
                        .onReceive(viewModel.yearsConfiguration.$text
                            .combineLatest(viewModel.countriesConfiguration.$text,
                                           viewModel.spokenLanguageConfiguration.$text),
                                   perform: { _ in
                            viewModel.checkChanges()
                            viewModel.checkProfileType()
                        })
                        .onChange(of: viewModel.profileChanges) { _ in
                            viewModel.checkChanges()
                            viewModel.checkProfileType()
                        }
                        .onChange(of: viewModel.profileChanges.shortBiography, perform: { bio in
                            if bio.count > 300 {
                                viewModel.profileChanges.shortBiography.removeLast()
                            }
                        })
                        
                        Button(ProfileLocalization.Edit.deleteAccount, action: {
                            viewModel.trackProfileDeleteAccountClicked()
                            viewModel.router.showDeleteProfileView()
                        })
                        .font(Theme.Fonts.labelLarge)
                        .foregroundColor(Theme.Colors.alert)
                        .padding(.top, 44)
                        .accessibilityIdentifier("delete_account_button")
                        
                        Spacer(minLength: 84)
                    }
                    .padding(.horizontal, 24)
                    .sheet(isPresented: $showingImagePicker) {
                        ImagePickerView(image: $viewModel.inputImage)
                            .ignoresSafeArea()
                    }
                    .frameLimit(width: proxy.size.width)
                }
                .padding(.top, 8)
                .onChange(of: showingImagePicker, perform: { value in
                    if !value {
                        if let image = viewModel.inputImage {
                            viewModel.profileChanges.isAvatarChanged = true
                            viewModel.resizeImage(image: image, longSideSize: 500)
                        }
                    }
                })
                .onRightSwipeGesture {
                    viewModel.backButtonTapped()
                }
                .scrollAvoidKeyboard(dismissKeyboardByTap: true)
                .ignoresSafeArea(edges: .bottom)
                // MARK: - Error Alert
                if viewModel.showError {
                    VStack {
                        Spacer()
                        SnackBarView(message: viewModel.errorMessage)
                    }
                    .transition(.move(edge: .bottom))
                    .onAppear {
                        doAfter(Theme.Timeout.snackbarMessageLongTimeout) {
                            viewModel.errorMessage = nil
                        }
                    }
                }
                // MARK: - Alert
                if viewModel.showAlert {
                    VStack(alignment: .center) {
                        Spacer()
                        HStack(alignment: .top, spacing: 6) {
                            CoreAssets.alarm.swiftUIImage.renderingMode(.template)
                            Text(viewModel.alertMessage ?? "")
                                .font(Theme.Fonts.labelLarge)
                        }.shadowCardStyle(bgColor: Theme.Colors.warning,
                                          textColor: .black)
                        .transition(.move(edge: .bottom))
                        .onAppear {
                            doAfter(Theme.Timeout.snackbarMessageLongTimeout) {
                                viewModel.alertMessage = nil
                            }
                        }
                    }
                }
                ProfileBottomSheet(
                    showingBottomSheet: $showingBottomSheet,
                    openGallery: {
                        showingImagePicker = true
                        withAnimation {
                            showingBottomSheet = false
                        }
                    },
                    removePhoto: {
                        viewModel.inputImage = CoreAssets.noAvatar.image
                        viewModel.profileChanges.isAvatarDeleted = true
                        showingBottomSheet = false
                    })
                
                if viewModel.isShowProgress {
                    ProgressBar(size: 40, lineWidth: 8)
                        .padding(.top, 150)
                        .padding(.horizontal)
                        .accessibilityIdentifier("progressbar")
                }
            }
            .navigationBarHidden(false)
            .navigationBarBackButtonHidden(true)
            .navigationTitle(ProfileLocalization.editProfile)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading, content: {
                    Button(action: {
                        viewModel.backButtonTapped()
                    }, label: {
                        CoreAssets.arrowLeft.swiftUIImage
                            .renderingMode(.template)
                            .foregroundColor(Theme.Colors.accentColor)
                    })
                })
                ToolbarItem(placement: .navigationBarTrailing, content: {
                    Button(action: {
                        if viewModel.isChanged {
                            Task {
                                viewModel.trackProfileEditDoneClicked()
                                await viewModel.saveProfileUpdates()
                            }
                        }
                    }, label: {
                        HStack(spacing: 2) {
                            CoreAssets.done.swiftUIImage.renderingMode(.template)
                                .foregroundColor(Theme.Colors.accentXColor)
                            Text(CoreLocalization.done)
                                .font(Theme.Fonts.labelLarge)
                                .foregroundColor(Theme.Colors.accentXColor)
                        }
                    })
                    .opacity(viewModel.isChanged ? 1 : 0.3)
                    .accessibilityIdentifier("done_button")
                })
            }
            .background(
                Theme.Colors.background
                    .ignoresSafeArea()
            )
        }
    }
}

#if DEBUG
struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        let userModel = UserProfile(
            avatarUrl: "",
            name: "Peter Parket",
            username: "Peter",
            dateJoined: Date(),
            yearOfBirth: 0,
            country: "Ukraine",
            shortBiography: "",
            isFullProfile: true
        )
        
        EditProfileView(
            viewModel: EditProfileViewModel(
                userModel: userModel,
                interactor: ProfileInteractor.mock,
                router: ProfileRouterMock(),
                analytics: ProfileAnalyticsMock()),
            avatar: nil,
            profileDidEdit: {_ in}
        )
    }
}
#endif
