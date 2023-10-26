//
//  UpdateRecommendedView.swift
//  Discovery
//
//  Created by  Stepanok Ivan on 23.10.2023.
//

import SwiftUI
import Core
import StoreKit

public struct UpdateRecommendedView: View {
    
    @Environment (\.isHorizontal) private var isHorizontal
    private let router: DiscoveryRouter
    private let config: Config
    
    public init(router: DiscoveryRouter, config: Config) {
        self.router = router
        self.config = config
    }
    
    public var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .ignoresSafeArea()
                .onTapGesture {
                    router.dismiss(animated: true)
                    NotificationCenter.default.post(name: .showUpdateNotification, object: "update")
                }
            VStack(spacing: 10) {
                Image(systemName: "arrow.up.circle")
                    .resizable()
                    .frame(width: isHorizontal ? 50 : 110,
                           height: isHorizontal ? 50 : 110)
                    .foregroundColor(Theme.Colors.accentColor)
                    .padding(.bottom, isHorizontal ? 0 : 20)
                Text(DiscoveryLocalization.updateNeededTitle)
                    .font(Theme.Fonts.titleMedium)
                Text(DiscoveryLocalization.updateNeededDescription)
                    .font(Theme.Fonts.titleSmall)
                    .foregroundColor(Theme.Colors.avatarStroke)
                    .multilineTextAlignment(.center)
                
                HStack(spacing: 28) {
                    Button(action: {
                        router.dismiss(animated: true)
                        NotificationCenter.default.post(name: .showUpdateNotification, object: "update")
                    }, label: {
                        HStack {
                        Text(DiscoveryLocalization.updateNeededNotNow)
                            .font(Theme.Fonts.labelLarge)
                            .foregroundColor(Theme.Colors.accentColor)
                        }.padding(8)
                    })
                    
                    StyledButton(DiscoveryLocalization.updateButton, action: {
                        openAppStore()
                    }).fixedSize()
                }.padding(.top, isHorizontal ? 0 : 44)

            }.padding(isHorizontal ? 40 : 40)
                .background(Theme.Colors.background)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .frame(maxWidth: 400, maxHeight: 400)
                .padding(24)
                .shadow(color: Color.black.opacity(0.4), radius: 12, x: 0, y: 0)
        }.navigationTitle(DiscoveryLocalization.updateDeprecatedApp)
    }
    
    private func openAppStore() {
        guard let appStoreURL = URL(string: config.appStoreLink) else { return }
            UIApplication.shared.open(appStoreURL)
    }
}

#if DEBUG
struct UpdateRecommendedView_Previews: PreviewProvider {
    static var previews: some View {
        UpdateRecommendedView(
            router: DiscoveryRouterMock(),
            config: ConfigMock()
        )
    }
}
#endif
