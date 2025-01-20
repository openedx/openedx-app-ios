//
//  UnitButtonView.swift
//  Course
//
//  Created by  Stepanok Ivan on 14.02.2023.
//

import SwiftUI
import Theme

public enum UnitButtonType: Equatable {
    case first
    case next
    case nextBig
    case previous
    case last
    case finish
    case reload
    case continueLesson
    case nextSection
    case custom(String)
    
    func stringValue() -> String {
        switch self {
        case .first:
            return CoreLocalization.Courseware.next
        case .next, .nextBig:
            return CoreLocalization.Courseware.next
        case .previous:
            return CoreLocalization.Courseware.previous
        case .last:
            return CoreLocalization.Courseware.finish
        case .finish:
            return CoreLocalization.Courseware.finish
        case .reload:
            return CoreLocalization.Error.reload
        case .continueLesson:
            return CoreLocalization.Courseware.resume
        case .nextSection:
            return CoreLocalization.Courseware.nextSection
        case let .custom(text):
            return text
        }
    }
}

public struct UnitButtonView: View {
    
    private let action: () -> Void
    private let type: UnitButtonType
    private let bgColor: Color?
    private let isVerticalNavigation: Bool
    
    private var nextButtonDegrees: Double {
        isVerticalNavigation ? -90 : 180
    }

    public init(
        type: UnitButtonType,
        isVerticalNavigation: Bool = true,
        bgColor: Color? = nil,
        action: @escaping () -> Void
    ) {
        self.type = type
        self.bgColor = bgColor
        self.action = action
        self.isVerticalNavigation = isVerticalNavigation
    }
    
    public  var body: some View {
        HStack {
            Button(action: action) {
                VStack {
                    switch type {
                    case .first:
                        HStack {
                            Text(type.stringValue())
                                .foregroundColor(Theme.Colors.primaryButtonTextColor)
                                .font(Theme.Fonts.labelLarge)
                            CoreAssets.arrowLeft.swiftUIImage.renderingMode(.template)
                                .foregroundColor(Theme.Colors.primaryButtonTextColor)
                                .rotationEffect(Angle.degrees(nextButtonDegrees))
                        }.padding(.horizontal, 16)
                    case .next, .nextBig:
                        HStack {
                            Text(type.stringValue())
                                .foregroundColor(Theme.Colors.primaryButtonTextColor)
                                .padding(.leading, 20)
                                .font(Theme.Fonts.labelLarge)
                            if type != .nextBig {
                                Spacer()
                            }
                            CoreAssets.arrowLeft.swiftUIImage.renderingMode(.template)
                                .foregroundColor(Theme.Colors.primaryButtonTextColor)
                                .rotationEffect(Angle.degrees(nextButtonDegrees))
                                .padding(.trailing, 20)
                        }
                    case .previous:
                        HStack {
                            if isVerticalNavigation {
                                Text(type.stringValue())
                                    .foregroundColor(Theme.Colors.accentColor)
                                    .font(Theme.Fonts.labelLarge)
                                    .padding(.leading, 20)
                                CoreAssets.arrowLeft.swiftUIImage.renderingMode(.template)
                                    .rotationEffect(Angle.degrees(90))
                                    .padding(.trailing, 20)
                                    .foregroundColor(Theme.Colors.accentColor)
                            } else {
                                CoreAssets.arrowLeft.swiftUIImage.renderingMode(.template)
                                    .padding(.leading, 20)
                                    .foregroundColor(Theme.Colors.accentColor)
                                Text(type.stringValue())
                                    .foregroundColor(Theme.Colors.accentColor)
                                    .font(Theme.Fonts.labelLarge)
                                    .padding(.trailing, 20)
                            }
                        }
                    case .last:
                        HStack {
                            Text(type.stringValue())
                                .foregroundColor(Theme.Colors.primaryButtonTextColor)
                                .padding(.leading, 8)
                                .font(Theme.Fonts.labelLarge)
                                .scaledToFit()
                            Spacer()
                            CoreAssets.check.swiftUIImage.renderingMode(.template)
                                .foregroundColor(Theme.Colors.primaryButtonTextColor)
                                .padding(.trailing, 8)
                        }
                    case .finish:
                        HStack {
                            Text(type.stringValue())
                                .foregroundColor(Theme.Colors.primaryButtonTextColor)
                                .font(Theme.Fonts.labelLarge)
                            CoreAssets.check.swiftUIImage.renderingMode(.template)
                                .foregroundColor(Theme.Colors.primaryButtonTextColor)
                        }.padding(.horizontal, 16)
                    case .reload, .custom:
                        VStack(alignment: .center) {
                            Text(type.stringValue())
                                .foregroundColor(bgColor == nil ? .white : Theme.Colors.secondaryButtonTextColor)
                                .font(Theme.Fonts.labelLarge)
                        }.padding(.horizontal, 16)
                    case .continueLesson, .nextSection:
                        HStack {
                            Text(type.stringValue())
                                .foregroundColor(
                                    type == .continueLesson ? Theme.Colors.resumeButtonText :
                                    Theme.Colors.styledButtonText
                                )
                                .padding(.leading, 20)
                                .font(Theme.Fonts.labelLarge)
                            CoreAssets.arrowLeft.swiftUIImage.renderingMode(.template)
                                .foregroundColor(
                                        type == .continueLesson
                                        ? Theme.Colors.resumeButtonText
                                        : Theme.Colors.styledButtonText
                                    )
                                .rotationEffect(Angle.degrees(180))
                                .padding(.trailing, 20)
                        }
                    }
                }
                .frame(maxWidth: .infinity, minHeight: 42)
                .background(
                    VStack {
                        switch self.type {
                        case .first, .next, .nextBig, .previous, .last:
                            Theme.Shapes.buttonShape
                                .fill(type == .previous
                                      ? Theme.Colors.background
                                      : Theme.Colors.accentColor)
                                .shadow(color: Color.black.opacity(0.25), radius: 21, y: 4)
                                .overlay(
                                    Theme.Shapes.buttonShape
                                        .stroke(style: .init(
                                            lineWidth: 1,
                                            lineCap: .round,
                                            lineJoin: .round,
                                            miterLimit: 1)
                                        )
                                        .foregroundColor(
                                            Theme.Colors.accentColor
                                        )
                                )
                                
                        case .continueLesson, .nextSection, .reload, .finish, .custom:
                            Theme.Shapes.buttonShape
                                .fill(
                                    type == .continueLesson ? Theme.Colors.resumeButtonBG :
                                    bgColor ?? Theme.Colors.accentButtonColor
                                )
                            
                                .shadow(color: (type == .first
                                                || type == .next
                                                || type == .previous
                                                || type == .last
                                                || type == .finish
                                                || type == .reload) ? Color.black.opacity(0.25) : .clear,
                                        radius: 21, y: 4)
                                .overlay(
                                    Theme.Shapes.buttonShape
                                        .stroke(style: .init(
                                            lineWidth: 1,
                                            lineCap: .round,
                                            lineJoin: .round,
                                            miterLimit: 1
                                        ))
                                        .foregroundColor(
                                            type == .continueLesson
                                            ? Theme.Colors.accentButtonColor
                                            : Theme.Colors.secondaryButtonBorderColor
                                        )
                                )
                        }
                    }
                )
            
            }
            .fixedSize(horizontal: (type == .first
                       || type == .next
                       || type == .previous
                       || type == .last
                       || type == .finish
                       || type == .reload)
                       , vertical: false)
        }
        
    }
}

struct UnitButtonView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            UnitButtonView(type: .first, action: {})
            UnitButtonView(type: .previous, action: {})
            UnitButtonView(type: .next, action: {})
            UnitButtonView(type: .last, action: {})
            UnitButtonView(type: .finish, action: {})
            UnitButtonView(type: .reload, action: {})
            UnitButtonView(type: .custom("Custom text"), action: {})
            UnitButtonView(type: .continueLesson, action: {})
            UnitButtonView(type: .nextSection, action: {})
        }.padding()
    }
}
