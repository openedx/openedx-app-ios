//
//  FullScreenProgressView.swift
//  Core
//
//  Created by Eugene Yatsenko on 01.03.2024.
//

import SwiftUI
import Theme

public struct FullScreenProgressView: View {

    private let title: String

    public init(title: String) {
        self.title = title
    }

    public var body: some View {
        ZStack(alignment: .center) {
            Color.black.opacity(0.8)
            VStack(alignment: .center) {
                ProgressBar(size: 40, lineWidth: 8)
                    .padding(.horizontal)
                    .padding(.top, 50)
                Text(title)
                    .font(Theme.Fonts.titleMedium)
                    .padding(.top, 20)
                    .padding(.bottom, 50)
            }
            .frame(maxWidth: 200)
            .background(
                Theme.Shapes.cardShape
                    .fill(Theme.Colors.cardViewBackground)
                    .shadow(radius: 24)
                    .fixedSize(horizontal: false, vertical: false)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        style: .init(
                            lineWidth: 1,
                            lineCap: .round,
                            lineJoin: .round,
                            miterLimit: 1
                        )
                    )
                    .foregroundColor(Theme.Colors.backgroundStroke)
                    .fixedSize(horizontal: false, vertical: false)
            )
        }
        .ignoresSafeArea()
    }
}
