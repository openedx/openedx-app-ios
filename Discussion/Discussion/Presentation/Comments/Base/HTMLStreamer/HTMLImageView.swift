//
//  HTMLImageView.swift
//  Discussion
//
//  Created by  Stepanok Ivan on 3.04.2025.
//

import Foundation
import Core
import SwiftUI
import Kingfisher

struct HTMLImage: Identifiable {
    let id = UUID()
    let url: URL
    let altText: String?
}

struct HTMLImageView: View {
    let image: HTMLImage
    @State private var isLoading = true
    
    init(image: HTMLImage) {
        self.image = image
    }
    
    var body: some View {
        ZStack {
            if isLoading {
                ProgressView()
            }
            let decodedString = image.url.absoluteString.replacingOccurrences(of: "&amp;", with: "&")
            if let decodedURL = URL(string: decodedString) {
                KFImage(decodedURL)
                    .onFailureImage(CoreAssets.noCourseImage.image)
                    .onSuccess { _ in
                        isLoading = false
                    }
                    .onFailure { _ in
                        isLoading = false
                    }
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .accessibilityLabel(image.altText ?? "Image")
            }
        }
    }
}
