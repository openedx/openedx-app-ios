import SwiftUI
import Theme
import Core

struct CourseCompletionCarouselSlideView<DownloadBarsView: View>: View {
    
    // MARK: - Variables
    let viewModelProgress: CourseProgressViewModel
    let viewModelContainer: CourseContainerViewModel
    let isVideo: Bool
    let idiom: UIUserInterfaceIdiom
    let downloadQualityBars: (GeometryProxy) -> DownloadBarsView
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading) {
            headerView
            progressView
            sectionView
            Text("Show all")
        }
        .padding(16)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(style: .init(lineWidth: 1, lineCap: .round, lineJoin: .round, miterLimit: 1))
                .foregroundColor(Theme.Colors.cardViewStroke)
        )
    }
    
    // MARK: - Header View
    private var headerView: some View {
        Text(CourseLocalization.CourseContainer.Progress.title)
            .foregroundStyle(Theme.Colors.textPrimary)
            .font(Theme.Fonts.titleLarge)
            .frame(maxWidth: .infinity, alignment: .leading)
            .clipped()
    }
    
    // MARK: - Progress View
    private var progressView: some View {
        
        let progressPercentage = Int(ceil(viewModelProgress.overallProgressPercentage * 100))
        
        return HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Progress")
                    .font(Theme.Fonts.titleMedium)
                    .foregroundColor(Theme.Colors.textPrimary)
                    .accessibilityAddTraits(.isHeader)
                
                Text("You have completed \(progressPercentage)% of the course progress")
                    .font(Theme.Fonts.bodyMedium)
                    .foregroundColor(Theme.Colors.textPrimary)
                    .lineLimit(nil)
            }
            
            Spacer()
            
            CourseProgressCircleView(
                progressPercentage: viewModelProgress.overallProgressPercentage,
                size: 90
            )
            .accessibilityLabel(CourseLocalization.Accessibility.progressRing)
            .accessibilityValue(
                CourseLocalization.Accessibility.progressPercentageCompleted("\(progressPercentage)")
            )
        }
    }
    
    // MARK: - Section View
    private var sectionView: some View {
        VStack {
            GeometryReader { proxy in
                VStack(spacing: 18) {
                    if let course = isVideo
                        ? viewModelContainer.courseVideosStructure
                        : viewModelContainer.courseStructure {
                        if let progress = course.courseProgress,
                           progress.totalAssignmentsCount != 0 {
                            ZStack(alignment: .leading) {
                                GeometryReader { geometry in
                                    RoundedCorners(tl: 8, tr: 8, bl: 0, br: 0)
                                        .fill(Theme.Colors.courseProgressBG)
                                        .frame(width: geometry.size.width, height: 6)
                                    
                                    if let total = progress.totalAssignmentsCount,
                                       let completed = progress.assignmentsCompleted {
                                        RoundedCorners(tl: 8, tr: completed == total ? 8 : 0, bl: 0, br: 0)
                                            .fill(Theme.Colors.accentColor)
                                            .frame(width: geometry.size.width * CGFloat(completed) / CGFloat(total),
                                                   height: 6)
                                    }
                                }
                                .frame(height: 6)
                            }
                            .padding(.top, -10)
                        }
                    }
                    
                    VStack {
                        if let continueWith = viewModelContainer.continueWith,
                           let courseStructure = viewModelContainer.courseStructure {
                            let chapter = courseStructure.childs[continueWith.chapterIndex]
                            let sequential = chapter.childs[continueWith.sequentialIndex]
                            let continueUnit = sequential.childs[continueWith.verticalIndex]
                            
                            HStack {
                                Text("\(sequential.displayName)")
                                    .font(Theme.Fonts.titleMedium)
                                    .foregroundColor(Theme.Colors.textPrimary)
                                
                                Spacer()
                                
                                if isVideo, viewModelContainer.isShowProgress == false {
                                    downloadQualityBars(proxy)
                                }
                            }
                            
                            HStack {
                                CoreAssets.chapter.swiftUIImage
                                    .renderingMode(.template)
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                
                                Text(continueUnit.displayName)
                                    .font(Theme.Fonts.titleSmall)
                                    .multilineTextAlignment(.leading)
                                    .lineLimit(1)
                                    .frame(
                                        maxWidth: idiom == .pad
                                        ? proxy.size.width * 0.5
                                        : proxy.size.width * 0.6,
                                        alignment: .leading
                                    )
                                
                                Spacer()
                                
                                CoreAssets.chevronRight.swiftUIImage
                                    .foregroundColor(Theme.Colors.textPrimary)
                            }
                            .onTapGesture {
                                viewModelContainer.router.showCourseVerticalView(
                                    courseID: viewModelContainer.courseStructure?.id ?? "",
                                    courseName: viewModelContainer.courseStructure?.displayName ?? "",
                                    title: sequential.displayName,
                                    chapters: courseStructure.childs,
                                    chapterIndex: continueWith.chapterIndex,
                                    sequentialIndex: continueWith.sequentialIndex
                                )
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                }
                .frame(height: 96)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(style: StrokeStyle(lineWidth: 1, lineCap: .round, lineJoin: .round))
                        .foregroundColor(Theme.Colors.cardViewStroke)
                )
            }
            .frame(height: 96)
        }
    }
}

// MARK: - Preview
#if DEBUG
#Preview {
    CourseCompletionCarouselSlideView(
        viewModelProgress: CourseProgressViewModel(
            interactor: CourseInteractor.mock,
            router: CourseRouterMock(),
            analytics: CourseAnalyticsMock(),
            connectivity: Connectivity()
        ),
        viewModelContainer: CourseContainerViewModel(
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
            coreAnalytics: CoreAnalyticsMock(),
            courseHelper: CourseDownloadHelper(courseStructure: nil, manager: DownloadManagerMock())
        ),
        isVideo: false,
        idiom: .phone,
        downloadQualityBars: { _ in
            HStack(spacing: 4) {
                Capsule().fill(Color.gray.opacity(0.3)).frame(width: 12, height: 6)
                Capsule().fill(Color.gray.opacity(0.6)).frame(width: 12, height: 6)
                Capsule().fill(Color.gray).frame(width: 12, height: 6)
            }
        }
    )
    .padding(16)
    .frame(height: 327)
    .loadFonts()
}
#endif
