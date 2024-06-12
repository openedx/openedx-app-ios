//
//  UpgradeInfoCellView.swift
//  Core
//
//  Created by Vadim Kuznetsov on 11.06.24.
//

import SwiftUI
import Theme

struct UpgradeInfoCellView: View {
    var title: String
    
    var body: some View {
        HStack(spacing: 10) {
            UpgradeInfoPointView()
            Text(title)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(Theme.Fonts.bodyLarge)
        }
    }
}

struct UpgradeInfoPointView: View {
    var body: some View {
        CoreAssets.upgradeCheckmarkImage.swiftUIImage
            .resizable()
        .frame(width: 30, height: 30)
    }
}

public struct UpgradeOptionsView: View {
    public var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            UpgradeInfoCellView(title: CoreLocalization.CourseUpgrade.View.Option.first)
            UpgradeInfoCellView(title: CoreLocalization.CourseUpgrade.View.Option.second)
            UpgradeInfoCellView(title: CoreLocalization.CourseUpgrade.View.Option.third)
        }
    }
}

#if DEBUG
#Preview {
    UpgradeOptionsView()
}
#endif
