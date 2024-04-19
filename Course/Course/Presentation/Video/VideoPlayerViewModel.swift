//
//  VideoPlayerViewModel.swift
//  Course
//
//  Created by  Stepanok Ivan on 10.04.2023.
//

import Foundation
import Core
import _AVKit_SwiftUI
import Combine

public class VideoPlayerViewModel: ObservableObject {
    @Published var pause: Bool = false
    @Published var currentTime: Double = 0

    public let connectivity: ConnectivityProtocol

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
    var isPlayingInPip: Bool {
        playerHolder.isPlayingInPip
    }

    var isOtherPlayerInPip: Bool {
        playerHolder.isOtherPlayerInPipPlaying
    }
    public let playerHolder: PlayerViewControllerHolderProtocol

    public init(
        languages: [SubtitleUrl],
        playerStateSubject: CurrentValueSubject<VideoPlayerState?, Never>,
        connectivity: ConnectivityProtocol,
        playerHolder: PlayerViewControllerHolderProtocol
    ) {
        self.languages = languages
        self.connectivity = connectivity
        self.playerHolder = playerHolder
        self.prepareLanguages()
    }
    
    @MainActor
    public func getSubtitles(subtitlesUrl: String) async {
        do {
            let result = try await playerHolder.getService().getSubtitles(
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
    
    func pauseScrolling() {
        pause = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.pause = false
        }
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
        let service = playerHolder.getService()
        let router = service.router
        service.presentView(
            transitionStyle: .crossDissolve,
            animated: true
        ) {
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
