//
//  DatesAndCalendarViewModel.swift
//  Profile
//
//  Created by  Stepanok Ivan on 12.04.2024.
//

import SwiftUI
import Combine
import Core
import EventKit
import Theme

public struct CourseForSync: Identifiable {
    public let id: UUID
    public let name: String
    public var synced: Bool
    public var active: Bool

    public init(id: UUID = UUID(), name: String, synced: Bool, active: Bool) {
        self.id = id
        self.name = name
        self.synced = synced
        self.active = active
    }
}

public class DatesAndCalendarViewModel: ObservableObject {
    // Output
    @Published var useRelativeDates: Bool = false
    @Published var showCalendaAccessDenided: Bool = false
    @Published var showError: Bool = false
    @Published var errorMessage: String?
    @Published var openNewCalendarView: Bool = false
    
    // NewCalendarView
    @Published var accountSelection: DropDownPicker.DownPickerOption? = .init(
        title: ProfileLocalization.Calendar.Dropdown.icloud
    )
    var calendarNameHint: String
    @Published var calendarName: String = ""
    @Published var colorSelection: DropDownPicker.DownPickerOption? = .init(
        title: ProfileLocalization.Calendar.DropdownColor.accent,
        color: Theme.Colors.accentColor
    )
    
    // SyncCalendarOptions
    @Published var assignmentStatus: AssignmentStatus = .synced
    @Published var courseCalendarSync: Bool = false
    @Published var reconnectRequired: Bool = false
    @Published var openChangeSyncView: Bool = false

    let accounts: [DropDownPicker.DownPickerOption] = [
        .init(title: ProfileLocalization.Calendar.Dropdown.icloud),
        .init(title: ProfileLocalization.Calendar.Dropdown.local)
    ]
    let colors: [DropDownPicker.DownPickerOption] = [
        .init(title: ProfileLocalization.Calendar.DropdownColor.accent, color: Theme.Colors.accentColor),
        .init(title: ProfileLocalization.Calendar.DropdownColor.red, color: .red),
        .init(title: ProfileLocalization.Calendar.DropdownColor.orange, color: .orange),
        .init(title: ProfileLocalization.Calendar.DropdownColor.yellow, color: .yellow),
        .init(title: ProfileLocalization.Calendar.DropdownColor.green, color: .green),
        .init(title: ProfileLocalization.Calendar.DropdownColor.blue, color: .blue),
        .init(title: ProfileLocalization.Calendar.DropdownColor.purple, color: .purple),
        .init(title: ProfileLocalization.Calendar.DropdownColor.brown, color: .brown)
    ]
    
    var router: ProfileRouter
    
        // CoursesToSyncView
    
    @Published var coursesForSync = [
        CourseForSync(name: "History of Example Studies", synced: true, active: true),
        CourseForSync(name: "Example Language 101", synced: true, active: true),
        CourseForSync(name: "Example Course", synced: true, active: true),
        CourseForSync(name: "More Example Courses", synced: true, active: true),
        CourseForSync(name: "Another Example Course", synced: true, active: true),
        CourseForSync(name: "Example Excluded Course", synced: false, active: false),
        CourseForSync(name: "Science of Examples", synced: false, active: true),
        CourseForSync(name: "Example Learning", synced: false, active: false),
        CourseForSync(name: "Science of Examples", synced: false, active: false)
    ]
    
    @Published var synced: Bool = true
    @Published var hideInactiveCourses: Bool = false
    
    func toggleSync(for course: CourseForSync) {
         if let index = coursesForSync.firstIndex(where: { $0.id == course.id }) {
             if coursesForSync[index].active {
                 coursesForSync[index].synced.toggle()
             }
         }
     }
    
    public init(router: ProfileRouter) {
        self.router = router
        self.calendarNameHint = ProfileLocalization.Calendar.courseDates((Bundle.main.applicationName ?? ""))
    }
        
    // MARK: - Request Calendar Permission
    func requestCalendarPermission() {
        let eventStore = EKEventStore()
        eventStore.requestAccess(to: .event) { [weak self] granted, error in
            DispatchQueue.main.async {
                if granted {
                    self?.showNewCalendarSetup()
                } else {
                    self?.showCalendarAccessDenided()
                }
            }
        }
    }
    
    func openAppSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    private func showCalendarAccessDenided() {
        withAnimation(.bouncy(duration: 0.3)) {
            self.showCalendaAccessDenided = true
        }
    }
    
    private func showNewCalendarSetup() {
        withAnimation(.bouncy(duration: 0.3)) {
            openNewCalendarView = true
        }
    }
}
