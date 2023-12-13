//
//  VideoPlayerViewModel.swift
//  Course
//
//  Created by  Stepanok Ivan on 10.04.2023.
//

import Foundation
import Core
import _AVKit_SwiftUI

public class VideoPlayerViewModel: ObservableObject {
    
    private var blockID: String
    private var courseID: String

    private let interactor: CourseInteractorProtocol
    public let connectivity: ConnectivityProtocol
    public let router: CourseRouter
    public let appStorage: CoreStorage

    private var subtitlesDownloaded: Bool = false
    @Published var subtitles: [Subtitle] = []
    var languages: [SubtitleUrl]
    @Published var items: [PickerItem] = []
    @Published var selectedLanguage: String?
    
    @Published var showError: Bool = false
    var errorMessage: String? {
        didSet {
            showError = errorMessage != nil
        }
    }

    public var didUnitCompletion: (() -> Void)?

    public init(
        blockID: String,
        courseID: String,
        languages: [SubtitleUrl],
        interactor: CourseInteractorProtocol,
        router: CourseRouter,
        appStorage: CoreStorage,
        connectivity: ConnectivityProtocol
    ) {
        self.blockID = blockID
        self.courseID = courseID
        self.languages = languages
        self.interactor = interactor
        self.router = router
        self.appStorage = appStorage
        self.connectivity = connectivity
        self.prepareLanguages()
    }
    
    @MainActor
    func blockCompletionRequest() async {
        do {
            try await interactor.blockCompletionRequest(courseID: courseID, blockID: blockID)
            NotificationCenter.default.post(
                name: NSNotification.blockCompletion,
                object: nil
            )
        } catch let error {
            if error.isInternetError || error is NoCachedDataError {
                errorMessage = CoreLocalization.Error.slowOrNoInternetConnection
            } else {
                errorMessage = CoreLocalization.Error.unknownError
            }
        }
    }
    
    @MainActor
    public func getSubtitles(subtitlesUrl: String) async {
        do {
            let result = try await interactor.getSubtitles(
                url: subtitlesUrl,
                selectedLanguage: self.selectedLanguage ?? "en"
            )
            subtitles = result
        } catch {
            print(">>>>> ⛔️⛔️⛔️⛔️⛔️⛔️⛔️⛔️", error)
        }
    }
    
    public func prepareLanguages() {
        if !languages.isEmpty {
            generateLanguageItems()
            generateSelectedLanguage()
            loadSelectedSubtitles()
        }
    }
    
    public func generateLanguageName(code: String) -> String {
        let locale = Locale(identifier: code)
        return locale.localizedString(forLanguageCode: code)?.capitalized ?? ""
    }
    
    private func generateLanguageItems() {
        items = languages.map { language in
            let name = generateLanguageName(code: language.language)
            return PickerItem(key: language.language, value: name)
        }
    }
    
    private func generateSelectedLanguage() {
        if let selectedLanguage = languages.first(where: {
            $0.language == Locale.current.languageCode
        })?.language {
            self.selectedLanguage = selectedLanguage
        } else {
            self.selectedLanguage = languages.first?.language ?? ""
        }
        
        if let selectedLanguage {
            moveItemWithKeyToTop(selectedLanguage)
        }
    }
    
    private func loadSelectedSubtitles() {
        let url = languages.first(where: {
            $0.language == selectedLanguage
        })?.url
        subtitles = []
        Task {
            await self.getSubtitles(subtitlesUrl: url ?? languages.first?.url ?? "")
        }
    }
    
    func moveItemWithKeyToTop(_ key: String) {
        if let index = items.firstIndex(where: { $0.key == key }) {
            let item = items.remove(at: index)
            items.insert(item, at: 0)
        }
    }
    
    func presentPicker() {
        router.presentView(transitionStyle: .crossDissolve) {
            PickerMenu(items: items,
                       titleText: generateLanguageName(code: selectedLanguage ?? ""),
                       router: router,
                       selected: { [weak self] selected in
                if selected.key != "" {
                    self?.moveItemWithKeyToTop(selected.key)
                    self?.selectedLanguage = selected.key
                    self?.loadSelectedSubtitles()
                }
            })
        }
    }
}
