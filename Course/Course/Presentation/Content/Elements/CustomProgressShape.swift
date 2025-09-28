//
//  CustomProgressShape.swift
//  Course
//
//  Created by  Stepanok Ivan on 24.06.2025.
//

import SwiftUI

struct CustomProgressShape: Shape {
    let cornerRadius: CGFloat
    let progress: Double
    
    init(cornerRadius: CGFloat = 6, progress: Double = 1.0) {
        self.cornerRadius = cornerRadius
        self.progress = progress
    }
    
    private var isComplete: Bool {
        progress == 1
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let width = rect.width
        let height = rect.height
        let radius = min(cornerRadius, height)
        
        path.move(to: CGPoint(x: 0, y: height))
        path.addLine(to: CGPoint(x: 0, y: radius))
        
        path.addArc(
            center: CGPoint(x: radius, y: radius),
            radius: radius,
            startAngle: .degrees(180),
            endAngle: .degrees(270),
            clockwise: false
        )
        
        if isComplete {
            path.addLine(to: CGPoint(x: width - radius, y: 0))
            
            path.addArc(
                center: CGPoint(x: width - radius, y: radius),
                radius: radius,
                startAngle: .degrees(270),
                endAngle: .degrees(0),
                clockwise: false
            )
            
            path.addLine(to: CGPoint(x: width, y: height))
        } else {
            path.addLine(to: CGPoint(x: width, y: 0))
            path.addLine(to: CGPoint(x: width, y: height))
        }
        path.addLine(to: CGPoint(x: 0, y: height))
        path.closeSubpath()
        
        return path
    }
}

#if DEBUG
#Preview {
    VStack(spacing: 20) {
        CustomProgressShape(cornerRadius: 6)
            .fill(Color.green)
            .frame(height: 6)
        ZStack(alignment: .leading) {
            CustomProgressShape(cornerRadius: 6, progress: 1.0)
                .fill(Color.gray.opacity(0.3))
                .frame(height: 6)
            
            CustomProgressShape(cornerRadius: 6, progress: 0.5)
                .fill(Color.green)
                .frame(width: 100, height: 6)
        }
        .frame(width: 200)
    }
    .padding()
}
#endif
