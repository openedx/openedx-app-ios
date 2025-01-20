//
//  ProfileSupportInfo.swift
//  Profile
//
//  Created by Eugene Yatsenko on 13.12.2023.
//

import SwiftUI
import Theme
import Core

private enum SupportType {
    case contactSupport, tos, privacyPolicy, cookiesPolicy, sellData, faq
}

struct ProfileSupportInfoView: View {

    struct LinkViewModel {
        let url: URL
        let title: String
    }

    @ObservedObject var viewModel: SettingsViewModel

    var body: some View {
        Text(ProfileLocalization.supportInfo)
            .padding(.horizontal, 24)
            .font(Theme.Fonts.labelLarge)
            .foregroundColor(Theme.Colors.textSecondary)
            .accessibilityIdentifier("support_info_text")
            .padding(.top, 12)
        
        VStack(alignment: .leading, spacing: 24) {
            viewModel.contactSupport().map(supportInfo)
            viewModel.config.agreement.tosURL.map(terms)
            viewModel.config.agreement.privacyPolicyURL.map(privacy)
            viewModel.config.agreement.cookiePolicyURL.map(cookiePolicy)
            viewModel.config.agreement.dataSellContentURL.map(dataSellContent)
            viewModel.config.faq.map(faq)
            version
                .accessibilityIdentifier("version_info")
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
            isEmailSupport: true,
            supportType: .contactSupport,
            identifier: "contact_support"
        )
    }

    private func terms(url: URL) -> some View {
        navigationLink(
            viewModel: .init(
                url: url,
                title: ProfileLocalization.terms
            ),
            type: .tos
        )
        .accessibilityIdentifier("tos")
    }

    private func privacy(url: URL) -> some View {
        navigationLink(
            viewModel: .init(
                url: url,
                title: ProfileLocalization.privacy
            ),
            type: .privacyPolicy
        )
        .accessibilityIdentifier("privacy_policy")
    }

    private func cookiePolicy(url: URL) -> some View {
        navigationLink(
            viewModel: .init(
                url: url,
                title: ProfileLocalization.cookiePolicy
            ),
            type: .cookiesPolicy
        )
        .accessibilityIdentifier("cookies_policy")
    }

    private func dataSellContent(url: URL) -> some View {
        navigationLink(
            viewModel: .init(
                url: url,
                title: ProfileLocalization.doNotSellInformation
            ),
            type: .sellData
        )
        .accessibilityIdentifier("dont_sell_data")
    }

    private func faq(url: URL) -> some View {
        button(
            linkViewModel: .init(
                url: url,
                title: ProfileLocalization.faqTitle
            ),
            supportType: .faq,
            identifier: "view_faq"
        )
    }

    @ViewBuilder
    private func navigationLink(viewModel: LinkViewModel, type: SupportType) -> some View {
        NavigationLink {
            WebBrowser(
                url: viewModel.url.absoluteString,
                pageTitle: viewModel.title,
                showProgress: true,
                connectivity: self.viewModel.connectivity
            )
            
        } label: {
            HStack {
                Text(viewModel.title)
                    .multilineTextAlignment(.leading)
                    .font(Theme.Fonts.titleMedium)
                    .foregroundColor(Theme.Colors.textPrimary)
                Spacer()
                Image(systemName: "chevron.right")
                    .flipsForRightToLeftLayoutDirection(true)
            }
        }
        .simultaneousGesture(TapGesture().onEnded {
            switch type {
            case .cookiesPolicy:
                self.viewModel.trackCookiePolicyClicked()
            case .tos:
                self.viewModel.trackTOSClicked()
            case .privacyPolicy:
                self.viewModel.trackPrivacyPolicyClicked()
            case .sellData:
                self.viewModel.trackDataSellClicked()
                
            default:
                break
            }
        })
        .foregroundColor(.primary)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(viewModel.title)
        Rectangle()
            .frame(height: 1)
            .foregroundColor(Theme.Colors.textSecondary)
    }

    @ViewBuilder
    private func button(
        linkViewModel: LinkViewModel,
        isEmailSupport: Bool = false,
        supportType: SupportType,
        identifier: String
    ) -> some View {
        Button {
            guard UIApplication.shared.canOpenURL(linkViewModel.url) else {
                viewModel.errorMessage = isEmailSupport ?
                ProfileLocalization.Error.cannotSendEmail :
                CoreLocalization.Error.unknownError
                return
            }
            
            switch supportType {
            case .contactSupport:
                viewModel.trackEmailSupportClicked()
            case .faq:
                viewModel.trackFAQClicked()
            default:
                break
            }
            
            UIApplication.shared.open(linkViewModel.url)
        } label: {
            HStack {
                Text(linkViewModel.title)
                    .foregroundColor(Theme.Colors.textPrimary)
                    .font(Theme.Fonts.titleMedium)
                Spacer()
                Image(systemName: "chevron.right")
                    .flipsForRightToLeftLayoutDirection(true)
            }
        }
        .foregroundColor(.primary)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(linkViewModel.title)
        .accessibilityIdentifier(identifier)
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
                            .font(Theme.Fonts.titleMedium)
                    }
                    switch viewModel.versionState {
                    case .actual:
                        HStack {
                            CoreAssets.checkmark.swiftUIImage
                                .renderingMode(.template)
                                .foregroundColor(Theme.Colors.success)
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
        })
        .disabled(viewModel.versionState == .actual)
        .accessibilityIdentifier("version_button")
    }

}
