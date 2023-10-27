//
//  AuthBackgroundView.swift
//  Authorization
//
//  Created by Eugene Yatsenko on 27.10.2023.
//

import SwiftUI
import Core

public struct AuthBackgroundView: View {

    let image: Image

    public var body: some View {
        VStack {
            image
                .resizable()
                .edgesIgnoringSafeArea(.top)
        }.frame(maxWidth: .infinity, maxHeight: 200)
    }

}
