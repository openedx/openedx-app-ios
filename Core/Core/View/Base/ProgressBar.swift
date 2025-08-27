//
//  ProgressBar.swift
//  Core
//
//  Created by Vladimir Chekyrta on 14.09.2022.
//

import SwiftUI
import Theme

public struct ProgressBar: View {
    
    @State private var isAnimating = false
    @EnvironmentObject var themeManager: ThemeManager
    
    private let size: CGFloat
    private let lineWidth: CGFloat
    
    private var animation: Animation {
        Animation.linear(duration: 0.5)
            .speed(0.5)
            .repeatForever(autoreverses: false)
    }
    
    private var gradient: AngularGradient {
            AngularGradient(
                gradient: Gradient(colors: [
                    themeManager.theme.colors.accentColor.opacity(0.7),
                    themeManager.theme.colors.accentColor.opacity(0.35),
                    themeManager.theme.colors.accentColor.opacity(0.01)
                ]),
                center: .center,
                startAngle: .degrees(270),
                endAngle: .degrees(0)
            )
        }
    
    public init(size: CGFloat = 50, lineWidth: CGFloat = 10) {
        self.size = size
        self.lineWidth = lineWidth
    }
    
    public var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: lineWidth)
                .foregroundColor(themeManager.theme.colors.accentColor.opacity(0.3))
            
            Circle()
                .trim(from: 0.0, to: 0.7)
                .stroke(gradient, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
        }
        .frame(width: size, height: size)
        .rotationEffect(Angle.degrees(isAnimating ? 360 : 0), anchor: .center)
        .animation(animation, value: isAnimating)
        .onAppear {
            DispatchQueue.main.async {
                isAnimating = true
            }
        }
    }
}

struct ProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        ProgressBar(size: 50)
    }
}
