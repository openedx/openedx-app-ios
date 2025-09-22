//
//  SearchView.swift
//  Discovery
//
//  Created by Paul Maul on 10.02.2023.
//

import SwiftUI
import Core
import OEXFoundation
import Theme

public struct SearchView: View {
    
    @FocusState
    private var focused: Bool
    
    @ObservedObject
    private var viewModel: SearchViewModel<RunLoop>
    @State private var animated: Bool = false
    
    public init(viewModel: SearchViewModel<RunLoop>, searchQuery: String? = nil) {
        self.viewModel = viewModel
        self.viewModel.searchText = searchQuery ?? ""
        self.viewModel.isSearchActive = !(searchQuery?.isEmpty ?? false)
    }
    
    public var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .top) {
                
                // MARK: - Page name
                VStack(alignment: .center) {
                    NavigationBar(title: DiscoveryLocalization.search,
                                  leftButtonAction: {
                        viewModel.router.backWithFade()
                    }).padding(.bottom, -7)
                    
                    HStack(spacing: 11) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(Theme.Colors.textPrimary)
                            .padding(.leading, 16)
                            .padding(.top, 1)
                            .foregroundColor(
                                viewModel.isSearchActive
                                ? Theme.Colors.accentColor
                                : Theme.Colors.textPrimary
                            )
                            .accessibilityHidden(true)
                            .accessibilityIdentifier("search_image")
                        
                        TextField(
                            !viewModel.isSearchActive
                            ? DiscoveryLocalization.search
                            : "",
                            text: $viewModel.searchText,
                            onEditingChanged: { editing in
                                viewModel.isSearchActive = editing
                            }
                        ).focused($focused)
                            .onAppear {
                                self.focused = true
                            }
                            .foregroundColor(Theme.Colors.textInputTextColor)
                            .font(Theme.Fonts.bodyLarge)
                            .accessibilityIdentifier("search_textfields")
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
                            .accessibilityIdentifier("search_button")
                        }
                    }
                    .frame(minHeight: 48)
                    .frame(maxWidth: .infinity)
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
                    .frameLimit(width: proxy.size.width)
                    
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
                                let searchResults = viewModel.searchResults.enumerated()
                                let useRelativeDates = viewModel.storage.useRelativeDates
                                ForEach(
                                    Array(searchResults), id: \.offset) { index, course in
                                        CourseCellView(
                                            model: course,
                                            type: .discovery,
                                            index: index,
                                            cellsCount: viewModel.searchResults.count,
                                            useRelativeDates: useRelativeDates
                                        )
                                        .padding(.horizontal, 24)
                                        .onAppear {
                                            Task {
                                                await viewModel.searchCourses(
                                                    index: index,
                                                    searchTerm: viewModel.searchText
                                                )
                                            }
                                        }
                                        .onTapGesture {
                                            viewModel.router.showCourseDetais(
                                                courseID: course.courseID,
                                                title: course.name
                                            )
                                        }
                                    }
                                // MARK: - ProgressBar
                                if viewModel.fetchInProgress {
                                    VStack(alignment: .center) {
                                        ProgressBar(size: 40, lineWidth: 8)
                                            .padding(.top, 20)
                                    }.frame(maxWidth: .infinity,
                                            maxHeight: .infinity)
                                }
                            }
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
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    withAnimation(.easeIn(duration: 0.3)) {
                        animated = true
                    }
                }
            }
            
            .onDisappear {
                viewModel.searchText = ""
            }
            .avoidKeyboard(dismissKeyboardByTap: true)
            .background(Theme.Colors.background.ignoresSafeArea())
        }
    }
    
    private func searchHeader(viewModel: SearchViewModel<RunLoop>) -> some View {
        return VStack(alignment: .leading) {
            Text(DiscoveryLocalization.Search.title)
                .font(Theme.Fonts.displaySmall)
                .foregroundColor(Theme.Colors.textPrimary)
                .accessibilityIdentifier("title_text")
            Text(searchDescription(viewModel: viewModel))
                .font(Theme.Fonts.titleSmall)
                .foregroundColor(Theme.Colors.textPrimary)
                .accessibilityIdentifier("description_text")
        }.listRowBackground(Color.clear)
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(DiscoveryLocalization.Search.title + searchDescription(viewModel: viewModel))
    }
    
    private func searchDescription(viewModel: SearchViewModel<RunLoop>) -> String {
        let searchEmptyDescription = DiscoveryLocalization.Search.emptyDescription
        let searchDescription =  DiscoveryLocalization.searchResultsDescription(
            viewModel.searchResults.isEmpty
            ? 0
            : viewModel.searchResults[0].coursesCount
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
struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        let router = DiscoveryRouterMock()
        let vm = SearchViewModel(
            interactor: DiscoveryInteractor.mock,
            connectivity: Connectivity(),
            router: router,
            analytics: DiscoveryAnalyticsMock(),
            storage: CoreStorageMock(),
            debounce: .searchDebounce
        )
        
        SearchView(viewModel: vm)
            .preferredColorScheme(.light)
            .previewDisplayName("SearchView Light")
        
        SearchView(viewModel: vm)
            .preferredColorScheme(.dark)
            .previewDisplayName("SearchView Dark")
    }
}
#endif
