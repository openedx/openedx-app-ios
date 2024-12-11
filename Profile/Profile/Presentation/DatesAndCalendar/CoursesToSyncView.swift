//
//  CoursesToSyncView.swift
//  Profile
//
//  Created by  Stepanok Ivan on 15.05.2024.
//

import SwiftUI
import Theme
import Core

public struct CoursesToSyncView: View {
    
    @ObservedObject
    private var viewModel: DatesAndCalendarViewModel
    
    @Environment(\.isHorizontal) private var isHorizontal
    
    public init(viewModel: DatesAndCalendarViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .top) {
                ThemeAssets.headerBackground.swiftUIImage
                    .resizable()
                    .edgesIgnoringSafeArea(.top)
                    .frame(maxWidth: .infinity, maxHeight: 200)
                    .accessibilityIdentifier("title_bg_image")
                
                VStack(alignment: .leading, spacing: 8) {
                    // MARK: Navigation and Title
                    NavigationTitle(
                        title: ProfileLocalization.CoursesToSync.title,
                        backAction: {
                            viewModel.router.back()
                        }
                    )
                    
                    // MARK: Body
                    ScrollView {
                        Group {
                            Text(ProfileLocalization.CoursesToSync.description)
                                .font(Theme.Fonts.labelMedium)
                                .foregroundColor(Theme.Colors.textPrimary)
                                .padding(.top, 24)
                                .padding(.horizontal, 24)
                                .frame(
                                    minWidth: 0,
                                    maxWidth: .infinity,
                                    alignment: .leading
                                )
                            
                            ToggleWithDescriptionView(
                                text: ProfileLocalization.CoursesToSync.hideInactiveCourses,
                                description: ProfileLocalization.CoursesToSync.hideInactiveCoursesDescription,
                                toggle: $viewModel.hideInactiveCourses
                            )
                            .padding(.horizontal, 24)
                            .padding(.vertical, 16)
                            
                            SyncSelector(sync: $viewModel.synced)
                                .padding(.horizontal, 24)
                            
                            coursesList
                        }
                        .padding(.horizontal, isHorizontal ? 48 : 0)
                    }
                    .frameLimit(width: proxy.size.width)
                    .roundedBackground(Theme.Colors.background)
                    .ignoresSafeArea(.all, edges: .bottom)
                }
                .navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)
                
                if viewModel.showError {
                    ErrorAlertView(errorMessage: $viewModel.errorMessage)
                }
            }
            .ignoresSafeArea(.all, edges: .horizontal)
        }
    }
    
    private var coursesList: some View {
        VStack(alignment: .leading, spacing: 24) {
            if viewModel.coursesForSync.allSatisfy({ !$0.synced }) && viewModel.synced {
                noSyncedCourses
            } else {
                ForEach(
                    Array(
                        viewModel.coursesForSync.filter(
                            { course in
                                course.synced == viewModel.synced && (
                                    !viewModel.hideInactiveCourses || course.recentlyActive
                                )
                            }
                        )
                        .sorted { $0.recentlyActive && !$1.recentlyActive }
                            .enumerated()
                    ),
                    id: \.offset
                ) { _, course in
                    HStack {
                        CheckBoxView(
                            checked: Binding(
                                get: { course.synced },
                                set: { _ in viewModel.toggleSync(for: course) }
                            ),
                            text: course.name,
                            color: Theme.Colors.textPrimary.opacity(course.recentlyActive ? 1 : 0.8)
                        )
                        
                        if !course.recentlyActive {
                            Text(ProfileLocalization.CoursesToSync.inactive)
                                .font(Theme.Fonts.labelSmall)
                                .foregroundStyle(Theme.Colors.textPrimary.opacity(0.8))
                        }
                    }
                    .frame(
                        minWidth: 0,
                        maxWidth: .infinity,
                        alignment: .leading
                    )
                }
            }
            Spacer(minLength: 100)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 16)
    }
    
    private var noSyncedCourses: some View {
        VStack(spacing: 8) {
            Spacer()
            CoreAssets.learnEmpty.swiftUIImage
                .resizable()
                .frame(width: 96, height: 96)
                .foregroundStyle(Theme.Colors.textSecondaryLight)
            Text(ProfileLocalization.Sync.noSynced)
                .foregroundStyle(Theme.Colors.textPrimary)
                .font(Theme.Fonts.titleMedium)
            Text(ProfileLocalization.Sync.noSyncedDescription)
                .multilineTextAlignment(.center)
                .foregroundStyle(Theme.Colors.textPrimary)
                .font(Theme.Fonts.labelMedium)
                .frame(width: 245)
        }
    }
}

#if DEBUG
struct CoursesToSyncView_Previews: PreviewProvider {
    static var previews: some View {
        let vm = DatesAndCalendarViewModel(
            router: ProfileRouterMock(),
            interactor: ProfileInteractor(repository: ProfileRepositoryMock()),
            profileStorage: ProfileStorageMock(),
            persistence: ProfilePersistenceMock(),
            calendarManager: CalendarManagerMock(),
            connectivity: Connectivity()
        )
        return CoursesToSyncView(viewModel: vm)
            .previewDisplayName("Courses to Sync")
            .loadFonts()
    }
}
#endif
