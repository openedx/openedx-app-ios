//
//  SocialAuthButton.swift
//  Core
//
//  Created by Eugene Yatsenko on 10.10.2023.
//

import SwiftUI

public struct SocialAuthButton: View {

    // MARK: - Properties

    private var idiom: UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    
    private var image: Image
    private var title: String
    private var textColor: Color
    private var backgroundColor: Color
    private var cornerRadius: CGFloat
    private var action: () -> Void

    public init(
        image: Image,
        title: String,
        textColor: Color = .white,
        backgroundColor: Color = .accentColor,
        cornerRadius: CGFloat = 8,
        action: @escaping () -> Void
    ) {
        self.image = image
        self.title = title
        self.textColor = textColor
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.action = action
    }

    // MARK: - Views

    public var body: some View {
        Button {
            action()
        } label: {
            Label {
                Text(title)
                    .foregroundStyle(textColor)
                    .padding(.leading, 10)
                Spacer()
            } icon: {
                image.padding(.leading, 10)
            }
        }
        .frame(maxWidth: idiom == .pad ? 260: .infinity, minHeight: 42)
        .background(backgroundColor)
        .clipShape(
            RoundedRectangle(cornerRadius: cornerRadius)
        )

    }
}

#if DEBUG
struct LabelButton_Previews: PreviewProvider {
    static var previews: some View {
        SocialAuthButton(
            image: CoreAssets.iconApple.swiftUIImage,
            title: "Apple",
            backgroundColor: CoreAssets.appleButtonColor.swiftUIColor,
            action: {  }
        )
    }
}
#endif
