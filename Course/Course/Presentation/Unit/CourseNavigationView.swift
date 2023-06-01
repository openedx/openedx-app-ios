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
    
    @ObservedObject private var viewModel: CourseUnitViewModel
    private let sectionName: String
    private let playerStateSubject: CurrentValueSubject<VideoPlayerState?, Never>
    
    init(sectionName: String,
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
                UnitButtonView(type: .previous, action: {}).opacity(0.5)
                UnitButtonView(type: .next, action: {
                    playerStateSubject.send(VideoPlayerState.pause)
                        viewModel.select(move: .next)
                })
            } else {
                if viewModel.selectedLesson() == viewModel.verticals[viewModel.verticalIndex].childs.last {
                    UnitButtonView(type: .previous, action: {
                        playerStateSubject.send(VideoPlayerState.pause)
                            viewModel.select(move: .previous)
                    }).opacity(viewModel.selectedLesson() == viewModel.verticals[viewModel.verticalIndex].childs.first
                               ? 0.5
                               : 1)
                    UnitButtonView(type: .last, action: {
                        
                        let sequentials = viewModel.chapters[viewModel.chapterIndex].childs
                        let verticals = viewModel.chapters[viewModel.chapterIndex].childs[viewModel.sequentialIndex].childs

                        viewModel.router.presentAlert(
                            alertTitle: CourseLocalization.Courseware.goodWork,
                            alertMessage: (CourseLocalization.Courseware.section
                                            + sectionName + CourseLocalization.Courseware.isFinished),
                            nextSectionName: {
                                if viewModel.chapters.count > viewModel.chapterIndex + 1 {
                                    return viewModel.chapters[viewModel.chapterIndex + 1].childs.first?.displayName
                                } else if !sequentials.isEmpty, sequentials.count > viewModel.sequentialIndex + 1 {
                                    return sequentials[viewModel.sequentialIndex + 1].childs.first?.displayName
                                } else if !verticals.isEmpty, verticals.count > viewModel.verticalIndex + 1 {
                                    return verticals[viewModel.verticalIndex + 1].displayName
                                } else {
                                    return nil
                                }
                            }(),
                            action: CourseLocalization.Courseware.backToOutline,
                            image: CoreAssets.goodWork.swiftUIImage,
                            onCloseTapped: { viewModel.router.dismiss(animated: false) },
                            okTapped: {
                                playerStateSubject.send(VideoPlayerState.pause)
                                playerStateSubject.send(VideoPlayerState.kill)
                                viewModel.router.dismiss(animated: false)
                                viewModel.router.back(animated: true)
                            },
                            nextSectionTapped: {
                                playerStateSubject.send(VideoPlayerState.pause)
                                playerStateSubject.send(VideoPlayerState.kill)
                                viewModel.router.dismiss(animated: false)
                                
                                let chapterIndex: Int
                                let sequentialIndex: Int
                                let verticalIndex: Int
                                
                                // Switch to the next Vertical
                                if verticals.count - 1 > viewModel.verticalIndex {
                                    chapterIndex = viewModel.chapterIndex
                                    sequentialIndex = viewModel.sequentialIndex
                                    verticalIndex = viewModel.verticalIndex + 1
                                    // Switch to the next Sequential
                                } else if sequentials.count - 1 > viewModel.sequentialIndex {
                                    chapterIndex = viewModel.chapterIndex
                                    sequentialIndex = viewModel.sequentialIndex + 1
                                    verticalIndex = 0
                                } else {
                                    // Switch to the next Chapter
                                    chapterIndex = viewModel.chapterIndex + 1
                                    sequentialIndex = 0
                                    verticalIndex = 0
                                }
                                
                                viewModel.router.replaceCourseUnit(
                                    blockId: viewModel.lessonID,
                                    courseID: viewModel.courseID,
                                    sectionName: viewModel.selectedLesson().displayName,
                                    verticalIndex: verticalIndex,
                                    chapters: viewModel.chapters,
                                    chapterIndex: chapterIndex,
                                    sequentialIndex: sequentialIndex)
                            }
                        )
                    })
                } else {
                    if viewModel.selectedLesson() != viewModel.verticals[viewModel.verticalIndex].childs.first {
                        UnitButtonView(type: .previous, action: {
                            playerStateSubject.send(VideoPlayerState.pause)
                            viewModel.select(move: .previous)
                        })
                    }
                    
                    UnitButtonView(type: .next, action: {
                        playerStateSubject.send(VideoPlayerState.pause)
                            viewModel.select(move: .next)
                    })
                }
            }
        }.frame(minWidth: 0, maxWidth: .infinity)
            .padding(.horizontal, 24)
    }
}

#if DEBUG
struct CourseNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = CourseUnitViewModel(lessonID: "1",
                                            courseID: "1",
                                            chapters: [],
                                            chapterIndex: 1,
                                            sequentialIndex: 1,
                                            verticalIndex: 1,
                                            interactor: CourseInteractor.mock,
                                            router: CourseRouterMock(),
                                            connectivity: Connectivity(),
                                            manager: DownloadManagerMock())
        
        CourseNavigationView(sectionName: "Name",
                             viewModel: viewModel,
                             playerStateSubject: CurrentValueSubject<VideoPlayerState?, Never>(nil)
        )
    }
}
#endif
