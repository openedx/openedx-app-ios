//
//  VideoPlayerViewModel.swift
//  Course
//
//  Created by  Stepanok Ivan on 10.04.2023.
//

import Foundation
import Core
import OEXFoundation
import _AVKit_SwiftUI
import Combine

@MainActor
public class VideoPlayerViewModel: ObservableObject {
    @Published var pause: Bool = false
    @Published var currentTime: Double = 0
    @Published var isLoading: Bool = true

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
    internal var subscription = Set<AnyCancellable>()
    private var appStorage: CoreStorage?
    private var analytics: CourseAnalytics?
    private var lastSavedTime: Double = 0

    public init(
        languages: [SubtitleUrl],
        playerStateSubject: CurrentValueSubject<VideoPlayerState?, Never>? = nil,
        connectivity: ConnectivityProtocol,
        playerHolder: PlayerViewControllerHolderProtocol,
        appStorage: CoreStorage?,
        analytics: CourseAnalytics?
    ) {
        self.languages = languages
        self.connectivity = connectivity
        self.playerHolder = playerHolder
        self.prepareLanguages()
        self.appStorage = appStorage
        self.analytics = analytics
        
        observePlayer(with: playerStateSubject)
    }
    
    func observePlayer(with playerStateSubject: CurrentValueSubject<VideoPlayerState?, Never>?) {
        playerStateSubject?.sink { [weak self] state in
            switch state {
            case .pause:
                if self?.playerHolder.isPlayingInPip != true {
                    self?.playerHolder.playerController?.pause()
                }
            case .kill:
                if self?.playerHolder.isPlayingInPip != true {
                    self?.playerHolder.playerController?.stop()
                }
            case .none:
                break
            }
        }
        .store(in: &subscription)
        
        playerHolder.getTimePublisher()
            .sink {[weak self] time in
                self?.currentTime = time
            }
            .store(in: &subscription)
        playerHolder.getErrorPublisher()
            .sink {[weak self] error in
                if error.isInternetError || error is NoCachedDataError {
                    self?.errorMessage = CoreLocalization.Error.slowOrNoInternetConnection
                } else {
                    self?.errorMessage = CoreLocalization.Error.unknownError
                }
            }
            .store(in: &subscription)
        playerHolder.getReadyPublisher()
            .sink {[weak self] isReady in
                guard isReady else { return }
                self?.isLoading = false
                self?.trackVideoLoaded()
                self?.loadAndApplyLocalProgress()
            }
            .store(in: &subscription)
        
        playerHolder.getRatePublisher()
            .sink {[weak self] rate in
                guard self?.isLoading == false else { return }
                self?.trackVideoSpeedChange(rate: rate)
            }
            .store(in: &subscription)
        
        playerHolder.getFinishPublisher()
            .sink { [weak self] in
                self?.trackVideoCompleted()
            }
            .store(in: &subscription)

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
            debugLog(">>>>> ⛔️⛔️⛔️⛔️⛔️⛔️⛔️⛔️", error)
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
            $0.language == Locale.current.language.languageCode?.identifier
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
    
    private func trackVideoLoaded() {
        analytics?.videoLoaded(
            courseID: playerHolder.courseID,
            blockID: playerHolder.blockID,
            videoURL: playerHolder.url?.absoluteString ?? ""
        )
    }
    
    private func trackVideoPlayed() {
        analytics?.videoPlayed(
            courseID: playerHolder.courseID,
            blockID: playerHolder.blockID,
            videoURL: playerHolder.url?.absoluteString ?? ""
        )
    }
    
    private func trackVideoSpeedChange(rate: Float) {
        if rate == 0 {
            analytics?.videoPaused(
                courseID: playerHolder.courseID,
                blockID: playerHolder.blockID,
                videoURL: playerHolder.url?.absoluteString ?? "",
                currentTime: currentTime,
                duration: playerHolder.duration
            )
        } else {
            guard let storage = appStorage,
                  let userSettings = storage.userSettings
            else {
                return
            }
            
            if userSettings.videoPlaybackSpeed == rate {
                analytics?.videoPlayed(
                    courseID: playerHolder.courseID,
                    blockID: playerHolder.blockID,
                    videoURL: playerHolder.url?.absoluteString ?? ""
                )
            } else {
                analytics?.videoSpeedChange(
                    courseID: playerHolder.courseID,
                    blockID: playerHolder.blockID,
                    videoURL: playerHolder.url?.absoluteString ?? "",
                    oldSpeed: userSettings.videoPlaybackSpeed,
                    newSpeed: rate,
                    currentTime: currentTime,
                    duration: playerHolder.duration
                )
            }
        }
    }
    
    public func saveCurrentProgress() {
        
        Task {
            let time = currentTime
            let duration = playerHolder.duration
            let blockID = playerHolder.blockID
                        
            if duration > 0 && time > 0 {
                let progress = min(time / duration, 1.0)
                await playerHolder.getService().updateVideoProgress(progress: progress)
            }
        }
    }
    
    private func loadAndApplyLocalProgress() {
        Task {
            let blockID = playerHolder.blockID
            let duration = playerHolder.duration
            
            if let localProgress = await playerHolder.getService().loadVideoProgress() {
                
                if localProgress > 0 && duration > 0 {
                    let timeToSeek = localProgress * duration
                    
                    await MainActor.run {
                        // Seek to the saved position
                        if let playerController = playerHolder.playerController {
                            let seekDate = Date(timeIntervalSince1970: timeToSeek)
                            playerController.seekTo(to: seekDate)
                        }
                    }
                }
            }
        }
    }
    
    private func trackVideoCompleted() {
        analytics?.videoCompleted(
            courseID: playerHolder.courseID,
            blockID: playerHolder.blockID,
            videoURL: playerHolder.url?.absoluteString ?? "",
            currentTime: currentTime,
            duration: playerHolder.duration
        )
    }
    
    func findSubtitle(at currentTime: Date) -> Subtitle? {
        return subtitles.first { $0.fromTo.contains(currentTime) }
    }
}
