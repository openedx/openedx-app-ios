//
//  SuccessViewWithButton.swift
//  Core
//
//  Created by Shafqat Muneer on 2/18/24.
//

import SwiftUI
import Combine
import Theme

public struct DatesShiftedSuccessView: View {
    
    public static let height: CGFloat = 50
    
    @State private var dismiss: Bool = false
    private var action: () async -> Void
    
    public init(action: @escaping () async -> Void) {
        self.action = action
    }
    
    public var body: some View {
        ZStack {
            VStack {
                Spacer()
                VStack(alignment: .leading, spacing: 10) {
                    HStack(spacing: 10) {
                        Text(CourseLocalization.CourseDates.toastSuccessMessage)
                            .foregroundStyle(.white)
                        Button {
                            withAnimation {
                                dismiss = true
                            }
                        } label: {
                            Image(systemName: "xmark")
                        }
                        .padding(.all, 5)
                        .tint(.white)
                    }
                    
                    Button(CourseLocalization.CourseDates.viewAllDates,
                           action: {
                        Task {
                            await action()
                        }
                        withAnimation {
                            dismiss = true
                        }
                    })
                    .padding(.horizontal, 16)
                    .padding(.vertical, 5)
                    .background(Theme.Colors.thisWeekTimelineColor)
                    .foregroundStyle(.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 0)
                            .stroke(Theme.Colors.datesSectionStroke, lineWidth: 1)
                    )
                }
                .font(Theme.Fonts.titleSmall)
                .padding(.all, 16)
                .background(Theme.Colors.thisWeekTimelineColor)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            .frame(maxWidth: .infinity)
            .padding(.all, 8)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                withAnimation {
                    dismiss = true
                }
            }
        }
        .onDisappear {
            withAnimation {
                dismiss = true
            }
        }
        .offset(y: dismiss ? 100 : 0)
        .opacity(dismiss ? 0 : 1)
        .transition(.move(edge: .bottom))
    }
}

struct SuccessViewWithButton_Previews: PreviewProvider {
    static var previews: some View {
        DatesShiftedSuccessView(action: {})
    }
}
