//
//  DeviceStorageFullAlertView.swift
//  Course
//
//  Created by  Stepanok Ivan on 13.06.2024.
//

import SwiftUI
import Theme

public struct DeviceStorageFullAlertView: View {
    private let sequentials: [CourseSequential]
    private let usedSpace: Int
    private let freeSpace: Int
    private let close: () -> Void
    @State private var fadeEffect: Bool = false
    
    @Environment(\.isHorizontal) private var isHorizontal
    
    public init(
        sequentials: [CourseSequential],
        usedSpace: Int,
        freeSpace: Int,
        close: @escaping () -> Void
    ) {
        self.sequentials = sequentials
        self.usedSpace = usedSpace
        self.freeSpace = freeSpace
        self.close = close
    }
    
    public var body: some View {
        ZStack(alignment: .center) {
            Color.black.opacity(fadeEffect ? 0.4 : 0)
                .onTapGesture {
                    close()
                    fadeEffect = false
                }
            content
                .padding(.bottom, 20)
        }
        .ignoresSafeArea()
        .onAppear {
            withAnimation(Animation.linear(duration: 0.3).delay(0.2)) {
                fadeEffect = true
            }
        }
    }
    
    private var content: some View {
        VStack {
            HStack {
                CoreAssets.reportOctagon.swiftUIImage
                    .scaledToFit()
                    .foregroundStyle(Theme.Colors.alert)
                Text(CoreLocalization.Course.StorageAlert.title)
                    .font(Theme.Fonts.titleLarge)
            }
            .padding(.top, 16)
            .padding(.horizontal, 16)
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            
            if sequentials.count <= 3 {
                list
            } else {
                ScrollView {
                    list
                }
                .frame(maxHeight: isHorizontal ? 80 : 200)
            }
            
            VStack(spacing: 4) {
                StorageProgressBar(
                    usedSpace: usedSpace,
                    contentSize: totalSize
                )
                .padding(.horizontal, 16)
                .padding(.top, 8)
                
                HStack {
                    Text(
                        CoreLocalization.Course.StorageAlert.usedAndFree(
                            usedSpace.formattedFileSize(),
                            freeSpace.formattedFileSize()
                        )
                    )
                    .foregroundColor(Theme.Colors.textSecondaryLight)
                    .font(Theme.Fonts.bodySmall)
                    Spacer()
                    Text(totalSize.formattedFileSize())
                        .foregroundColor(Theme.Colors.alert)
                        .font(Theme.Fonts.bodySmall)
                }
                .padding(.horizontal, 16)
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            }
            
            Text(CoreLocalization.Course.StorageAlert.description)
                .font(.subheadline)
                .padding(.horizontal, 16)
                .padding(.top, 8)
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 16) {
                Button(action: {
                    fadeEffect = false
                    close()
                }) {
                    Text(CoreLocalization.Course.Alert.close)
                        .font(Theme.Fonts.bodyMedium)
                        .foregroundStyle(Theme.Colors.accentColor)
                        .frame(maxWidth: .infinity)
                        .frame(height: 42)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Theme.Colors.accentColor, lineWidth: 2)
                        )
                        .background(Theme.Colors.background)
                        .cornerRadius(8)
                    
                }
            }
            .padding(16)
        }
        .background(Theme.Colors.background)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Theme.Colors.datesSectionStroke, lineWidth: 2)
        )
        .cornerRadius(8)
        .padding(16)
        .frame(maxWidth: 400)
    }
    
    @ViewBuilder
    var list: some View {
        VStack(spacing: 8) {
            ForEach(sequentials) { sequential in
                HStack {
                    sequential.type.image
                        .renderingMode(.template)
                        .foregroundStyle(Theme.Colors.textPrimary)
                    Text(sequential.displayName)
                        .font(Theme.Fonts.bodyMedium)
                        .lineLimit(1)
                    if sequential.totalSize != 0 {
                        Text(sequential.totalSize.formattedFileSize())
                            .foregroundColor(Theme.Colors.textSecondaryLight)
                            .font(Theme.Fonts.bodySmall)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            }
        }
    }
    
    private var totalSize: Int {
        sequentials.reduce(0) { $0 + $1.totalSize }
    }
}

struct StorageProgressBar: View {
    let usedSpace: Int
    let contentSize: Int
    
    var body: some View {
        GeometryReader { geometry in
            let totalSpace = geometry.size.width
            let usedSpace = Double(usedSpace)
            let contentSize = Double(contentSize)
            let total = usedSpace + contentSize
            
            let minSize: Double = 0.1
            let usedSpacePercentage = (usedSpace / total) + minSize
            let contentSizePercentage = (contentSize / total) + minSize
            let normalizationFactor = 1 / (usedSpacePercentage + contentSizePercentage)
            
            let normalizedUsedSpaceWidth = usedSpacePercentage * normalizationFactor
            
            ZStack {
                RoundedRectangle(cornerRadius: 3)
                    .fill(Theme.Colors.datesSectionStroke)
                    .frame(width: totalSpace, height: 42)
                
                RoundedRectangle(cornerRadius: 2)
                    .fill(Theme.Colors.background)
                    .frame(width: totalSpace - 4, height: 38)
                
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Theme.Colors.alert)
                        .frame(width: totalSpace - 6, height: 36)
                    
                    HStack(spacing: 0) {
                        RoundedCorners(tl: 2, bl: 2)
                            .fill(Theme.Colors.datesSectionStroke)
                            .frame(width: (totalSpace - 6) * normalizedUsedSpaceWidth, height: 36)
                        Rectangle()
                            .fill(Theme.Colors.background)
                            .frame(width: 1, height: 36)
                    }
                }
            }
        }
        .frame(height: 44)
    }
}

#if DEBUG
struct DeviceStorageFullAlertView_Previews: PreviewProvider {
    static var previews: some View {
        DeviceStorageFullAlertView(
            sequentials: [
                CourseSequential(
                    blockId: "",
                    id: "",
                    displayName: "Course intro",
                    type: .chapter,
                    completion: 0,
                    childs: [],
                    sequentialProgress: nil,
                    due: nil
                )
            ],
            usedSpace: 460580220928,
            freeSpace: 33972756480,
            close: { print("Close action triggered") }
        )
        .loadFonts()
    }
}
#endif
