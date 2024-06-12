//
//  StyledButton.swift
//  Core
//
//  Created by Vladimir Chekyrta on 14.09.2022.
//

import SwiftUI
import Theme

public struct StyledButton: View {
    public enum ImagesStyle {
        case onSides
        case attachedToText
    }

    private let title: String
    private let action: () -> Void
    private let isTransparent: Bool
    private var idiom: UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    private let buttonColor: Color
    private let textColor: Color
    private let isActive: Bool
    private let horizontalPadding: Bool
    private let borderColor: Color
    private let leftImage: Image?
    private let rightImage: Image?
    private let imagesStyle: ImagesStyle
    private let isTitleTracking: Bool
    private let isLimitedOnPad: Bool
    private let shape: RoundedCorners
    
    public init(_ title: String,
                action: @escaping () -> Void,
                isTransparent: Bool = false,
                color: Color = Theme.Colors.accentButtonColor,
                textColor: Color = Theme.Colors.styledButtonText,
                borderColor: Color = .clear,
                leftImage: Image? = nil,
                rightImage: Image? = nil,
                imagesStyle: ImagesStyle = .attachedToText,
                isActive: Bool = true,
                isTitleTracking: Bool = true,
                isLimitedOnPad: Bool = true,
                shape: RoundedCorners = Theme.Shapes.buttonShape,
                horizontalPadding: Bool = false
    ) {
        self.title = title
        self.action = action
        self.isTransparent = isTransparent
        self.textColor = textColor
        self.borderColor = borderColor
        self.buttonColor = color
        self.isActive = isActive
        self.leftImage = leftImage
        self.rightImage = rightImage
        self.imagesStyle = imagesStyle
        self.isTitleTracking = isTitleTracking
        self.isLimitedOnPad = isLimitedOnPad
        self.shape = shape
        self.horizontalPadding = horizontalPadding
    }
    
    public var body: some View {
        Button(action: action) {
            HStack {
                if imagesStyle == .attachedToText {
                    Spacer()
                }

                if let icon = leftImage {
                    icon
                        .renderingMode(.template)
                        .foregroundStyle(textColor)
                }
                Text(title)
                    .tracking(isTitleTracking ? 1.3 : 0)
                    .foregroundColor(textColor)
                    .font(Theme.Fonts.labelLarge)
                    .opacity(isActive ? 1.0 : 0.6)

                if imagesStyle == .onSides {
                    Spacer()
                }

                if let icon = rightImage {
                    icon
                        .renderingMode(.template)
                        .foregroundStyle(textColor)
                }
                
                if imagesStyle == .attachedToText {
                    Spacer()
                }
            }
            .padding(.horizontal, imagesStyle == .onSides ? 10 : horizontalPadding ? 20 : 0)
            
        }
        .disabled(!isActive)
        .frame(maxWidth: idiom == .pad && isLimitedOnPad ? 260: .infinity, minHeight: isTransparent ? 36 : 42)
        .background(
            shape
                .fill(isTransparent ? .clear : buttonColor)
                .opacity(isActive ? 1.0 : 0.3)
        )
        .overlay(
            shape
                .stroke(style: .init(lineWidth: 1, lineCap: .round, lineJoin: .round, miterLimit: 1))
                .foregroundColor(isTransparent ? Theme.Colors.white : borderColor)
                .opacity(isActive ? 1.0 : 0.6)
        
        )
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(title)
    }
}

struct StyledButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            StyledButton("Active Button", action: {}, isActive: true)
            StyledButton("Disabled button", action: {}, isActive: false)
            StyledButton(
                "Back Button",
                action: {},
                leftImage: CoreAssets.arrowLeft.swiftUIImage,
                isActive: true
            )
        }
        .padding(20)
    }
}
