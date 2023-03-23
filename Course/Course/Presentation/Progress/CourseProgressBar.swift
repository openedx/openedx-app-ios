//
//  CourseProgressBar.swift
//  Course
//
//  Created by Vladimir Chekyrta on 22.03.2023.
//

import SwiftUI
import Core

struct CourseProgressBar: View {
    
    let progress: Int
    
    var body: some View {
        GeometryReader { proxy in
            let progressPx = proxy.size.width / 100.0 * Double(progress)
            
            Capsule(style: .continuous)
                .foregroundColor(Color.gray.opacity(0.6))
            
            Capsule(style: .continuous)
                .foregroundColor(CoreAssets.accentColor.swiftUIColor)
                .frame(width: progressPx)
        }
    }
}

struct CourseProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        CourseProgressBar(progress: 50)
            .frame(height: 30)
            .padding(20)
    }
}
