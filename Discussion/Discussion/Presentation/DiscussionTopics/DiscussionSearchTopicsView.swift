//
//  DiscussionSearchTopicsView.swift
//  Discussion
//
//  Created by  Stepanok Ivan on 21.02.2023.
//

import SwiftUI
import Core

public struct DiscussionSearchTopicsView: View {
    
    @ObservedObject private var viewModel: DiscussionSearchTopicsViewModel<RunLoop>
    @State private var animated: Bool = false
    @State private var becomeFirstResponderRunOnce = false
    
    public init(viewModel: DiscussionSearchTopicsViewModel<RunLoop>) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        ZStack(alignment: .top) {
            
            // MARK: - Page name
            VStack(alignment: .center) {
                NavigationBar(title: DiscussionLocalization.search,
                leftButtonAction: { viewModel.router.backWithFade() })
                
                HStack(spacing: 11) {
                    Image(systemName: "magnifyingglass")
                        .padding(.leading, 16)
                        .padding(.top, -1)
                        .foregroundColor(
                            viewModel.isSearchActive
                            ? Theme.Colors.accentColor
                            : Theme.Colors.textPrimary
                        )
                    
                    TextField(
                        !viewModel.isSearchActive
                        ? DiscussionLocalization.search
                        : "",
                        text: $viewModel.searchText,
                        onEditingChanged: { editing in
                            viewModel.isSearchActive = editing
                        }
                    )
                    .introspect(.textField, on: .iOS(.v14, .v15, .v16, .v17), customize: { textField in
                        if !becomeFirstResponderRunOnce {
                            textField.becomeFirstResponder()
                            self.becomeFirstResponderRunOnce = true
                        }
                    })
                    .foregroundColor(Theme.Colors.textPrimary)
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
                .padding(.top, 3)
                .frame(minHeight: 48)
                .frame(maxWidth: 532)
                .background(
                    Theme.Shapes.textInputShape
                        .fill(viewModel.isSearchActive
                              ? Theme.Colors.textInputBackground
                              : Theme.Colors.textInputUnfocusedBackground)
                )
                .overlay(
                    Theme.Shapes.textInputShape
                        .stroke(lineWidth: 1)
                        .fill(viewModel.isSearchActive
                              ? Theme.Colors.accentColor
                              : Theme.Colors.textInputUnfocusedStroke)
                )
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
                        }.padding(.leading, 10)
                        
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
                        Spacer(minLength: 40)
                    }.frameLimit()
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
        }.hideNavigationBar()
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    withAnimation(.easeIn(duration: 0.3)) {
                        animated = true
                    }
                }
            }
            .background(Theme.Colors.background.ignoresSafeArea())
            .addTapToEndEditing(isForced: true)
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
            router: DiscussionRouterMock(),
            debounce: .searchDebounce
        )
        
        DiscussionSearchTopicsView(viewModel: vm)
    }
}
#endif
