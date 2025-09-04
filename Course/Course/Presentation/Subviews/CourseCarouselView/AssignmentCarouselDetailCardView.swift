import SwiftUI
import Theme
import Core

struct AssignmentCarouselDetailCardView: View {

    let detailData: AssignmentDetailData

    private var subsectionUI: CourseProgressSubsectionUI {
        detailData.subsectionUI
    }

    private var sectionName: String {
        detailData.sectionName
    }

    private var status: AssignmentCardStatus {
        return subsectionUI.status
    }

    private var statusText: String {
        return subsectionUI.statusTextForCarousel
    }

    var body: some View {
        Button(action: {
            detailData.onAssignmentTap(subsectionUI)
        }) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    if detailData.subsectionUI.status != .incomplete {
                        HStack {
                            CoreAssets.icAssignmentPastDue.swiftUIImage
                            Text(detailData.subsectionUI.status == .pastDue ? "Past Due" : "Due Soon")
                                .font(Theme.Fonts.titleMedium)
                                .foregroundStyle(Theme.Colors.textPrimary)
                        }
                    }
                    
                    HStack {
                        VStack(alignment: .leading) {
                            if detailData.subsectionUI.date == nil {
                                Text(statusText)
                                    .font(Theme.Fonts.labelSmall)
                                    .foregroundColor(Theme.Colors.accentColor)
                                    .padding(.leading, -3)
                            }

                            Text(subsectionUI.subsection.displayName)
                                .font(Theme.Fonts.titleSmall)
                                .foregroundColor(Theme.Colors.textPrimary)

                            Text(sectionName)
                                .font(Theme.Fonts.labelSmall)
                                .foregroundColor(Theme.Colors.textSecondary)
                        }

                        Spacer()

                        CoreAssets.chevronRight.swiftUIImage
                            .resizable()
                            .renderingMode(.template)
                            .frame(width: 24, height: 24)
                            .foregroundStyle(Theme.Colors.textPrimary)
                            .flipsForRightToLeftLayoutDirection(true)
                    }
                }
            }
            .padding(.all, 8)
            .background(ThemeAssets.tabbarBGColor.swiftUIColor)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(style: .init(lineWidth: 1, lineCap: .round, lineJoin: .round, miterLimit: 1))
                    .foregroundColor(Theme.Colors.cardViewStroke)
            )
            .cornerRadius(4)
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.horizontal, 16)
    }
}
