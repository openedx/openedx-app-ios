//
//  SectionProgressView.swift
//  Course
//
//  Created by  Stepanok Ivan on 24.06.2025.
//

import SwiftUI
import Theme

struct SectionProgressView: View {
    let progress: Double
    let height: CGFloat
    let cornerRadius: CGFloat
    
    init(progress: Double, height: CGFloat = 6, cornerRadius: CGFloat = 6) {
        self.progress = max(0.0, min(1.0, progress))
        self.height = height
        self.cornerRadius = cornerRadius
    }
    
    var body: some View {
        ZStack(alignment: .leading) {
            GeometryReader { geometry in
                CustomProgressShape(cornerRadius: cornerRadius, progress: 1.0)
                    .fill(Theme.Colors.courseProgressBG)
                    .frame(width: geometry.size.width, height: height)
                
                if progress > 0 {
                    CustomProgressShape(cornerRadius: cornerRadius, progress: progress)
                        .fill(Theme.Colors.success)
                        .frame(width: geometry.size.width * CGFloat(progress), height: height)
                }
            }
            .frame(height: height)
        }
    }
}

#if DEBUG
#Preview {
    VStack(spacing: 20) {
        // 0% progress
        SectionProgressView(progress: 0.0)
        
        // 25% progress
        SectionProgressView(progress: 0.25)
        
        // 50% progress  
        SectionProgressView(progress: 0.5)
        
        // 75% progress
        SectionProgressView(progress: 0.75)
        
        // 100% progress
        SectionProgressView(progress: 1.0)
    }
    .padding()
}
#endif
