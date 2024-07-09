//
//  CustomDisclosureGroup.swift
//  Course
//
//  Created by  Stepanok Ivan on 21.05.2024.
//

import SwiftUI
import Core
import Theme

struct CustomDisclosureGroup: View {
    @State private var expandedSections: [String: Bool] = [:]
    
    private let proxy: GeometryProxy
    private let course: CourseStructure
    private let viewModel: CourseContainerViewModel
    private var idiom: UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    
    init(course: CourseStructure, proxy: GeometryProxy, viewModel: CourseContainerViewModel) {
        self.course = course
        self.proxy = proxy
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(course.childs) { chapter in
                let chapterIndex = course.childs.firstIndex(where: { $0.id == chapter.id })
                VStack(alignment: .leading) {
                    Button(
                        action: {
                            withAnimation(.linear(duration: course.childs.count > 1 ? 0.2 : 0.05)) {
                                expandedSections[chapter.id, default: false].toggle()
                            }
                        }, label: {
                            HStack {
                                CoreAssets.chevronRight.swiftUIImage
                                    .rotationEffect(.degrees(expandedSections[chapter.id] ?? false ? -90 : 90))
                                    .foregroundColor(Theme.Colors.textPrimary)
                                if chapter.childs.allSatisfy({ $0.completion == 1 }) {
                                    CoreAssets.finishedSequence.swiftUIImage
                                }
                                Text(chapter.displayName)
                                    .font(Theme.Fonts.titleMedium)
                                    .foregroundColor(Theme.Colors.textPrimary)
                                    .lineLimit(1)
                                Spacer()
                                if canDownloadAllSections(in: chapter),
                                   let state = downloadAllButtonState(for: chapter) {
                                    Button(
                                        action: {
                                            switch state {
                                            case .finished:
                                                viewModel.router.presentAlert(
                                                    alertTitle: CourseLocalization.Alert.warning,
                                                    alertMessage: deleteMessage(for: chapter),
                                                    positiveAction: CoreLocalization.Alert.delete,
                                                    onCloseTapped: {
                                                        viewModel.router.dismiss(animated: true)
                                                    },
                                                    okTapped: {
                                                        downloadAllSubsections(in: chapter, state: state)
                                                        viewModel.router.dismiss(animated: true)
                                                    },
                                                    type: .deleteVideo
                                                )
                                            default:
                                                downloadAllSubsections(in: chapter, state: state)
                                            }
                                        }, label: {
                                            switch state {
                                            case .available:
                                                DownloadAvailableView()
                                            case .downloading:
                                                DownloadProgressView()
                                            case .finished:
                                                DownloadFinishedView()
                                            }
                                            
                                        }
                                    )
                                }
                            }
                        }
                    )
                    if expandedSections[chapter.id] ?? false {
                        VStack(alignment: .leading) {
                            ForEach(chapter.childs) { sequential in
                                let sequentialIndex = chapter.childs.firstIndex(where: { $0.id == sequential.id })
                                VStack(alignment: .leading) {
                                    HStack {
                                        Button(
                                            action: {
                                                guard let chapterIndex = chapterIndex else { return }
                                                guard let sequentialIndex else { return }
                                                guard let courseVertical = sequential.childs.first else { return }
                                                guard let block = courseVertical.childs.first else { return }

                                                viewModel.trackSequentialClicked(sequential)
                                                if viewModel.config.uiComponents.courseDropDownNavigationEnabled {
                                                    viewModel.router.showCourseUnit(
                                                        courseName: viewModel.courseStructure?.displayName ?? "",
                                                        blockId: block.id,
                                                        courseID: viewModel.courseStructure?.id ?? "",
                                                        verticalIndex: 0,
                                                        chapters: course.childs,
                                                        chapterIndex: chapterIndex,
                                                        sequentialIndex: sequentialIndex
                                                    )
                                                } else {
                                                    viewModel.router.showCourseVerticalView(
                                                        courseID: viewModel.courseStructure?.id ?? "",
                                                        courseName: viewModel.courseStructure?.displayName ?? "",
                                                        title: sequential.displayName,
                                                        chapters: course.childs,
                                                        chapterIndex: chapterIndex,
                                                        sequentialIndex: sequentialIndex
                                                    )
                                                }
                                            },
                                            label: {
                                                VStack(alignment: .leading) {
                                                    HStack {
                                                        if sequential.completion == 1 {
                                                            CoreAssets.finishedSequence.swiftUIImage
                                                                .resizable()
                                                                .frame(width: 20, height: 20)
                                                        } else {
                                                            sequential.type.image
                                                        }
                                                        Text(sequential.displayName)
                                                            .font(Theme.Fonts.titleSmall)
                                                            .multilineTextAlignment(.leading)
                                                            .lineLimit(1)
                                                            .frame(
                                                                maxWidth: idiom == .pad
                                                                ? proxy.size.width * 0.5
                                                                : proxy.size.width * 0.6,
                                                                alignment: .leading
                                                            )
                                                    }
                                                    if let sequentialProgress = sequential.sequentialProgress,
                                                       let assignmentType = sequentialProgress.assignmentType,
                                                       let numPointsEarned = sequentialProgress.numPointsEarned,
                                                       let numPointsPossible = sequentialProgress.numPointsPossible,
                                                       let due = sequential.due {
                                                        let daysRemaining = getAssignmentStatus(for: due)
                                                        Text("\(assignmentType) - \(daysRemaining) - \(numPointsEarned) / \(numPointsPossible)")
                                                            .font(Theme.Fonts.bodySmall)
                                                            .multilineTextAlignment(.leading)
                                                            .lineLimit(2)
                                                    }
                                                }
                                                .foregroundColor(Theme.Colors.textPrimary)
                                                .accessibilityElement(children: .ignore)
                                                .accessibilityLabel(sequential.displayName)
                                            }
                                        )
                                        Spacer()
                                        if sequential.due != nil {
                                            CoreAssets.chevronRight.swiftUIImage
                                                .foregroundColor(Theme.Colors.textPrimary)
                                        }
                                    }
                                    .padding(.vertical, 4)
                                }
                            }
                        }

                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Theme.Colors.datesSectionBackground)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(style: .init(lineWidth: 1, lineCap: .round, lineJoin: .round, miterLimit: 1))
                        .foregroundColor(Theme.Colors.cardViewStroke)
                )
            }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 8)
        .onFirstAppear {
            for chapter in course.childs {
                expandedSections[chapter.id] = false
            }
        }
    }
    
    private func deleteMessage(for chapter: CourseChapter) -> String {
        "\(CourseLocalization.Alert.deleteVideos) \"\(chapter.displayName)\"?"
    }
    
    func getAssignmentStatus(for date: Date) -> String {
        let calendar = Calendar.current
        let today = Date()
        
        if calendar.isDateInToday(date) {
            return CourseLocalization.Course.dueToday
        } else if calendar.isDateInTomorrow(date) {
            return CourseLocalization.Course.dueTomorrow
        } else if let daysUntil = calendar.dateComponents([.day], from: today, to: date).day, daysUntil > 0 {
            return CourseLocalization.dueIn(daysUntil)
        } else if let daysAgo = calendar.dateComponents([.day], from: date, to: today).day, daysAgo > 0 {
            return CourseLocalization.pastDue(daysAgo)
        } else {
            return ""
        }
    }
    
    private func canDownloadAllSections(in chapter: CourseChapter) -> Bool {
        for sequential in chapter.childs {
            if let state = viewModel.sequentialsDownloadState[sequential.id] {
                return true
            }
        }
        return false
    }
    
    private func downloadAllSubsections(in chapter: CourseChapter, state: DownloadViewState) {
        Task {
            var allBlocks: [CourseBlock] = []
            for sequential in chapter.childs {
                let blocks = await viewModel.collectBlocks(chapter: chapter, blockId: sequential.id, state: state)
                allBlocks.append(contentsOf: blocks)
            }
            await viewModel.download(
                state: state,
                blocks: allBlocks,
                sequentials: chapter.childs.filter({ $0.isDownloadable })
            )
        }
    }
    
    private func downloadAllButtonState(for chapter: CourseChapter) -> DownloadViewState? {
        if canDownloadAllSections(in: chapter) {
            let downloads = chapter.childs.filter({ viewModel.sequentialsDownloadState[$0.id] != nil })
            
            if downloads.contains(where: { viewModel.sequentialsDownloadState[$0.id] == .downloading }) {
                return .downloading
            } else if downloads.allSatisfy({ viewModel.sequentialsDownloadState[$0.id] == .finished }) {
                return .finished
            } else {
                return .available
            }
        }
        return nil
    }
    
}

#if DEBUG
struct CustomDisclosureGroup_Previews: PreviewProvider {
    
    static var previews: some View {
        
        // Sample data models
        let sampleCourseChapters: [CourseChapter] = [
            CourseChapter(
                blockId: "1",
                id: "1",
                displayName: "Chapter 1",
                type: .chapter,
                childs: [
                    CourseSequential(
                        blockId: "1-1",
                        id: "1-1",
                        displayName: "Sequential 1",
                        type: .sequential,
                        completion: 0,
                        childs: [
                            CourseVertical(
                                blockId: "1-1-1",
                                id: "1-1-1",
                                courseId: "1",
                                displayName: "Vertical 1",
                                type: .vertical,
                                completion: 0,
                                childs: []
                            ),
                            CourseVertical(
                                blockId: "1-1-2",
                                id: "1-1-2",
                                courseId: "1",
                                displayName: "Vertical 2",
                                type: .vertical,
                                completion: 1.0,
                                childs: []
                            )
                        ],
                        sequentialProgress: SequentialProgress(
                            assignmentType: "Advanced Assessment Tools",
                            numPointsEarned: 1,
                            numPointsPossible: 3
                        ),
                        due: Date()
                    ),
                    CourseSequential(
                        blockId: "1-2",
                        id: "1-2",
                        displayName: "Sequential 2",
                        type: .sequential,
                        completion: 1.0,
                        childs: [
                            CourseVertical(
                                blockId: "1-2-1",
                                id: "1-2-1",
                                courseId: "1",
                                displayName: "Vertical 3",
                                type: .vertical,
                                completion: 1.0,
                                childs: []
                            )
                        ],
                        sequentialProgress: SequentialProgress(
                            assignmentType: "Basic Assessment Tools",
                            numPointsEarned: 1,
                            numPointsPossible: 3
                        ),
                        due: Date()
                    )
                ]
            ),
            CourseChapter(
                blockId: "2",
                id: "2",
                displayName: "Chapter 2",
                type: .chapter,
                childs: [
                    CourseSequential(
                        blockId: "2-1",
                        id: "2-1",
                        displayName: "Sequential 3",
                        type: .sequential,
                        completion: 1.0,
                        childs: [
                            CourseVertical(
                                blockId: "2-1-1",
                                id: "2-1-1",
                                courseId: "2",
                                displayName: "Vertical 4",
                                type: .vertical,
                                completion: 1.0,
                                childs: []
                            ),
                            CourseVertical(
                                blockId: "2-1-2",
                                id: "2-1-2",
                                courseId: "2",
                                displayName: "Vertical 5",
                                type: .vertical,
                                completion: 1.0,
                                childs: []
                            )
                        ],
                        sequentialProgress: SequentialProgress(
                            assignmentType: "Advanced Assessment Tools",
                            numPointsEarned: 1,
                            numPointsPossible: 3
                        ),
                        due: Date()
                    )
                ]
            )
        ]
        
        let viewModel = CourseContainerViewModel(
            interactor: CourseInteractor.mock,
            authInteractor: AuthInteractor.mock,
            router: CourseRouterMock(),
            analytics: CourseAnalyticsMock(),
            config: ConfigMock(),
            connectivity: Connectivity(),
            manager: DownloadManagerMock(),
            storage: CourseStorageMock(),
            isActive: true,
            courseStart: Date(),
            courseEnd: nil,
            enrollmentStart: Date(),
            enrollmentEnd: nil, 
            lastVisitedBlockID: nil,
            coreAnalytics: CoreAnalyticsMock()
        )
        Task {
            await withTaskGroup(of: Void.self) { group in
                group.addTask {
                    await viewModel.getCourseBlocks(courseID: "courseId")
                }
                group.addTask {
                    await viewModel.getCourseDeadlineInfo(courseID: "courseId")
                }
            }
        }
        
        return GeometryReader { proxy in
            ScrollView {
                CustomDisclosureGroup(
                    course: CourseStructure(
                        id: "Id",
                        graded: false,
                        completion: 0,
                        viewYouTubeUrl: "",
                        encodedVideo: "",
                        displayName: "Course",
                        childs: sampleCourseChapters,
                        media: DataLayer.CourseMedia.init(image: DataLayer.Image(raw: "", small: "", large: "")),
                        certificate: nil,
                        org: "org",
                        isSelfPaced: false,
                        courseProgress: nil
                    ),
                    proxy: proxy,
                    viewModel: viewModel
                )
            }
        }
    }
}
#endif
