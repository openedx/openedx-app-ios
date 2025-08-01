//
//  VideoThumbnailService.swift
//  Course
//
//  Created by Ivan Stepanok on 30.07.2025.
//

import UIKit
import AVFoundation
import Kingfisher

public protocol VideoThumbnailServiceProtocol: Sendable {
    func generateVideoThumbnailIfNeeded(from url: URL) async -> UIImage?
}

public actor VideoThumbnailService: VideoThumbnailServiceProtocol {
    
    public init() {}
    
    public func generateVideoThumbnailIfNeeded(from url: URL) async -> UIImage? {
        let cacheKey = "video_thumbnail_\(url.absoluteString.hash)"
        
        // Check if thumbnail is already cached (both memory and disk)
        do {
            let cacheResult = try await ImageCache.default.retrieveImage(forKey: cacheKey)
            if let cachedImage = cacheResult.image {
                return cachedImage
            }
        } catch {
            // Cache retrieval failed, continue to generate new thumbnail
        }
        
        do {
            let image = try await generateVideoThumbnail(from: url)
            
            // Cache the generated thumbnail to both memory and disk
            try await ImageCache.default.store(
                image,
                forKey: cacheKey,
                toDisk: true
            )
            
            return image
        } catch {
            return nil
        }
    }
    
    private func generateVideoThumbnail(from url: URL) async throws -> UIImage {
        let asset = AVAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        imageGenerator.requestedTimeToleranceBefore = .zero
        imageGenerator.requestedTimeToleranceAfter = .zero
        
        let time = CMTime(seconds: 1.0, preferredTimescale: 600)
        
        return try await withCheckedThrowingContinuation { continuation in
            imageGenerator.generateCGImagesAsynchronously(
                forTimes: [NSValue(time: time)]) { _, cgImage, _, _, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                guard let cgImage = cgImage else {
                    continuation.resume(
                        throwing: NSError(
                            domain: "VideoThumbnailError", code: -1,
                            userInfo: [NSLocalizedDescriptionKey: "Failed to generate thumbnail"]
                        )
                    )
                    return
                }
                
                let image = UIImage(cgImage: cgImage)
                continuation.resume(returning: image)
            }
        }
    }
}
