//
//  LMSDirectoryView.swift
//  Authorization
//
//  The list of platforms the directory holds. A document is a fixed list, so
//  this is a list and nothing else — no search box, and nothing to type.
//

import Core
import Kingfisher
import SwiftUI
import Theme

struct LMSDirectoryView: View {
    @ObservedObject private var viewModel: LMSDirectoryViewModel

    init(viewModel: LMSDirectoryViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if let provider = viewModel.providerName, !provider.isEmpty {
                Text(AuthLocalization.LmsDirectory.providerSubtitle(provider))
                    .font(Theme.Fonts.labelLarge)
                    .foregroundColor(Theme.Colors.textSecondary)
                    .accessibilityIdentifier("lms_provider_name")
            }

            switch viewModel.state {
            case .loading:
                loadingView
            case .ready:
                ForEach(viewModel.platforms) { platform in
                    row(platform)
                }
            case .empty:
                message(AuthLocalization.LmsDirectory.empty)
            case let .failed(text):
                message(text)
                Button(AuthLocalization.LmsDirectory.retry) {
                    viewModel.retry()
                }
                .font(Theme.Fonts.labelLarge)
                .foregroundColor(Theme.Colors.accentColor)
                .accessibilityIdentifier("lms_retry_button")
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func row(_ item: LMSSummary) -> some View {
        Button(action: { viewModel.select(item) }) {
            LMSRowContent(
                title: item.title,
                subtitle: item.shortDescription,
                url: item.baseURL,
                logoURL: item.logoURL,
                accentColorHex: item.accentColorHex
            )
        }
        .buttonStyle(PlainButtonStyle())
        .accessibilityIdentifier("lms_platform_\(item.id)")
    }

    private var loadingView: some View {
        HStack(spacing: 12) {
            ProgressView()
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .accessibilityIdentifier("lms_loading")
    }

    private func message(_ text: String) -> some View {
        Text(text)
            .font(Theme.Fonts.bodyLarge)
            .foregroundColor(Theme.Colors.textSecondary)
            .accessibilityIdentifier("lms_message")
    }
}

private struct LMSRowContent: View {
    let title: String
    let subtitle: String
    let url: URL
    let logoURL: URL?
    let accentColorHex: String?

    private var badgeColor: Color {
        if let hex = accentColorHex, let lmsColor = LMSColor(hex: hex) {
            return Color(red: lmsColor.red, green: lmsColor.green, blue: lmsColor.blue)
        }
        return Theme.Colors.accentColor
    }

    private var lmsInitialsView: some View {
        let initials = title
            .split(separator: " ")
            .prefix(2)
            .compactMap { $0.first.map(String.init) }
            .joined()
            .uppercased()
        return RoundedRectangle(cornerRadius: 8)
            .fill(badgeColor)
            .frame(width: 44, height: 44)
            .overlay(
                Text(initials.isEmpty ? String(title.prefix(1)).uppercased() : initials)
                    .font(Theme.Fonts.titleSmall)
                    .foregroundColor(.white)
            )
    }

    var body: some View {
        HStack(spacing: 12) {
            switch LMSImageSource(url: logoURL) {
            case let .remote(url):
                KFImage.url(url)
                    .placeholder {
                        lmsInitialsView
                    }
                    .onFailure { _ in }
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 44, height: 44)
                    .cornerRadius(8)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Theme.Colors.background)
                    )
            case .bundled:
                // Shipped inside the app: there is nothing to load, so it draws in
                // the first frame and works with no network at all.
                if let image = LMSImageSource(url: logoURL)?.bundledImage() {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 44, height: 44)
                        .cornerRadius(8)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Theme.Colors.background)
                        )
                } else {
                    lmsInitialsView
                }
            case .none:
                lmsInitialsView
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(Theme.Fonts.bodyLarge)
                    .foregroundColor(Theme.Colors.textPrimary)
                Text(subtitle)
                    .font(Theme.Fonts.bodyMedium)
                    .foregroundColor(Theme.Colors.textSecondary)
                Text(url.host ?? url.absoluteString)
                    .font(Theme.Fonts.labelMedium)
                    .foregroundColor(Theme.Colors.textSecondary)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(Theme.Colors.textSecondary)
        }
        .padding(16)
        .background(
            Theme.Shapes.textInputShape
                .fill(Theme.Colors.background)
        )
        .overlay(
            Theme.Shapes.textInputShape
                .stroke(lineWidth: 1)
                .fill(Theme.Colors.textInputStroke.opacity(0.4))
        )
    }
}
