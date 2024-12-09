//
//  EditProfileViewModel.swift
//  Profile
//
//  Created by  Stepanok Ivan on 26.11.2022.
//

import Foundation
import Core
import SwiftUI

public struct Changes: Equatable, Sendable {
    public var shortBiography: String
    public var profileType: ProfileType
    public var isAvatarChanged: Bool
    public var isAvatarDeleted: Bool
    public var isAvatarSaved: Bool
}

@MainActor
public class EditProfileViewModel: ObservableObject {
    
    @Published private(set) var userModel: UserProfile
    @Published private(set) var selectedCountry: PickerItem?
    @Published private(set) var selectedSpokeLanguage: PickerItem?
    @Published private(set) var selectedYearOfBirth: PickerItem?

    var profileDidEdit: (((UserProfile?, UIImage?)) -> Void)?
    var oldAvatar: UIImage?

    private let currentYear = Calendar.current.component(.year, from: Date())
    public let profileTypes: [ProfileType] = [.full, .limited]
    private var years: [PickerFields.Option] = []
    private var spokenLanguages: [PickerFields.Option] = []
    private var countries: [PickerFields.Option] = []
    
    private(set) var editedProfile: UserProfile?
    private(set) var yearsConfiguration: FieldConfiguration = .initial(
        ProfileLocalization.Edit.Fields.yearOfBirth
    )
    private(set) var countriesConfiguration: FieldConfiguration = .initial(
        ProfileLocalization.Edit.Fields.location
    )
    private(set) var spokenLanguageConfiguration: FieldConfiguration = .initial(
        ProfileLocalization.Edit.Fields.spokenLangugae
    )
    
    @Published
    public var profileChanges: Changes = .init(
        shortBiography: "",
        profileType: .limited,
        isAvatarChanged: false,
        isAvatarDeleted: false,
        isAvatarSaved: false
    )
    
    @Published public var inputImage: UIImage?
    private(set) var isYongUser: Bool = false
    private(set) var isEditable: Bool = true
    
    @Published var isChanged = false
    @Published private(set) var isShowProgress = false
    @Published var showError: Bool = false
    @Published var showAlert: Bool = false
    
    var errorMessage: String? {
        didSet {
            withAnimation {
                showError = errorMessage != nil
            }
        }
    }
    
    var alertMessage: String? {
        didSet {
            withAnimation {
                showAlert = alertMessage != nil
            }
        }
    }
    
    let router: ProfileRouter
    
    private let interactor: ProfileInteractorProtocol
    private let analytics: ProfileAnalytics
    
    public init(
        userModel: UserProfile,
        interactor: ProfileInteractorProtocol,
        router: ProfileRouter,
        analytics: ProfileAnalytics
    ) {
        self.userModel = userModel
        self.interactor = interactor
        self.router = router
        self.analytics = analytics
        self.spokenLanguages = interactor.getSpokenLanguages()
        self.countries = interactor.getCountries()
        generateYears()
    }
    
    func resizeImage(image: UIImage, longSideSize: Double) {
        let size = image.size
        
        let widthRatio  = longSideSize / size.width
        let heightRatio = longSideSize / size.height
        
        var newSize: CGSize
        if widthRatio > heightRatio {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        let rect = CGRect(origin: .zero, size: newSize)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.inputImage = newImage
    }
    
    @MainActor
    func deleteAvatar() async throws {
        isShowProgress = true
        do {
            if try await interactor.deleteProfilePicture() {
                inputImage = CoreAssets.noAvatar.image
                isShowProgress = false
            }
        } catch {
            isShowProgress = false
            if error.isInternetError {
                errorMessage = CoreLocalization.Error.slowOrNoInternetConnection
            } else {
                errorMessage = CoreLocalization.Error.unknownError
            }
        }
    }
    
    func checkChanges() {
        withAnimation(.easeIn(duration: 0.1)) {
            self.isChanged = [
                spokenLanguageConfiguration.text.isEmpty
                ? false
                : spokenLanguageConfiguration.text != userModel.spokenLanguage,
                yearsConfiguration.text.isEmpty ? false : yearsConfiguration.text != String(userModel.yearOfBirth),
                countriesConfiguration.text.isEmpty ? false : countriesConfiguration.text != userModel.country,
                userModel.shortBiography != profileChanges.shortBiography,
                profileChanges.isAvatarChanged,
                profileChanges.isAvatarDeleted,
                userModel.isFullProfile != profileChanges.profileType.boolValue
            ].contains(where: { $0 == true })
        }
    }
    
    func switchProfile() {
        var yearOfBirth = 0
        if yearsConfiguration.text != "" {
            yearOfBirth = Int(yearsConfiguration.text) ?? 0
        } else {
            yearOfBirth = userModel.yearOfBirth
        }
        if yearOfBirth == 0 || currentYear - yearOfBirth < 13 {
            alertMessage = ProfileLocalization.Edit.tooYongUser
        } else {
            profileChanges.profileType.toggle()
        }
        
        analytics.profileSwitch(action: profileChanges.profileType.value ?? "")
    }
    
    func checkProfileType() {
        if yearsConfiguration.text != "" {
            let yearOfBirth = yearsConfiguration.text
            if currentYear - (Int(yearOfBirth) ?? 0) < 13 {
                profileChanges.profileType = .limited
                isYongUser = true
            } else {
                withAnimation {
                    isYongUser = false
                }
            }
        } else {
            if (currentYear - userModel.yearOfBirth) < 13 {
                profileChanges.profileType = .limited
                isYongUser = true
            } else {
                withAnimation {
                    isYongUser = false
                }
            }
        }
        if profileChanges.profileType == .full {
            isEditable = true
        } else {
            isEditable = false
        }
    }
    
    @MainActor
    func saveProfileUpdates() async {
        var parameters: [String: any Any & Sendable] = [:]
        
        if userModel.isFullProfile != profileChanges.profileType.boolValue {
            parameters["account_privacy"] = profileChanges.profileType.param
        }
        let country = countriesConfiguration.text
        if country != "" && country != userModel.country {
            parameters["country"] = country
        }
        let spokenLanguage = spokenLanguageConfiguration.text
        if spokenLanguage != "" && spokenLanguage != userModel.spokenLanguage {
            let language: [[String: String]] = [["code": "\(spokenLanguage)"]]
            parameters["language_proficiencies"] = language
        }
        let yearOfBirth = yearsConfiguration.text
        if yearOfBirth != "" && Int(yearOfBirth) != userModel.yearOfBirth {
            parameters["year_of_birth"] = yearOfBirth
        }
        if self.profileChanges.shortBiography != userModel.shortBiography {
            parameters["bio"] = self.profileChanges.shortBiography
        }
        await uploadData(parameters: parameters)
        
        if profileChanges.isAvatarSaved {
            profileDidEdit?((editedProfile, inputImage))
        } else {
            profileDidEdit?((editedProfile, oldAvatar))
        }
    }
    
    @MainActor
    func uploadData(parameters: [String: any Any & Sendable]) async {
        do {
            if profileChanges.isAvatarDeleted {
                try await deleteAvatar()
                profileChanges.isAvatarChanged = false
                profileChanges.isAvatarDeleted = false
                profileChanges.isAvatarSaved = true
                checkChanges()
            }
            if profileChanges.isAvatarChanged {
                if let newImage = inputImage?.jpegData(compressionQuality: 80) {
                    isShowProgress = true
                    try await interactor.uploadProfilePicture(pictureData: newImage)
                    isShowProgress = false
                    profileChanges.isAvatarChanged = false
                    profileChanges.isAvatarSaved = true
                    checkChanges()
                }
            }
            
            if isChanged {
                if !parameters.isEmpty {
                    isShowProgress = true
                    editedProfile = try await interactor.updateUserProfile(parameters: parameters)
                    if let editedProfile {
                        userModel = editedProfile
                    }
                    isChanged = false
                    isShowProgress = false
                }
                isChanged = false
            }
        } catch {
            isShowProgress = false
            if error.isInternetError {
                errorMessage = CoreLocalization.Error.slowOrNoInternetConnection
            } else {
                errorMessage = CoreLocalization.Error.unknownError
            }
        }
    }
    
    func backButtonTapped() {
        if isChanged {
            router.presentAlert(
                alertTitle: ProfileLocalization.UnsavedDataAlert.title,
                alertMessage: ProfileLocalization.UnsavedDataAlert.text,
                positiveAction: CoreLocalization.Alert.accept,
                onCloseTapped: {
                    self.router.dismiss(animated: true)
                },
                okTapped: {
                    self.router.dismiss(animated: false)
                    self.router.back()
                },
                type: .leaveProfile
            )
        } else {
            router.back()
        }
    }
    
    func loadLocationsAndSpokenLanguages() {
        if let yearOfBirth = userModel.yearOfBirth == 0 ? nil : userModel.yearOfBirth {
            self.selectedYearOfBirth = PickerItem(key: "\(yearOfBirth)", value: "\(yearOfBirth)")
        }
        
        if let index = countries.firstIndex(where: {$0.value == userModel.country}) {
            countries[index].optionDefault = true
            let selected = countries[index]
            self.selectedCountry = PickerItem(key: selected.value, value: selected.name)
        }
        if let spokenLanguage = userModel.spokenLanguage {
            if let spokenIndex = spokenLanguages.firstIndex(where: {$0.value == spokenLanguage }) {
                let selected = spokenLanguages[spokenIndex]
                self.selectedSpokeLanguage = PickerItem(key: selected.value, value: selected.name)
            }
        }
        
        generateFieldConfigurations()
    }
    
    private func generateYears() {
        let currentYear = Calendar.current.component(.year, from: Date())
        years = []
        for i in stride(from: currentYear, to: currentYear - 100, by: -1) {
            years.append(PickerFields.Option(value: "\(i)", name: "\(i)", optionDefault: false))
        }
    }
    
    private func generateFieldConfigurations() {
        
        if userModel.isFullProfile {
            profileChanges.profileType = .full
        } else {
            profileChanges.profileType = .limited
        }
        
        yearsConfiguration = FieldConfiguration(
            field: PickerFields(type: .select,
                                label: ProfileLocalization.yearOfBirth,
                                required: false,
                                name: ProfileLocalization.yearOfBirth,
                                instructions: "",
                                options: years),
            selectedItem: selectedYearOfBirth)
        
        countriesConfiguration = FieldConfiguration(
            field: PickerFields(type: .select,
                                label: ProfileLocalization.Edit.Fields.location,
                                required: false,
                                name: ProfileLocalization.Edit.Fields.location,
                                instructions: "",
                                options: countries),
            selectedItem: selectedCountry)
        
        spokenLanguageConfiguration = FieldConfiguration(
            field: PickerFields(type: .select,
                                label: ProfileLocalization.Edit.Fields.spokenLangugae,
                                required: false,
                                name: ProfileLocalization.Edit.Fields.spokenLangugae,
                                instructions: "",
                                options: spokenLanguages),
            selectedItem: selectedSpokeLanguage)
        
        profileChanges.shortBiography = userModel.shortBiography
    }
    
    func trackProfileDeleteAccountClicked() {
        analytics.profileDeleteAccountClicked()
    }
    
    func trackProfileEditDoneClicked() {
        analytics.profileEditDoneClicked()
    }
    
    func trackScreenEvent() {
        analytics.profileScreenEvent(.profileEdit, biValue: .profileEdit)
    }
}
