//
//  CheckBoxView.swift
//  Core
//
//  Created by  Stepanok Ivan on 12.11.2022.
//

import SwiftUI
import Theme

public struct CheckBoxView: View {

    @Binding private var checked: Bool
    private var text: String
    private var font: Font

    public init(checked: Binding<Bool>, text: String, font: Font = Theme.Fonts.labelLarge) {
        self._checked = checked
        self.text = text
        self.font = font
    }

    public var body: some View {
        HStack(spacing: 10) {
            Image(
                systemName: checked ? "checkmark.square.fill" : "square"
            )
            .foregroundColor(
                checked ? Theme.Colors.accentXColor : Theme.Colors.textPrimary
            )
            Text(text)
                .font(font)
                .foregroundColor(Theme.Colors.textPrimary)
        }
        .onTapGesture {
            withAnimation(.linear(duration: 0.1)) {
                self.checked.toggle()
            }
        }
    }
}

struct CheckBoxView_Previews: PreviewProvider {
    static var previews: some View {
        CheckBoxView(checked: .constant(false), text: "Check it")
            .preferredColorScheme(.light)
            .previewDisplayName("CheckBoxView Light")

        CheckBoxView(checked: .constant(true), text: "Check it")
            .preferredColorScheme(.dark)
            .previewDisplayName("CheckBoxView Dark")
    }
}
