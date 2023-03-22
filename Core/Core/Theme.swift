//
//  Theme.swift
//  Core
//
//  Created by Vladimir Chekyrta on 13.09.2022.
//

import Foundation
import SwiftUI

public struct Theme {
    
    public struct Fonts {
        
        public static let displayLarge: Font = .custom("SFPro-Regular", size: 57)
        public static let displayMedium: Font = .custom("SFPro-Regular", size: 45)
        public static let displaySmall: Font = .custom("SFPro-Bold", size: 36)
        
        public static let headlineLarge: Font = .custom("SFPro-Regular", size: 32)
        public static let headlineMedium: Font = .custom("SFPro-Regular", size: 28)
        public static let headlineSmall: Font = .custom("SFPro-Regular", size: 24)
        
        public static let titleLarge: Font = .custom("SFPro-Bold", size: 22)
        public static let titleMedium: Font = .custom("SFPro-Semibold", size: 18)
        public static let titleSmall: Font = .custom("SFPro-Medium", size: 14)
        
        public static let bodyLarge: Font = .custom("SFPro-Regular", size: 16)
        public static let bodyMedium: Font = .custom("SFPro-Regular", size: 14)
        public static let bodySmall: Font = .custom("SFPro-Regular", size: 12)
        
        public static let labelLarge: Font = .custom("SFPro-Medium", size: 14)
        public static let labelMedium: Font = .custom("SFPro-Regular", size: 12)
        public static let labelSmall: Font = .custom("SFPro-Regular", size: 10)
    }
    
    public struct Shapes {
        public static let screenBackgroundRadius = 24.0
        public static let cardImageRadius = 10.0
        public static let textInputShape = RoundedRectangle(cornerRadius: 8)
        public static let buttonShape = RoundedCorners(tl: 8, tr: 8, bl: 8, br: 8)
        public static let roundedScreenBackgroundShape = RoundedCorners(
            tl: Theme.Shapes.screenBackgroundRadius,
            tr: Theme.Shapes.screenBackgroundRadius,
            bl: Theme.Shapes.screenBackgroundRadius,
            br: Theme.Shapes.screenBackgroundRadius
        )
        public static let roundedScreenBackgroundShapeCroppedBottom = RoundedCorners(
            tl: Theme.Shapes.screenBackgroundRadius,
            tr: Theme.Shapes.screenBackgroundRadius
        )
        public static let cardShape = RoundedCorners(tl: 12, tr: 12, bl: 12, br: 12)
    }
    
    public struct Timeout {
        public static let snackbarMessageShortTimeout: TimeInterval = 3
        public static let snackbarMessageLongTimeout: TimeInterval = 5
    }
    
}

public extension Theme.Fonts {
    // swiftlint:disable type_name
    class __ {}
    static func registerFonts() {
        guard let url = Bundle(for: __.self).url(forResource: "SF-Pro", withExtension: "ttf") else { return }
        CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
    }
}

extension View {
    public func loadFonts() -> some View {
        Theme.Fonts.registerFonts()
        return self
    }
}
