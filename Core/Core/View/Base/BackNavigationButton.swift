//
//  BackNavigationButton.swift
//  Core
//
//  Created by Vadim Kuznetsov on 3.04.24.
//

import SwiftUI
import Theme

public struct BackNavigationButton: View {
    @StateObject var viewModel = BackNavigationButtonViewModel()
    private let color: Color
    private let action: (() -> Void)?
    
    public init(
        color: Color = Theme.Colors.accentXColor,
        action: (() -> Void)? = nil
    ) {
        self.color = color
        self.action = action
    }
    
    public var body: some View {
        Menu {
            ForEach(viewModel.items) { item in
                Button(item.title) {
                    viewModel.navigateTo(item: item)
                }
            }
        } label: {
            CoreAssets.arrowLeft.swiftUIImage
                .backButtonStyle(color: color)
        } primaryAction: {
            action?()
        }
        .foregroundColor(Theme.Colors.styledButtonText)
        .accessibilityIdentifier("back_button")
        .onAppear {
            viewModel.loadItems()
        }
        
    }
}
#if DEBUG
struct BackNavigationButton_Previews: PreviewProvider {
    static var previews: some View {
        BackNavigationButton()
    }
}
#endif
