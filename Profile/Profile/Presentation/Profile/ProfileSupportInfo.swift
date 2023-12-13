//
//  ProfileSupportInfo.swift
//  Profile
//
//  Created by Eugene Yatsenko on 13.12.2023.
//

import SwiftUI
import Theme
import Core

struct ProfileSupportInfo: View {

    struct LinkViewModel {
        let URL: URL
        let title: String
    }

    @ObservedObject var viewModel: ProfileViewModel

    var body: some View {
        Text(ProfileLocalization.supportInfo)
            .padding(.horizontal, 24)
            .font(Theme.Fonts.labelLarge)
        VStack(alignment: .leading, spacing: 24) {
            viewModel.contactSupport().map(supportInfo)
            viewModel.config.agreement.tosURL.map(terms)
            viewModel.config.agreement.privacyPolicyURL.map(privacy)
            viewModel.config.agreement.cookiePolicyURL.map(cookiePolicy)
            viewModel.config.agreement.dataSellContentURL.map(dataSellContent)
            viewModel.config.faq.map(faq)
            version
        }
        .cardStyle(
            bgColor: Theme.Colors.textInputUnfocusedBackground,
            strokeColor: .clear
        )
    }

    @ViewBuilder
    private func supportInfo(support: URL) -> some View {
        Button {
            viewModel.trackEmailSupportClicked()
            UIApplication.shared.open(support)
        } label: {
            HStack {
                Text(ProfileLocalization.contact)
                Spacer()
                Image(systemName: "chevron.right")
            }
        }
        .foregroundColor(.primary)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(ProfileLocalization.supportInfo)
        Rectangle()
            .frame(height: 1)
            .foregroundColor(Theme.Colors.textSecondary)
    }

    private func terms(url: URL) -> some View {
        navigationLink(
            viewModel: .init(
                URL: url,
                title: ProfileLocalization.terms
            )
        )
    }

    private func privacy(url: URL) -> some View {
        navigationLink(
            viewModel: .init(
                URL: url,
                title: ProfileLocalization.privacy
            )
        )
    }

    private func cookiePolicy(url: URL) -> some View {
        navigationLink(
            viewModel: .init(
                URL: url,
                title: ProfileLocalization.cookiePolicy
            )
        )
    }

    private func dataSellContent(url: URL) -> some View {
        navigationLink(
            viewModel: .init(
                URL: url,
                title: ProfileLocalization.doNotSellInformation
            )
        )
    }

    private func faq(url: URL) -> some View {
        navigationLink(
            viewModel: .init(
                URL: url,
                title: ProfileLocalization.faq
            )
        )
    }

    @ViewBuilder
    private func navigationLink(viewModel: LinkViewModel) -> some View {
        NavigationLink {
            WebBrowser(
                url: viewModel.URL.absoluteString,
                pageTitle: viewModel.title
            )
        } label: {
            HStack {
                Text(viewModel.title)
                    .multilineTextAlignment(.leading)
                Spacer()
                Image(systemName: "chevron.right")
            }
        }
        .foregroundColor(.primary)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(viewModel.title)
        Rectangle()
            .frame(height: 1)
            .foregroundColor(Theme.Colors.textSecondary)
    }

    @ViewBuilder
    private var version: some View {
        Button(action: {
            viewModel.openAppStore()
        }, label: {
            HStack {
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        if viewModel.versionState == .updateRequired {
                            CoreAssets.warningFilled.swiftUIImage
                                .resizable()
                                .frame(width: 24, height: 24)
                        }
                        Text("\(ProfileLocalization.Settings.version) \(viewModel.currentVersion)")
                    }
                    switch viewModel.versionState {
                    case .actual:
                        HStack {
                            CoreAssets.checkmark.swiftUIImage
                                .renderingMode(.template)
                                .foregroundColor(.green)
                            Text(ProfileLocalization.Settings.upToDate)
                                .font(Theme.Fonts.labelMedium)
                                .foregroundStyle(Theme.Colors.textSecondary)
                        }
                    case .updateNeeded:
                        Text("\(ProfileLocalization.Settings.tapToUpdate) \(viewModel.latestVersion)")
                            .font(Theme.Fonts.labelMedium)
                            .foregroundStyle(Theme.Colors.accentColor)
                    case .updateRequired:
                        Text(ProfileLocalization.Settings.tapToInstall)
                            .font(Theme.Fonts.labelMedium)
                            .foregroundStyle(Theme.Colors.accentColor)
                    }
                }
                Spacer()
                if viewModel.versionState != .actual {
                    Image(systemName: "arrow.up.circle")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(Theme.Colors.accentColor)
                }

            }
        }).disabled(viewModel.versionState == .actual)
    }

}
