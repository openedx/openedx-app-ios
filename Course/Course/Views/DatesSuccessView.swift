//
//  DatesSuccessView.swift
//  Core
//
//  Created by Shafqat Muneer on 2/18/24.
//

import SwiftUI
import Combine
import Theme

public struct DatesSuccessView: View {
    
    enum Tab {
        case course
        case dates
    }

    private var title: String
    private var message: String
    var selectedTab: Tab
    var courseDatesViewModel: CourseDatesViewModel?
    var courseContainerViewModel: CourseContainerViewModel?
    var action: () async -> Void = {}
    var dismissAction: () async -> Void = {}

    @State private var dismiss: Bool = false
    
    init (
        title: String,
        message: String,
        selectedTab: Tab,
        dismissAction: @escaping () -> Void
    ) {
        self.title = title
        self.message = message
        self.selectedTab = selectedTab
        self.dismissAction = dismissAction
    }
    
    init (
        title: String,
        message: String,
        selectedTab: Tab,
        courseDatesViewModel: CourseDatesViewModel?
    ) {
        self.title = title
        self.message = message
        self.selectedTab = selectedTab
        self.courseDatesViewModel = courseDatesViewModel
    }
    
    init (
        title: String,
        message: String,
        selectedTab: Tab,
        courseContainerViewModel: CourseContainerViewModel?,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.message = message
        self.selectedTab = selectedTab
        self.courseContainerViewModel = courseContainerViewModel
        self.action = action
    }
    
    public var body: some View {
        ZStack {
            VStack {
                Spacer()
                VStack(alignment: .leading, spacing: 16) {
                    HStack(alignment: .top) {
                        Text(title)
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
                    
                    Text(message)
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
        Task {
            await dismissAction()
        }
    }
}

#if DEBUG
struct DatesSuccessView_Previews: PreviewProvider {
    static var previews: some View {
        DatesSuccessView(
            title: CourseLocalization.CourseDates.toastSuccessTitle,
            message: CourseLocalization.CourseDates.toastSuccessMessage,
            selectedTab: .course
        ) {}
    }
}
#endif
