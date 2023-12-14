//
//  ProfileSupportInfo.swift
//  Profile
//
//  Created by Eugene Yatsenko on 13.12.2023.
//

import SwiftUI
import Theme
import Core

struct ProfileSupportInfoView: View {

    struct LinkViewModel {
        let url: URL
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

    private func supportInfo(url: URL) -> some View {
        button(
            linkViewModel: .init(
                url: url,
                title: ProfileLocalization.contact
            ),
            isEmailSupport: true
        )

    }

    private func terms(url: URL) -> some View {
        navigationLink(
            viewModel: .init(
                url: url,
                title: ProfileLocalization.terms
            )
        )
    }

    private func privacy(url: URL) -> some View {
        navigationLink(
            viewModel: .init(
                url: url,
                title: ProfileLocalization.privacy
            )
        )
    }

    private func cookiePolicy(url: URL) -> some View {
        navigationLink(
            viewModel: .init(
                url: url,
                title: ProfileLocalization.cookiePolicy
            )
        )
    }

    private func dataSellContent(url: URL) -> some View {
        navigationLink(
            viewModel: .init(
                url: url,
                title: ProfileLocalization.doNotSellInformation
            )
        )
    }

    private func faq(url: URL) -> some View {
        button(
            linkViewModel: .init(
                url: url,
                title: ProfileLocalization.faq
            )
        )
    }

    @ViewBuilder
    private func navigationLink(viewModel: LinkViewModel) -> some View {
        NavigationLink {
            WebBrowser(
                url: viewModel.url.absoluteString,
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
    private func button(linkViewModel: LinkViewModel, isEmailSupport: Bool = false) -> some View {
        Button {
            guard UIApplication.shared.canOpenURL(linkViewModel.url) else {
                viewModel.errorMessage = isEmailSupport ?
                ProfileLocalization.Error.cannotSendEmail :
                CoreLocalization.Error.unknownError
                return
            }
            if isEmailSupport {
                viewModel.trackEmailSupportClicked()
            }
            UIApplication.shared.open(linkViewModel.url)
        } label: {
            HStack {
                Text(linkViewModel.title)
                Spacer()
                Image(systemName: "chevron.right")
            }
        }
        .foregroundColor(.primary)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(linkViewModel.title)
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
