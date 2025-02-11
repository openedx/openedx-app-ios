//
//  CourseDatesView.swift
//  Discussion
//
//  Created by Muhammad Umer on 10/17/23.
//

import Foundation
import SwiftUI
import Core
import OEXFoundation
import Theme
import SwiftUIIntrospect

public struct CourseDatesView: View {
    
    private let courseID: String
    
    @StateObject
    private var viewModel: CourseDatesViewModel
    @Binding private var coordinate: CGFloat
    @Binding private var collapsed: Bool
    @Binding private var viewHeight: CGFloat
    
    public init(
        courseID: String,
        coordinate: Binding<CGFloat>,
        collapsed: Binding<Bool>,
        viewHeight: Binding<CGFloat>,
        viewModel: CourseDatesViewModel
    ) {
        self.courseID = courseID
        self._coordinate = coordinate
        self._collapsed = collapsed
        self._viewHeight = viewHeight
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    public var body: some View {
        ZStack {
            VStack(alignment: .center) {
                if viewModel.isShowProgress {
                    HStack(alignment: .center) {
                        ProgressBar(size: 40, lineWidth: 8)
                            .padding(.top, 200)
                            .padding(.horizontal)
                    }
                } else if let courseDates = viewModel.courseDates, !courseDates.courseDateBlocks.isEmpty {
                    CourseDateListView(
                        viewModel: viewModel,
                        coordinate: $coordinate,
                        collapsed: $collapsed,
                        viewHeight: $viewHeight,
                        courseDates: courseDates,
                        courseID: courseID
                    )
                    .padding(.top, 10)
                } else {
                    GeometryReader { proxy in
                        VStack {
                            ScrollView {
                                DynamicOffsetView(
                                    coordinate: $coordinate,
                                    collapsed: $collapsed,
                                    viewHeight: $viewHeight
                                )
                                
                                FullScreenErrorView(
                                    type: .noContent(
                                        CourseLocalization.Error.courseDateUnavailable,
                                        image: CoreAssets.information.swiftUIImage
                                    )
                                )
                                .frame(maxWidth: .infinity)
                                .frame(height: proxy.size.height - viewHeight)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                    }
                }
            }
            
            switch viewModel.eventState {
            case .addedCalendar:
                showDatesSuccessView(
                    title: CourseLocalization.CourseDates.calendarEvents,
                    message: CourseLocalization.CourseDates.calendarEventsAdded
                )
            case .removedCalendar:
                showDatesSuccessView(
                    title: CourseLocalization.CourseDates.calendarEvents,
                    message: CourseLocalization.CourseDates.calendarEventsRemoved
                )
            case .updatedCalendar:
                showDatesSuccessView(
                    title: CourseLocalization.CourseDates.calendarEvents,
                    message: CourseLocalization.CourseDates.calendarEventsUpdated
                )
            case .shiftedDueDates:
                showDatesSuccessView(
                    title: CourseLocalization.CourseDates.toastSuccessTitle,
                    message: CourseLocalization.CourseDates.toastSuccessMessage
                )
            default:
                EmptyView()
            }
            
            if viewModel.showError {
                VStack {
                    Spacer()
                    SnackBarView(message: viewModel.errorMessage)
                }
                .transition(.move(edge: .bottom))
                .onAppear {
                    doAfter(Theme.Timeout.snackbarMessageLongTimeout) {
                        viewModel.errorMessage = nil
                    }
                }
            }
        }
        .onFirstAppear {
            Task {
                await viewModel.getCourseDates(courseID: courseID)
            }
        }
        .background(
            Theme.Colors.background
                .ignoresSafeArea()
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func showDatesSuccessView(title: String, message: String) -> some View {
        if viewModel.eventState == .shiftedDueDates {
            return DatesSuccessView(
                title: title,
                message: message,
                selectedTab: .dates,
                courseDatesViewModel: viewModel
            )
        } else {
            return DatesSuccessView(
                title: title,
                message: message,
                selectedTab: .dates
            ) {
                viewModel.resetEventState()
            }
        }
    }
}

fileprivate extension BlockStatus {
    var title: String {
        switch self {
        case .completed: return CourseLocalization.CourseDates.completed
        case .pastDue: return CourseLocalization.CourseDates.pastDue
        case .dueNext: return CourseLocalization.CourseDates.dueNext
        case .unreleased: return CourseLocalization.CourseDates.unreleased
        case .verifiedOnly: return CourseLocalization.CourseDates.verifiedOnly
        default: return ""
        }
    }
    
    var foregroundColor: Color {
        switch self {
        case .completed: return Color.white
        case .verifiedOnly: return Color.white
        case .pastDue: return Color.black
        case .dueNext: return Color.white
        default: return Color.white.opacity(0)
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .completed: return Color.black.opacity(0.5)
        case .verifiedOnly: return Color.black.opacity(0.5)
        case .pastDue: return Color.gray.opacity(0.4)
        case .dueNext: return Color.black.opacity(0.5)
        default: return Color.white.opacity(0)
        }
    }
}

fileprivate extension AttributedString {
    mutating func appendSpaces(_ count: Int = 1) {
        self += AttributedString(String(repeating: " ", count: count))
    }
}

#if DEBUG
struct CourseDatesView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = CourseDatesViewModel(
            interactor: CourseInteractor(repository: CourseRepositoryMock()),
            router: CourseRouterMock(),
            cssInjector: CSSInjectorMock(),
            connectivity: Connectivity(),
            config: ConfigMock(),
            courseID: "",
            courseName: "",
            analytics: CourseAnalyticsMock(),
            calendarManager: CalendarManagerMock()
        )
        
        CourseDatesView(
            courseID: "",
            coordinate: .constant(0),
            collapsed: .constant(false),
            viewHeight: .constant(0),
            viewModel: viewModel
        )
    }
}
#endif
