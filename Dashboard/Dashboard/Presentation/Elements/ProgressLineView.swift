//
//  ProgressLineView.swift
//  Dashboard
//
//  Created by  Stepanok Ivan on 16.04.2024.
//

import SwiftUI
import Theme

struct ProgressLineView: View {
    private let progressEarned: Int
    private let progressPossible: Int
    private let height: CGFloat
    
    var progressValue: CGFloat {
         guard progressPossible != 0 else { return 0 }
         return CGFloat(progressEarned) / CGFloat(progressPossible)
     }
    
    init(progressEarned: Int, progressPossible: Int, height: CGFloat = 8) {
        self.progressEarned = progressEarned
        self.progressPossible = progressPossible
        self.height = height
    }
    
    var body: some View {
        ZStack(alignment: .leading) {
                GeometryReader { geometry in
                    Rectangle()
                        .foregroundStyle(Theme.Colors.primaryCardProgressBG)
                    Rectangle()
                        .foregroundStyle(Theme.Colors.accentButtonColor)
                        .frame(width: geometry.size.width * progressValue)
                }.frame(height: height)
        }
    }
}

#if DEBUG
struct ProgressLineView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressLineView(progressEarned: 4, progressPossible: 6)
            .frame(height: 8)
            .padding()
    }
}
#endif
