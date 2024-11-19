//
//  HTMLFormattedText.swift
//  Core
//
//  Created by  Stepanok Ivan on 11.10.2022.
//

import Foundation
import SwiftUI

public struct HTMLFormattedText: UIViewRepresentable {
    
    private let text: String
    private let isScrollEnabled: Bool
    @Binding private var textViewHeight: CGFloat?
    private let processing: ((Bool) -> Void)?
    
    public init(
        _ content: String,
        isScrollEnabled: Bool = false,
        textViewHeight: Binding<CGFloat?> = .constant(nil),
        processing: ((Bool) -> Void)? = nil
    ) {
        self.text = content
        self.isScrollEnabled = isScrollEnabled
        self._textViewHeight = textViewHeight
        self.processing = processing
    }
    
    public func makeUIView(context: UIViewRepresentableContext<Self>) -> UITextView {
        let textView = UITextView()
        textView.isSelectable = true
        textView.isUserInteractionEnabled = true
        textView.isEditable = false
        textView.isScrollEnabled = isScrollEnabled
        textView.backgroundColor = .clear
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        textView.delegate = context.coordinator
        textView.accessibilityIdentifier = "honer_code_textarea"
        return textView
    }
    
    public func updateUIView(_ uiView: UITextView, context: UIViewRepresentableContext<Self>) {
        uiView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        uiView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        uiView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        uiView.setContentCompressionResistancePriority(.required, for: .vertical)
        
        processing?(true)
        DispatchQueue.global(qos: .background).async {
            if let attributeText = self.convertHTML(text: text) {
                DispatchQueue.main.async {
                    uiView.attributedText = attributeText
                    textViewHeight = uiView.contentSize.height
                    processing?(false)
                }
            } else {
                DispatchQueue.main.async {
                    uiView.text = ""
                    processing?(false)
                }
            }
        }
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    private nonisolated(unsafe) func convertHTML(text: String) -> NSAttributedString? {
        guard let data = text.data(using: .utf8) else { return nil }
        
        if let attributedString = try? NSAttributedString(
            data: data,
            options: [
                .documentType: NSAttributedString.DocumentType.html,
                .characterEncoding: String.Encoding.utf8.rawValue
            ],
            documentAttributes: nil
        ) {
            return attributedString
        } else {
            return nil
        }
    }
    
    public class Coordinator: NSObject, UITextViewDelegate {
        let parent: HTMLFormattedText
        
        init(_ parent: HTMLFormattedText) {
            self.parent = parent
        }
    }
}

extension NSAttributedString {
    func trimmedAttributedString() -> NSAttributedString {
        let nonNewlines = CharacterSet.whitespacesAndNewlines.inverted
        let startRange = string.rangeOfCharacter(from: nonNewlines)
        let endRange = string.rangeOfCharacter(from: nonNewlines, options: .backwards)
        guard let startLocation = startRange?.lowerBound, let endLocation = endRange?.lowerBound else {
            return self
        }
        let range = NSRange(startLocation...endLocation, in: string)
        return attributedSubstring(from: range)
    }
}
