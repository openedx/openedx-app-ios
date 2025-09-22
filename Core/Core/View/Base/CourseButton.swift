//
//  CourseButton.swift
//  Core
//
//  Created by  Stepanok Ivan on 05.10.2022.
//

import Foundation
import SwiftUI
import Theme

public struct CourseButton: View {
    
    private let isCompleted: Bool
    private let image: Image
    private let displayName: String
    private let index: Double
    @State private var animate: Bool = false
    
    public init(isCompleted: Bool, image: Image, displayName: String, index: Double) {
        self.isCompleted = isCompleted
        self.image = image
        self.displayName = displayName
        self.index = index+1
    }
    
    public var body: some View {
        HStack {
            if isCompleted {
                CoreAssets.finished.swiftUIImage
                    .renderingMode(.template)
                    .foregroundColor(Theme.Colors.accentXColor)
            } else {
                image
                    .foregroundColor(Theme.Colors.textPrimary)
            }
            Text(displayName)
                .font(Theme.Fonts.titleMedium)
                .multilineTextAlignment(.leading)
                .foregroundColor(Theme.Colors.textPrimary)
            Spacer()
            Image(systemName: "chevron.right")
                .flipsForRightToLeftLayoutDirection(true)
                .padding(.vertical, 8)
                .foregroundColor(Theme.Colors.accentXColor)
        }
        .padding(.horizontal, 36)
        .padding(.vertical, 14)
        .opacity(animate ? 1 : 0)
        .offset(x: animate ? 0 : 20)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                withAnimation(.easeInOut(duration: (index <= 5 ? 0.3 : 0.1))
                    .delay((index <= 5 ? index : 0) * 0.05)) {
                        animate = true
                    }
            }
        }
    }
}

struct CourseButton_Previews: PreviewProvider {
    static var previews: some View {
        CourseButton(
            isCompleted: true,
            image: CoreAssets.pen.swiftUIImage,
            displayName: "Lets see whats happen",
            index: 0
        )
    }
}
