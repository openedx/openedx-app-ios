//
//  RefreshProgressView.swift
//  Course
//
//  Created by  Stepanok Ivan on 15.04.2024.
//

import SwiftUI

public struct RefreshProgressView: View {
    
    @Binding private var isShowProgress: Bool
    
    public init(isShowProgress: Binding<Bool>) {
        self._isShowProgress = isShowProgress
    }
    
    public var body: some View {
        ProgressView()
            .padding(.top, isShowProgress ? 20 : -60)
    }
}
