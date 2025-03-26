//
//  DownloadCourseCell.swift
//  Downloads
//
//  Created by Ivan Stepanok on 22.02.2025.
//

import SwiftUI
import Core
import Theme
import Kingfisher

struct DownloadCourseCell: View {
    let course: DownloadCoursePreview
    @Binding var downloadedSize: Int64
    let downloadState: DownloadState?
    let onDownloadTap: () -> Void
    let onCardTap: () -> Void
    let onRemoveTap: () -> Void
    let onCancelTap: () -> Void
    @State private var isCancelling: Bool = false
    
    // Ensure the download size is valid
    private var validDownloadedSize: Int64 {
        // Always ensure downloaded size is non-negative
        return max(0, downloadedSize)
    }
    
    // Calculate progress percentage safely
    private var progressPercentage: CGFloat {
        guard course.totalSize > 0 else { return 0 }
        // Calculate as a percentage of the total course size, but cap at 100%
        let percentage = CGFloat(validDownloadedSize) / CGFloat(course.totalSize)
        // Clamp to valid range
        return max(0, min(1, percentage))
    }
    
    // Format progress as percentage
    private var progressText: String {
        let percent = Int(progressPercentage * 100)
        return "\(min(percent, 100))%"
    }
    
    private var downloadButtonState: DownloadButtonState {
        if isCancelling {
            return validDownloadedSize > 0 ? .partiallyDownloaded : .notDownloaded
        } else if downloadState == .loadingStructure {
            return .loadingStructure
        } else if downloadState == .inProgress || downloadState == .waiting {
            return .downloading
        } else if downloadState == .finished && validDownloadedSize >= course.totalSize * 95 / 100 {
            // Only consider it fully downloaded if it's at least 95% complete
            return .downloaded
        } else if validDownloadedSize > 0 {
            // If there's any downloaded content but not fully downloaded, consider it partially downloaded
            return .partiallyDownloaded
        } else {
            return .notDownloaded
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            VStack(alignment: .leading) {
                HStack(alignment: .top, spacing: 12) {
                    ZStack {
                        // Clickable area
                        Rectangle()
                            .foregroundStyle(Color.white.opacity(0.001))
                            .background {
                                KFImage(URL(string: course.image ?? ""))
                                    .onFailureImage(CoreAssets.noCourseImage.image)
                                    .resizable()
                                    .scaledToFill()
                                    .allowsHitTesting(false)
                                    .clipped()
                            }
                    }
                }
                .clipped()
                
                VStack(alignment: .leading, spacing: 4) {
                    ZStack(alignment: .leading) {
                        Text(course.name)
                            .font(Theme.Fonts.titleLarge)
                            .lineLimit(2)
                            .foregroundColor(.primary)
                            .padding(.horizontal, 12)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background {
                                Theme.Colors.background
                            }
                    }
                }
            }
            .onTapGesture {
                onCardTap()
            }
            
            let downloadedFormatted = Int(validDownloadedSize).formattedFileSize()
            let availableBytes = max(course.totalSize - validDownloadedSize, 0)
            let availableFormatted = Int(availableBytes).formattedFileSize()
            
            // Progress bar
            if downloadButtonState == .partiallyDownloaded || downloadButtonState == .downloading {
                ZStack(alignment: .leading) {
                    GeometryReader { geometry in
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Theme.Colors.textSecondary.opacity(0.5))
                            .frame(width: geometry.size.width, height: 8)
                        
                        if progressPercentage > 0 {
                            let width = max(0, min(geometry.size.width * progressPercentage, geometry.size.width))
                            
                            RoundedCorners(
                                tl: 4,
                                tr: progressPercentage >= 1.0 ? 4 : 0,
                                bl: 4,
                                br: progressPercentage >= 1.0 ? 4 : 0
                            )
                            .fill(Theme.Colors.success)
                            .frame(
                                width: downloadButtonState == .downloaded
                                ? geometry.size.width
                                : width,
                                height: 8
                            )
                        }
                    }
                    .frame(height: 8)
                    
                    if downloadButtonState == .downloading {
                        Text(progressText)
                            .font(Theme.Fonts.labelSmall)
                            .foregroundColor(Theme.Colors.white)
                            .padding(.horizontal, 4)
                            .padding(.vertical, 1)
                            .background(
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Theme.Colors.textPrimary.opacity(0.7))
                            )
                            .offset(y: -14)
                    }
                }
                .cornerRadius(4)
                .padding(.horizontal, 12)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                switch downloadButtonState {
                case .downloaded:
                    HStack {
                        CoreAssets.deleteDownloading.swiftUIImage
                        Text(DownloadsLocalization.Downloads.Cell.allDownloaded(downloadedFormatted))
                            .font(Theme.Fonts.labelLarge)
                            .foregroundStyle(Theme.Colors.success)
                    }
                case .partiallyDownloaded, .downloading:
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            CoreAssets.deleteDownloading.swiftUIImage
                            Text(
                                DownloadsLocalization.Downloads.Cell.downloaded(downloadedFormatted)
                            )
                            .font(Theme.Fonts.labelLarge)
                            .foregroundStyle(Theme.Colors.success)
                        }
                        
                        HStack {
                            CoreAssets.startDownloading.swiftUIImage
                                .foregroundStyle(Theme.Colors.textSecondary)
                            Text(DownloadsLocalization.Downloads.Cell.available(availableFormatted))
                                .font(Theme.Fonts.labelLarge)
                                .foregroundStyle(Theme.Colors.textSecondary)
                        }
                    }
                case .notDownloaded, .loadingStructure:
                    HStack {
                        CoreAssets.startDownloading.swiftUIImage
                            .foregroundStyle(Theme.Colors.textSecondary)
                        Text(DownloadsLocalization.Downloads.Cell.available(availableFormatted))
                            .font(Theme.Fonts.labelLarge)
                            .foregroundStyle(Theme.Colors.textSecondary)
                    }
                }
            }
            .padding(.horizontal, 12)
            .padding(
                .bottom,
                (downloadButtonState == .notDownloaded || downloadButtonState == .partiallyDownloaded) ? 0 : 12
            )
            
            switch downloadButtonState {
            case .notDownloaded, .partiallyDownloaded:
                StyledButton(
                    DownloadsLocalization.Downloads.Cell.downloadCourse,
                    action: {
                        isCancelling = false
                        onDownloadTap()
                    },
                    iconImage: CoreAssets.downloads.swiftUIImage,
                    iconPosition: .left,
                    maxWidthIpad: .infinity
                )
                .padding(.horizontal, 12)
                .padding(.bottom, 12)
            case .downloading:
                HStack {
                    DownloadProgressView()
                        .padding(.trailing, 4)
                        .onTapGesture {
                            isCancelling = true
                            onCancelTap()
                        }
                    Text(DownloadsLocalization.Downloads.Cell.downloading)
                        .font(Theme.Fonts.bodyMedium)
                        .foregroundStyle(Theme.Colors.textPrimary)
                }
                .padding(.bottom, 12)
                .frame(maxWidth: .infinity, maxHeight: 42, alignment: .center)
                .padding(.horizontal, 16)
            case .loadingStructure:
                HStack {
                    DownloadProgressView()
                        .padding(.trailing, 4)
                        .onTapGesture {
                            isCancelling = true
                            onCancelTap()
                        }
                    Text(DownloadsLocalization.Downloads.Cell.loadingCourseStructure)
                        .font(Theme.Fonts.bodyMedium)
                        .foregroundStyle(Theme.Colors.textPrimary)
                }
                .padding(.bottom, 12)
                .frame(maxWidth: .infinity, maxHeight: 42, alignment: .center)
                .padding(.horizontal, 16)
            case .downloaded:
                EmptyView()
            }
        }
        .cornerRadius(8)
        .padding(.horizontal, 16)
        .background {
            Theme.Colors.background
                .cornerRadius(8)
                .padding(.horizontal, 16)
                .shadow(radius: 4, y: 3)
        }
        .overlay {
            if downloadButtonState != .notDownloaded {
                DropDownMenu(
                    isDownloading: downloadButtonState == .downloading || downloadButtonState == .loadingStructure,
                    showRemoveOption: validDownloadedSize > 0,
                    onRemoveTap: onRemoveTap,
                    onCancelTap: onCancelTap
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                .padding(.horizontal, 16)
            }
        }
        .onChange(of: downloadState) { newState in
            if newState == .inProgress || newState == .loadingStructure {
                isCancelling = false
            }
        }
    }
}

private enum DownloadButtonState {
    case notDownloaded
    case downloading
    case downloaded
    case partiallyDownloaded
    case loadingStructure
}

//swiftlint:disable all
#if DEBUG
#Preview {
    VStack(spacing: 20) {
        // Not downloaded
        DownloadCourseCell(
            course: DownloadCoursePreview(
                id: "123",
                name: "Not Downloaded Course",
                image: "https://sample-videos.com/img/Sample-jpg-image-200kb.jpg",
                totalSize: 31213
            ),
            downloadedSize: .constant(0),
            downloadState: nil,
            onDownloadTap: {},
            onCardTap: {},
            onRemoveTap: {},
            onCancelTap: {}
        )
        
        // Downloading
        DownloadCourseCell(
            course: DownloadCoursePreview(
                id: "124",
                name: "Downloading Course",
                image: "https://sample-videos.com/img/Sample-jpg-image-200kb.jpg",
                totalSize: 31213
            ),
            downloadedSize: .constant(0),
            downloadState: .inProgress,
            onDownloadTap: {},
            onCardTap: {},
            onRemoveTap: {},
            onCancelTap: {}
        )
        
        // Partially downloaded
        DownloadCourseCell(
            course: DownloadCoursePreview(
                id: "125",
                name: "Partially Downloaded Course",
                image: "https://sample-videos.com/img/Sample-jpg-image-200kb.jpg",
                totalSize: 31213
            ),
            downloadedSize: .constant(15000),
            downloadState: nil,
            onDownloadTap: {},
            onCardTap: {},
            onRemoveTap: {},
            onCancelTap: {}
        )
        
        // Fully downloaded
        DownloadCourseCell(
            course: DownloadCoursePreview(
                id: "126",
                name: "Fully Downloaded Course",
                image: "https://sample-videos.com/img/Sample-jpg-image-200kb.jpg",
                totalSize: 31213
            ),
            downloadedSize: .constant(31213),
            downloadState: .finished,
            onDownloadTap: {},
            onCardTap: {},
            onRemoveTap: {},
            onCancelTap: {}
        )
    }
    .padding()
}
#endif
// swiftlint:enable all
