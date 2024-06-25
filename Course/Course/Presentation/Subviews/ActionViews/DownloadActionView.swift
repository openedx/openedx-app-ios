//
//  DownloadActionView.swift
//  Course
//
//  Created by  Stepanok Ivan on 12.06.2024.
//

import SwiftUI
import Core
import Theme

enum ContentActionType {
    case remove
    case confirmDownload
    case confirmDownloadCellular
}

struct Lesson: Identifiable {
    let id = UUID()
    let name: String
    let size: Int
    let image: Image
}

public struct DownloadActionView: View {
    private let actionType: ContentActionType
    private let sequentials: [CourseSequential]
    private let courseBlocks: [CourseBlock]
    private let courseName: String?
    private let action: () -> Void
    private let cancel: () -> Void
    @State private var fadeEffect: Bool = false
    
    @Environment(\.isHorizontal) private var isHorizontal
    
    init(
        actionType: ContentActionType,
        sequentials: [CourseSequential],
        action: @escaping () -> Void,
        cancel: @escaping () -> Void
    ) {
        self.actionType = actionType
        self.sequentials = sequentials
        self.courseName = nil
        self.courseBlocks = []
        self.action = action
        self.cancel = cancel
    }
    
    init(
        actionType: ContentActionType,
        courseBlocks: [CourseBlock],
        courseName: String? = nil,
        action: @escaping () -> Void,
        cancel: @escaping () -> Void
    ) {
        self.actionType = actionType
        self.sequentials = []
        self.courseBlocks = courseBlocks
        self.courseName = courseName
        self.action = action
        self.cancel = cancel
    }
    
    public var body: some View {
        ZStack(alignment: .bottom) {
            Color.black.opacity(fadeEffect ? 0.15 : 0)
                .onTapGesture {
                    cancel()
                    fadeEffect = false
                }
            content
                .padding(.bottom, 20)
        }
        .ignoresSafeArea()
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.linear(duration: 0.3), {
                    fadeEffect = true
                })
            }
        }
    }
    
    private var content: some View {
        VStack {
            HStack {
                if actionType == .confirmDownloadCellular {
                    CoreAssets.warningFilled.swiftUIImage
                        .resizable()
                        .scaledToFit()
                        .frame(width: 22)
                }
                Text(headerTitle)
                    .font(Theme.Fonts.titleLarge)
            }
            .padding(.top, 16)
            .padding(.horizontal, 16)
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            
            if let courseName {
                HStack {
                    Image(systemName: "doc.text")
                        .renderingMode(.template)
                        .foregroundStyle(Theme.Colors.textPrimary)
                    Text(courseName)
                        .font(Theme.Fonts.bodyMedium)
                        .lineLimit(1)
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            } else {
                if sequentials.count <= 3 {
                    list
                } else {
                    ScrollView {
                        list
                    }
                    .frame(maxHeight: isHorizontal ? 80 : 200)
                }
            }
            
            Text(descriptionText)
                .font(.subheadline)
                .padding(.horizontal, 16)
                .padding(.top, 8)
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 16) {
                
                Button(action: {
                    fadeEffect = false
                    action()
                }) {
                    HStack {
                        actionButtonImage
                            .renderingMode(.template)
                        Text(actionButtonText)
                            .font(Theme.Fonts.bodyMedium)
                    }
                    .foregroundStyle(Theme.Colors.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 42)
                    .background(actionButtonColor)
                    .cornerRadius(8)
                }
                
                Button(action: {
                    fadeEffect = false
                    cancel()
                }) {
                    Text(CourseLocalization.Course.Alert.cancel)
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
            .padding([.leading, .trailing, .bottom], 16)
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
            if sequentials.isEmpty {
                ForEach(Array(courseBlocks.enumerated()), id: \.offset) { _, block in
                    HStack {
                        block.type.image
                            .renderingMode(.template)
                            .foregroundStyle(Theme.Colors.textPrimary)
                        Text(block.displayName)
                            .font(Theme.Fonts.bodyMedium)
                            .lineLimit(1)
                        if let fileSize = block.fileSize, fileSize != 0 {
                            Text(fileSize.formattedFileSize())
                                .foregroundColor(Theme.Colors.textSecondaryLight)
                                .font(Theme.Fonts.bodySmall)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                }
            } else {
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
    }
    
    private var headerTitle: String {
        switch actionType {
        case .remove:
            return CourseLocalization.Course.Alert.removeTitle
        case .confirmDownload:
            return CourseLocalization.Course.Alert.confirmDownloadTitle
        case .confirmDownloadCellular:
            return CourseLocalization.Course.Alert.confirmDownloadCellularTitle
        }
    }
    
    private var descriptionText: String {
        switch actionType {
        case .remove:
            return CourseLocalization.Course.Alert.removeDescription(totalSize)
        case .confirmDownload:
            return CourseLocalization.Course.Alert.confirmDownloadDescription(totalSize)
        case .confirmDownloadCellular:
            return CourseLocalization.Course.Alert.confirmDownloadCellularDescription(totalSize)
        }
    }
    
    private var actionButtonText: String {
        switch actionType {
        case .remove:
            return CourseLocalization.Course.Alert.remove
        case .confirmDownload, .confirmDownloadCellular:
            return CourseLocalization.Course.Alert.download
        }
    }
    
    private var actionButtonImage: Image {
        switch actionType {
        case .remove:
            return CoreAssets.remove.swiftUIImage
        case .confirmDownload, .confirmDownloadCellular:
            return CoreAssets.startDownloading.swiftUIImage
        }
    }
    
    private var actionButtonColor: Color {
        switch actionType {
        case .remove:
            Theme.Colors.snackbarErrorColor
        case .confirmDownloadCellular, .confirmDownload:
            Theme.Colors.accentColor
        
        }
    }
    
    private var totalSize: String {
        if sequentials.isEmpty {
            courseBlocks.reduce(0) { $0 + ($1.fileSize ?? 0) }.formattedFileSize()
        } else {
            sequentials.reduce(0) { $0 + $1.totalSize }.formattedFileSize()
        }
    }
}

#if DEBUG
struct ContentActionView_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            DownloadActionView(
                actionType: .remove,
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
                    ),
                    CourseSequential(
                        blockId: "",
                        id: "",
                        displayName: "Course intro",
                        type: .chapter,
                        completion: 0,
                        childs: [],
                        sequentialProgress: nil,
                        due: nil
                    ),
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
                action: {
                    print("Action triggered")
                },
                cancel: { print("Cancel triggered") }
            )
        }.loadFonts()
    }
}
#endif
