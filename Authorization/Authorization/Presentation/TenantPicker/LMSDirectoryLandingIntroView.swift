import SwiftUI
import Theme

struct LMSDirectoryLandingIntroView: View {
    var onFindTapped: () -> Void
    var onQRTapped: () -> Void

    var body: some View {
        VStack(spacing: 32) {
            Spacer(minLength: 120)
            VStack(spacing: 12) {
                ThemeAssets.appLogo.swiftUIImage
                    .resizable()
                    .scaledToFit()
                    .frame(width: 140, height: 140)
//                    .foregroundColor(Theme.Colors.accentColor)
                    .accessibilityHidden(true)
                Text("Welcome to Open X Project")
                    .font(Theme.Fonts.titleLarge)
                    .foregroundColor(Theme.Colors.textPrimary)
                Text("Connect to any LMS in our library to explore courses or continue learning.")
                    .font(Theme.Fonts.bodyLarge)
                    .foregroundColor(Theme.Colors.textSecondary)
                    .multilineTextAlignment(.center)
            }
            Spacer()
            VStack(spacing: 16) {
                Button(action: onFindTapped) {
                    Text("Find my LMS")
                        .font(Theme.Fonts.titleMedium)
                        .foregroundColor(Theme.Colors.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Theme.Colors.accentColor)
                        .clipShape(Theme.Shapes.buttonShape)
                }
                Button(action: onQRTapped) {
                    HStack(spacing: 8) {
                        Image(systemName: "qrcode.viewfinder")
                        Text("QR Login")
                    }
                    .font(Theme.Fonts.bodyLarge)
                    .foregroundColor(Theme.Colors.infoColor)
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
}
