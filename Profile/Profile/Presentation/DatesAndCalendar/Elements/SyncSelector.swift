//
//  SyncSelector.swift
//  Profile
//
//  Created by  Stepanok Ivan on 15.05.2024.
//

import SwiftUI
import Core
import Theme

struct SyncSelector: View {
    @Binding var sync: Bool
    
    var body: some View {
        HStack(spacing: 2) {
            Button(action: {
                    sync = true
            }) {
                Text(ProfileLocalization.SyncSelector.synced)
                    .font(Theme.Fonts.bodyMedium)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(sync ? Theme.Colors.accentColor : Theme.Colors.background)
                    .foregroundColor(sync ? Theme.Colors.white : Theme.Colors.accentColor)
                    .clipShape(RoundedCorners(tl: 8, bl: 8))
            }
            .overlay(
                RoundedCorners(tl: 8, bl: 8)
                    .stroke(Theme.Colors.accentColor, lineWidth: 1)
                    .padding(.vertical, 0.5)
            )
            Button(action: {
                    sync = false
            }) {
                Text(ProfileLocalization.SyncSelector.notSynced)
                    .font(Theme.Fonts.bodyMedium)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(sync ? Theme.Colors.background : Theme.Colors.accentColor)
                    .foregroundColor(sync ? Theme.Colors.accentColor : Theme.Colors.white)
                    .clipShape(RoundedCorners(tr: 8, br: 8))
            }
            .overlay(
                RoundedCorners(tr: 8, br: 8)
                    .stroke(Theme.Colors.accentColor, lineWidth: 1)
                    .padding(.vertical, 0.5)
            )
        }
        
        .frame(height: 42)
    }
}

#if DEBUG
#Preview {
    SyncSelector(sync: .constant(true))
        .padding(8)
}
#endif
