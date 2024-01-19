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
    
    @Environment (\.isHorizontal)
    private var isHorizontal
    
    @State var index = 0
    
    public init(router: WhatsNewRouter, viewModel: WhatsNewViewModel) {
        self.router = router
        self.viewModel = viewModel
    }
    
    public var body: some View {
        GeometryReader { reader in
            ZStack(alignment: isHorizontal ? .center : .bottom) {
                Theme.Colors.background
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
                            .foregroundColor(Theme.Colors.background)
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
                                Text(viewModel.newItems[viewModel.index].description)
                                    .font(Theme.Fonts.bodyMedium)
                                    .multilineTextAlignment(.center)
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
                            }).opacity(viewModel.index != 0 ? 1 : 0)
                            WhatsNewNavigationButton(
                                type: viewModel.index < viewModel.newItems.count - 1 ? .next : .done,
                                action: {
                                    if index < viewModel.newItems.count - 1 {
                                        withAnimation(.linear(duration: 0.3)) {
                                            index += 1
                                        }
                                    } else {
                                        router.showMainOrWhatsNewScreen(sourceScreen: viewModel.sourceScreen)
                                    }
                                }
                            )
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
                }
                
            }.onChange(of: index) { ind in
                withAnimation(.linear(duration: 0.3)) {
                    viewModel.index = ind
                }
            }
            .navigationTitle(WhatsNewLocalization.title)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing, content: {
                    Button(action: {
                        router.showMainOrWhatsNewScreen(sourceScreen: viewModel.sourceScreen)
                    }, label: {
                        Image(systemName: "xmark")
                            .foregroundColor(Theme.Colors.accentColor)
                    })
                })
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
            viewModel: WhatsNewViewModel(storage: WhatsNewStorageMock(), config: ConfigMock())
        )
        .loadFonts()
    }
}
#endif
