//
//  RestoreInProgressView.swift
//  Core
//
//  Created by Saeed Bashir on 6/4/24.
//

import Foundation
import SwiftUI
import Theme

public struct RestoreInProgressView: View {
    
    public init() {
    }
    
    public var body: some View {
        ZStack(alignment: .center) {
            VStack(spacing: 20) {
                Text(CoreLocalization.CourseUpgrade.Restore.inprogressText)
                    .foregroundColor(Theme.Colors.white)
                    .font(Theme.Fonts.bodyLarge)
                    .accessibilityIdentifier("restore_inprogress_text")
                
                ProgressBar(size: 40, lineWidth: 8)
                    .padding(20)
                    .accessibilityIdentifier("progressbar")
            }
        }
        .ignoresSafeArea()
    }
}
