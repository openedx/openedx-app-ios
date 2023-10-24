//
//  UpdateNotificationView.swift
//  Discovery
//
//  Created by  Stepanok Ivan on 23.10.2023.
//

import SwiftUI
import Core

struct UpdateNotificationView: View {
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                HStack(spacing: 10) {
                    Image(systemName: "arrow.up.circle")
                        .resizable()
                        .frame(width: 36,
                               height: 36)
                        .foregroundColor(.white)
                    VStack(alignment: .leading) {
                        Text(DiscoveryLocalization.updateNeededTitle)
                            .font(Theme.Fonts.titleMedium)
                        Text(DiscoveryLocalization.updateNewAvaliable)
                            .font(Theme.Fonts.bodySmall)
                    }.foregroundColor(.white)
                }
                .padding(16)
                    .background(Theme.Colors.accentColor)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(color: Color.black.opacity(0.4), radius: 12, x: 0, y: 0)
                    .padding(24)
                
            }
        }
    }
}

#Preview {
    UpdateNotificationView()
}
