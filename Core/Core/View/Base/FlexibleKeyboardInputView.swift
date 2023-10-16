//
//  FlexibleKeyboardInputView.swift
//  Core
//
//  Created by  Stepanok Ivan on 28.01.2023.
//

import SwiftUI

public struct FlexibleKeyboardInputView: View {
    
    @State private var commentText: String = ""
    @State private var commentSize: CGFloat = .init(64)
    @Environment (\.isHorizontal) private var isHorizontal
    public var sendText: ((String) -> Void)
    private let hint: String
    
    public init(
        hint: String,
        sendText: @escaping ((String) -> Void)
    ) {
        self.hint = hint
        self.sendText = sendText
    }
    
    public var body: some View {
        VStack {
            VStack {
                Spacer()
                VStack(alignment: .leading) {
                    
                    ScrollView {
                        HStack(alignment: .top, spacing: 6) {
                            Text("\(commentText) ").foregroundColor(.clear).padding(8)
                                .lineLimit(3)
                                .frame(maxWidth: .infinity)
                                .background(
                                    GeometryReader { reader in
                                        Color.clear.preference(
                                            key: ViewSizePreferenceKey.self,
                                            value: reader.size
                                        )
                                    }
                                )
                                .onPreferenceChange(ViewSizePreferenceKey.self) { size in
                                    commentSize = size.height
                                }
                                .overlay(
                                    TextEditor(text: $commentText)
                                        .padding(.horizontal, 8)
                                        .foregroundColor(Theme.Colors.textPrimary)
                                        .hideScrollContentBackground()
                                        .frame(maxHeight: commentSize)
                                        .background(
                                            ZStack(alignment: .leading) {
                                                Theme.Shapes.textInputShape
                                                    .fill(Theme.Colors.textInputBackground)
                                                Text(commentText.count == 0 ? hint : "")
                                                    .foregroundColor(Theme.Colors.textSecondary)
                                                    .font(Theme.Fonts.labelLarge)
                                                    .padding(.leading, 14)
                                            }
                                        )
                                        .overlay(
                                            Theme.Shapes.textInputShape
                                                .stroke(lineWidth: 1)
                                                .fill(
                                                    Theme.Colors.textInputStroke
                                                )
                                        )
                                ).padding(8)
                            Button(action: {
                                if commentText.trimmingCharacters(in: .whitespacesAndNewlines).count > 0 {
                                    sendText(commentText)
                                    self.commentText = ""
                                }
                            }, label: {
                                VStack {
                                    commentText.trimmingCharacters(in: .whitespacesAndNewlines).count > 0
                                    ? CoreAssets.send.swiftUIImage
                                    : CoreAssets.sendDisabled.swiftUIImage
                                }
                                .frame(width: 36, height: 36)
                                .foregroundColor(.white)
                            }).padding(.top, 8)
                                
                        }.padding(.horizontal, isHorizontal ? 50 : 16)
                        
                    }
                    .padding(.leading, 6)
                    .padding(.trailing, 14)
                }.frame(maxWidth: .infinity, maxHeight: commentSize + 16)
                    .background(
                        Theme.Colors.commentCellBackground
                    )
                    .overlay(
                        GeometryReader { proxy in
                            Rectangle()
                                .size(width: proxy.size.width, height: 1)
                                .foregroundColor(Theme.Colors.cardViewStroke)
                        }
                    )
            }
        }
    }
}

struct FlexibleKeyboardInputView_Previews: PreviewProvider {
    static var previews: some View {
        FlexibleKeyboardInputView(hint: "Some hint", sendText: {_ in})
    }
}

private struct ViewSizePreferenceKey: PreferenceKey {
    public static var defaultValue: CGSize = .zero
    public static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = value.width + value.height > nextValue().width + nextValue().height ? value : nextValue()
    }
}
