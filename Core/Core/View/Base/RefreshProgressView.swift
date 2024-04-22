//
//  RefreshProgressView.swift
//  Course
//
//  Created by  Stepanok Ivan on 15.04.2024.
//

import SwiftUI

public struct RefreshProgressView: View {
    
    @Binding private var isShowRefresh: Bool
    
    public init(isShowRefresh: Binding<Bool>) {
            self._isShowRefresh = isShowRefresh
    }
    
    public var body: some View {
        ProgressView()
            .padding(.top, isShowRefresh ? 20 : -60)
            .padding(.bottom, isShowRefresh ? 20 : 0)
    }
}
