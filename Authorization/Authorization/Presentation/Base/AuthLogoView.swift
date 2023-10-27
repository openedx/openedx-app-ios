//
//  AuthLogoView.swift
//  Authorization
//
//  Created by Eugene Yatsenko on 27.10.2023.
//

import SwiftUI
import Core

public struct AuthLogoView: View {

    @Environment (\.isHorizontal) private var isHorizontal

    let image: Image

    public var body: some View {
        image
            .resizable()
            .frame(maxWidth: 189, maxHeight: 54)
            .padding(.top, isHorizontal ? 20 : 40)
            .padding(.bottom, isHorizontal ? 10 : 40)
    }

}
