//
//  CourseNavigationView.swift
//  Course
//
//  Created by  Stepanok Ivan on 14.02.2023.
//

import SwiftUI
import Core

struct CourseNavigationView: View {
    
    @ObservedObject private var viewModel: CourseUnitViewModel
    private let sectionName: String
    @Binding var killPlayer: Bool

    init(sectionName: String, viewModel: CourseUnitViewModel, killPlayer: Binding<Bool>) {
        self.viewModel = viewModel
        self.sectionName = sectionName
        self._killPlayer = killPlayer
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 24) {
            if viewModel.selectedLesson() == viewModel.verticals[viewModel.selectedVertical].childs.first
                && viewModel.verticals[viewModel.selectedVertical].childs.count != 1 {
                UnitButtonView(type: .first, action: {
                    killPlayer.toggle()
                    withAnimation {
                        viewModel.select(move: .next)
//                        viewModel.createLessonType()
                    }
                })
            } else {
               
                if viewModel.previousLesson != "" {
                    UnitButtonView(type: .previous, action: {
                        killPlayer.toggle()
                        withAnimation {
                            viewModel.select(move: .previous)
//                            viewModel.createLessonType()
                        }
                        
                    })
                }
                if viewModel.nextLesson != "" {
                    UnitButtonView(type: .next, action: {
                        killPlayer.toggle()
                        viewModel.select(move: .next)
//                        viewModel.createLessonType()
                    })
                }
                if viewModel.selectedLesson() == viewModel.verticals[viewModel.selectedVertical].childs.last {
//                    var nextSeсtionName: String? = nil
//                    if viewModel.selectedVertical < viewModel.verticals.count - 1 {
//                        nextSeсtionName = viewModel.verticals[viewModel.selectedVertical + 1].displayName
//                    }
                    UnitButtonView(type: viewModel.verticals[viewModel.selectedVertical].childs.count == 1 ? .finish : .last, action: {
                        viewModel.router.presentAlert(
                            alertTitle: CourseLocalization.Courseware.goodWork,
                            alertMessage: (CourseLocalization.Courseware.section
                                           + " " + sectionName + " " + CourseLocalization.Courseware.isFinished),
                            nextSectionName: viewModel.selectedVertical < viewModel.verticals.count - 1 ?
                            viewModel.verticals[viewModel.selectedVertical + 1].displayName
                            : nil,
                            action: CourseLocalization.Courseware.backToOutline,
                            image: CoreAssets.goodWork.swiftUIImage,
                            onCloseTapped: {},
                            okTapped: {
                                killPlayer.toggle()
                                viewModel.router.dismiss(animated: false)
                                viewModel.router.removeLastView(controllers: 2)
                            },
                            nextSectionTapped: {
                                viewModel.index = 0
                                viewModel.selectedVertical += 1
                            }
                        )
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
//                                            blocks: [],
                                            verticals: [],
                                            selectedVertical: 1,
                                            interactor: CourseInteractor.mock,
                                            router: CourseRouterMock(),
                                            connectivity: Connectivity(),
                                            manager: DownloadManagerMock())
        
        CourseNavigationView(sectionName: "Name", viewModel: viewModel, killPlayer: .constant(false))
    }
}
#endif
