import SwiftUI

enum CarouselSection: Int, CaseIterable, Identifiable, Sendable {
    case progress
    case grade

    // MARK: Identifiable
    public var id: Int {
        rawValue
    }

    // MARK: Height
    var height: CGFloat {
        switch self {
        case .progress: return 326
        case .grade:    return 420
        }
    }

    // MARK: - Make Slide
    @MainActor @ViewBuilder
    func makeSlides<Content: View>(
        viewModelProgress: CourseProgressViewModel,
        viewModelContainer: CourseContainerViewModel,
        isVideo: Bool,
        @ViewBuilder downloadQualityBars: @escaping (GeometryProxy) -> Content
    ) -> some View {
        switch self {

        case .progress:
            CourseCompletionCarouselSlideView(
                viewModelProgress: viewModelProgress,
                viewModelContainer: viewModelContainer,
                isVideo: isVideo,
                idiom: UIDevice.current.userInterfaceIdiom
            ) { proxy in
                downloadQualityBars(proxy)
            }

        case .grade:
            CourseGradeCarouselSlideView(
                viewModelProgress: viewModelProgress,
                viewModelContainer: viewModelContainer
            )
        }
    }
}
