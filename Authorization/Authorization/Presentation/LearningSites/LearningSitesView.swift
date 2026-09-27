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
    @Environment(\.isHorizontal) private var isHorizontal

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
                        ZStack {
                            HStack {
                                Text(AuthLocalization.LearningSites.title)
                                    .titleSettings(color: Theme.Colors.loginNavigationText)
                                    .accessibilityIdentifier("learning_sites_title_text")
                            }
                            VStack {
                                BackNavigationButton(
                                    color: Theme.Colors.loginNavigationText,
                                    action: { viewModel.router.back() }
                                )
                                .backViewStyle()
                                .padding(.leading, isHorizontal ? 48 : 0)
                                .accessibilityIdentifier("back_button")
                            }.frame(minWidth: 0, maxWidth: .infinity, alignment: .topLeading)
                        }
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
                            if !viewModel.isSwitching {
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

                            if !viewModel.currentLearningSites.isEmpty {
                                sitesSection(
                                    title: AuthLocalization.LearningSites.currentSite,
                                    sites: viewModel.currentLearningSites,
                                    showsLogOut: true
                                )
                            }

                            sitesSection(
                                title: AuthLocalization.LearningSites.searchTitle,
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
                Text(instance.name)
                    .font(Theme.Fonts.titleSmall)
                    .foregroundColor(Theme.Colors.textPrimary)
                Text(instance.baseURL.host ?? instance.baseURL.absoluteString)
                    .font(Theme.Fonts.labelMedium)
                    .foregroundColor(Theme.Colors.textSecondary)
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
        .frame(height: 60)
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
