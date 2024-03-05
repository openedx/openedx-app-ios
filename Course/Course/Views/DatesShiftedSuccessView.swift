//
//  DatesShiftedSuccessView.swift
//  Core
//
//  Created by Shafqat Muneer on 2/18/24.
//

import SwiftUI
import Combine
import Theme

public struct DatesShiftedSuccessView: View {
    
    enum Tab {
        case course
        case dates
    }

    var selectedTab: Tab
    var courseDatesViewModel: CourseDatesViewModel?
    var courseContainerViewModel: CourseContainerViewModel?
    var action: () async -> Void = {}

    @State private var dismiss: Bool = false
    
    public var body: some View {
        ZStack {
            VStack {
                Spacer()
                VStack(alignment: .leading, spacing: 16) {
                    HStack(alignment: .top) {
                        Text(CourseLocalization.CourseDates.toastSuccessTitle)
                            .foregroundStyle(Theme.Colors.textPrimary)
                            .font(Theme.Fonts.titleMedium)
                        Spacer()
                        Button {
                            withAnimation {
                                dismissView()
                            }
                        } label: {
                            Image(systemName: "xmark")
                                .resizable()
                                .frame(width: 14.0, height: 14.0)
                        }
                        .padding(.all, 5)
                        .tint(Theme.Colors.textPrimary)
                    }
                    
                    Text(CourseLocalization.CourseDates.toastSuccessMessage)
                        .foregroundStyle(Theme.Colors.textPrimary)
                        .font(Theme.Fonts.labelLarge)
                    
                    if selectedTab == .course {
                        Button(CourseLocalization.CourseDates.viewAllDates,
                               action: {
                            Task {
                                await action()
                            }
                            withAnimation {
                                dismissView()
                            }
                        })
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 11)
                        .background(Theme.Colors.datesSectionBackground)
                        .foregroundStyle(Theme.Colors.secondaryButtonBorderColor)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Theme.Colors.secondaryButtonBorderColor, lineWidth: 1)
                        )
                    }
                }
                .font(Theme.Fonts.titleSmall)
                .padding(.all, 16)
                .background(Theme.Colors.datesSectionBackground)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            .frame(maxWidth: .infinity)
            .padding(.all, 10)
            .shadow(color: .black.opacity(0.25), radius: 5, y: 4)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                withAnimation {
                    dismissView()
                }
            }
        }
        .onDisappear {
            withAnimation {
                dismissView()
            }
        }
        .offset(y: dismiss ? 100 : 0)
        .opacity(dismiss ? 0 : 1)
        .transition(.move(edge: .bottom))
    }
    
    private func dismissView() {
        dismiss = true
        courseDatesViewModel?.resetDueDatesShiftedFlag()
        courseContainerViewModel?.resetDueDatesShiftedFlag()
    }
}

#if DEBUG
struct DatesShiftedSuccessView_Previews: PreviewProvider {
    static var previews: some View {
        DatesShiftedSuccessView(selectedTab: .course)
    }
}
#endif
