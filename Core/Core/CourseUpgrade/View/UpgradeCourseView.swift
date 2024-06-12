//
//  UpgradeCourseView.swift
//  Core
//
//  Created by Vadim Kuznetsov on 11.06.24.
//

import SwiftUI
import Swinject

public enum CourseAccessErrorHelperType {
    case isEndDateOld(date: Date)
    case startDateError(date: Date?)
    case auditExpired(date: Date?, sku: String, courseID: String, pacing: String, screen: CourseUpgradeScreen)
    case upgradeable(date: Date?, sku: String, courseID: String, pacing: String, screen: CourseUpgradeScreen)
}

public struct UpgradeCourseView: View {
    let type: CourseAccessErrorHelperType
    @Binding private var coordinate: CGFloat
    @Binding private var collapsed: Bool
    @Binding private var shouldShowUpgradeButton: Bool
    @Binding private var shouldHideMenuBar: Bool
    private var backAction: (() -> Void)?
    @Environment(\.isHorizontal) private var isHorizontal
    private let findAction: (() -> Void)?
    
    public init(
        type: CourseAccessErrorHelperType,
        coordinate: Binding<CGFloat>,
        collapsed: Binding<Bool>,
        shouldShowUpgradeButton: Binding<Bool>,
        shouldHideMenuBar: Binding<Bool>,
        backAction: (() -> Void)?,
        findAction: (() -> Void)?
    ) {
        self.type = type
        self._coordinate = coordinate
        self._collapsed = collapsed
        self._shouldShowUpgradeButton = shouldShowUpgradeButton
        self._shouldHideMenuBar = shouldHideMenuBar
        self.backAction = backAction
        self.findAction = findAction
    }

    public var body: some View {
        switch type {
        case let .upgradeable(date, sku, courseID, pacing, screen),
            let .auditExpired(date, sku, courseID, pacing, screen):
            VStack {
                let message = CoreLocalization.CourseUpgrade.View.auditMessage
                    .replacingOccurrences(
                        of: CoreLocalization.CourseUpgrade.View.datePlaceholder,
                        with: date?.dateToString(style: .monthDayYear) ?? ""
                    )
                UpgradeInfoView(
                    isFindCourseButtonVisible: true,
                    viewModel: Container.shared.resolve(
                        UpgradeInfoViewModel.self,
                        arguments: "", message, sku, courseID, screen, pacing
                    )!,
                    findAction: {
                        findAction?()
                    },
                    headerView: {
                        VStack(spacing: 40) {
                            DynamicOffsetView(
                                coordinate: $coordinate,
                                collapsed: $collapsed,
                                shouldShowUpgradeButton: $shouldShowUpgradeButton,
                                shouldHideMenuBar: $shouldHideMenuBar
                            )
                            if !isHorizontal {
                                VStack {
                                    CoreAssets.upgradeArrowImage.swiftUIImage
                                        .resizable()
                                        .frame(width: 96, height: 96)
                                        .padding(.bottom, 4)
                                }
                                .frame(maxWidth: .infinity)
                            }
                        }
                    }
                )
            }
        case .startDateError(let date):
            let message = CoreLocalization.CourseUpgrade.View.startDateMessage
                .replacingOccurrences(
                    of: CoreLocalization.CourseUpgrade.View.datePlaceholder,
                    with: date?.dateToString(style: .monthDayYear) ?? ""
                )
            UpgradeCourseViewMessage(
                message: message,
                icon: CoreAssets.upgradeCalendarImage.swiftUIImage,
                coordinate: $coordinate,
                collapsed: $collapsed,
                shouldShowUpgradeButton: $shouldShowUpgradeButton,
                shouldHideMenuBar: $shouldHideMenuBar,
                backAction: backAction
            )
        case .isEndDateOld(let date):
            let message = CoreLocalization.CourseUpgrade.View.endDateMessage
                .replacingOccurrences(
                    of: CoreLocalization.CourseUpgrade.View.datePlaceholder,
                    with: date.dateToString(style: .monthDayYear)
                )
            UpgradeCourseViewMessage(
                message: message,
                icon: CoreAssets.upgradeArrowImage.swiftUIImage,
                coordinate: $coordinate,
                collapsed: $collapsed,
                shouldShowUpgradeButton: $shouldShowUpgradeButton,
                shouldHideMenuBar: $shouldHideMenuBar,
                backAction: backAction
            )
        }
    }
}

#if DEBUG
#Preview {
    VStack {
        UpgradeCourseView(
            type: .auditExpired(
                date: .now,
                sku: "some sku",
                courseID: "courseID",
                pacing: "pacing",
                screen: .unknown
            ),
            coordinate: .constant(0),
            collapsed: .constant(false),
            shouldShowUpgradeButton: .constant(true),
            shouldHideMenuBar: .constant(false),
            backAction: nil,
            findAction: nil
        )
        UpgradeCourseView(
            type: .upgradeable(
                date: .now,
                sku: "some sku",
                courseID: "courseID",
                pacing: "pacing",
                screen: .unknown
            ),
            coordinate: .constant(0),
            collapsed: .constant(false),
            shouldShowUpgradeButton: .constant(true),
            shouldHideMenuBar: .constant(false),
            backAction: nil,
            findAction: nil
        )
        UpgradeCourseView(
            type: .startDateError(date: .now),
            coordinate: .constant(0),
            collapsed: .constant(false),
            shouldShowUpgradeButton: .constant(true),
            shouldHideMenuBar: .constant(false),
            backAction: nil,
            findAction: nil
        )
        UpgradeCourseView(
            type: .isEndDateOld(date: .now),
            coordinate: .constant(0),
            collapsed: .constant(false),
            shouldShowUpgradeButton: .constant(true),
            shouldHideMenuBar: .constant(false),
            backAction: nil,
            findAction: nil
        )
    }
}
#endif
