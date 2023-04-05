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

    private let subtitles: [Subtitle]
    @Binding var currentTime: Double
    @State var id = 0

    public init(subtitles: [Subtitle], currentTime: Binding<Double>) {
        self.subtitles = subtitles
        self._currentTime = currentTime
    }

    public var body: some View {
        ScrollViewReader { scroll in
            VStack(alignment: .leading, spacing: 0) {
            Text("Subtitles")
                .font(Theme.Fonts.titleMedium)
                ScrollView {
                    if subtitles.count > 0 {
                        VStack(alignment: .leading, spacing: 0) {
                            ForEach(subtitles, id: \.id) { subtitle in
                                HStack {
                                    Text(subtitle.text)
                                        .padding(.vertical, 16)
                                        .font(Theme.Fonts.bodyMedium)
                                        .foregroundColor(subtitle.fromTo.contains(Date(milliseconds: currentTime))
                                                         ? CoreAssets.textPrimary.swiftUIColor
                                                         : CoreAssets.textSecondary.swiftUIColor)
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
                    }
                }
            }.padding(.horizontal, 24)
        }
    }
}

struct SubtittlesView_Previews: PreviewProvider {
    static var previews: some View {
        
        let subtitles = [
            Subtitle(id: 0, fromTo: DateInterval(start: Date(milliseconds: 0), duration: 10000), text: "Hello"),
            Subtitle(id: 1, fromTo: DateInterval(start: Date(milliseconds: 10000), duration: 10000), text: "World"),
            Subtitle(id: 2, fromTo: DateInterval(start: Date(milliseconds: 20000), duration: 10000), text: "Hello"),
            Subtitle(id: 3, fromTo: DateInterval(start: Date(milliseconds: 30000), duration: 10000), text: "World"),
            Subtitle(id: 4, fromTo: DateInterval(start: Date(milliseconds: 40000), duration: 10000), text: "Hello"),
            Subtitle(id: 5, fromTo: DateInterval(start: Date(milliseconds: 50000), duration: 10000), text: "World"),
            Subtitle(id: 6, fromTo: DateInterval(start: Date(milliseconds: 60000), duration: 10000), text: "Hello"),
            Subtitle(id: 7, fromTo: DateInterval(start: Date(milliseconds: 70000), duration: 10000), text: "World"),
            Subtitle(id: 8, fromTo: DateInterval(start: Date(milliseconds: 80000), duration: 10000), text: "Hello"),
            Subtitle(id: 9, fromTo: DateInterval(start: Date(milliseconds: 90000), duration: 10000), text: "World"),
            Subtitle(id: 10, fromTo: DateInterval(start: Date(milliseconds: 100000), duration: 10000), text: "Hello"),
            Subtitle(id: 11, fromTo: DateInterval(start: Date(milliseconds: 110000), duration: 10000), text: "World"),
            Subtitle(id: 12, fromTo: DateInterval(start: Date(milliseconds: 120000), duration: 10000), text: "Hello"),
            Subtitle(id: 13, fromTo: DateInterval(start: Date(milliseconds: 130000), duration: 10000), text: "World"),
            Subtitle(id: 14, fromTo: DateInterval(start: Date(milliseconds: 140000), duration: 10000), text: "Hello")
            ]
        
        SubtittlesView(subtitles: subtitles, currentTime: .constant(0))
    }
}
