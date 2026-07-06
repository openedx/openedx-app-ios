import SwiftUI
import Theme

struct LMSDirectoryQRInstructionsView: View {
    var onScan: () -> Void

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                Text("QR login")
                    .font(Theme.Fonts.titleLarge)
                    .foregroundColor(Theme.Colors.textPrimary)
                Text(
                    "1. On your desktop, visit https://your-lms.com/qr (replace with your LMS URL).\n"
                        + "2. The page will display a QR code.\n"
                        + "3. Tap “Scan QR” below and point your camera at the code to continue."
                )
                    .font(Theme.Fonts.bodyLarge)
                    .foregroundColor(Theme.Colors.textSecondary)
                Spacer()
                Button(action: onScan) {
                    Text("Scan QR")
                        .font(Theme.Fonts.titleMedium)
                        .foregroundColor(Theme.Colors.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Theme.Colors.accentColor)
                        .clipShape(Theme.Shapes.buttonShape)
                }
            }
            .padding(24)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
        }
    }

    @Environment(\.dismiss) private var dismiss
}
