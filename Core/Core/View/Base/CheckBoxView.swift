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
    private let color: Color

    public init(
        checked: Binding<Bool>,
        text: String,
        font: Font = Theme.Fonts.labelLarge,
        color: Color = Theme.Colors.textPrimary
    ) {
        self._checked = checked
        self.text = text
        self.font = font
        self.color = color
    }

    public var body: some View {
        Toggle(isOn: Binding(
            get: { checked },
            set: { newValue in
                withAnimation(.linear(duration: 0.1)) {
                    checked = newValue
                }
            }
        )) {
            Text(text)
                .font(font)
                .foregroundColor(color)
        }
        .toggleStyle(CheckBoxToggleStyle(color: color))
    }
}

// Draws the existing checkbox look while keeping the Toggle's built-in accessibility,
// so VoiceOver reads the box and its text as one control with an on or off value.
private struct CheckBoxToggleStyle: ToggleStyle {
    let color: Color

    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 10) {
            Image(
                systemName: configuration.isOn ? "checkmark.square.fill" : "square"
            )
            .foregroundColor(
                configuration.isOn ? Theme.Colors.accentXColor : color
            )
            .accessibilityHidden(true)
            configuration.label
        }
        .contentShape(Rectangle())
        .onTapGesture { configuration.isOn.toggle() }
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
