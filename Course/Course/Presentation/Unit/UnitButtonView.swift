//
//  UnitButtonView.swift
//  Course
//
//  Created by  Stepanok Ivan on 14.02.2023.
//

import SwiftUI
import Core

struct UnitButtonView: View {
    
    enum UnitButtonType {
        case first
        case next
        case previous
        case last
        case finish
        case reload
        
        func stringValue() -> String {
            switch self {
            case .first:
                return CourseLocalization.Courseware.next
            case .next:
                return CourseLocalization.Courseware.next
            case .previous:
                return CourseLocalization.Courseware.previous
            case .last:
                return CourseLocalization.Courseware.finish
            case .finish:
                return CourseLocalization.Courseware.finish
            case .reload:
                return CourseLocalization.Error.reload
            }
        }
    }
    
    private let action: () -> Void
    private let type: UnitButtonType
    
    init(type: UnitButtonType, action: @escaping () -> Void) {
        self.action = action
        self.type = type
    }
    
    var body: some View {
        HStack {
            Button(action: action) {
                VStack {
                    switch type {
                    case .first:
                        HStack {
                            Text(type.stringValue())
                                .foregroundColor(CoreAssets.styledButtonText.swiftUIColor)
                                .font(Theme.Fonts.labelLarge)
                            CoreAssets.arrowLeft.swiftUIImage.renderingMode(.template)
                                .foregroundColor(CoreAssets.styledButtonText.swiftUIColor)
                                .rotationEffect(Angle.degrees(180))
                        }
                    case .next:
                        HStack {
                            Text(type.stringValue())
                                .foregroundColor(CoreAssets.styledButtonText.swiftUIColor)
                                .padding(.leading, 20)
                                .font(Theme.Fonts.labelLarge)
                            Spacer()
                            CoreAssets.arrowLeft.swiftUIImage.renderingMode(.template)
                                .foregroundColor(CoreAssets.styledButtonText.swiftUIColor)
                                .rotationEffect(Angle.degrees(180))
                                .padding(.trailing, 20)
                        }
                    case .previous:
                        HStack {
                            CoreAssets.arrowLeft.swiftUIImage.renderingMode(.template)
                                .padding(.leading, 20)
                                .foregroundColor(CoreAssets.accentColor.swiftUIColor)
                            Spacer()
                            Text(type.stringValue())
                                .foregroundColor(CoreAssets.accentColor.swiftUIColor)
                                .font(Theme.Fonts.labelLarge)
                                .padding(.trailing, 20)
                        }
                    case .last:
                        HStack {
                            Text(type.stringValue())
                                .foregroundColor(CoreAssets.styledButtonText.swiftUIColor)
                                .padding(.leading, 16)
                                .font(Theme.Fonts.labelLarge)
                            Spacer()
                            CoreAssets.check.swiftUIImage.renderingMode(.template)
                                .foregroundColor(CoreAssets.styledButtonText.swiftUIColor)
                                .padding(.trailing, 16)
                        }
                    case .finish:
                        HStack {
                            Text(type.stringValue())
                                .foregroundColor(CoreAssets.styledButtonText.swiftUIColor)
                                .font(Theme.Fonts.labelLarge)
                            CoreAssets.check.swiftUIImage.renderingMode(.template)
                                .foregroundColor(CoreAssets.styledButtonText.swiftUIColor)
                        }
                    case .reload:
                        VStack(alignment: .center) {
                            Text(type.stringValue())
                                .foregroundColor(CoreAssets.accentColor.swiftUIColor)
                                .font(Theme.Fonts.labelLarge)
                        }
                    }
                }
                .frame(maxWidth: .infinity, minHeight: 48)
                .background(
                    VStack {
                        if self.type == .reload {
                            Theme.Shapes.buttonShape
                                .fill(.clear)
                        } else {
                            Theme.Shapes.buttonShape
                                .fill(type == .previous ? .clear : CoreAssets.accentColor.swiftUIColor)
                        }
                    }
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(style: .init(lineWidth: 1, lineCap: .round, lineJoin: .round, miterLimit: 1))
                        .foregroundColor(CoreAssets.accentColor.swiftUIColor)
                )
            }
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
        }
    }
}
