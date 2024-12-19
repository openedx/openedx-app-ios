//
//  AlertView.swift
//  Core
//
//  Created by  Stepanok Ivan on 22.09.2022.
//

import SwiftUI
import Theme

public enum AlertViewType: Equatable {
    case `default`(positiveAction: String, image: SwiftUI.Image?)
    case action(String, SwiftUI.Image)
    case logOut
    case leaveProfile
    case deleteVideo
    case deepLink
    case addCalendar
    case removeCalendar
    case updateCalendar
    case calendarAdded

    var contentPadding: CGFloat {
        switch self {
        case .`default`, .calendarAdded:
            return 16
        case .action, .logOut, .leaveProfile, .deleteVideo, .deepLink, .addCalendar, .removeCalendar, .updateCalendar:
            return 36
        }
    }
}

public struct AlertView: View {
    
    private var alertTitle: String
    private var alertMessage: String
    private var nextSectionName: String?
    private var positiveAction: String
    private var onCloseTapped: (() -> Void) = {}
    private var okTapped: (() -> Void) = {}
    private var nextSectionTapped: (() -> Void) = {}
    private let type: AlertViewType
    
    @Environment(\.isHorizontal) private var isHorizontal
    
    public init(
        alertTitle: String,
        alertMessage: String,
        positiveAction: String,
        onCloseTapped: @escaping () -> Void,
        okTapped: @escaping () -> Void,
        type: AlertViewType
    ) {
        self.alertTitle = alertTitle
        self.alertMessage = alertMessage
        self.positiveAction = positiveAction
        self.onCloseTapped = onCloseTapped
        self.okTapped = okTapped
        self.type = type
    }
    
    public init(
        alertTitle: String,
        alertMessage: String,
        nextSectionName: String? = nil,
        mainAction: String,
        image: SwiftUI.Image,
        onCloseTapped: @escaping () -> Void,
        okTapped: @escaping () -> Void,
        nextSectionTapped: @escaping () -> Void
    ) {
        self.alertTitle = alertTitle
        self.alertMessage = alertMessage
        self.onCloseTapped = onCloseTapped
        self.nextSectionName = nextSectionName
        self.okTapped = okTapped
        self.nextSectionTapped = nextSectionTapped
        self.positiveAction = ""
        type = .action(mainAction, image)
    }

    public var body: some View {
        ZStack(alignment: .center) {
            Color.black.opacity(0.5)
                .onTapGesture {
                    onCloseTapped()
                }
            content
        }
        .ignoresSafeArea()
    }

    private var content: some View {
        ZStack(alignment: .topTrailing) {
            adaptiveStack(
                spacing: isHorizontal ? 10 : 20,
                isHorizontal: (type == .leaveProfile && isHorizontal)
            ) {
                titles
                buttons
            }
            close
        }
        .frame(maxWidth: type == .logOut ? 390 : nil)
        .background(
            Theme.Shapes.cardShape
                .fill(Theme.Colors.cardViewBackground)
                .shadow(radius: 24)
                .fixedSize(horizontal: false, vertical: false)
        )
        .overlay(
            Theme.Shapes.buttonShape
                .stroke(lineWidth: 1)
                .foregroundColor(Theme.Colors.backgroundStroke)
                .fixedSize(horizontal: false, vertical: false)
        )
        .frame(maxWidth: isHorizontal ? nil : 390)
        .padding(40)
    }

    private var close: some View {
        Button {
            onCloseTapped()
        } label: {
            Image(systemName: "xmark")
                .padding(.trailing, 40)
                .padding(.top, 24)
                .foregroundColor(Theme.Colors.accentColor)
        }
    }

    @ViewBuilder
    private var titles: some View {
        switch type {
        case .logOut:
            HStack {
                Spacer(minLength: 100)
                CoreAssets.logOut.swiftUIImage.renderingMode(.template)
                    .padding(.top, isHorizontal ? 20 : 54)
                    .foregroundColor(Theme.Colors.textPrimary)
                Spacer(minLength: 100)
            }
            Text(alertMessage)
                .font(Theme.Fonts.titleLarge)
                .foregroundColor(Theme.Colors.textPrimary)
                .padding(.vertical, isHorizontal ? 6 : 40)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
                .frame(maxWidth: 250)
        case .leaveProfile, .deleteVideo, .deepLink, .addCalendar, .removeCalendar, .updateCalendar:
            VStack(spacing: 20) {
                switch type {
                case .deleteVideo, .deepLink:
                    CoreAssets.warning.swiftUIImage
                        .padding(.top, isHorizontal ? 20 : 54)
                case .addCalendar, .removeCalendar, .updateCalendar:
                    CoreAssets.syncToCalendar.swiftUIImage
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .padding(.top, isHorizontal ? 20 : 54)
                default:
                    CoreAssets.leaveProfile.swiftUIImage
                        .padding(.top, isHorizontal ? 20 : 54)
                }
                Text(alertTitle)
                    .font(Theme.Fonts.titleLarge)
                    .foregroundColor(Theme.Colors.textPrimary)
                    .padding(.horizontal, 40)
                    .fixedSize(horizontal: false, vertical: true)
                Text(alertMessage)
                    .font(Theme.Fonts.bodyMedium)
                    .foregroundColor(Theme.Colors.textPrimary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)

            }
            .padding(.bottom, 20)
        default:
            HStack {
                VStack(alignment: .center, spacing: 10) {
                    if case let .action(_, image) = type {
                        image.padding(.top, 48)
                    }
                    if case let .default(_, image) = type {
                        image.flatMap { $0.padding(.top, 48) }
                    }
                    Text(alertTitle)
                        .font(Theme.Fonts.titleLarge)
                        .foregroundColor(Theme.Colors.textPrimary)
                        .padding(.horizontal, 40)
                        .padding(.top, 10)
                    Text(alertMessage)
                        .font(Theme.Fonts.bodyMedium)
                        .foregroundColor(Theme.Colors.textPrimary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                        .frame(maxWidth: 250)
                }
                if isHorizontal {
                    if case let .action(action, _) = type {
                        VStack(spacing: 20) {
                            if nextSectionName != nil {
                                UnitButtonView(type: .nextSection, action: { nextSectionTapped() })
                                    .frame(maxWidth: 215)
                            }
                            UnitButtonView(type: .custom(action),
                                           bgColor: .clear,
                                           action: { okTapped() })
                            .frame(maxWidth: 215)

                            if let nextSectionName {
                                Group {
                                    Text(CoreLocalization.Courseware.nextSectionDescriptionFirst) +
                                    Text(nextSectionName) +
                                    Text(CoreLocalization.Courseware.nextSectionDescriptionLast)
                                }.frame(maxWidth: 215)
                                    .padding(.horizontal, 40)
                                    .multilineTextAlignment(.center)
                                    .font(Theme.Fonts.labelSmall)
                                    .foregroundColor(Theme.Colors.textSecondary)
                            }
                        }.padding(.top, 70)
                            .padding(.trailing, 20)
                    }
                }
            }
        }
    }

    private var buttons: some View {
        HStack {
            switch type {
            case let .`default`(positiveAction, _):
                HStack {
                    StyledButton(positiveAction, action: { okTapped() })
                        .frame(maxWidth: 135)
                    StyledButton(CoreLocalization.Alert.cancel, action: { onCloseTapped() })
                        .frame(maxWidth: 135)
                        .saturation(0)
                }
                .padding(.leading, 10)
                .padding(.trailing, 10)
                .padding(.bottom, 10)
            case let .action(action, _):
                if !isHorizontal {
                    VStack(spacing: 20) {
                        if nextSectionName != nil {
                            UnitButtonView(type: .nextSection, action: { nextSectionTapped() })
                                .frame(maxWidth: 215)
                        }
                        UnitButtonView(type: .custom(action),
                                       bgColor: Theme.Colors.secondaryButtonBGColor,
                                       action: { okTapped() })
                        .frame(maxWidth: 215)

                        if let nextSectionName {
                            Group {
                                Text(CoreLocalization.Courseware.nextSectionDescriptionFirst) +
                                Text(nextSectionName) +
                                Text(CoreLocalization.Courseware.nextSectionDescriptionLast)
                            }.frame(maxWidth: 215)
                                .padding(.horizontal, 40)
                                .multilineTextAlignment(.center)
                                .font(Theme.Fonts.labelSmall)
                                .foregroundColor(Theme.Colors.textSecondary)
                        }
                    }
                } else {
                    EmptyView()
                }
            case .logOut:
                Button(action: {
                    okTapped()
                }, label: {
                    ZStack {
                        Text(CoreLocalization.Alert.logout)
                            .foregroundColor(Theme.Colors.warningText)
                            .font(Theme.Fonts.labelLarge)
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal, 16)
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                            .foregroundColor(Theme.Colors.warningText)
                            .frame(minWidth: 190, minHeight: 48, alignment: .trailing)
                    }
                    .frame(maxWidth: 215, minHeight: 48)
                })
                .background(
                    Theme.Shapes.buttonShape
                        .fill(Theme.Colors.warning)
                )
                .overlay(
                    Theme.Shapes.buttonShape
                        .stroke(style: .init(
                            lineWidth: 1,
                            lineCap: .round,
                            lineJoin: .round,
                            miterLimit: 1
                        ))
                        .foregroundColor(.clear)
                )
                .frame(maxWidth: 215)
            case .leaveProfile:
                VStack(spacing: 0) {
                    Button(action: {
                        okTapped()
                    }, label: {
                        ZStack {
                            Text(CoreLocalization.Alert.leave)
                                .foregroundColor(Theme.Colors.primaryButtonTextColor)
                                .font(Theme.Fonts.labelLarge)
                                .frame(maxWidth: .infinity)
                                .padding(.horizontal, 16)
                        }
                        .frame(maxWidth: 215, minHeight: 48)
                    })
                    .background(
                        Theme.Shapes.buttonShape
                            .fill(Theme.Colors.accentColor)
                    )
                    .overlay(
                        Theme.Shapes.buttonShape
                            .stroke(style: .init(
                                lineWidth: 1,
                                lineCap: .round,
                                lineJoin: .round,
                                miterLimit: 1
                            ))
                            .foregroundColor(.clear)
                    )
                    .frame(maxWidth: 215)
                    .padding(.bottom, isHorizontal ? 10 : 24)
                    Button(action: {
                        onCloseTapped()
                    }, label: {
                        ZStack {
                            Text(CoreLocalization.Alert.keepEditing)
                                .foregroundColor(Theme.Colors.accentColor)
                                .font(Theme.Fonts.labelLarge)
                                .frame(maxWidth: .infinity)
                                .padding(.horizontal, 16)
                        }
                        .frame(maxWidth: 215, minHeight: 48)
                    })
                    .background(
                        Theme.Shapes.buttonShape
                            .fill(Theme.Colors.background)
                    )
                    .overlay(
                        Theme.Shapes.buttonShape
                            .stroke(style: .init(
                                lineWidth: 1,
                                lineCap: .round,
                                lineJoin: .round,
                                miterLimit: 1
                            ))
                            .foregroundColor(Theme.Colors.accentColor)
                    )
                    .frame(maxWidth: 215)
                }
                .padding(.trailing, isHorizontal ? 20 : 0)
            case .deleteVideo:
                configure(
                    primaryButtonTitle: CoreLocalization.Alert.delete,
                    secondaryButtonTitle: CoreLocalization.Alert.cancel
                )
            case .deepLink:
                configure(
                    primaryButtonTitle: CoreLocalization.view,
                    secondaryButtonTitle: CoreLocalization.Alert.cancel
                )
            case .addCalendar:
                configure(
                    primaryButtonTitle: CoreLocalization.Alert.add,
                    secondaryButtonTitle: CoreLocalization.Alert.cancel
                )
            case .removeCalendar:
                configure(
                    primaryButtonTitle: CoreLocalization.Alert.remove,
                    secondaryButtonTitle: CoreLocalization.Alert.cancel
                )
            case .updateCalendar:
                configure(
                    primaryButtonTitle: positiveAction,
                    secondaryButtonTitle: CoreLocalization.Alert.calendarShiftPromptRemoveCourseCalendar
                )
            case .calendarAdded:
                HStack {
                    StyledButton(positiveAction, action: { okTapped() })
                        .frame(maxWidth: 135)
                    StyledButton(CoreLocalization.done, action: { onCloseTapped() })
                        .frame(maxWidth: 135)
                        .saturation(0)
                }
                .padding(.leading, 10)
                .padding(.trailing, 10)
                .padding(.bottom, 10)
            }
        }
        .padding(.top, 16)
        .padding(.bottom, isHorizontal ? 16 : type.contentPadding)
    }

    private func configure(
        primaryButtonTitle: String,
        secondaryButtonTitle: String
    ) -> some View {
        VStack(spacing: 0) {
            Button {
                okTapped()
            } label: {
                ZStack {
                    Text(primaryButtonTitle)
                        .foregroundColor(Theme.Colors.primaryButtonTextColor)
                        .font(Theme.Fonts.labelLarge)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 16)
                }
                .frame(maxWidth: 215, minHeight: 48)
            }
            .background(
                Theme.Shapes.buttonShape
                    .fill(Theme.Colors.accentColor)
            )
            .overlay(
                Theme.Shapes.buttonShape
                    .stroke(style: .init(
                        lineWidth: 1,
                        lineCap: .round,
                        lineJoin: .round,
                        miterLimit: 1
                    ))
                    .foregroundColor(.clear)
            )
            .frame(maxWidth: 215)
            .padding(.bottom, isHorizontal ? 10 : 24)
            Button(action: {
                onCloseTapped()
            }, label: {
                ZStack {
                    Text(secondaryButtonTitle)
                        .foregroundColor(Theme.Colors.accentColor)
                        .font(Theme.Fonts.labelLarge)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 16)
                }
                .frame(maxWidth: 215, minHeight: 48)
            })
            .background(
                Theme.Shapes.buttonShape
                    .fill(Theme.Colors.background)
            )
            .overlay(
                Theme.Shapes.buttonShape
                    .stroke(style: .init(
                        lineWidth: 1,
                        lineCap: .round,
                        lineJoin: .round,
                        miterLimit: 1
                    ))
                    .foregroundColor(Theme.Colors.accentColor)
            )
            .frame(maxWidth: 215)
        }
        .padding(.trailing, isHorizontal ? 20 : 0)
    }
}

// swiftlint:disable all
struct AlertView_Previews: PreviewProvider {
    static var previews: some View {
        AlertView(
            alertTitle: "Congratulations!",
            alertMessage: "You've passed the course",
            nextSectionName: "Continue",
            mainAction: "Back to outline",
            image: CoreAssets.goodWork.swiftUIImage,
            onCloseTapped: {},
            okTapped: {},
            nextSectionTapped: {}
        )
        .previewLayout(.sizeThatFits)
        .background(Color.gray)
        
        AlertView(alertTitle: "Confirm log out",
                  alertMessage: "Are you sure you want to log out?",
                  positiveAction: "Yes",
                  onCloseTapped: {},
                  okTapped: {},
                  type: .logOut)
        
        AlertView(alertTitle: "Leave profile?",
                  alertMessage: "Changes you have made not be saved.",
                  positiveAction: "Yes",
                  onCloseTapped: {},
                  okTapped: {},
                  type: .leaveProfile)
        
        .previewLayout(.sizeThatFits)
        .background(Color.gray)
    }
}
//swiftlint:enable all
