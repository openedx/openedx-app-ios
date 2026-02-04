//
//  EditProfileViewModelTests.swift
//  ProfileTests
//
//  Created by  Stepanok Ivan on 18.01.2023.
//

import XCTest
@testable import Core
@testable import Profile
import Alamofire
import SwiftUI

// swiftlint:disable type_body_length file_length
@MainActor
final class EditProfileViewModelTests: XCTestCase {

    func testResizeVerticalImage() async throws {
        let interactor = ProfileInteractorProtocolMock()
        let router = ProfileRouterMock()
        let analytics = ProfileAnalyticsMock()
        let userProfile = UserProfile(
            avatarUrl: "url",
            name: "Test",
            username: "Name",
            dateJoined: Date(),
            yearOfBirth: 2000,
            country: "UA",
            spokenLanguage: "UA",
            shortBiography: "Bio",
            isFullProfile: false,
            email: ""
        )

        interactor.getSpokenLanguagesHandler = { [] }
        interactor.getCountriesHandler = { [] }

        let viewModel = EditProfileViewModel(
            userModel: userProfile,
            interactor: interactor,
            router: router,
            analytics: analytics
        )

        let imageVertical = UIGraphicsImageRenderer(size: CGSize(width: 600, height: 800)).image { rendererContext in
            UIColor.red.setFill()
            rendererContext.fill(CGRect(origin: .zero, size: CGSize(width: 600, height: 800)))
        }

        viewModel.resizeImage(image: imageVertical, longSideSize: 500)

        XCTAssertNotNil(viewModel.inputImage)
        XCTAssertEqual(viewModel.inputImage?.size.height, 500)
    }

    func testResizeHorizontalImage() async throws {
        let interactor = ProfileInteractorProtocolMock()
        let router = ProfileRouterMock()
        let analytics = ProfileAnalyticsMock()
        let userProfile = UserProfile(
            avatarUrl: "url",
            name: "Test",
            username: "Name",
            dateJoined: Date(),
            yearOfBirth: 2000,
            country: "UA",
            spokenLanguage: "UA",
            shortBiography: "Bio",
            isFullProfile: false,
            email: ""
        )

        interactor.getSpokenLanguagesHandler = { [] }
        interactor.getCountriesHandler = { [] }

        let viewModel = EditProfileViewModel(
            userModel: userProfile,
            interactor: interactor,
            router: router,
            analytics: analytics
        )

        let imageHorizontal = UIGraphicsImageRenderer(size: CGSize(width: 800, height: 600)).image { rendererContext in
            UIColor.red.setFill()
            rendererContext.fill(CGRect(origin: .zero, size: CGSize(width: 800, height: 600)))
        }

        viewModel.resizeImage(image: imageHorizontal, longSideSize: 500)

        XCTAssertNotNil(viewModel.inputImage)
        XCTAssertEqual(viewModel.inputImage?.size.width, 500)
    }

    func testCheckChangesShortBiographyChanged() {
        let interactor = ProfileInteractorProtocolMock()
        let router = ProfileRouterMock()
        let analytics = ProfileAnalyticsMock()
        let userProfile = UserProfile(
            avatarUrl: "url",
            name: "Test",
            username: "Name",
            dateJoined: Date(),
            yearOfBirth: 2000,
            country: "UA",
            spokenLanguage: "UA",
            shortBiography: "Bio",
            isFullProfile: false,
            email: ""
        )

        interactor.getSpokenLanguagesHandler = { [] }
        interactor.getCountriesHandler = { [] }

        let viewModel = EditProfileViewModel(
            userModel: userProfile,
            interactor: interactor,
            router: router,
            analytics: analytics
        )

        viewModel.profileChanges.shortBiography = "New bio"
        viewModel.checkChanges()

        XCTAssertTrue(viewModel.isChanged)
    }

    func testCheckChangesSpokenLanguageChanged() {
        let interactor = ProfileInteractorProtocolMock()
        let router = ProfileRouterMock()
        let analytics = ProfileAnalyticsMock()
        let userModel = UserProfile(
            avatarUrl: "url",
            name: "Test",
            username: "Name",
            dateJoined: Date(),
            yearOfBirth: 1986,
            country: "UA",
            spokenLanguage: "UA",
            shortBiography: "Bio",
            isFullProfile: true,
            email: ""
        )

        interactor.getSpokenLanguagesHandler = { [] }
        interactor.getCountriesHandler = { [] }

        let viewModel = EditProfileViewModel(
            userModel: userModel,
            interactor: interactor,
            router: router,
            analytics: analytics
        )

        viewModel.spokenLanguageConfiguration.text = "Changed"
        viewModel.checkChanges()

        XCTAssertTrue(viewModel.isChanged)
    }

    func testCheckChangesBirthYearChanged() {
        let interactor = ProfileInteractorProtocolMock()
        let router = ProfileRouterMock()
        let analytics = ProfileAnalyticsMock()
        let userModel = UserProfile(
            avatarUrl: "url",
            name: "Test",
            username: "Name",
            dateJoined: Date(),
            yearOfBirth: 1986,
            country: "UA",
            spokenLanguage: "UA",
            shortBiography: "Bio",
            isFullProfile: true,
            email: ""
        )

        interactor.getSpokenLanguagesHandler = { [] }
        interactor.getCountriesHandler = { [] }

        let viewModel = EditProfileViewModel(
            userModel: userModel,
            interactor: interactor,
            router: router,
            analytics: analytics
        )

        viewModel.yearsConfiguration.text = "Changed"
        viewModel.checkChanges()

        XCTAssertTrue(viewModel.isChanged)
    }

    func testCheckChangesAvatarChanged() {
        let interactor = ProfileInteractorProtocolMock()
        let router = ProfileRouterMock()
        let analytics = ProfileAnalyticsMock()
        let userModel = UserProfile(
            avatarUrl: "url",
            name: "Test",
            username: "Name",
            dateJoined: Date(),
            yearOfBirth: 1986,
            country: "UA",
            spokenLanguage: "UA",
            shortBiography: "Bio",
            isFullProfile: true,
            email: ""
        )

        interactor.getSpokenLanguagesHandler = { [] }
        interactor.getCountriesHandler = { [] }

        let viewModel = EditProfileViewModel(
            userModel: userModel,
            interactor: interactor,
            router: router,
            analytics: analytics
        )

        viewModel.profileChanges.isAvatarChanged = true
        viewModel.checkChanges()

        XCTAssertTrue(viewModel.isChanged)
    }

    func testCheckChangesProfileTypeChanged() {
        let interactor = ProfileInteractorProtocolMock()
        let router = ProfileRouterMock()
        let analytics = ProfileAnalyticsMock()
        let userModel = UserProfile(
            avatarUrl: "url",
            name: "Test",
            username: "Name",
            dateJoined: Date(),
            yearOfBirth: 1986,
            country: "UA",
            spokenLanguage: "UA",
            shortBiography: "Bio",
            isFullProfile: true,
            email: ""
        )

        interactor.getSpokenLanguagesHandler = { [] }
        interactor.getCountriesHandler = { [] }

        let viewModel = EditProfileViewModel(
            userModel: userModel,
            interactor: interactor,
            router: router,
            analytics: analytics
        )

        viewModel.profileChanges.profileType = .limited
        viewModel.checkChanges()

        XCTAssertTrue(viewModel.isChanged)
    }

    func testCheckChangesCountryChanged() {
        let interactor = ProfileInteractorProtocolMock()
        let router = ProfileRouterMock()
        let analytics = ProfileAnalyticsMock()
        let userModel = UserProfile(
            avatarUrl: "url",
            name: "Test",
            username: "Name",
            dateJoined: Date(),
            yearOfBirth: 1986,
            country: "UA",
            spokenLanguage: "UA",
            shortBiography: "Bio",
            isFullProfile: true,
            email: ""
        )

        interactor.getSpokenLanguagesHandler = { [] }
        interactor.getCountriesHandler = { [] }

        let viewModel = EditProfileViewModel(
            userModel: userModel,
            interactor: interactor,
            router: router,
            analytics: analytics
        )

        viewModel.countriesConfiguration.text = "Changed"
        viewModel.checkChanges()

        XCTAssertTrue(viewModel.isChanged)
    }

    func testCheckProfileTypeNotYongUser() {
        let interactor = ProfileInteractorProtocolMock()
        let router = ProfileRouterMock()
        let analytics = ProfileAnalyticsMock()
        let userModel = UserProfile(
            avatarUrl: "url",
            name: "Test",
            username: "Name",
            dateJoined: Date(),
            yearOfBirth: 1986,
            country: "UA",
            spokenLanguage: "UA",
            shortBiography: "Bio",
            isFullProfile: true,
            email: ""
        )

        interactor.getSpokenLanguagesHandler = { [] }
        interactor.getCountriesHandler = { [] }

        let viewModel = EditProfileViewModel(
            userModel: userModel,
            interactor: interactor,
            router: router,
            analytics: analytics
        )

        viewModel.profileChanges.profileType = viewModel.userModel.isFullProfile ? .full : .limited

        viewModel.yearsConfiguration.text = "1986"
        viewModel.checkProfileType()

        XCTAssertFalse(viewModel.isYongUser)
        XCTAssertTrue(viewModel.isEditable)
        XCTAssertTrue(viewModel.userModel.isFullProfile)
    }

    func testCheckProfileTypeIsYongerUser() {
        let interactor = ProfileInteractorProtocolMock()
        let router = ProfileRouterMock()
        let analytics = ProfileAnalyticsMock()
        let userModel = UserProfile(
            avatarUrl: "url",
            name: "Test",
            username: "Name",
            dateJoined: Date(),
            yearOfBirth: 1986,
            country: "UA",
            spokenLanguage: "UA",
            shortBiography: "Bio",
            isFullProfile: true,
            email: ""
        )

        interactor.getSpokenLanguagesHandler = { [] }
        interactor.getCountriesHandler = { [] }

        let yearOfBirth10Years = Calendar.current.component(.year, from: Date()) - 10

        let viewModel = EditProfileViewModel(
            userModel: userModel,
            interactor: interactor,
            router: router,
            analytics: analytics
        )

        viewModel.yearsConfiguration.text = "\(yearOfBirth10Years - 1)"
        viewModel.checkProfileType()

        XCTAssertEqual(viewModel.profileChanges.profileType, .limited)
        XCTAssertTrue(viewModel.isYongUser)
        XCTAssertFalse(viewModel.isEditable)
    }

    func testCheckProfileTypeYearsConfigurationEmpty() {
        let interactor = ProfileInteractorProtocolMock()
        let router = ProfileRouterMock()
        let analytics = ProfileAnalyticsMock()
        let userModel = UserProfile(
            avatarUrl: "url",
            name: "Test",
            username: "Name",
            dateJoined: Date(),
            yearOfBirth: 0,
            country: "UA",
            spokenLanguage: "UA",
            shortBiography: "Bio",
            isFullProfile: false,
            email: ""
        )

        interactor.getSpokenLanguagesHandler = { [] }
        interactor.getCountriesHandler = { [] }

        let viewModel = EditProfileViewModel(
            userModel: userModel,
            interactor: interactor,
            router: router,
            analytics: analytics
        )

        viewModel.yearsConfiguration.text = ""
        viewModel.checkProfileType()

        XCTAssertEqual(viewModel.profileChanges.profileType, .limited)
        XCTAssertFalse(viewModel.isYongUser)
        XCTAssertFalse(viewModel.isEditable)
    }

    func testCheckProfileTypeYearsConfigurationEmptyYongUser() {

        let interactor = ProfileInteractorProtocolMock()
        let router = ProfileRouterMock()
        let analytics = ProfileAnalyticsMock()
        let userModel = UserProfile(
            avatarUrl: "url",
            name: "Test",
            username: "Name",
            dateJoined: Date(),
            yearOfBirth: 0,
            country: "UA",
            spokenLanguage: "UA",
            shortBiography: "Bio",
            isFullProfile: false,
            email: ""
        )

        interactor.getSpokenLanguagesHandler = { [] }
        interactor.getCountriesHandler = { [] }

        let viewModel = EditProfileViewModel(
            userModel: userModel,
            interactor: interactor,
            router: router,
            analytics: analytics
        )

        viewModel.yearsConfiguration.text = ""
        viewModel.checkProfileType()

        XCTAssertEqual(viewModel.profileChanges.profileType, .limited)
        XCTAssertFalse(viewModel.isYongUser)
        XCTAssertFalse(viewModel.isEditable)
        XCTAssertTrue(viewModel.profileChanges.profileType == .limited)
    }

    func testSaveProfileUpdates() async {
        let interactor = ProfileInteractorProtocolMock()
        let router = ProfileRouterMock()
        let analytics = ProfileAnalyticsMock()
        let userModel = UserProfile(
            avatarUrl: "url",
            name: "Test",
            username: "Name",
            dateJoined: Date(),
            yearOfBirth: 1986,
            country: "UA",
            spokenLanguage: "UA",
            shortBiography: "Bio",
            isFullProfile: true,
            email: ""
        )

        interactor.getSpokenLanguagesHandler = { [] }
        interactor.getCountriesHandler = { [] }

        let viewModel = EditProfileViewModel(
            userModel: userModel,
            interactor: interactor,
            router: router,
            analytics: analytics
        )

        viewModel.countriesConfiguration.text = "USA"
        viewModel.spokenLanguageConfiguration.text = "EN"
        viewModel.yearsConfiguration.text = "1899"
        viewModel.profileChanges.shortBiography = "New bio"
        viewModel.profileChanges.isAvatarChanged = true

        viewModel.checkChanges()

        viewModel.inputImage = UIGraphicsImageRenderer(size: CGSize(width: 400, height: 400)).image { rendererContext in
            UIColor.red.setFill()
            rendererContext.fill(CGRect(origin: .zero, size: CGSize(width: 400, height: 400)))
        }

        interactor.uploadProfilePictureHandler = { _ in }
        interactor.updateUserProfileHandler = { _ in await viewModel.userModel }

        await viewModel.saveProfileUpdates()

        await Task.yield()

        XCTAssertEqual(interactor.uploadProfilePictureCallCount, 1)
        XCTAssertEqual(interactor.updateUserProfileCallCount, 1)
    }

    func testDeleteAvatarSuccess() async {
        let interactor = ProfileInteractorProtocolMock()
        let router = ProfileRouterMock()
        let analytics = ProfileAnalyticsMock()
        let userModel = UserProfile(
            avatarUrl: "url",
            name: "Test",
            username: "Name",
            dateJoined: Date(),
            yearOfBirth: 1986,
            country: "UA",
            spokenLanguage: "UA",
            shortBiography: "Bio",
            isFullProfile: true,
            email: ""
        )

        interactor.getSpokenLanguagesHandler = { [] }
        interactor.getCountriesHandler = { [] }

        let viewModel = EditProfileViewModel(
            userModel: userModel,
            interactor: interactor,
            router: router,
            analytics: analytics
        )

        viewModel.profileChanges.isAvatarDeleted = true

        viewModel.checkChanges()

        viewModel.inputImage = nil

        interactor.updateUserProfileHandler = { _ in await viewModel.userModel }
        interactor.deleteProfilePictureHandler = { true }

        await viewModel.saveProfileUpdates()

        await Task.yield()

        XCTAssertEqual(interactor.deleteProfilePictureCallCount, 1)
        XCTAssertEqual(interactor.updateUserProfileCallCount, 1)
    }

    func testSaveProfileUpdatesNoInternetError() async {
        let interactor = ProfileInteractorProtocolMock()
        let router = ProfileRouterMock()
        let analytics = ProfileAnalyticsMock()
        let userModel = UserProfile(
            avatarUrl: "url",
            name: "Test",
            username: "Name",
            dateJoined: Date(),
            yearOfBirth: 1986,
            country: "UA",
            spokenLanguage: "UA",
            shortBiography: "Bio",
            isFullProfile: true,
            email: ""
        )

        interactor.getSpokenLanguagesHandler = { [] }
        interactor.getCountriesHandler = { [] }

        let viewModel = EditProfileViewModel(
            userModel: userModel,
            interactor: interactor,
            router: router,
            analytics: analytics
        )

        viewModel.countriesConfiguration.text = "USA"
        viewModel.spokenLanguageConfiguration.text = "EN"
        viewModel.yearsConfiguration.text = "1899"
        viewModel.profileChanges.shortBiography = "New bio"
        viewModel.profileChanges.isAvatarChanged = true

        viewModel.checkChanges()

        viewModel.inputImage = UIGraphicsImageRenderer(size: CGSize(width: 400, height: 400)).image { rendererContext in
            UIColor.red.setFill()
            rendererContext.fill(CGRect(origin: .zero, size: CGSize(width: 400, height: 400)))
        }

        let noInternetError = AFError.sessionInvalidated(error: URLError(.notConnectedToInternet))

        interactor.uploadProfilePictureHandler = { _ in }
        interactor.updateUserProfileHandler = { _ in throw noInternetError }

        await viewModel.saveProfileUpdates()

        XCTAssertEqual(interactor.uploadProfilePictureCallCount, 0)
        XCTAssertEqual(interactor.updateUserProfileCallCount, 1)

        XCTAssertTrue(viewModel.showError)
        XCTAssertEqual(viewModel.errorMessage, CoreLocalization.Error.slowOrNoInternetConnection)
        XCTAssertFalse(viewModel.isShowProgress)
        XCTAssertTrue(viewModel.isChanged)
    }

    func testSaveProfileUpdatesUnknownError() async {
        let interactor = ProfileInteractorProtocolMock()
        let router = ProfileRouterMock()
        let analytics = ProfileAnalyticsMock()
        let userModel = UserProfile(
            avatarUrl: "url",
            name: "Test",
            username: "Name",
            dateJoined: Date(),
            yearOfBirth: 1986,
            country: "UA",
            spokenLanguage: "UA",
            shortBiography: "Bio",
            isFullProfile: true,
            email: ""
        )

        interactor.getSpokenLanguagesHandler = { [] }
        interactor.getCountriesHandler = { [] }

        let viewModel = EditProfileViewModel(
            userModel: userModel,
            interactor: interactor,
            router: router,
            analytics: analytics
        )

        viewModel.countriesConfiguration.text = "USA"
        viewModel.spokenLanguageConfiguration.text = "EN"
        viewModel.yearsConfiguration.text = "1899"
        viewModel.profileChanges.shortBiography = "New bio"
        viewModel.profileChanges.isAvatarChanged = true

        viewModel.checkChanges()

        viewModel.inputImage = UIGraphicsImageRenderer(size: CGSize(width: 400, height: 400)).image { rendererContext in
            UIColor.red.setFill()
            rendererContext.fill(CGRect(origin: .zero, size: CGSize(width: 400, height: 400)))
        }

        interactor.uploadProfilePictureHandler = { _ in }
        interactor.updateUserProfileHandler = { _ in throw NSError(domain: "error", code: -1, userInfo: nil) }

        await viewModel.saveProfileUpdates()

        await Task.yield()

        XCTAssertEqual(interactor.uploadProfilePictureCallCount, 0)
        XCTAssertEqual(interactor.updateUserProfileCallCount, 1)

        XCTAssertTrue(viewModel.showError)
        XCTAssertEqual(viewModel.errorMessage, CoreLocalization.Error.unknownError)
        XCTAssertFalse(viewModel.isShowProgress)
        XCTAssertTrue(viewModel.isChanged)
    }

    func testBackButtonTapped() {
        let interactor = ProfileInteractorProtocolMock()
        let router = ProfileRouterMock()
        let analytics = ProfileAnalyticsMock()
        let userModel = UserProfile(
            avatarUrl: "url",
            name: "Test",
            username: "Name",
            dateJoined: Date(),
            yearOfBirth: 1986,
            country: "UA",
            spokenLanguage: "UA",
            shortBiography: "Bio",
            isFullProfile: true,
            email: ""
        )

        interactor.getSpokenLanguagesHandler = { [] }
        interactor.getCountriesHandler = { [] }

        let viewModel = EditProfileViewModel(
            userModel: userModel,
            interactor: interactor,
            router: router,
            analytics: analytics
        )

        viewModel.profileChanges.isAvatarChanged = true
        viewModel.checkChanges()
        viewModel.backButtonTapped()

        XCTAssertEqual(router.presentAlertCallCount, 1)
    }

    func testGenerateFieldConfigurationsFullProfile() {
        let interactor = ProfileInteractorProtocolMock()
        let router = ProfileRouterMock()
        let analytics = ProfileAnalyticsMock()
        let userModel = UserProfile(
            avatarUrl: "url",
            name: "Test",
            username: "Name",
            dateJoined: Date(),
            yearOfBirth: 1986,
            country: "UA",
            spokenLanguage: "UA",
            shortBiography: "Bio",
            isFullProfile: true,
            email: ""
        )

        interactor.getSpokenLanguagesHandler = { [] }
        interactor.getCountriesHandler = { [] }

        let viewModel = EditProfileViewModel(
            userModel: userModel,
            interactor: interactor,
            router: router,
            analytics: analytics
        )

        viewModel.loadLocationsAndSpokenLanguages()

        XCTAssertTrue(viewModel.profileChanges.profileType == .full)
        XCTAssertEqual(viewModel.profileChanges.shortBiography, viewModel.userModel.shortBiography)
    }

    func testGenerateFieldConfigurationsLimitedProfile() {
        let interactor = ProfileInteractorProtocolMock()
        let router = ProfileRouterMock()
        let analytics = ProfileAnalyticsMock()
        let userModel = UserProfile(
            avatarUrl: "url",
            name: "Test",
            username: "Name",
            dateJoined: Date(),
            yearOfBirth: 1986,
            country: "UA",
            spokenLanguage: "UA",
            shortBiography: "Bio",
            isFullProfile: false,
            email: ""
        )

        interactor.getSpokenLanguagesHandler = { [] }
        interactor.getCountriesHandler = { [] }

        let viewModel = EditProfileViewModel(
            userModel: userModel,
            interactor: interactor,
            router: router,
            analytics: analytics
        )

        viewModel.loadLocationsAndSpokenLanguages()

        XCTAssertTrue(viewModel.profileChanges.profileType == .limited)
    }

    func testLoadLocationsAndSpokenLanguages() async throws {
        let interactor = ProfileInteractorProtocolMock()
        let router = ProfileRouterMock()
        let analytics = ProfileAnalyticsMock()
        let userModel = UserProfile(
            avatarUrl: "url",
            name: "Test",
            username: "Name",
            dateJoined: Date(),
            yearOfBirth: 1986,
            country: "UA",
            spokenLanguage: "UA",
            shortBiography: "Bio",
            isFullProfile: true,
            email: ""
        )

        let languages = [
            PickerFields.Option(value: "UA", name: "Ukraine", optionDefault: true),
            PickerFields.Option(value: "USA", name: "United States of America", optionDefault: false)
        ]

        interactor.getSpokenLanguagesHandler = { languages }
        interactor.getCountriesHandler = { languages }

        let viewModel = EditProfileViewModel(
            userModel: userModel,
            interactor: interactor,
            router: router,
            analytics: analytics
        )

        viewModel.loadLocationsAndSpokenLanguages()

        await Task.yield()

        XCTAssertEqual(interactor.getSpokenLanguagesCallCount, 1)
        XCTAssertEqual(interactor.getCountriesCallCount, 1)
    }

    func testTrackProfileDeleteAccountClicked() {
        let interactor = ProfileInteractorProtocolMock()
        let router = ProfileRouterMock()
        let analytics = ProfileAnalyticsMock()
        let userModel = UserProfile(
            avatarUrl: "url",
            name: "Test",
            username: "Name",
            dateJoined: Date(),
            yearOfBirth: 1986,
            country: "UA",
            spokenLanguage: "UA",
            shortBiography: "Bio",
            isFullProfile: false,
            email: ""
        )

        interactor.getSpokenLanguagesHandler = { [] }
        interactor.getCountriesHandler = { [] }

        let viewModel = EditProfileViewModel(
            userModel: userModel,
            interactor: interactor,
            router: router,
            analytics: analytics
        )

        viewModel.trackProfileDeleteAccountClicked()

        XCTAssertEqual(analytics.profileDeleteAccountClickedCallCount, 1)
    }

    func testTrackProfileEditDoneClicked() {
        let interactor = ProfileInteractorProtocolMock()
        let router = ProfileRouterMock()
        let analytics = ProfileAnalyticsMock()
        let userModel = UserProfile(
            avatarUrl: "url",
            name: "Test",
            username: "Name",
            dateJoined: Date(),
            yearOfBirth: 1986,
            country: "UA",
            spokenLanguage: "UA",
            shortBiography: "Bio",
            isFullProfile: false,
            email: ""
        )

        interactor.getSpokenLanguagesHandler = { [] }
        interactor.getCountriesHandler = { [] }

        let viewModel = EditProfileViewModel(
            userModel: userModel,
            interactor: interactor,
            router: router,
            analytics: analytics
        )

        viewModel.trackProfileEditDoneClicked()

        XCTAssertEqual(analytics.profileEditDoneClickedCallCount, 1)
    }
}
