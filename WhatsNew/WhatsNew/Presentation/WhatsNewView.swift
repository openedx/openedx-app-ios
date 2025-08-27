//
//  WhatsNewView.swift
//  WhatsNew
//
//  Created by  Stepanok Ivan on 18.10.2023.
//

import SwiftUI
import Core
import Theme

public struct WhatsNewView: View {
    
    private let router: WhatsNewRouter
    
    @ObservedObject
    private var viewModel: WhatsNewViewModel
    
    @Environment(\.isHorizontal)
    private var isHorizontal
    
    @State var index = 0
    @EnvironmentObject var themeManager: ThemeManager
    
    public init(router: WhatsNewRouter, viewModel: WhatsNewViewModel) {
        self.router = router
        self.viewModel = viewModel
    }
    
    public var body: some View {
        GeometryReader { reader in
            ZStack(alignment: isHorizontal ? .center : .bottom) {
                themeManager.theme.colors.background
                    .ignoresSafeArea()
                adaptiveStack(isHorizontal: isHorizontal) {
                    TabView(selection: $index) {
                        ForEach(Array(viewModel.newItems.enumerated()), id: \.offset) { _, new in
                            adaptiveStack(isHorizontal: isHorizontal) {
                                ZStack(alignment: .center) {
                                    Image(new.image, bundle: Bundle(for: BundleToken.self))
                                        .resizable()
                                        .scaledToFit()
                                        .frame(minWidth: 250, maxWidth: 300)
                                        .padding(24)
                                        .accessibilityIdentifier("whatsnew_image")
                                }.frame(minHeight: 250, maxHeight: 416)
                                Spacer()
                            }
                        }
                    }.tabViewStyle(.page(indexDisplayMode: .never))
                }
                if isHorizontal {
                    HStack {
                        Spacer()
                        
                        Rectangle()
                            .foregroundColor(themeManager.theme.colors.background)
                            .frame(width: reader.size.width / 1.9)
                            .ignoresSafeArea()
                            .mask(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        .clear,
                                        .black,
                                        .black,
                                        .black,
                                        .black,
                                        .black,
                                        .black,
                                        .black,
                                        .black]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                    } .allowsHitTesting(false)
                }
                HStack {
                    if isHorizontal {
                        Spacer()
                    }
                    VStack(spacing: 16) {
                        VStack {
                            if !viewModel.newItems.isEmpty {
                                Text(viewModel.newItems[viewModel.index].title)
                                    .font(Theme.Fonts.titleMedium)
                                    .accessibilityIdentifier("title_text")
                                Text(viewModel.newItems[viewModel.index].description)
                                    .font(Theme.Fonts.bodyMedium)
                                    .multilineTextAlignment(.center)
                                    .accessibilityIdentifier("description_text")
                            }
                        }.frame(height: 100)
                            .allowsHitTesting(false)
                        
                        HStack(spacing: 36) {
                            WhatsNewNavigationButton(type: .previous, action: {
                                if index != 0 {
                                    withAnimation(.linear(duration: 0.3)) {
                                        index -= 1
                                    }
                                }
                            })
                            .opacity(viewModel.index != 0 ? 1 : 0)
                            .accessibilityIdentifier("previous_button")
                            WhatsNewNavigationButton(
                                type: viewModel.index < viewModel.newItems.count - 1 ? .next : .done,
                                action: {
                                    if index < viewModel.newItems.count - 1 {
                                        withAnimation(.linear(duration: 0.3)) {
                                            index += 1
                                        }
                                    } else {
                                        router.showMainOrWhatsNewScreen(
                                            sourceScreen: viewModel.sourceScreen,
                                            postLoginData: viewModel.postLoginData
                                        )
                                    }
                                    
                                    if viewModel.index == viewModel.newItems.count - 1 {
                                        viewModel.logWhatsNewDone()
                                    }
                                }
                            )
                            .accessibilityIdentifier("next_button")
                        }
                    }
                    .padding(.bottom, isHorizontal ? 0 : 52)
                    .padding(.horizontal, 24)
                    .frame(width: isHorizontal ? reader.size.width / 1.9 : nil)
                }
                VStack {
                    if isHorizontal {
                        Spacer()
                    }
                    PageControl(numberOfPages: viewModel.newItems.count, currentPage: viewModel.index)
                        .frame(height: isHorizontal ? 8 : nil)
                        .allowsHitTesting(false)
                        .padding(.top, isHorizontal ? 0 : 170)
                        .padding(.bottom, 8)
                        .accessibilityIdentifier("whatsnew_pagecontrol")
                }
                
            }.onChange(of: index) { ind in
                withAnimation(.linear(duration: 0.3)) {
                    viewModel.index = ind
                }
            }
            .navigationTitle(WhatsNewLocalization.title)
            .toolbar {
                ToolbarItem(
                    placement: .navigationBarTrailing,
                    content: {
                        Button(
                            action: {
                                router.showMainOrWhatsNewScreen(
                                    sourceScreen: viewModel.sourceScreen,
                                    postLoginData: viewModel.postLoginData
                                )
                                viewModel.logWhatsNewClose()
                            },
                            label: {
                        Image(systemName: "xmark")
                            .foregroundColor(themeManager.theme.colors.accentXColor)
                    })
                    .accessibilityIdentifier("close_button")
                })
            }
            .onFirstAppear {
                viewModel.logWhatsNewPopup()
            }
        }
    }
    
    class BundleToken {}
}

#if DEBUG
struct WhatsNewView_Previews: PreviewProvider {
    static var previews: some View {
        WhatsNewView(
            router: WhatsNewRouterMock(),
            viewModel: WhatsNewViewModel(
                storage: WhatsNewStorageMock(),
                analytics: WhatsNewAnalyticsMock()
            )
        )
        .loadFonts()
    }
}
#endif
