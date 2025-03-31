//
//  ShiftDueDatesView.swift
//  AppDates
//
//  Created by Ivan Stepanok on 25.03.2025.
//

import SwiftUI
import Theme
import Core

public struct ShiftDueDatesView: View {
    @State private var isLoading = false
    @Binding var isShowProgressForDueDates: Bool
    var onShiftButtonTap: () -> Void
    
    public init(
        isShowProgressForDueDates: Binding<Bool>,
        onShiftButtonTap: @escaping () -> Void
    ) {
        self._isShowProgressForDueDates = isShowProgressForDueDates
        self.onShiftButtonTap = onShiftButtonTap
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(AppDatesLocalization.ShiftDueDates.title)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(Theme.Fonts.titleMedium)
                .foregroundColor(Theme.Colors.textPrimary)
            
            Text(AppDatesLocalization.ShiftDueDates.description)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(Theme.Fonts.labelLarge)
                .foregroundColor(Theme.Colors.textPrimary)
            
            if isShowProgressForDueDates {
                VStack(alignment: .center) {
                    ProgressBar(size: 40, lineWidth: 8)
                }.frame(maxWidth: .infinity,
                        maxHeight: 42)
            } else {
                StyledButton(
                    AppDatesLocalization.ShiftDueDates.button,
                    action: {
                        onShiftButtonTap()
                    }
                )
            }
        }
        .padding(16)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Theme.Colors.datesSectionStroke, lineWidth: 2)
        )
        .background(Theme.Colors.datesSectionBackground)
        .cornerRadius(8)
    }
}
