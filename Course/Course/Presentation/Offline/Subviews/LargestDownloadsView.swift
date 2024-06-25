//
//  LargestDownloadsView.swift
//  Course
//
//  Created by  Stepanok Ivan on 18.06.2024.
//

import SwiftUI
import Core
import Theme

public struct LargestDownloadsView: View {
    
    @State private var isEditing = false
    @StateObject
    private var viewModel: CourseContainerViewModel
    
    init(viewModel: CourseContainerViewModel) {
        self._viewModel = StateObject(wrappedValue: { viewModel }())
    }
    
    public var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(CourseLocalization.Course.LargestDownloads.title)
                    .font(Theme.Fonts.titleMedium)
                    .foregroundColor(Theme.Colors.textPrimary)
                Spacer()
                if viewModel.downloadAllButtonState == .start {
                    Button(action: {
                        isEditing.toggle()
                    }) {
                        Text(
                            isEditing
                            ? CourseLocalization.Course.LargestDownloads.done
                            : CourseLocalization.Course.LargestDownloads.edit
                        )
                        .font(Theme.Fonts.labelLarge)
                        .foregroundColor(Theme.Colors.accentColor)
                    }
                }
            }
            .padding(.vertical)
            
            ForEach(viewModel.largestDownloadBlocks) { block in
                HStack {
                    block.type.image
                    VStack(alignment: .leading) {
                        Text(block.displayName)
                            .font(Theme.Fonts.labelLarge)
                            .foregroundColor(Theme.Colors.textPrimary)
                        if let fileSize = block.fileSize {
                            Text(fileSize.formattedFileSize())
                                .font(Theme.Fonts.labelSmall)
                                .foregroundColor(Theme.Colors.textSecondary)
                        }
                    }
                    Spacer()
                    if isEditing {
                        Button(action: {
                            Task {
                                await viewModel.removeBlock(block)
                            }
                        }) {
                            CoreAssets.remove.swiftUIImage
                                .foregroundColor(Theme.Colors.alert)
                        }
                    } else {
                        CoreAssets.deleteDownloading.swiftUIImage
                            .foregroundColor(.green)
                    }
                }
                Divider()
                    .foregroundStyle(Theme.Colors.shade)
                .padding(.vertical, 8)
            }
        }
        .onChange(of: viewModel.downloadAllButtonState, perform: { state in
            if state == .cancel {
                self.isEditing = false
            }
        })
        .onAppear {
            Task {
                await viewModel.fetchLargestDownloadBlocks()
            }
        }
    }
}

#if DEBUG
struct LargestDownloadsView_Previews: PreviewProvider {
    static var previews: some View {
        
        let vm = CourseContainerViewModel(
            interactor: CourseInteractor.mock,
            authInteractor: AuthInteractor.mock,
            router: CourseRouterMock(),
            analytics: CourseAnalyticsMock(),
            config: ConfigMock(),
            connectivity: Connectivity(),
            manager: DownloadManagerMock(),
            storage: CourseStorageMock(),
            isActive: true,
            courseStart: nil,
            courseEnd: nil,
            enrollmentStart: nil,
            enrollmentEnd: nil,
            lastVisitedBlockID: nil,
            coreAnalytics: CoreAnalyticsMock()
        )
        
        LargestDownloadsView(viewModel: vm)
        .loadFonts()
        .onAppear {
            vm.largestDownloadBlocks = [
                CourseBlock(
                    blockId: "",
                    id: "1",
                    courseId: "",
                    graded: false,
                    due: nil,
                    completion: 0,
                    type: .discussion,
                    displayName: "Welcome to Mobile Testing",
                    studentUrl: "",
                    webUrl: "",
                    encodedVideo: nil,
                    multiDevice: nil,
                    offlineDownload: OfflineDownload(
                        fileUrl: "123",
                        lastModified: "e",
                        fileSize: 3423123214
                    )
                ),
                CourseBlock(
                    blockId: "",
                    id: "2",
                    courseId: "",
                    graded: false,
                    due: nil,
                    completion: 0,
                    type: .video,
                    displayName: "Advanced Mobile Sketching",
                    studentUrl: "",
                    webUrl: "",
                    encodedVideo: nil,
                    multiDevice: nil,
                    offlineDownload: OfflineDownload(
                        fileUrl: "123",
                        lastModified: "e",
                        fileSize: 34213214
                    )
                ),
                CourseBlock(
                    blockId: "",
                    id: "3",
                    courseId: "",
                    graded: false,
                    due: nil,
                    completion: 0,
                    type: .problem,
                    displayName: "File Naming Conventions",
                    studentUrl: "",
                    webUrl: "",
                    encodedVideo: nil,
                    multiDevice: nil,
                    offlineDownload: OfflineDownload(
                        fileUrl: "123",
                        lastModified: "e",
                        fileSize: 742343214
                    )
                ),
                CourseBlock(
                    blockId: "",
                    id: "4",
                    courseId: "",
                    graded: false,
                    due: nil,
                    completion: 0,
                    type: .discussion,
                    displayName: "Basic Illustration",
                    studentUrl: "",
                    webUrl: "",
                    encodedVideo: nil,
                    multiDevice: nil,
                    offlineDownload: OfflineDownload(
                        fileUrl: "123",
                        lastModified: "e",
                        fileSize: 122343214
                    )
                ),
                CourseBlock(
                    blockId: "",
                    id: "5",
                    courseId: "",
                    graded: false,
                    due: nil,
                    completion: 0,
                    type: .discussion,
                    displayName: "Block Diagrams",
                    studentUrl: "",
                    webUrl: "",
                    encodedVideo: nil,
                    multiDevice: nil,
                    offlineDownload: OfflineDownload(
                        fileUrl: "123",
                        lastModified: "e",
                        fileSize: 42343214
                    )
                )
            ]
        }
    }
}
#endif
