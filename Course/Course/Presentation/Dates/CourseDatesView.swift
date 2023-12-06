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
                    CourseDateListView(viewModel: viewModel, courseDates: courseDates)
                        .padding(.top, 10)
                }
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
    let block: CourseDateBlock
    let date: Date
    let firstDate: Date?
    let lastDate: Date?
    let allHaveSameStatus: Bool
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                Line()
                    .stroke(style: StrokeStyle(lineWidth: 1))
                    .frame(maxHeight: lastDate == date ? 10 : .infinity, alignment: .top)
                    .padding(.top, firstDate == date && lastDate != date ? 10 : 0)

                if lastDate == date {
                    Spacer()
                }
            }
            
            Circle()
                .frame(width: date.isToday ? 12 : 8, height: date.isToday ? 12 : 8)
                .foregroundColor({
                    if date.isToday {
                        return Theme.Colors.warning
                    } else if date.isInPast {
                        switch block.blockStatus {
                        case .completed: return allHaveSameStatus ? Color.white : Color.gray
                        case .courseStartDate: return Color.white
                        case .verifiedOnly: return Color.black
                        case .pastDue: return Color.gray
                        default: return Color.gray
                        }
                    } else if date.isInFuture {
                        return Color.black
                    } else {
                        return Color.white
                    }
                }())
                .overlay(Circle().stroke(Color.black, lineWidth: 1))
                .padding(.top, 5)
        }
        .frame(width: 16)
    }
}

struct CourseDateListView: View {
    @ObservedObject var viewModel: CourseDatesViewModel
    var courseDates: CourseDates

    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(viewModel.sortedDates, id: \.self) { date in
                        let blocks = courseDates.sortedDateToCourseDateBlockDict[date]!
                        let block = blocks[0]
                        
                        HStack(alignment: .center) {
                            let ignoredStatuses: [BlockStatus] = [.courseStartDate, .courseEndDate]
                            let allHaveSameStatus = blocks
                                .filter { !ignoredStatuses.contains($0.blockStatus) }
                                .allSatisfy { $0.blockStatus == block.blockStatus }
                            
                            TimeLineView(block: block, date: date,
                                         firstDate: viewModel.sortedDates.first,
                                         lastDate: viewModel.sortedDates.last,
                                         allHaveSameStatus: allHaveSameStatus)
                            
                            BlockStatusView(block: block,
                                            allHaveSameStatus: allHaveSameStatus,
                                            blocks: blocks)
                                            
                            Spacer()
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

struct BlockStatusView: View {
    let block: CourseDateBlock
    let allHaveSameStatus: Bool
    let blocks: [CourseDateBlock]
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(block.formattedDate)
                    .font(Theme.Fonts.bodyLarge)
                    .bold()

                if block.isToday {
                    Text(CoreLocalization.CourseDates.today)
                        .font(Theme.Fonts.bodySmall)
                        .foregroundColor(Color.black)
                        .padding(EdgeInsets(top: 2, leading: 6, bottom: 2, trailing: 8))
                        .background(Theme.Colors.warning)
                        .cornerRadius(5)
                }

                if allHaveSameStatus {
                    let lockImageText = block.isVerifiedOnly ? Text(Image(systemName: "lock.fill")) : Text("")
                    Text("\(lockImageText) \(block.blockStatus.title)")
                        .font(Theme.Fonts.bodySmall)
                        .foregroundColor(block.blockStatus.foregroundColor)
                        .padding(EdgeInsets(top: 2, leading: 6, bottom: 2, trailing: 8))
                        .background(block.blockStatus.backgroundColor)
                        .cornerRadius(5)
                }
            }

            ForEach(blocks) { block in
                styleBlock(block: block, allHaveSameStatus: allHaveSameStatus)
            }
            .padding(.top, 0.2)
        }
        .padding(.vertical, 0)
        .padding(.leading, 5)
        .padding(.bottom, 10)
    }
    
    func styleBlock(block: CourseDateBlock, allHaveSameStatus: Bool) -> some View {
        var attributedString = AttributedString("")
        
        if let prefix = block.assignmentType, !prefix.isEmpty {
            attributedString += AttributedString("\(prefix): ")
        }
        
        attributedString += styleTitle(block: block)
        
        if !allHaveSameStatus {
            attributedString.appendSpaces(2)
            attributedString += applyStyle(
                string: block.blockStatus.title,
                forgroundColor: block.blockStatus.foregroundColor,
                backgroundColor: block.blockStatus.backgroundColor)
        }
        
        return Text(attributedString)
            .font(Theme.Fonts.bodyMedium)
            .foregroundColor({
                if block.isAssignment {
                    return block.isAvailable ? Color.black : Color.gray.opacity(0.6)
                } else {
                    return Color.black
                }
            }())
            .onTapGesture {
                
            }
    }
    
    func styleTitle(block: CourseDateBlock) -> AttributedString {
        var attributedString = AttributedString(block.title)
        attributedString.font = Theme.Fonts.bodyMedium
        if block.canShowLink && !block.firstComponentBlockID.isEmpty {
            attributedString.underlineStyle = .single
        }
        return attributedString
    }
        
    func applyStyle(string: String, forgroundColor: Color, backgroundColor: Color) -> AttributedString {
        var attributedString = AttributedString(string)
        attributedString.font = Theme.Fonts.bodySmall
        attributedString.foregroundColor = forgroundColor
        attributedString.backgroundColor = backgroundColor
        return attributedString
    }
}

fileprivate extension BlockStatus {
    var title: String {
        switch self {
        case .completed: return CoreLocalization.CourseDates.completed
        case .pastDue: return CoreLocalization.CourseDates.pastDue
        case .dueNext: return CoreLocalization.CourseDates.dueNext
        case .unreleased: return CoreLocalization.CourseDates.unreleased
        case .verifiedOnly: return CoreLocalization.CourseDates.verifiedOnly
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
            courseID: "")
        
        CourseDatesView(
            courseID: "",
            viewModel: viewModel)
    }
}
#endif
