//
//  SubtitlesView.swift
//  Course
//
//  Created by  Stepanok Ivan on 04.04.2023.
//

import SwiftUI
import Core
import Theme

public struct Subtitle: Sendable {
    var id: Int
    var fromTo: DateInterval
    var text: String
}

public struct SubtitlesView: View {
    
    @Environment(\.isHorizontal) private var isHorizontal
    
    @ObservedObject
    private var viewModel: VideoPlayerViewModel
    private var scrollTo: ((Date) -> Void) = { _ in }
    
    @Binding var currentTime: Double
    @State var id = 0
    @State var pause: Bool = false
    @State var languages: [SubtitleUrl]
    
    public init(languages: [SubtitleUrl],
                currentTime: Binding<Double>,
                viewModel: VideoPlayerViewModel,
                scrollTo: @escaping (Date) -> Void) {
        self.languages = languages
        self.viewModel = viewModel
        self._currentTime = currentTime
        self.scrollTo = scrollTo
    }
    
    public var body: some View {
        ScrollViewReader { scroll in
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text(viewModel.subtitles.isEmpty ? "" : CourseLocalization.Subtitles.title)
                        .font(Theme.Fonts.titleMedium)
                    Spacer()
                    if !viewModel.languages.isEmpty && viewModel.languages.count > 1 {
                        Button(action: {
                            viewModel.presentPicker()
                        }, label: {
                            Group {
                                CoreAssets.sub.swiftUIImage.renderingMode(.template)
                                Text(viewModel.generateLanguageName(code: viewModel.selectedLanguage ?? ""))
                            }.foregroundColor(Theme.Colors.accentColor)
                                .font(Theme.Fonts.labelLarge)
                        })
                    }
                }
                ZStack {
                    ScrollView {
                        if viewModel.subtitles.count > 0 {
                            LazyVStack(alignment: .leading, spacing: 0) {
                                ForEach(viewModel.subtitles, id: \.id) { subtitle in
                                    HStack {
                                        Button(action: {
                                            scrollTo(subtitle.fromTo.start)
                                            pause = false
                                        }, label: {
                                        Text(subtitle.text)
                                            .padding(.vertical, 16)
                                            .font(Theme.Fonts.bodyMedium)
                                            .multilineTextAlignment(.leading)
                                            .foregroundColor(subtitle.fromTo.contains(Date(milliseconds: currentTime))
                                                             ? Theme.Colors.textPrimary
                                                             : Theme.Colors.textSecondary)
                                            
                                            .onChange(of: currentTime, perform: { _ in
                                                if subtitle.fromTo.contains(Date(milliseconds: currentTime)) {
                                                    if id != subtitle.id {
                                                        withAnimation {
                                                            if !pause {
                                                                scroll.scrollTo(subtitle.id, anchor: .top)
                                                            }
                                                        }
                                                    }
                                                    self.id = subtitle.id
                                                }
                                            })
                                        })
                                    }.id(subtitle.id)
                                }
                            }
                        }
                    }.simultaneousGesture(
                        DragGesture().onChanged({ _ in
                            pauseScrolling()
                        }))
                }
            }.padding(.horizontal, 24)
                .padding(.top, 16)
                .padding(.bottom, isHorizontal ? 100 : 16)
        }
    }
    
    private func pauseScrolling() {
        pause = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.pause = false
        }
    }
}

#if DEBUG
import Combine
struct SubtittlesView_Previews: PreviewProvider {
    static var previews: some View {
        
        SubtitlesView(
            languages: [SubtitleUrl(language: "fr", url: "url"),
                        SubtitleUrl(language: "uk", url: "url2")],
            currentTime: .constant(0),
            viewModel: VideoPlayerViewModel(
                languages: [],
                playerStateSubject: CurrentValueSubject<VideoPlayerState?, Never>(nil),
                connectivity: Connectivity(),
                playerHolder: PlayerViewControllerHolder.mock
            ), scrollTo: {_ in }
        )
    }
}
#endif
