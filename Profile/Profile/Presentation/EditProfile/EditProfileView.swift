//
//  EditProfileView.swift
//  Profile
//
//  Created by  Stepanok Ivan on 26.11.2022.
//

import SwiftUI
import Core

public struct EditProfileView: View {
    
    @ObservedObject private var viewModel: EditProfileViewModel
    @State private var showingImagePicker = false
    @State private var showingBottomSheet = false
    private var oldAvatar: UIImage?
    private var profileDidEdit: ((UserProfile?, UIImage?)) -> Void
    
    public init(
        viewModel: EditProfileViewModel,
        avatar: UIImage?,
        profileDidEdit: @escaping ((UserProfile?, UIImage?)) -> Void
    ) {
        self.viewModel = viewModel
        self.profileDidEdit = profileDidEdit
        self.viewModel.inputImage = avatar
        self.oldAvatar = avatar
        self.viewModel.loadLocationsAndSpokenLanguages()
    }
    
    public var body: some View {
        ZStack(alignment: .top) {
            
            // MARK: - Page name
            VStack(alignment: .center) {
                NavigationBar(
                    title: ProfileLocalization.editProfile,
                    leftButtonAction: {
                        viewModel.backButtonTapped()
                        if viewModel.profileChanges.isAvatarSaved {
                            self.profileDidEdit((viewModel.editedProfile, viewModel.inputImage))
                        } else {
                            self.profileDidEdit((viewModel.editedProfile, oldAvatar))
                        }
                    },
                    rightButtonType: .done,
                    rightButtonAction: {
                        if viewModel.isChanged {
                            Task {
                                viewModel.analytics.profileEditDoneClicked()
                                await viewModel.saveProfileUpdates()
                            }
                        }
                    },
                    rightButtonIsActive: $viewModel.isChanged
                )
                
                // MARK: - Page Body
                ScrollView {
                    VStack {
                        Text(viewModel.profileChanges.profileType.localizedValue.capitalized)
                            .font(Theme.Fonts.titleSmall)
                            .foregroundColor(CoreAssets.textSecondary.swiftUIColor)
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
                                            .foregroundColor(CoreAssets.accentColor.swiftUIColor)
                                        CoreAssets.addPhoto.swiftUIImage
                                            .foregroundColor(.white)
                                    }.offset(x: 36, y: 50)
                                )
                        }).disabled(!viewModel.isEditable)
                        
                        Text(viewModel.userModel.name)
                            .font(Theme.Fonts.headlineSmall)
                        
                        Button(ProfileLocalization.switchTo + " " +
                               viewModel.profileChanges.profileType.switchToButtonTitle,
                               action: {
                            viewModel.switchProfile()
                        }).padding(.vertical, 24)
                            .font(Theme.Fonts.labelLarge)
                        
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
                                    TextEditor(text: $viewModel.profileChanges.shortBiography)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 4)
                                        .frame(height: 200)
                                        .hideScrollContentBackground()
                                        .background(
                                            Theme.Shapes.textInputShape
                                                .fill(CoreAssets.textInputBackground.swiftUIColor)
                                        )
                                        .overlay(
                                            Theme.Shapes.textInputShape
                                                .stroke(lineWidth: 1)
                                                .fill(
                                                    CoreAssets.textInputStroke.swiftUIColor
                                                )
                                        )
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
                            viewModel.analytics.profileDeleteAccountClicked()
                            viewModel.router.showDeleteProfileView()
                        })
                        .font(Theme.Fonts.labelLarge)
                        .foregroundColor(CoreAssets.alert.swiftUIColor)
                        .padding(.top, 44)
                        
                        Spacer(minLength: 84)
                    }.padding(.horizontal, 24)
                        .sheet(isPresented: $showingImagePicker) {
                            ImagePickerView(image: $viewModel.inputImage)
                                .ignoresSafeArea()
                        }
                }
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
                    if viewModel.profileChanges.isAvatarSaved {
                        self.profileDidEdit((viewModel.editedProfile, viewModel.inputImage))
                    } else {
                        self.profileDidEdit((viewModel.editedProfile, oldAvatar))
                    }
                }
                
                .scrollAvoidKeyboard(dismissKeyboardByTap: true)
                .frameLimit(sizePortrait: 420)
            }.ignoresSafeArea(edges: .bottom)
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
                    }.shadowCardStyle(bgColor: CoreAssets.warning.swiftUIColor,
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
            }
        }
        .background(
            CoreAssets.background.swiftUIColor
                .ignoresSafeArea()
        )
    }
}

#if DEBUG
struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        let userModel = UserProfile(avatarUrl: "",
                                    name: "Peter Parket",
                                    username: "Peter",
                                    dateJoined: Date(),
                                    yearOfBirth: 0,
                                    country: "Ukraine",
                                    shortBiography: "",
                                    isFullProfile: true)
        
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
