//
//  CheckBoxView.swift
//  Discussion
//
//  Created by  Stepanok Ivan on 12.11.2022.
//

import SwiftUI
import Core
import Theme

public struct CheckBoxView: View {
    @Binding var checked: Bool
    var text: String

    public var body: some View {
        HStack(spacing: 10) {
            Image(systemName: checked ? "checkmark.square.fill" : "square")
                .foregroundColor(checked
                                 ? Theme.Colors.accentColor
                                 : Theme.Colors.textPrimary)
            Text(text)
                .font(Theme.Fonts.labelLarge)
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
