//
//  SubtittlesView.swift
//  Course
//
//  Created by  Stepanok Ivan on 04.04.2023.
//

import SwiftUI
import Core

public struct Subtitle {
    var id: Int
    var fromTo: DateInterval
    var text: String
}

public struct SubtittlesView: View {
    
    @ObservedObject
    private var viewModel: VideoPlayerViewModel
    
    @Binding var currentTime: Double
    @State var id = 0
    @State var languages: [SubtitleUrl]
    
    public init(languages: [SubtitleUrl],
                currentTime: Binding<Double>,
                viewModel: VideoPlayerViewModel) {
        self.languages = languages
        self.viewModel = viewModel
        self._currentTime = currentTime
    }
    
    public var body: some View {
        ScrollViewReader { scroll in
            VStack(alignment: .leading, spacing: 0) {
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
                            VStack(alignment: .leading, spacing: 0) {
                                ForEach(viewModel.subtitles, id: \.id) { subtitle in
                                    HStack {
                                        Text(subtitle.text)
                                            .padding(.vertical, 16)
                                            .font(Theme.Fonts.bodyMedium)
                                            .foregroundColor(subtitle.fromTo.contains(Date(milliseconds: currentTime))
                                                             ? Theme.Colors.textPrimary
                                                             : Theme.Colors.textSecondary)
                                            .onChange(of: currentTime, perform: { _ in
                                                if subtitle.fromTo.contains(Date(milliseconds: currentTime)) {
                                                    if id != subtitle.id {
                                                        withAnimation {
                                                            scroll.scrollTo(subtitle.id, anchor: .top)
                                                        }
                                                    }
                                                    self.id = subtitle.id
                                                }
                                            })
                                    }.id(subtitle.id)
                                }
                            }
                            .introspect(.scrollView, on: .iOS(.v14, .v15, .v16, .v17), customize: { scrollView in
                                scrollView.isScrollEnabled = false
                            })
                        }
                    }
                    // Forced disable scrolling for iOS 14, 15
                    Color.white.opacity(0)
                }
            }.padding(.horizontal, 24)
                .padding(.top, 34)
        }
    }
}

#if DEBUG
struct SubtittlesView_Previews: PreviewProvider {
    static var previews: some View {
        
        SubtittlesView(
            languages: [SubtitleUrl(language: "fr", url: "url"),
                        SubtitleUrl(language: "uk", url: "url2")],
            currentTime: .constant(0),
            viewModel: VideoPlayerViewModel(
                blockID: "", courseID: "",
                languages: [],
                interactor: CourseInteractor(repository: CourseRepositoryMock()),
                router: CourseRouterMock(),
                connectivity: Connectivity()
            )
        )
    }
}
#endif
