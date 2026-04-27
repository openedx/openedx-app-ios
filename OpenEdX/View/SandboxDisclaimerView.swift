//
//  SandboxDisclaimerView.swift
//  OpenEdX
//
//  Created on 16.03.2026.
//

import SwiftUI
import Theme

struct SandboxDisclaimerView: View {

    @State private var appearAnimation = false
    @State private var progress: CGFloat = 0

    let onDismiss: () -> Void

    private let duration: TimeInterval = 5

    var body: some View {
        ZStack {
            Theme.Colors.accentColor
                .ignoresSafeArea()

            VStack(spacing: 24) {
                Spacer()

                // Icon
                Image(systemName: "flask.fill")
                    .font(.system(size: 56))
                    .foregroundColor(.white.opacity(0.9))
                    .scaleEffect(appearAnimation ? 1 : 0.5)
                    .opacity(appearAnimation ? 1 : 0)
                    .animation(.spring(response: 0.6, dampingFraction: 0.7), value: appearAnimation)

                // Title
                Text("Sandbox Environment")
                    .font(Theme.Fonts.displaySmall)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .opacity(appearAnimation ? 1 : 0)
                    .offset(y: appearAnimation ? 0 : 20)
                    .animation(.easeOut(duration: 0.5).delay(0.2), value: appearAnimation)

                // Description
                VStack(spacing: 12) {
                    Text("You are using a test instance of Open edX")
                        .font(Theme.Fonts.titleMedium)
                        .foregroundColor(.white.opacity(0.95))
                        .multilineTextAlignment(.center)

                    Text(
                        "This environment is for testing and demonstration "
                        + "purposes only. Courses, progress, and account data "
                        + "may be reset at any time without notice."
                    )
                        .font(Theme.Fonts.bodyLarge)
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)

                    Text("sandbox.openedx.org")
                        .font(Theme.Fonts.labelLarge)
                        .foregroundColor(.white.opacity(0.6))
                        .padding(.top, 4)
                }
                .padding(.horizontal, 32)
                .opacity(appearAnimation ? 1 : 0)
                .offset(y: appearAnimation ? 0 : 20)
                .animation(.easeOut(duration: 0.5).delay(0.35), value: appearAnimation)

                Spacer()

                // Progress bar
                VStack(spacing: 8) {
                    GeometryReader { geo in
                        Capsule()
                            .fill(Color.white.opacity(0.2))
                            .frame(height: 4)
                            .overlay(alignment: .leading) {
                                Capsule()
                                    .fill(Color.white.opacity(0.7))
                                    .frame(width: geo.size.width * progress, height: 4)
                            }
                    }
                    .frame(height: 4)
                    .padding(.horizontal, 48)
                }
                .opacity(appearAnimation ? 1 : 0)
                .animation(.easeOut(duration: 0.3).delay(0.5), value: appearAnimation)

                // Skip button
                Button {
                    onDismiss()
                } label: {
                    Text("Tap to continue")
                        .font(Theme.Fonts.labelLarge)
                        .foregroundColor(.white.opacity(0.5))
                }
                .padding(.bottom, 40)
                .opacity(appearAnimation ? 1 : 0)
                .animation(.easeOut(duration: 0.3).delay(0.6), value: appearAnimation)
            }
        }
        .onAppear {
            appearAnimation = true
            withAnimation(.linear(duration: duration)) {
                progress = 1
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                onDismiss()
            }
        }
    }
}
