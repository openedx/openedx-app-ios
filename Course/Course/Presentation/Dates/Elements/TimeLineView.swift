//
//  TimeLineView.swift
//  Course
//
//  Created by Ivan Stepanok on 09.12.2024.
//

import SwiftUI
import Core
import Theme

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
