//
//  ProgressStyledButton.swift
//  Authorization
//
//  Created by Eugene Yatsenko on 27.10.2023.
//

import SwiftUI
import Core

public struct ProgressStyledButton: View {

    public var isShowProgress: Bool
    public var onTap: () -> Void

    public var body: some View {
        if isShowProgress {
            HStack(alignment: .center) {
                ProgressBar(size: 40, lineWidth: 8)
                    .padding(20)
            }.frame(maxWidth: .infinity)
        } else {
            StyledButton(AuthLocalization.SignIn.logInBtn) {
                onTap()
            }.frame(maxWidth: .infinity)
                .padding(.top, 40)
        }
    }
}
