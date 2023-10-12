//
//  LabelButton.swift
//  Core
//
//  Created by Eugene Yatsenko on 10.10.2023.
//

import SwiftUI

public struct LabelButton: View {

    // MARK: - Properties -

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

    // MARK: - Views -

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
        .frame(height: 44)
        .background(backgroundColor)
        .clipShape(
            RoundedRectangle(cornerRadius: cornerRadius)
        )

    }
}
