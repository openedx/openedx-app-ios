//
//  LearningSitesView.swift
//  Authorization
//
//  Created by Rawan Matar on 22/09/2026.
//

import SwiftUI
import Core
import Theme

public struct LearningSitesView: View {

    @Bindable private var viewModel: LearningSitesViewModel
    @Environment(\.isHorizontalLayout) private var isHorizontal

    public init(viewModel: LearningSitesViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .top) {
                VStack {
                    ThemeAssets.headerBackground.swiftUIImage
                        .resizable()
                        .edgesIgnoringSafeArea(.top)
                }
                .frame(maxWidth: .infinity, maxHeight: 200)
                .accessibilityIdentifier("auth_bg_image")

                VStack(alignment: .center) {
                    if viewModel.isSwitching {
                        // Fixed spacing, not a Spacer -- an unbounded Spacer here would expand
                        // to fill whatever room the ScrollView below doesn't claim.
                        VStack(alignment: .leading, spacing: 12) {
                            BackNavigationButton(
                                color: Theme.Colors.loginNavigationText,
                                action: { viewModel.router.back() }
                            )
                            .backViewStyle()
                            .padding(.leading, isHorizontal ? 48 : 16)
                            .accessibilityIdentifier("back_button")

                            // The site being switched FROM.
                            if let current = viewModel.currentInstance {
                                HStack(spacing: 12) {
                                    InstanceThemedImage(
                                        source: current.logoURLString,
                                        allowsBundledAsset: true,
                                        fallback: ThemeAssets.appLogo.swiftUIImage
                                    )
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 56, height: 56)

                                    Text(current.name)
                                        .font(Theme.Fonts.titleLarge)
                                        .foregroundColor(Theme.Colors.loginNavigationText)
                                        .accessibilityIdentifier("current_site_header_name")
                                }
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(.bottom, 24)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    } else {
                        ThemeAssets.appLogo.swiftUIImage
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: 189, maxHeight: 89)
                            .padding(.top, isHorizontal ? 20 : 40)
                            .padding(.bottom, isHorizontal ? 10 : 40)
                            .accessibilityIdentifier("logo_image")
                    }

                    ScrollView {
                        VStack(alignment: .leading, spacing: 24) {
                            if viewModel.isSwitching {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(AuthLocalization.LearningSites.title)
                                        .font(Theme.Fonts.displaySmall)
                                        .foregroundColor(Theme.Colors.textPrimary)
                                        .accessibilityIdentifier("learning_sites_title_text")

                                    Text(AuthLocalization.LearningSites.subtitle)
                                        .font(Theme.Fonts.titleSmall)
                                        .foregroundColor(Theme.Colors.textSecondary)
                                        .accessibilityIdentifier("learning_sites_subtitle_text")
                                }
                            } else {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(AuthLocalization.LearningSites.getStarted)
                                        .font(Theme.Fonts.displaySmall)
                                        .foregroundColor(Theme.Colors.textPrimary)
                                        .accessibilityIdentifier("get_started_text")

                                    Text(AuthLocalization.LearningSites.welcomeSubtitle)
                                        .font(Theme.Fonts.titleSmall)
                                        .foregroundColor(Theme.Colors.textPrimary)
                                        .accessibilityIdentifier("welcome_subtitle_text")
                                }
                            }

                            if let current = viewModel.currentInstance {
                                sitesSection(
                                    title: AuthLocalization.LearningSites.currentSite,
                                    sites: [current],
                                    showsLogOut: true
                                )
                            }

                            if !viewModel.otherLearningSites.isEmpty {
                                sitesSection(
                                    title: AuthLocalization.LearningSites.moreSites,
                                    sites: viewModel.otherLearningSites,
                                    showsLogOut: true
                                )
                            }

                            sitesSection(
                                title: AuthLocalization.LearningSites.addSite,
                                sites: viewModel.addableSites,
                                showsLogOut: false,
                                searchField: true
                            )
                        }
                        .frameLimit(width: proxy.size.width)
                        .padding(.horizontal, 24)
                        .padding(.top, 24)
                    }
                    .roundedBackground(Theme.Colors.background)
                }
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .minimumTopSafeArea()
    }

    @ViewBuilder
    private func sitesSection(
        title: String,
        sites: [Instance],
        showsLogOut: Bool,
        searchField: Bool = false
    ) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(Theme.Fonts.titleMedium)
                .foregroundColor(Theme.Colors.textPrimary)

            if searchField {
                searchBar
            }

            if sites.isEmpty && searchField {
                Text(AuthLocalization.LearningSites.emptySearch)
                    .font(Theme.Fonts.bodySmall)
                    .foregroundColor(Theme.Colors.textSecondary)
            } else {
                ForEach(sites) { instance in
                    siteRow(instance, showsLogOut: showsLogOut)
                    Divider()
                }
            }
        }
    }

    private var searchBar: some View {
        HStack(spacing: 11) {
            Image(systemName: "magnifyingglass")
                .padding(.leading, 16)
                .foregroundColor(Theme.Colors.textInputTextColor)
            TextField("", text: $viewModel.searchText)
                .autocapitalization(.none)
                .autocorrectionDisabled()
                .frame(minHeight: 50)
                .font(Theme.Fonts.bodyLarge)
                .foregroundColor(Theme.Colors.textInputTextColor)
                .accessibilityIdentifier("learning_sites_search_field")
        }
        .overlay(
            Theme.Shapes.textInputShape
                .stroke(lineWidth: 1)
                .fill(Theme.Colors.textInputStroke)
        )
        .background(
            Theme.InputFieldBackground(
                placeHolder: AuthLocalization.LearningSites.searchPlaceholder,
                text: viewModel.searchText,
                padding: 48
            )
        )
    }

    // A `Button` can't nest inside another `Button`'s label -- the outer one swallows every
    // tap. The row itself is tappable via `.onTapGesture`; the X stays a real, separate
    // `Button` so it keeps receiving its own taps.
    private func siteRow(_ instance: Instance, showsLogOut: Bool) -> some View {
        HStack(spacing: 12) {
            InstanceThemedImage(
                source: instance.logoURLString,
                allowsBundledAsset: true,
                fallback: ThemeAssets.appLogo.swiftUIImage
            )
            .aspectRatio(contentMode: .fit)
            .frame(width: 50, height: 50)

            VStack(alignment: .leading, spacing: 2) {
                Text(instance.baseURL.host ?? instance.baseURL.absoluteString)
                    .font(Theme.Fonts.labelMedium)
                    .foregroundColor(Theme.Colors.textSecondary)
                Text(instance.name)
                    .font(Theme.Fonts.titleSmall)
                    .foregroundColor(Theme.Colors.textPrimary)
            }

            Spacer()

            if showsLogOut {
                Button(action: { presentLogOutConfirm(for: instance) }, label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(Theme.Colors.textSecondary)
                })
                .accessibilityIdentifier("log_out_site_button")
            }
        }
        .frame(minHeight: 60)
        .contentShape(Rectangle())
        .onTapGesture {
            Task { await viewModel.select(instance) }
        }
        .accessibilityIdentifier("select_site_button")
    }

    private func presentLogOutConfirm(for instance: Instance) {
        viewModel.router.presentAlert(
            alertTitle: AuthLocalization.LearningSites.logOutTitle,
            alertMessage: AuthLocalization.LearningSites.logOutMessage(instance.name),
            positiveAction: AuthLocalization.LearningSites.logOutAction,
            onCloseTapped: {
                viewModel.router.dismiss(animated: true)
            },
            firstButtonTapped: {
                viewModel.router.dismiss(animated: true)
                Task { await viewModel.logOut(instance) }
            },
            type: .logOut
        )
    }
}
