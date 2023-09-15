//
//  RefreshableScrollViewCompat.swift
//  Core
//
//  Created by  Stepanok Ivan on 15.09.2023.
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
        if #available(iOS 16.0, *) {
            return ScrollView {
                content()
            } .refreshable {
                Task {
                    await action()
                }
            }
        } else {
            return RefreshableScrollView(onRefresh: { done in
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
