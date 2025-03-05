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
    let router: DownloadsRouter
    @Binding var downloadedSize: Int64
    let downloadState: DownloadState?
    let onDownloadTap: () -> Void
    let onRemoveTap: () -> Void
    let onCancelTap: () -> Void
    
    // Ensure the download size is valid
    private var validDownloadedSize: Int64 {
        // Always return a value between 0 and course.totalSize to avoid overflow
        return max(0, min(downloadedSize, course.totalSize))
    }

    // Calculate progress percentage safely
    private var progressPercentage: CGFloat {
        guard course.totalSize > 0 else { return 0 }
        // Always calculate as a percentage of the total course size
        let percentage = CGFloat(validDownloadedSize) / CGFloat(course.totalSize)
        // Clamp to valid range
        return max(0, min(1, percentage))
    }
    
    // Format progress as percentage
    private var progressText: String {
        let percent = Int(progressPercentage * 100)
        return "\(percent)%"
    }
    
    private var downloadButtonState: DownloadButtonState {
        if downloadState == .inProgress || downloadState == .waiting {
            return .downloading
        } else if downloadState == .finished && validDownloadedSize >= course.totalSize * 95 / 100 {
            return .downloaded
        } else if downloadState == .finished || validDownloadedSize > 0 {
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
                        KFImage(URL(string: course.image ?? ""))
                            .onFailureImage(CoreAssets.noCourseImage.image)
                            .resizable()
                            .scaledToFill()
                            .allowsHitTesting(false)
                            .clipped()
                        // Clickable area
                        Rectangle()
                            .foregroundStyle(Color.white.opacity(0.01))
                            .frame(height: 120)
                    }
                    
                }.frame(height: 120)
                    .clipped()
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(course.name)
                        .font(Theme.Fonts.titleLarge)
                        .foregroundColor(.primary)
                        .padding(.horizontal, 12)
                }
            }
            .onTapGesture {
                router
                    .showCourseScreens(
                        courseID: course.id,
                        hasAccess: true,
                        courseStart: Date(),
                        courseEnd: nil,
                        enrollmentStart: nil,
                        enrollmentEnd: nil,
                        title: course.name,
                        courseRawImage: nil,
                        showDates: false,
                        lastVisitedBlockID: nil
                    )
            }

            let downloadedFormatted = ByteCountFormatter().string(fromByteCount: validDownloadedSize)
            let totalSizeFormatted = ByteCountFormatter().string(fromByteCount: course.totalSize)
            let availableBytes = max(course.totalSize - validDownloadedSize, 0)
            let availableFormatted = ByteCountFormatter().string(fromByteCount: availableBytes)
            
            // Progress bar
            if downloadButtonState != .notDownloaded {
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
                case .notDownloaded:
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
                    downloadButtonState == .notDownloaded
                    ? DownloadsLocalization.Downloads.Cell.downloadSize(totalSizeFormatted)
                    : DownloadsLocalization.Downloads.Cell.downloadCourse,
                    action: onDownloadTap,
                    iconImage: CoreAssets.downloads.swiftUIImage,
                    iconPosition: .left
                )
                .padding(.horizontal, 12)
                .padding(.bottom, 12)
            case .downloading:
                HStack {
                    DownloadProgressView()
                        .padding(.trailing, 4)
                    Text(DownloadsLocalization.Downloads.Cell.downloading)
                        .font(Theme.Fonts.bodyMedium)
                        .foregroundStyle(Theme.Colors.textPrimary)
                }
                .padding(.bottom, 12)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
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
                    isDownloading: downloadButtonState == .downloading,
                    onRemoveTap: onRemoveTap,
                    onCancelTap: onCancelTap
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                .padding(.horizontal, 16)
            }
        }
    }
}

private enum DownloadButtonState {
    case notDownloaded
    case downloading
    case downloaded
    case partiallyDownloaded
}

//swiftlint:disable all
#if DEBUG
#Preview {
    DownloadCourseCell(
        course: DownloadCoursePreview(
            id: "123",
            name: "Demo Course",
            image: "https://sample-videos.com/img/Sample-jpg-image-200kb.jpg",
            totalSize: 31213
        ),
        router: DownloadsRouterMock(),
        downloadedSize: .constant(21423),
        downloadState: .inProgress,
        onDownloadTap: {},
        onRemoveTap: {},
        onCancelTap: {}
    )
}
#endif
// swiftlint:enable all
