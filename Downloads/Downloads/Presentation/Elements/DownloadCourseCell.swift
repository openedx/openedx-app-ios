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
    let onDownloadTap: () -> Void
    let onRemoveTap: () -> Void
    let onCancelTap: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top, spacing: 12) {
                ZStack {
                    KFImage(URL(string: course.image ?? ""))
                        .onFailureImage(CoreAssets.noCourseImage.image)
                        .resizable()
                        .scaledToFill()
                }
                
            }.frame(height: 120)
                .clipped()
            
            VStack(alignment: .leading, spacing: 4) {
                Text(course.name)
                    .font(Theme.Fonts.titleLarge)
                    .foregroundColor(.primary)
                    .padding(.horizontal, 12)
            }

            let downloadedFormatted = ByteCountFormatter().string(fromByteCount: downloadedSize)
            let availableBytes = max(course.totalSize - downloadedSize, 0)
            let availableFormatted = ByteCountFormatter().string(fromByteCount: availableBytes)
            
            ZStack(alignment: .leading) {
                GeometryReader { geometry in
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Theme.Colors.textSecondary.opacity(0.5))
                        .frame(width: geometry.size.width, height: 8)
                    
                    RoundedCorners(
                        tl: 4,
                        tr: course.totalSize == downloadedSize ? 4 : 0,
                        bl: 4,
                        br: course.totalSize == downloadedSize ? 4 : 0
                    )
                        .fill(Theme.Colors.success)
                        .frame(
                            width: geometry.size.width * CGFloat(
                                downloadedSize
                            ) / CGFloat(course.totalSize),
                            height: 8
                        )
                }
                .frame(height: 8)
            }
            .cornerRadius(4)
            .padding(.horizontal, 12)

            VStack(alignment: .leading, spacing: 8) {
                if downloadedSize != 0 {
                    HStack {
                        CoreAssets.deleteDownloading.swiftUIImage
                        if course.totalSize == downloadedSize {
                            Text("All \(downloadedFormatted) downloaded")
                                .font(Theme.Fonts.labelLarge)
                                .foregroundStyle(Theme.Colors.success)
                        } else {
                            Text("\(downloadedFormatted) downloaded")
                                .font(Theme.Fonts.labelLarge)
                                .foregroundStyle(Theme.Colors.success)
                        }
                    }
                }
                if course.totalSize != downloadedSize {
                    HStack {
                        CoreAssets.startDownloading.swiftUIImage
                            .foregroundStyle(Theme.Colors.textSecondary)
                        Text("\(availableFormatted) available")
                            .font(Theme.Fonts.labelLarge)
                            .foregroundStyle(Theme.Colors.textSecondary)
                    }
                }
            }
            .font(.subheadline)
            .foregroundColor(.secondary)
            .padding(.horizontal, 12)

            StyledButton(
                "Download course",
                action: onDownloadTap,
                iconImage: CoreAssets.downloads.swiftUIImage,
                iconPosition: .left
            )
                .padding(12)
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
            DropDownMenu(
                isDownloading: downloadedSize > 0 && downloadedSize < course.totalSize,
                onRemoveTap: onRemoveTap,
                onCancelTap: onCancelTap
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
            .padding(.horizontal, 16)
        }
    }
}

// swiftlint:disable line_length
#if DEBUG
#Preview {
    DownloadCourseCell(
        course: DownloadCoursePreview(
            id: "123",
            name: "Demo Course",
            image: "https://axim-mobile.raccoongang.net/asset-v1:OpenedX+DemoX+DemoCourse+type@asset+block@thumbnail_demox.jpeg",
            totalSize: 31213
        ),
        downloadedSize: .constant(21423),
        onDownloadTap: {},
        onRemoveTap: {},
        onCancelTap: {}
    )
}
#endif
// swiftlint:enable line_length
