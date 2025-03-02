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
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            VStack(alignment: .leading) {
                HStack(alignment: .top, spacing: 12) {
                    ZStack {
                        KFImage(URL(string: course.image ?? ""))
                            .onFailureImage(CoreAssets.noCourseImage.image)
                            .resizable()
                            .scaledToFill()
                            .clipped()
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
            
            // Progress bar with improved logging
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
                        .frame(width: width, height: 8)
                    }
                }
                .frame(height: 8)
                
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
                    .opacity((downloadState == .inProgress || downloadState == .waiting) ? 1 : 0)
            }
            .cornerRadius(4)
            .padding(.horizontal, 12)

            VStack(alignment: .leading, spacing: 4) {
                if downloadState == .waiting || downloadState == .inProgress {
                    if downloadState == .inProgress {
                        HStack {
                            CoreAssets.deleteDownloading.swiftUIImage
                            Text(
                                DownloadsLocalization.Downloads.Cell.downloadedOfTotal(
                                    downloadedFormatted,
                                    totalSizeFormatted
                                )
                            )
                                .font(Theme.Fonts.labelLarge)
                                .foregroundStyle(Theme.Colors.success)
                        }
                    }
                } else if downloadState == .finished {
                    HStack {
                        CoreAssets.deleteDownloading.swiftUIImage
                        Text(DownloadsLocalization.Downloads.Cell.allDownloaded(downloadedFormatted))
                            .font(Theme.Fonts.labelLarge)
                            .foregroundStyle(Theme.Colors.success)
                    }
                }
                
                if downloadState == nil || (downloadState != .finished) {
                    HStack {
                        CoreAssets.startDownloading.swiftUIImage
                            .foregroundStyle(Theme.Colors.textSecondary)
                        Text(DownloadsLocalization.Downloads.Cell.available(availableFormatted))
                            .font(Theme.Fonts.labelLarge)
                            .foregroundStyle(Theme.Colors.textSecondary)
                    }
                }
            }
            .font(.subheadline)
            .foregroundColor(.secondary)
            .padding(.horizontal, 12)
            .padding(.bottom, downloadState == nil ? 0 : 12)

            // Only show the Download button if course is not downloaded or downloading
            if downloadState == nil {
                StyledButton(
                    DownloadsLocalization.Downloads.Cell.downloadCourse,
                    action: onDownloadTap,
                    iconImage: CoreAssets.downloads.swiftUIImage,
                    iconPosition: .left
                )
                .padding(12)
            } else if downloadState == .inProgress || downloadState == .waiting {
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
            // Only show menu if course is downloading or downloaded
            if downloadState != nil {
                DropDownMenu(
                    isDownloading: downloadState == .inProgress || downloadState == .waiting,
                    onRemoveTap: onRemoveTap,
                    onCancelTap: onCancelTap
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                .padding(.horizontal, 16)
            }
        }
    }
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
