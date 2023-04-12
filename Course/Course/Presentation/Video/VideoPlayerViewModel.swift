//
//  VideoPlayerViewModel.swift
//  Course
//
//  Created by  Stepanok Ivan on 10.04.2023.
//

import Foundation
import Core

public class VideoPlayerViewModel: ObservableObject {
 
    private let interactor: CourseInteractorProtocol
    public let connectivity: ConnectivityProtocol
    public let router: CourseRouter

    private var subtitlesDownloaded: Bool = false
    @Published var subtitles: [Subtitle] = []
    @Published var languages: [SubtitleUrl] = []
    @Published var items: [PickerItem] = []
    @Published var selectedLanguage: String?
    
    @Published var showError: Bool = false
    var errorMessage: String? {
        didSet {
            showError = errorMessage != nil
        }
    }

    public init(interactor: CourseInteractorProtocol,
                router: CourseRouter,
                connectivity: ConnectivityProtocol) {
        self.interactor = interactor
        self.router = router
        self.connectivity = connectivity
    }
    
    @MainActor
    func blockCompletionRequest(blockID: String, courseID: String) async {
        let fullBlockID = "block-v1:\(courseID.dropFirst(10))+type@discussion+block@\(blockID)"
        do {
            try await interactor.blockCompletionRequest(courseID: courseID, blockID: fullBlockID)
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
        guard let result = try? await interactor.getSubtitles(url: subtitlesUrl) else { return }
        subtitles = parseSubtitles(from: result)
    }
    
    func removeEmptyElements(from subtitlesString: String) -> String {
        let subtitleComponents = subtitlesString.components(separatedBy: "\n\n")
            .filter({
                let lines = $0.components(separatedBy: .newlines)

                if lines.count >= 3 {
                    let text = lines[2..<lines.count].joined(separator: "\n")
                    if !text.isEmpty {
                       return true
                    }
                }
                return false
            })
            .map {
                if $0.hasPrefix("\n") {
                    let index = $0.index($0.startIndex, offsetBy: 1)
                    return String($0[index...])
                } else {
                    return $0
                }
            }
        
        return subtitleComponents.joined(separator: "\n\n")
    }
    
    func parseSubtitles(from subtitlesString: String) -> [Subtitle] {
        let clearedSubtitles = removeEmptyElements(from: subtitlesString)
        let subtitleComponents = clearedSubtitles.components(separatedBy: "\n\n")
        var subtitles = [Subtitle]()
        
        for component in subtitleComponents {
            let lines = component.components(separatedBy: .newlines)
            
            if lines.count >= 3 {
                let idString = lines[0]
                let id = Int(idString) ?? 0
                
                let startAndEndTimes = lines[1].components(separatedBy: " --> ")
                let startTime = startAndEndTimes.first ?? "00:00:00,000"
                let endTime = startAndEndTimes.last ?? "00:00:00,000"
                let text = lines[2..<lines.count].joined(separator: "\n")
                
                let subtitle = Subtitle(id: id,
                                        fromTo: DateInterval(start: Date(subtitleTime: startTime),
                                                             end: Date(subtitleTime: endTime)),
                                        text: text)
                subtitles.append(subtitle)
            }
        }
        return subtitles
    }
    
    public func generateLanguageName(code: String) -> String {
        let locale = Locale(identifier: code)
        return locale.localizedString(forLanguageCode: code)?.capitalized ?? ""
    }
    
    public func generateLanguageItems() {
        for language in languages {
            let name = generateLanguageName(code: language.language)
            items.append(PickerItem(key: language.language,
                                    value: name))
        }
    }
    
    public func generateSelectedLanguage() {
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
    
    public func loadSelectedSubtitles() {
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
