//
//  CourseDateListView.swift
//  Course
//
//  Created by Ivan Stepanok on 09.12.2024.
//

import SwiftUI
import Core
import Theme

struct CourseDateListView: View {
    @ObservedObject var viewModel: CourseDatesViewModel
    @State private var isExpanded = false
    @Binding var coordinate: CGFloat
    @Binding var collapsed: Bool
    @Binding var viewHeight: CGFloat
    var courseDates: CourseDates
    let courseID: String
    
    var body: some View {
        GeometryReader { proxy in
            VStack {
                ScrollView {
                    DynamicOffsetView(
                        coordinate: $coordinate,
                        collapsed: $collapsed,
                        viewHeight: $viewHeight
                    )
                    VStack(alignment: .leading, spacing: 0) {
                        
                        @State var status: SyncStatus = .offline
                        
                        CalendarSyncStatusView(status: status, router: viewModel.router)
                            .padding(.bottom, 16)
                            .task {
                                status = await viewModel.syncStatus()
                            }
                        
                        if !courseDates.hasEnded {
                            DatesStatusInfoView(
                                datesBannerInfo: courseDates.datesBannerInfo,
                                courseID: courseID,
                                courseDatesViewModel: viewModel,
                                screen: .courseDates
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
                    Spacer(minLength: 200)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
}
