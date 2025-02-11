//
//  DiscussionSearchTopicsView.swift
//  Discussion
//
//  Created by  Stepanok Ivan on 21.02.2023.
//

import SwiftUI
import Core
import OEXFoundation
import Theme

public struct DiscussionSearchTopicsView: View {
    
    @FocusState
    private var focused: Bool
    
    @ObservedObject private var viewModel: DiscussionSearchTopicsViewModel<RunLoop>
    @State private var animated: Bool = false
    
    public init(viewModel: DiscussionSearchTopicsViewModel<RunLoop>) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .top) {
                
                // MARK: - Page name
                VStack(alignment: .center) {
                    NavigationBar(title: DiscussionLocalization.search,
                                  leftButtonAction: { viewModel.router.backWithFade() })
                    .padding(.bottom, -7)

                    HStack(spacing: 11) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(Theme.Colors.textInputTextColor)
                            .padding(.leading, 16)
                            .padding(.top, -1)
                            .foregroundColor(
                                Theme.Colors.textInputTextColor
                            )
                        
                        TextField("",
                            text: $viewModel.searchText,
                            onEditingChanged: { editing in
                                viewModel.isSearchActive = editing
                            }
                        ).focused($focused)
                            .onAppear {
                                self.focused = true
                            }
                            .foregroundColor(Theme.Colors.textInputTextColor)
                            .font(Theme.Fonts.bodyMedium)
                        Spacer()
                        if !viewModel.searchText.trimmingCharacters(in: .whitespaces).isEmpty {
                            Button(action: { viewModel.searchText.removeAll() }, label: {
                                CoreAssets.clearInput.swiftUIImage
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 24)
                                    .padding(.horizontal)
                            })
                            .foregroundColor(Theme.Colors.styledButtonText)
                        }
                    }
                    .frame(minHeight: 48)
                    .background(
                        Theme.InputFieldBackground(
                            placeHolder: !viewModel.isSearchActive
                            ? DiscussionLocalization.search
                            : "",
                            text: viewModel.searchText,
                            padding: 48
                        )
                    )
                    .overlay(
                        Theme.Shapes.textInputShape
                            .stroke(lineWidth: 1)
                            .fill(viewModel.isSearchActive
                                  ? Theme.Colors.textInputTextColor
                                  : Theme.Colors.textInputUnfocusedStroke)
                    )
                    .frameLimit(width: proxy.size.width)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 20)
                    
                    ZStack {
                        ScrollView {
                            HStack {
                                searchHeader(viewModel: viewModel)
                                    .padding(.horizontal, 24)
                                    .padding(.bottom, 20)
                                    .offset(y: animated ? 0 : 50)
                                    .opacity(animated ? 1 : 0)
                                Spacer()
                            }
                            .padding(.leading, 10)
                            .frameLimit(width: proxy.size.width)
                            
                            LazyVStack {
                                let searchResults = Array(viewModel.searchResults.enumerated())
                                ForEach(searchResults, id: \.offset) { index, post in
                                    PostCell(post: post)
                                        .padding(24)
                                        .onAppear {
                                            Task.detached(priority: .high) {
                                                await viewModel.searchCourses(
                                                    index: index,
                                                    searchTerm: viewModel.searchText
                                                )
                                            }
                                        }
                                    if viewModel.searchResults.last != post {
                                        Divider().padding(.horizontal, 24)
                                    }
                                }
                                Spacer(minLength: 84)
                                
                                // MARK: - ProgressBar
                                if viewModel.fetchInProgress {
                                    VStack(alignment: .center) {
                                        ProgressBar(size: 40, lineWidth: 8)
                                            .padding(.top, 20)
                                    }.frame(maxWidth: .infinity,
                                            maxHeight: .infinity)
                                }
                            }
                            .id(UUID())
                            .frameLimit(width: proxy.size.width)

                            Spacer(minLength: 40)
                        }
                    }
                }
                // MARK: - Error Alert
                if viewModel.showError {
                    VStack {
                        Spacer()
                        SnackBarView(message: viewModel.errorMessage)
                    }
                    .transition(.move(edge: .bottom))
                    .onAppear {
                        doAfter(Theme.Timeout.snackbarMessageLongTimeout) {
                            viewModel.errorMessage = nil
                        }
                    }
                }
            }
            .background(Theme.Colors.background.ignoresSafeArea())
            .avoidKeyboard(dismissKeyboardByTap: true)
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
            .navigationTitle(DiscussionLocalization.search)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    withAnimation(.easeIn(duration: 0.3)) {
                        animated = true
                    }
                }
            }
        }
    }
    
    private func searchHeader(viewModel: DiscussionSearchTopicsViewModel<RunLoop>) -> some View {
        return VStack(alignment: .leading) {
            Text(DiscussionLocalization.Search.title)
                .font(Theme.Fonts.displaySmall)
                .foregroundColor(Theme.Colors.textPrimary)
            Text(searchDescription(viewModel: viewModel))
                .font(Theme.Fonts.titleSmall)
                .foregroundColor(Theme.Colors.textPrimary)
        }.listRowBackground(Color.clear)
    }
    
    private func searchDescription(viewModel: DiscussionSearchTopicsViewModel<RunLoop>) -> String {
        let searchEmptyDescription = DiscussionLocalization.Search.emptyDescription
        let searchDescription =  DiscussionLocalization.searchResultsDescription(
            viewModel.searchResults.isEmpty
            ? 0
            : viewModel.searchResults.count
        )
        let searchFieldEmpty = viewModel.searchText
            .trimmingCharacters(in: .whitespaces)
            .isEmpty
        if searchFieldEmpty {
            return searchEmptyDescription
        } else {
            return searchDescription
        }
    }
}

#if DEBUG
struct DiscussionSearchTopicsView_Previews: PreviewProvider {
    static var previews: some View {
        let vm = DiscussionSearchTopicsViewModel(
            courseID: "123",
            interactor: DiscussionInteractor.mock,
            storage: CoreStorageMock(),
            router: DiscussionRouterMock(),
            debounce: .searchDebounce
        )
        
        DiscussionSearchTopicsView(viewModel: vm)
    }
}
#endif
