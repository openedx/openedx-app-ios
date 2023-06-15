//
//  AlertView.swift
//  Core
//
//  Created by  Stepanok Ivan on 22.09.2022.
//

import SwiftUI

public enum AlertViewType: Equatable {
    case `default`(positiveAction: String)
    case action(String, SwiftUI.Image)
    case logOut
    case leaveProfile
    
    var contentPadding: CGFloat {
        switch self {
        case .`default`:
            return 5
        case .action, .logOut, .leaveProfile:
            return 36
        }
    }
}

public struct AlertView: View {
    
    private var alertTitle: String
    private var alertMessage: String
    private var nextSectionName: String?
    private var onCloseTapped: (() -> Void) = {}
    private var okTapped: (() -> Void) = {}
    private var nextSectionTapped: (() -> Void) = {}
    private let type: AlertViewType
    
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
        type = .action(mainAction, image)
    }
    
    public var body: some View {
        GeometryReader { reader in
            ZStack(alignment: .center) {
                Color.black.opacity(0.5)
                    .onTapGesture {
                        onCloseTapped()
                    }
                VStack(alignment: .center, spacing: 20) {
                    if case let .action(_, image) = type {
                        image.padding(.top, 48)
                    }
                    if type == .logOut {
                        CoreAssets.logOut.swiftUIImage
                            .padding(.top, 54)
                        Text(alertMessage)
                            .font(Theme.Fonts.titleLarge)
                            .padding(.vertical, 40)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                            .frame(maxWidth: 250)
                    } else if type == .leaveProfile {
                        CoreAssets.leaveProfile.swiftUIImage
                            .padding(.top, 54)
                        Text(alertTitle)
                            .font(Theme.Fonts.titleLarge)
                            .padding(.horizontal, 40)
                        Text(alertMessage)
                            .font(Theme.Fonts.bodyMedium)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                    } else {
                        Text(alertTitle)
                            .font(Theme.Fonts.titleLarge)
                            .padding(.horizontal, 40)
                        Text(alertMessage)
                            .font(Theme.Fonts.bodyMedium)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                            .frame(maxWidth: 250)
                    }
                    HStack {
                        switch type {
                        case let .`default`(positiveAction):
                            StyledButton(positiveAction, action: { okTapped() })
                                .frame(maxWidth: 135)
                            StyledButton(CoreLocalization.Alert.cancel, action: { onCloseTapped() })
                                .frame(maxWidth: 135)
                                .saturation(0)
                        case let .action(action, _):
                            VStack(spacing: 20) {
                                if let nextSectionName {
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
                                        .foregroundColor(CoreAssets.textSecondary.swiftUIColor)
                                }
                               
                            }
                        case .logOut:
                            Button(action: {
                                okTapped()
                            }, label: {
                                ZStack {
                                    Text(CoreLocalization.Alert.logout)
                                        .foregroundColor(.black)
                                        .font(Theme.Fonts.labelLarge)
                                        .frame(maxWidth: .infinity)
                                        .padding(.horizontal, 16)
                                    Image(systemName: "rectangle.portrait.and.arrow.right")
                                        .foregroundColor(.black)
                                        .frame(minWidth: 190, minHeight: 48, alignment: .trailing)
                                }
                                .frame(maxWidth: 215, minHeight: 48)
                            })
                            .background(
                                Theme.Shapes.buttonShape
                                    .fill(CoreAssets.warning.swiftUIColor)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
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
                                            .foregroundColor(.black)
                                            .font(Theme.Fonts.labelLarge)
                                            .frame(maxWidth: .infinity)
                                            .padding(.horizontal, 16)
                                    }
                                    .frame(maxWidth: 215, minHeight: 48)
                                })
                                .background(
                                    Theme.Shapes.buttonShape
                                        .fill(CoreAssets.warning.swiftUIColor)
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(style: .init(
                                            lineWidth: 1,
                                            lineCap: .round,
                                            lineJoin: .round,
                                            miterLimit: 1
                                        ))
                                        .foregroundColor(.clear)
                                )
                                .frame(maxWidth: 215)
                                .padding(.bottom, 24)
                                Button(action: {
                                    onCloseTapped()
                                }, label: {
                                    ZStack {
                                        Text(CoreLocalization.Alert.keepEditing)
                                            .foregroundColor(CoreAssets.textPrimary.swiftUIColor)
                                            .font(Theme.Fonts.labelLarge)
                                            .frame(maxWidth: .infinity)
                                            .padding(.horizontal, 16)
                                    }
                                    .frame(maxWidth: 215, minHeight: 48)
                                })
                                .background(
                                    Theme.Shapes.buttonShape
                                        .fill(.clear)
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(style: .init(
                                            lineWidth: 1,
                                            lineCap: .round,
                                            lineJoin: .round,
                                            miterLimit: 1
                                        ))
                                        .foregroundColor(CoreAssets.textPrimary.swiftUIColor)
                                )
                                .frame(maxWidth: 215)
                            }
                        }
                    }
                    .padding(.top, 5)
                    .padding(.bottom, type.contentPadding)
                }
                .background(
                    Theme.Shapes.cardShape
                        .fill(CoreAssets.cardViewBackground.swiftUIColor)
                        .shadow(radius: 24)
                        .frame(width: reader.size.width < 420
                               ? reader.size.width - 80
                               : 360)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(style: .init(lineWidth: 1, lineCap: .round, lineJoin: .round, miterLimit: 1))
                        .foregroundColor(CoreAssets.backgroundStroke.swiftUIColor)
                        .frame(width: reader.size.width < 420
                               ? reader.size.width - 80
                               : 360)
                )
                .padding()
            }
            
            .ignoresSafeArea()
        }
    }
}

// swiftlint:disable all
struct AlertView_Previews: PreviewProvider {
    static var previews: some View {
//        AlertView(
//            alertTitle: "Warning!",
//            alertMessage: "Something goes wrong. Do you want to exterminate your phone, right now",
//            positiveAction: "Accept",
//            onCloseTapped: {},
//            okTapped: {},
//            type: .action("", CoreAssets.goodWork.swiftUIImage)
//        )
        AlertView(alertTitle: "Warning",
                  alertMessage: "Something goes wrong. Do you want to exterminate your phone, right now",
                  nextSectionName: "Ahmad tea is a power",
                  mainAction: "Back to outline",
                  image: CoreAssets.goodWork.swiftUIImage,
                  onCloseTapped: {},
                  okTapped: {},
                  nextSectionTapped: {})
        
        .previewLayout(.sizeThatFits)
        .background(Color.gray)
    }
}
