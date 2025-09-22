//
//  CalendarSyncProgressView.swift
//  Core
//
//  Created by Shafqat Muneer on 3/15/24.
//

import SwiftUI
import Theme
import Core

public struct CalendarSyncProgressView: View {

    @Environment(\.dismiss) private var dismiss
    private let title: String

    public init(title: String) {
        self.title = title
    }

    public var body: some View {
        ZStack(alignment: .center) {
            Color.black.opacity(0)
                .onTapGesture {
                    dismiss()
                }
            VStack(alignment: .center) {
                Text(title)
                    .padding(.horizontal)
                    .padding(.top, 20)
                ProgressBar(size: 40, lineWidth: 8)
                    .font(Theme.Fonts.titleMedium)
                    .padding(.top, 20)
                    .padding(.bottom, 20)
            }
            .frame(maxWidth: 250)
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

#if DEBUG
struct CalendarSyncProgressView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarSyncProgressView(title: CourseLocalization.CourseDates.calendarSyncMessage)
    }
}
#endif
