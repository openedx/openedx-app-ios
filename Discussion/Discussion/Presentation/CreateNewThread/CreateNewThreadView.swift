//
//  CreateNewThreadView.swift
//  Discussion
//
//  Created by  Stepanok Ivan on 03.11.2022.
//

import SwiftUI
import Core

public struct CreateNewThreadView: View {
    
    @State private var postType: PostType = .discussion
    @State private var postTypes: [PostType] = [.discussion, .question]
    @State private var postTitle: String = ""
    @State private var postBody: String = ""
    @State private var followPost: Bool = false
    private var onPostCreated: (() -> Void) = {}
    private var courseID: String
    
    @Environment(\.colorScheme) var colorScheme
    
    @ObservedObject
    private var viewModel: CreateNewThreadViewModel
    
    public init(
        viewModel: CreateNewThreadViewModel,
        selectedTopic: String,
        courseID: String,
        onPostCreated: @escaping () -> Void
    ) {
        self.viewModel = viewModel
        self.onPostCreated = onPostCreated
        self.courseID = courseID
        viewModel.selectedTopic = selectedTopic
        Task {
            await viewModel.getTopics(courseID: courseID)
        }
        UISegmentedControl.appearance().selectedSegmentTintColor = CoreAssets.accentColor.color
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
    }
    
    public var body: some View {
        ZStack(alignment: .top) {
            
            // MARK: - Page name
            VStack(alignment: .center) {
                NavigationBar(title: DiscussionLocalization.CreateThread.newPost,
                              leftButtonAction: { viewModel.router.back() })
                
                // MARK: - Page Body
                if viewModel.isShowProgress {
                    HStack(alignment: .center) {
                        ProgressBar(size: 40, lineWidth: 8)
                            .padding(20)
                    }.frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollView {
                        VStack(alignment: .leading) {
                            HStack {
                                Text(DiscussionLocalization.CreateThread.selectPostType)
                                    .font(Theme.Fonts.titleMedium)
                                    .foregroundColor(CoreAssets.textPrimary.swiftUIColor)
                                    .padding(.top, 32)
                                Spacer()
                            }
                            
                            Picker("", selection: $postType) {
                                ForEach(postTypes, id: \.self) {
                                    Text($0.localizedValue.capitalized)
                                }
                            }.pickerStyle(.segmented)
                                .frame(maxWidth: .infinity, maxHeight: 40)
                            
                            // MARK: Topic picker
                            Group {
                                Text(DiscussionLocalization.CreateThread.topic)
                                    .font(Theme.Fonts.titleSmall)
                                    .padding(.top, 16)
                                
                                Menu {
                                    Picker(selection: $viewModel.selectedTopic) {
                                        ForEach(viewModel.allTopics, id: \.id) {
                                            Text($0.name)
                                                .tag($0.id)
                                                .font(Theme.Fonts.labelLarge)
                                        }
                                    } label: {}
                                } label: {
                                    HStack {
                                        Text(viewModel.allTopics.first(where: {
                                            $0.id == viewModel.selectedTopic })?.name ?? "")
                                        .font(Theme.Fonts.labelLarge)
                                        .frame(height: 40, alignment: .leading)
                                        Spacer()
                                        Image(systemName: "chevron.down")
                                    }.padding(.horizontal, 14)
                                        .accentColor(CoreAssets.textPrimary.swiftUIColor)
                                        .background(Theme.Shapes.textInputShape
                                            .fill(CoreAssets.textInputBackground.swiftUIColor)
                                        )
                                        .overlay(
                                            Theme.Shapes.textInputShape
                                                .stroke(lineWidth: 1)
                                                .fill(CoreAssets.textInputStroke.swiftUIColor)
                                        )
                                }
                            }
                            // MARK: End of topic picker
                            
                            Group {
                                Text(DiscussionLocalization.CreateThread.title)
                                    .font(Theme.Fonts.titleSmall)
                                + Text(" *").foregroundColor(.red)
                            }.padding(.top, 16)
                            TextField("", text: $postTitle)
                                .font(Theme.Fonts.labelLarge)
                                .padding(14)
                                .frame(height: 40)
                                .background(
                                    Theme.Shapes.textInputShape
                                        .fill(CoreAssets.textInputBackground.swiftUIColor)
                                )
                                .overlay(
                                    Theme.Shapes.textInputShape
                                        .stroke(lineWidth: 1)
                                        .fill(
                                            CoreAssets.textInputStroke.swiftUIColor
                                        )
                                )
                            
                            Group {
                                Text("\(postType.localizedValue.capitalized)")
                                    .font(Theme.Fonts.titleSmall)
                                + Text(" *").foregroundColor(.red)
                            }.padding(.top, 16)
                            TextEditor(text: $postBody)
                                .font(Theme.Fonts.labelLarge)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 10)
                                .frame(height: 200)
                                .hideScrollContentBackground()
                                .background(
                                    Theme.Shapes.textInputShape
                                        .fill(CoreAssets.textInputBackground.swiftUIColor)
                                )
                                .overlay(
                                    Theme.Shapes.textInputShape
                                        .stroke(lineWidth: 1)
                                        .fill(
                                            CoreAssets.textInputStroke.swiftUIColor
                                        )
                                )
                            
                            CheckBoxView(checked: $followPost,
                                         text: postType == .discussion
                                         ? DiscussionLocalization.CreateThread.followDiscussion
                                         : DiscussionLocalization.CreateThread.followQuestion
                            )
                            .padding(.top, 16)
                            
                            StyledButton(postType == .discussion
                                         ? DiscussionLocalization.CreateThread.createDiscussion
                                         : DiscussionLocalization.CreateThread.createQuestion, action: {
                                if postTitle != "" && postBody != "" {
                                    let newThread = DiscussionNewThread(courseID: courseID,
                                                                        topicID: viewModel.selectedTopic,
                                                                        type: postType,
                                                                        title: postTitle,
                                                                        rawBody: postBody,
                                                                        followPost: followPost)
                                    Task {
                                        if await viewModel.createNewThread(newThread: newThread) {
                                            onPostCreated()
                                        }
                                    }
                                }
                            })
                            .padding(.top, 26)
                            .saturation(!postTitle.isEmpty && !postBody.isEmpty ? 1 : 0)
                            Spacer()
                        }.padding(.horizontal, 24)
                            .frameLimit()
                            .onRightSwipeGesture {
                                viewModel.router.back()
                            }
                    }.scrollAvoidKeyboard(dismissKeyboardByTap: true)
                }
            }
        }
        .background(
            CoreAssets.background.swiftUIColor
                .ignoresSafeArea()
        )
    }
}

#if DEBUG
struct AddTopic_Previews: PreviewProvider {
    static var previews: some View {
        let vm = CreateNewThreadViewModel(
            interactor: DiscussionInteractor.mock,
            router: DiscussionRouterMock(),
            config: ConfigMock())
        
        CreateNewThreadView(
            viewModel: vm,
            selectedTopic: "",
            courseID: "",
            onPostCreated: {}
        )
        .preferredColorScheme(.light)
        .previewDisplayName("CreateNewThreadView Light")
        .loadFonts()
        
        CreateNewThreadView(
            viewModel: vm,
            selectedTopic: "",
            courseID: "",
            onPostCreated: {}
        )
        .preferredColorScheme(.dark)
        .previewDisplayName("CreateNewThreadView Dark")
        .loadFonts()
    }
}
#endif

extension UISegmentedControl {
    override open func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.setContentHuggingPriority(.defaultLow, for: .vertical)
    }
}
