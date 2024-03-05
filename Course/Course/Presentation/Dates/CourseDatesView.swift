//
//  CourseDatesView.swift
//  Discussion
//
//  Created by Muhammad Umer on 10/17/23.
//

import Foundation
import SwiftUI
import Core
import Theme

public struct CourseDatesView: View {
    
    private let courseID: String
    
    @StateObject
    private var viewModel: CourseDatesViewModel
    
    public init(
        courseID: String,
        viewModel: CourseDatesViewModel
    ) {
        self.courseID = courseID
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
                    CourseDateListView(viewModel: viewModel, courseDates: courseDates, courseID: courseID)
                        .padding(.top, 10)
                }
            }
            
            if viewModel.dueDatesShifted {
                DatesShiftedSuccessView(selectedTab: .dates, courseDatesViewModel: viewModel)
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
}

struct Line: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        return path
    }
}

struct TimeLineView: View {
    let status: CompletionStatus
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                Line()
                    .stroke(style: StrokeStyle(lineWidth: 8, lineCap: .round, lineJoin: .round))
                    .frame(maxHeight: .infinity, alignment: .top)
                    .padding(.top, 0)
                    .foregroundColor(status.foregroundColor)
            }
        }
        .frame(width: 16)
    }
}

struct CourseDateListView: View {
    @ObservedObject var viewModel: CourseDatesViewModel
    @State private var isExpanded = false
    var courseDates: CourseDates
    let courseID: String

    var body: some View {
        GeometryReader { proxy in
            VStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        if !courseDates.hasEnded {
                            DatesStatusInfoView(
                                datesBannerInfo: courseDates.datesBannerInfo,
                                courseID: courseID,
                                courseDatesViewModel: viewModel
                            )
                            .padding(.bottom, 16)
                        }
                        
                        ForEach(Array(viewModel.sortedStatuses), id: \.self) { status in
                            let courseDateBlockDict = courseDates.statusDatesBlocks[status]!
                            if status == .completed {
                                CompletedBlocks(
                                    isExpanded: $isExpanded,
                                    courseDateBlockDict: courseDateBlockDict,
                                    viewModel: viewModel
                                )
                            } else {
                                Text(status.rawValue)
                                    .font(Theme.Fonts.titleSmall)
                                    .padding(.top, 10)
                                    .padding(.bottom, 10)
                                HStack {
                                    TimeLineView(status: status)
                                        .padding(.bottom, 15)
                                    VStack(alignment: .leading) {
                                        ForEach(courseDateBlockDict.keys.sorted(), id: \.self) { date in
                                            let blocks = courseDateBlockDict[date]!
                                            let block = blocks[0]
                                            Text(block.formattedDate)
                                                .font(Theme.Fonts.labelMedium)
                                                .foregroundStyle(Theme.Colors.textPrimary)
                                            BlockStatusView(
                                                viewModel: viewModel,
                                                block: block,
                                                blocks: blocks
                                            )
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 5)
                    .frameLimit(width: proxy.size.width)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
}

struct CompletedBlocks: View {
    @Binding var isExpanded: Bool
    let courseDateBlockDict: [Date: [CourseDateBlock]]
    let viewModel: CourseDatesViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            // Toggle button to expand/collapse the cell
            Button(action: {
                withAnimation {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    VStack(alignment: .leading) {
                        Text(CompletionStatus.completed.rawValue)
                            .font(Theme.Fonts.titleSmall)
                            .foregroundColor(Theme.Colors.textPrimary)
                        
                        if !isExpanded {
                            let totalCount = courseDateBlockDict.values.reduce(0) { $0 + $1.count }
                            let itemsHidden = totalCount == 1 ?
                            CourseLocalization.CourseDates.itemHidden :
                            CourseLocalization.CourseDates.itemsHidden
                            Text("\(totalCount) \(itemsHidden)")
                                .font(Theme.Fonts.labelMedium)
                                .foregroundColor(Theme.Colors.textPrimary)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 16)
                    .padding(.vertical, 8)
                    
                    Image(systemName: "chevron.down")
                        .labelStyle(.iconOnly)
                        .dropdownArrowRotationAnimation(value: isExpanded)
                        .foregroundColor(Theme.Colors.textPrimary)
                        .padding()
                }
            }
            
            // Your expandable content goes here
            if isExpanded {
                VStack(alignment: .leading) {
                    ForEach(courseDateBlockDict.keys.sorted(), id: \.self) { date in
                        let blocks = courseDateBlockDict[date]!
                        let block = blocks[0]
                        
                        Spacer()
                        Text(block.formattedDate)
                            .font(Theme.Fonts.labelMedium)
                            .foregroundStyle(Theme.Colors.textPrimary)
                        
                        ForEach(blocks) { block in
                            HStack(alignment: .top) {
                                block.blockImage?.swiftUIImage
                                    .foregroundColor(Theme.Colors.textPrimary)
                                StyleBlock(block: block, viewModel: viewModel)
                                    .padding(.bottom, 15)
                                Spacer()
                                if block.canShowLink && !block.firstComponentBlockID.isEmpty {
                                    Image(systemName: "chevron.right")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 6.55, height: 11.15)
                                        .labelStyle(.iconOnly)
                                        .foregroundColor(Theme.Colors.textPrimary)
                                }
                            }
                            .padding(.trailing, 15)
                        }
                    }
                }
                .padding(.bottom, 15)
                .padding(.leading, 16)
            }

        }
        .overlay(
          RoundedRectangle(cornerRadius: 8)
            .stroke(Theme.Colors.datesSectionStroke, lineWidth: 2)
        )
        .background(Theme.Colors.datesSectionBackground)
    }
}

struct BlockStatusView: View {
    let viewModel: CourseDatesViewModel
    let block: CourseDateBlock
    let blocks: [CourseDateBlock]
    
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(blocks) { block in
                HStack(alignment: .top) {
                    block.blockImage?.swiftUIImage
                        .foregroundColor(Theme.Colors.textPrimary)
                    StyleBlock(block: block, viewModel: viewModel)
                        .padding(.bottom, 15)
                    Spacer()
                    if block.canShowLink && !block.firstComponentBlockID.isEmpty {
                        Image(systemName: "chevron.right")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 6.55, height: 11.15)
                            .labelStyle(.iconOnly)
                            .foregroundColor(Theme.Colors.textPrimary)
                    }
                }
                .padding(.trailing, 15)
            }
            .padding(.top, 0.2)
        }
    }
    
    func applyStyle(string: String, forgroundColor: Color, backgroundColor: Color) -> AttributedString {
        var attributedString = AttributedString(string)
        attributedString.font = Theme.Fonts.bodySmall
        attributedString.foregroundColor = forgroundColor
        attributedString.backgroundColor = backgroundColor
        return attributedString
    }
}

struct StyleBlock: View {
    let block: CourseDateBlock
    let viewModel: CourseDatesViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            styleBlock(block: block)
            if !block.description.isEmpty {
                Text(block.description)
                    .font(Theme.Fonts.labelMedium)
                    .foregroundStyle(Theme.Colors.thisWeekTimelineColor)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
    
    func styleBlock(block: CourseDateBlock) -> some View {
        var attributedString = AttributedString("")
        
        if let prefix = block.assignmentType, !prefix.isEmpty {
            attributedString += AttributedString("\(prefix): ")
        }
        
        attributedString += styleTitle(block: block)
        
        return Text(attributedString)
            .font(Theme.Fonts.titleSmall)
            .lineLimit(1)
            .foregroundStyle({
                if block.isAssignment {
                    return block.isAvailable ? Theme.Colors.textPrimary : Color.gray.opacity(0.6)
                } else {
                    return Theme.Colors.textPrimary
                }
            }())
            .onTapGesture {
                if block.canShowLink && !block.firstComponentBlockID.isEmpty {
                    Task {
                        await viewModel.showCourseDetails(componentID: block.firstComponentBlockID)
                    }
                }
            }
    }
    
    func styleTitle(block: CourseDateBlock) -> AttributedString {
        var attributedString = AttributedString(block.title)
        attributedString.font = Theme.Fonts.titleSmall
        return attributedString
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

fileprivate extension CompletionStatus {
    var foregroundColor: Color {
        switch self {
        case .pastDue: return Theme.Colors.pastDueTimelineColor
        case .today: return Theme.Colors.todayTimelineColor
        case .thisWeek: return Theme.Colors.thisWeekTimelineColor
        case .nextWeek: return Theme.Colors.nextWeekTimelineColor
        case .upcoming: return Theme.Colors.upcomingTimelineColor
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
            courseID: "")
        
        CourseDatesView(
            courseID: "",
            viewModel: viewModel)
    }
}
#endif
