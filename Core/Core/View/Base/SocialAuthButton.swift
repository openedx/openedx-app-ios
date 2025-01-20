//
//  SocialAuthButton.swift
//  Core
//
//  Created by Eugene Yatsenko on 10.10.2023.
//

import SwiftUI
import Theme

public struct SocialAuthButton: View {

    // MARK: - Properties

    private var idiom: UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    
    private var image: Image
    private var accessibilityLabel: String
    private var accessibilityIdentifier: String
    private var action: () -> Void

    public init(
        image: Image,
        accessibilityLabel: String,
        accessibilityIdentifier: String,
        action: @escaping () -> Void
    ) {
        self.image = image
        self.accessibilityLabel = accessibilityLabel
        self.accessibilityIdentifier = accessibilityIdentifier
        self.action = action
    }

    // MARK: - Views

    public var body: some View {
        Button {
            action()
        } label: {
            image
                .padding()
        }
        .frame(maxWidth: 42, maxHeight: 42)
        .overlay(
            Theme.Shapes.buttonShape
                .stroke(style: .init(
                    lineWidth: 1,
                    lineCap: .round,
                    lineJoin: .round,
                    miterLimit: 1)
                )
                .foregroundColor(
                    Theme.Colors.socialAuthColor
                )
        )
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(accessibilityLabel)
        .accessibilityIdentifier(accessibilityIdentifier)
    }
}

#if DEBUG
struct LabelButton_Previews: PreviewProvider {
    static var previews: some View {
        SocialAuthButton(
            image: CoreAssets.iconApple.swiftUIImage,
            accessibilityLabel: "social auth button",
            accessibilityIdentifier: "some_identifier",
            action: {  }
        )
    }
}
#endif
