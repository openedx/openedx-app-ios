//
//  CustomNavigationView.swift
//  Core
//
//  Created by  Stepanok Ivan on 20.03.2023.
//

import SwiftUI

public struct NavigationBar: View {
    
    public enum ButtonType {
        case done
        case edit
    }
    
    private let title: String
    private let leftButton: Bool
    private let leftButtonColor: Color
    private let titleColor: Color
    private let leftButtonAction: (() -> Void)?
    private let rightButtonType: ButtonType?
    private let rightButtonAction: (() -> Void)?
    @Binding private var rightButtonIsActive: Bool
    
    public init(title: String,
                titleColor: Color = Theme.Colors.textPrimary,
                leftButtonColor: Color = Theme.Colors.accentColor,
                leftButtonAction: (() -> Void)? = nil,
                rightButtonType: ButtonType? = nil,
                rightButtonAction: (() -> Void)? = nil,
                rightButtonIsActive: Binding<Bool> = .constant(true)
    ) {
        self.title = title
        self.titleColor = titleColor
        self.leftButton = leftButtonAction != nil
        self.leftButtonColor = leftButtonColor
        self.leftButtonAction = leftButtonAction
        self.rightButtonType = rightButtonType
        self.rightButtonAction = rightButtonAction
        self._rightButtonIsActive = rightButtonIsActive
    }
    
    public var body: some View {
        ZStack {
            HStack {
                Text(title)
                    .titleSettings(color: titleColor)
            }
            .padding(.horizontal, 24)
            if leftButton {
            VStack {
                    Button(action: {
                        leftButtonAction?()
                    }, label: {
                        CoreAssets.Assets.arrowLeft.swiftUIImage
                            .backButtonStyle(color: leftButtonColor)
                    })
                    .foregroundColor(Theme.Colors.styledButtonText)
                    
                }.frame(minWidth: 0,
                        maxWidth: .infinity,
                        alignment: .topLeading)
            }
            if rightButtonType != nil {
                VStack {
                    Button(action: {
                        if rightButtonIsActive {
                            rightButtonAction?()
                        }
                    }, label: {
                        switch rightButtonType {
                        case .done:
                            HStack(spacing: -10) {
                                CoreAssets.Assets.done.swiftUIImage
                                    .backButtonStyle(topPadding: 0)
                                Text(CoreLocalization.done)
                                    .font(Theme.Fonts.labelLarge)
                                    .foregroundColor(Theme.Colors.accentColor)
                            }.offset(y: -6)
                        case .edit:
                            CoreAssets.Assets.edit.swiftUIImage
                                .resizable()
                                .frame(width: 24, height: 24)
                                .padding(.horizontal)
                                .padding(.top, -10)
                        case .none:
                            EmptyView()
                        }
                        
                    })
                    .opacity(rightButtonIsActive ? 1 : 0.3)
                    .padding(.trailing, 16)
                    .foregroundColor(Theme.Colors.styledButtonText)
                }.frame(minWidth: 0,
                        maxWidth: .infinity,
                        alignment: .topTrailing)
            }
        }
    }
}

struct CustomNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            NavigationBar(title: "Title",
                                 leftButtonAction: {},
                                 rightButtonType: .done,
                                 rightButtonAction: {},
                                 rightButtonIsActive: .constant(true))
            NavigationBar(title: "Title 2",
                                 rightButtonType: nil)
        }
    }
}
