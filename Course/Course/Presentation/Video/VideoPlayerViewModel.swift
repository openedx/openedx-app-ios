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

    private var subtitlesDownloaded: Bool = false
    @Published var subtitles: [Subtitle] = []
    
    @Published var showError: Bool = false
    var errorMessage: String? {
        didSet {
            showError = errorMessage != nil
        }
    }

    public init(interactor: CourseInteractorProtocol,
                connectivity: ConnectivityProtocol) {
        self.interactor = interactor
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
        if !subtitlesDownloaded {
            do {
                if connectivity.isInternetAvaliable {
                    let result = try await interactor.getSubtitles(url: subtitlesUrl)
                    subtitles = self.parseSubtitles(from: result)
                } else {
                    let result = try await interactor.getSubtitlesOffline(url: subtitlesUrl)
                    subtitles = self.parseSubtitles(from: result)
                }
            } catch let error {
                print(">>>> ERROR", error)
            }
            subtitlesDownloaded = true
        }
    }
    
    func parseSubtitles(from subtitlesString: String) -> [Subtitle] {
        let subtitleComponents = subtitlesString.components(separatedBy: "\n\n")
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
                                                             end:   Date(subtitleTime: endTime)),
                                        text: text)
                subtitles.append(subtitle)
            }
        }
        return subtitles
    }
}
