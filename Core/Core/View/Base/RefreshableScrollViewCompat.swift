//
//  RefreshableScrollViewCompat.swift
//  Core
//
//  Created by  Stepanok Ivan on 15.02.2023.
//

import SwiftUI

public struct RefreshableScrollViewCompat<Content>: View where Content: View {
    private let content: () -> Content
    private let action: () async -> Void
    
    public init(action: @escaping () async -> Void, @ViewBuilder content: @escaping () -> Content) {
        self.action = action
        self.content = content
    }
    
    public var body: some View {
        if #available(iOS 15.0, *) {
            return RefreshableScrollView(onRefresh: { done in
                Task {
                    await action()
                    done()
                }
            }) {
                content()
            }
        } else {
            return RefreshableScrollViewIOS14(onRefresh: { done in
                Task {
                    await action()
                    done()
                }
            }) {
                content()
            }
        }
    }
}
