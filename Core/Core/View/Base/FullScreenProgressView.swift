//
//  FullScreenProgressView.swift
//  Core
//
//  Created by Eugene Yatsenko on 01.03.2024.
//

import SwiftUI
import Theme

public struct FullScreenProgressView: View {

    @Environment(\.dismiss) private var dismiss
    
    public init() {}

    public var body: some View {
        ZStack(alignment: .center) {
            Color.black.opacity(0.8)
                .onTapGesture {
                    dismiss()
                }
            VStack(alignment: .center) {
                ProgressBar(size: 40, lineWidth: 8)
                    .padding(.horizontal)
                    .padding(.vertical, 50)
            }
            .frame(maxWidth: 140)
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
