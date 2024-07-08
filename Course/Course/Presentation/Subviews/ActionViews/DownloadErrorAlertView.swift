//
//  DownloadErrorAlertView.swift
//  Course
//
//  Created by  Stepanok Ivan on 13.06.2024.
//

import SwiftUI
import Core
import Theme

public enum ContentErrorType {
    case downloadFailed
    case noInternetConnection
    case wifiRequired
}

public struct DownloadErrorAlertView: View {
    
    private let errorType: ContentErrorType
    private let sequentials: [CourseSequential]
    private let tryAgain: () -> Void
    private let close: () -> Void
    @State private var fadeEffect: Bool = false
    
    @Environment(\.isHorizontal) private var isHorizontal
    
    public init(
        errorType: ContentErrorType,
        sequentials: [CourseSequential],
        tryAgain: @escaping () -> Void = {},
        close: @escaping () -> Void
    ) {
        self.errorType = errorType
        self.sequentials = sequentials
        self.tryAgain = tryAgain
        self.close = close
    }
    
    public var body: some View {
        ZStack(alignment: .bottom) {
            Color.black.opacity(fadeEffect ? 0.15 : 0)
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
                Text(headerTitle)
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
            
            Text(descriptionText)
                .font(.subheadline)
                .padding(.horizontal, 16)
                .padding(.top, 8)
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 16) {
                
                if errorType == .downloadFailed {
                    Button(action: {
                        fadeEffect = false
                        tryAgain()
                    }) {
                        Text(CourseLocalization.Course.Alert.tryAgain)
                            .font(Theme.Fonts.bodyMedium)
                            .foregroundStyle(Theme.Colors.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 42)
                            .background(Theme.Colors.accentColor)
                            .cornerRadius(8)
                        
                    }
                }
                
                Button(action: {
                    fadeEffect = false
                    close()
                }) {
                    Text(CourseLocalization.Course.Alert.close)
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
    
    private var headerTitle: String {
        switch errorType {
        case .downloadFailed:
            return CourseLocalization.Course.Error.downloadFailedTitle
        case .noInternetConnection:
            return CourseLocalization.Course.Error.noInternetConnectionTitle
        case .wifiRequired:
            return CourseLocalization.Course.Error.wifiRequiredTitle
        }
    }
    
    private var descriptionText: String {
        switch errorType {
        case .downloadFailed:
            return CourseLocalization.Course.Error.downloadFailedDescription
        case .noInternetConnection:
            return CourseLocalization.Course.Error.noInternetConnectionDescription
        case .wifiRequired:
            return CourseLocalization.Course.Error.wifiRequiredDescription
        }
    }
}

#if DEBUG
struct DownloadErrorAlertView_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            DownloadErrorAlertView(
                errorType: .downloadFailed,
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
                close: { print("Cancel triggered") }
            )
            
            DownloadErrorAlertView(
                errorType: .noInternetConnection,
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
                    ),
                ],
                close: { print("Cancel triggered") }
            )
            
            DownloadErrorAlertView(
                errorType: .wifiRequired,
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
                close: { print("Cancel triggered") }
            )
        }.loadFonts()
    }
}
#endif
