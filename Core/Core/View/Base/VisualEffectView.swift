//
//  VisualEffectView.swift
//  Core
//
//  Created by  Stepanok Ivan on 29.03.2024.
//

import SwiftUI

public struct VisualEffectView: UIViewRepresentable {
    private var effect: UIVisualEffect?
    
    public init(effect: UIVisualEffect? = nil) {
        self.effect = effect
    }
    
    public func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView { UIVisualEffectView() }
    public func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) {
        uiView.effect = effect
    }
}
