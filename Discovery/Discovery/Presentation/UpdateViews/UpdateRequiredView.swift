//
//  UpdateRequiredView.swift
//  Discovery
//
//  Created by  Stepanok Ivan on 23.10.2023.
//

import SwiftUI
import Core

public struct UpdateRequiredView: View {
    
    @Environment (\.isHorizontal) private var isHorizontal
    private let router: DiscoveryRouter
    private let config: ConfigProtocol
    private let showAccountLink: Bool
    
    public init(router: DiscoveryRouter, config: ConfigProtocol, showAccountLink: Bool = true) {
        self.router = router
        self.config = config
        self.showAccountLink = showAccountLink
    }
    
    public var body: some View {
        ZStack {
            VStack(spacing: 10) {
                CoreAssets.Assets.warningFilled.swiftUIImage
                    .resizable()
                    .frame(width: isHorizontal ? 50 : 110,
                           height: isHorizontal ? 50 : 110)
                Text(DiscoveryLocalization.updateRequiredTitle)
                    .font(Theme.Fonts.titleMedium)
                Text(DiscoveryLocalization.updateRequiredDescription)
                    .font(Theme.Fonts.titleSmall)
                    .multilineTextAlignment(.center)

                HStack(spacing: 28) {
                    if showAccountLink {
                        Button(action: {
                            NotificationCenter.default.post(name: .onAppUpgradeAccountSettingsTapped, object: "block")
                            router.back(animated: false)
                        }, label: {
                            HStack {
                                Text(DiscoveryLocalization.updateAccountSettings)
                                    .font(Theme.Fonts.labelLarge)
                            }.padding(8)
                        })
                    }
                    StyledButton(DiscoveryLocalization.updateButton, action: {
                        openAppStore()
                    }).fixedSize()
                }.padding(.top, isHorizontal ? 10 : 44)
                
            }.padding(40)
                .frame(maxWidth: 400)
        }.navigationTitle(DiscoveryLocalization.updateDeprecatedApp)
            .navigationBarBackButtonHidden()
    }
    
    private func openAppStore() {
        guard let appStoreURL = URL(string: config.appStoreLink) else { return }
        UIApplication.shared.open(appStoreURL)
    }
}

#if DEBUG
struct UpdateRequiredView_Previews: PreviewProvider {
    static var previews: some View {
        UpdateRequiredView(
        router: DiscoveryRouterMock(),
        config: ConfigMock()
    )
    .loadFonts()
    }
}
#endif
