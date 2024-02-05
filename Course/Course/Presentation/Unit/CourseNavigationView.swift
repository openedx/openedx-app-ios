//
//  CourseNavigationView.swift
//  Course
//
//  Created by  Stepanok Ivan on 14.02.2023.
//

import SwiftUI
import Core
import Combine

struct CourseNavigationView: View {
    
    @ObservedObject
    private var viewModel: CourseUnitViewModel
    private let sectionName: String
    private let playerStateSubject: CurrentValueSubject<VideoPlayerState?, Never>
    
    init(
        sectionName: String,
        viewModel: CourseUnitViewModel,
        playerStateSubject: CurrentValueSubject<VideoPlayerState?, Never>
    ) {
        self.viewModel = viewModel
        self.sectionName = sectionName
        self.playerStateSubject = playerStateSubject
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 7) {
            if viewModel.selectedLesson() == viewModel.verticals[viewModel.verticalIndex].childs.first
                && viewModel.verticals[viewModel.verticalIndex].childs.count != 1 {
                nextBigButton
                    .frame(width: 215)
            } else {
                if viewModel.selectedLesson() == viewModel.verticals[viewModel.verticalIndex].childs.last {
                    if viewModel.selectedLesson() != viewModel.verticals[viewModel.verticalIndex].childs.first {
                        prevButton
                    }
                    lastButton
                } else {
                    if viewModel.selectedLesson() != viewModel.verticals[viewModel.verticalIndex].childs.first {
                        prevButton
                    }
                    
                    nextButton
                }
            }
        }.padding(.horizontal, 24)
    }
    
    private var nextBigButton: some View {
        UnitButtonView(
            type: .nextBig,
            isVerticalNavigation: !viewModel.courseUnitProgressEnabled,
            action: {
                playerStateSubject.send(VideoPlayerState.pause)
                viewModel.select(move: .next)
            }
        )
    }
    
    private var nextButton: some View {
        UnitButtonView(
            type: .next,
            isVerticalNavigation: !viewModel.courseUnitProgressEnabled,
            action: {
                playerStateSubject.send(VideoPlayerState.pause)
                viewModel.select(move: .next)
            }
        )
    }
    
    private var prevButton: some View {
        UnitButtonView(
            type: .previous,
            isVerticalNavigation: !viewModel.courseUnitProgressEnabled,
            action: {
                playerStateSubject.send(VideoPlayerState.pause)
                viewModel.select(move: .previous)
            }
        )
    }
    
    private var lastButton: some View {
        UnitButtonView(
            type: .last,
            isVerticalNavigation: !viewModel.courseUnitProgressEnabled,
            action: {
                let currentVertical = viewModel.verticals[viewModel.verticalIndex]
                
                viewModel.router.presentAlert(
                    alertTitle: CourseLocalization.Courseware.goodWork,
                    alertMessage: (CourseLocalization.Courseware.section
                                   + currentVertical.displayName + CourseLocalization.Courseware.isFinished),
                    nextSectionName: {
                        if let data = viewModel.nextData,
                           let vertical = viewModel.vertical(for: data) {
                            return vertical.displayName
                        }
                        return nil
                    }(),
                    action: CourseLocalization.Courseware.backToOutline,
                    image: CoreAssets.goodWork.swiftUIImage,
                    onCloseTapped: { viewModel.router.dismiss(animated: false) },
                    okTapped: {
                        playerStateSubject.send(VideoPlayerState.pause)
                        playerStateSubject.send(VideoPlayerState.kill)
                        
                        viewModel.trackFinishVerticalBackToOutlineClicked()
                        viewModel.router.dismiss(animated: false)
                        viewModel.router.back(animated: true)
                    },
                    nextSectionTapped: {
                        playerStateSubject.send(VideoPlayerState.pause)
                        playerStateSubject.send(VideoPlayerState.kill)
                        viewModel.router.dismiss(animated: false)
                        
                        viewModel.analytics
                            .finishVerticalNextSectionClicked(
                                courseId: viewModel.courseID,
                                courseName: viewModel.courseName,
                                blockId: viewModel.selectedLesson().blockId,
                                blockName: viewModel.selectedLesson().displayName
                            )
                        
                        guard let data = viewModel.nextData else { return }
                        viewModel.router.replaceCourseUnit(
                            courseName: viewModel.courseName,
                            blockId: viewModel.lessonID,
                            courseID: viewModel.courseID,
                            sectionName: viewModel.selectedLesson().displayName,
                            verticalIndex: data.verticalIndex,
                            chapters: viewModel.chapters,
                            chapterIndex: data.chapterIndex,
                            sequentialIndex: data.sequentialIndex,
                            animated: true
                        )
                    }
                )
                playerStateSubject.send(VideoPlayerState.pause)
                viewModel.analytics.finishVerticalClicked(
                    courseId: viewModel.courseID,
                    courseName: viewModel.courseName,
                    blockId: viewModel.selectedLesson().blockId,
                    blockName: viewModel.selectedLesson().displayName
                )
            }
        )
    }
}

#if DEBUG
struct CourseNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = CourseUnitViewModel(
            lessonID: "1",
            courseID: "1",
            courseName: "Name",
            chapters: [],
            chapterIndex: 1,
            sequentialIndex: 1,
            verticalIndex: 1,
            interactor: CourseInteractor.mock, 
            config: ConfigMock(),
            router: CourseRouterMock(),
            analytics: CourseAnalyticsMock(),
            connectivity: Connectivity(),
            storage: CourseStorageMock(),
            manager: DownloadManagerMock()
        )
        
        CourseNavigationView(
            sectionName: "Name",
            viewModel: viewModel,
            playerStateSubject: CurrentValueSubject<VideoPlayerState?, Never>(nil)
        )
    }
}
#endif
