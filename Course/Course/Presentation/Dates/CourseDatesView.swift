//
//  CourseDatesView.swift
//  Discussion
//
//  Created by Muhammad Umer on 10/17/23.
//

import Foundation
import SwiftUI
import Core

public struct CourseDatesView: View {
    
    private let courseID: String
    
    @StateObject
    private var viewModel: CourseDatesViewModel
    
    public init(
        courseID: String,
        viewModel: CourseDatesViewModel
    ) {
        self.courseID = courseID
        self._viewModel = StateObject(wrappedValue: { viewModel }())
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
    let date: Date
    let firstDate: Date?
    let lastDate: Date?
    
    var body: some View {
        ZStack(alignment: .top) {
            if lastDate == date {
                VStack {
                    Line()
                        .stroke(style: StrokeStyle(lineWidth: 1))
                        .frame(maxHeight: 10.0, alignment: .top)
                    Spacer()
                }
            } else if firstDate == date {
                Line()
                    .stroke(style: StrokeStyle(lineWidth: 1))
                    .frame(maxHeight: .infinity, alignment: .top)
                    .padding(.top, 10)
            } else {
                Line()
                    .stroke(style: StrokeStyle(lineWidth: 1))
                    .frame(maxHeight: .infinity, alignment: .top)
            }
            
            Circle()
                .frame(width: date.isToday ? 12 : 8, height: date.isToday ? 12 : 8)
                .foregroundColor({
                    if date.isToday {
                        return Theme.Colors.warning
                    } else if date.isInPast {
                        return Color.gray
                    } else {
                        return Color.black
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
                        
                        HStack(alignment: .center) {
                            TimeLineView(date: date,
                                         firstDate: viewModel.sortedDates.first,
                                         lastDate: viewModel.sortedDates.last)
                            
                            let ignoredStatuses: [BlockStatus] = [.courseStartDate, .courseEndDate]
                            let block = blocks[0]
                            let allHaveSameStatus = blocks
                                .filter { !ignoredStatuses.contains($0.blockStatus) }
                                .allSatisfy { $0.blockStatus == block.blockStatus }
                            
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
                Text(block.date.dateToString(style: .shortWeekdayMonthDayYear))
                    .font(.subheadline)
                    .bold()

                if block.isToday {
                    Text(block.blockTitle)
                        .font(.footnote)
                        .foregroundColor(Color.black)
                        .padding(EdgeInsets(top: 2, leading: 6, bottom: 2, trailing: 8))
                        .background(Theme.Colors.warning)
                        .cornerRadius(5)
                }

                if allHaveSameStatus {
                    let lockImageText = block.isVerifiedOnly ? Text(Image(systemName: "lock.fill")) : Text("")
                    Text("\(lockImageText) \(block.blockTitle)")
                        .font(.footnote)
                        .foregroundColor(determineForegroundColor(for: block.blockStatus))
                        .padding(EdgeInsets(top: 2, leading: 6, bottom: 2, trailing: 8))
                        .background(determineBackgroundColor(for: block.blockStatus))
                        .cornerRadius(5)
                }
            }

            ForEach(blocks, id: \.firstComponentBlockID) { block in
                styleBlock(block: block, allHaveSameStatus: allHaveSameStatus)
            }
        }
        .padding(.vertical, 0)
        .padding(.leading, 5)
        .padding(.bottom, 10)
    }
    
    private func determineForegroundColor(for status: BlockStatus) -> Color {
        switch status {
        case .verifiedOnly: return Color.white
        case .pastDue: return Color.black
        case .dueNext: return Color.white
        default: return Color.white.opacity(0)
        }
    }
    
    private func determineBackgroundColor(for status: BlockStatus) -> Color {
        switch status {
        case .verifiedOnly: return Color.black.opacity(0.5)
        case .pastDue: return Color.gray.opacity(0.4)
        case .dueNext: return Color.black.opacity(0.5)
        default: return Color.white.opacity(0)
        }
    }
    
    func styleBlock(block: CourseDateBlock, allHaveSameStatus: Bool) -> some View {
        var attrString = AttributedString("")
        
        if let prefix = block.assignmentType, !prefix.isEmpty {
            attrString += AttributedString("\(prefix): ")
        }
        
        attrString += block.canShowLink ? getAttributedUnderlineString(string: block.title) : AttributedString(block.title)
        
        if !allHaveSameStatus {
            attrString += "  "
            let (status, foregroundColor, backgroundColor) = getStatusDetails(for: block.blockStatus)
            attrString += getAttributedString(string: status, forgroundColor: foregroundColor, backgroundColor: backgroundColor)
        }
        
        return Text(attrString).padding(.bottom, 2).font(.footnote)
    }
    
    func getStatusDetails(for blockStatus: BlockStatus) -> (String, Color, Color) {
        switch blockStatus {
        case .verifiedOnly:
            return ("Verified Only", Color.white, Color.black.opacity(0.5))
        case .pastDue:
            return ("Past Due", Color.black, Color.gray.opacity(0.4))
        case .dueNext:
            return ("Due Next", Color.white, Color.black.opacity(0.5))
        case .unreleased:
            return ("Unreleased", Color.white.opacity(0), Color.white.opacity(0))
        default:
            return ("", Color.white.opacity(0), Color.white.opacity(0))
        }
    }
    
    func getAttributedUnderlineString(string: String) -> AttributedString {
        var attributedString = AttributedString(string)
        attributedString.font = .footnote
        attributedString.underlineStyle = .single
        return attributedString
    }
    
    func getAttributedString(string: String, forgroundColor: Color, backgroundColor: Color) -> AttributedString {
        var attributedString = AttributedString(string)
        attributedString.font = .footnote
        attributedString.foregroundColor = forgroundColor
        attributedString.backgroundColor = backgroundColor
        return attributedString
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
