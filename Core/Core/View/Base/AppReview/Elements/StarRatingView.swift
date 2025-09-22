//
//  StarRatingView.swift
//  Core
//
//  Created by  Stepanok Ivan on 31.10.2023.
//

import SwiftUI
import Theme

struct StarRatingView: View {
    @Binding var rating: Int
    
    var body: some View {
        HStack {
            ForEach(1 ..< 6) { index in
                Group {
                    if index <= rating {
                        CoreAssets.star.swiftUIImage
                            .resizable()
                            .frame(width: 48, height: 48)
                    } else {
                        CoreAssets.starOutline.swiftUIImage
                            .resizable()
                            .frame(width: 48, height: 48)
                            .foregroundColor(Theme.Colors.textPrimary)
                    }
                }
                    .onTapGesture {
                        self.rating = index
                    }
            }
        }
    }
}
