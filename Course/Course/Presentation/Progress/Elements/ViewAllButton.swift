import SwiftUI
import Theme
import Core

struct ViewAllButton: View {
    let section: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                Image(systemName: "list.bullet")
                    .renderingMode(.template)
                    .foregroundStyle(Theme.Colors.accentColor)
                Text("\(CoreLocalization.view) \(section)")
                    .foregroundColor(Theme.Colors.accentColor)
                    .font(Theme.Fonts.labelLarge)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(CoreLocalization.view) \(section)")
    }
}

#Preview {
    ViewAllButton(section: "Assignments") {
        print("View All tapped")
    }
}
