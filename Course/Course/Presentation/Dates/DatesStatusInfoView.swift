//
//  DatesStatusInfoView.swift
//  Course
//
//  Created by Shafqat Muneer on 2/14/24.
//

import Foundation
import SwiftUI
import Core
import Theme

public enum DatesStatusInfoScreen: String {
    case courseDashbaord = "course_dashbaord"
    case courseDates = "course_dates"
}

struct DatesStatusInfoView: View {
    let datesBannerInfo: DatesBannerInfo
    let courseID: String
    var courseDatesViewModel: CourseDatesViewModel?
    var courseContainerViewModel: CourseContainerViewModel?
    var screen: DatesStatusInfoScreen
    
    @State private var isLoading = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            let header = datesBannerInfo.status?.header ?? ""
            let button = datesBannerInfo.status?.buttonTitle ?? ""
            Spacer()
            if !header.isEmpty {
                Text(header)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(Theme.Fonts.titleMedium)
                    .foregroundColor(Theme.Colors.textPrimary)
                    .padding(.horizontal, 16)
            }
            
            Text(datesBannerInfo.status?.body ?? "")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(Theme.Fonts.labelLarge)
                .foregroundColor(Theme.Colors.textPrimary)
                .padding(.horizontal, 16)
            
            if !button.isEmpty {
                UnitButtonView(type: .custom(button)) {
                    guard !isLoading else { return }
                    isLoading = true
                    courseDatesViewModel?.trackPLSEvent(
                        .plsShiftDatesClicked,
                        bivalue: .plsShiftDatesClicked,
                        courseID: courseID,
                        screenName: screen.rawValue,
                        type: datesBannerInfo.status?.analyticsBannerType ?? ""
                    )
                    Task {
                        if courseDatesViewModel != nil {
                            await courseDatesViewModel?.shiftDueDates(
                                courseID: courseID,
                                screen: screen,
                                type: datesBannerInfo.status?.analyticsBannerType ?? ""
                            )
                        } else if courseContainerViewModel != nil {
                            await courseContainerViewModel?.shiftDueDates(
                                courseID: courseID,
                                screen: screen,
                                type: datesBannerInfo.status?.analyticsBannerType ?? ""
                            )
                        }
                         isLoading = false
                    }
                }
                .padding([.leading, .trailing], 16)
                .disabled(isLoading)
                
            }
            Spacer()
        }
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Theme.Colors.datesSectionStroke, lineWidth: 2)
        )
        .background(Theme.Colors.datesSectionBackground)
        .onFirstAppear {
            courseDatesViewModel?.trackPLSEvent(
                .plsBannerViewed,
                bivalue: .plsBannerViewed,
                courseID: courseID,
                screenName: screen.rawValue,
                type: datesBannerInfo.status?.analyticsBannerType ?? ""
            )
        }
    }
}

#if DEBUG
struct DatesStatusInfoView_Previews: PreviewProvider {
    static var previews: some View {
        let datesBannerInfo = DatesBannerInfo(
            missedDeadlines: true,
            contentTypeGatingEnabled: false,
            missedGatedContent: false,
            verifiedUpgradeLink: "https://ecommerce.edx.org/basket/add/?sku=87701A8",
            status: .resetDatesBanner
        )
        
        DatesStatusInfoView(
            datesBannerInfo: datesBannerInfo,
            courseID: "courseID",
            screen: .courseDashbaord
        )
    }
}
#endif
