//
//  WhatsNewView.swift
//  WhatsNew
//
//  Created by  Stepanok Ivan on 18.10.2023.
//

import SwiftUI
import Core

public struct WhatsNewView: View {

    @ObservedObject
    private var viewModel: WhatsNewViewModel
    
    @Environment (\.isHorizontal)
    private var isHorizontal
    
    @State var index = 0
    
    public init(viewModel: WhatsNewViewModel) {
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
                                    Image(new.image, bundle: Bundle(for: ___.self))
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
                            CustomButton(type: .previous, action: {
                                if index != 0 {
                                    withAnimation(.linear(duration: 0.3)) {
                                        index -= 1
                                    }
                                }
                            }).opacity(index != 0 ? 1 : 0)
                            CustomButton(type: viewModel.index < viewModel.newItems.count - 1 ? .next : .done, action: {
                                if index < viewModel.newItems.count - 1 {
                                    withAnimation(.linear(duration: 0.3)) {
                                        index += 1
                                    }
                                } else {
                                    viewModel.router.showMainScreen()
                                }
                            }
                                         )
//                            if viewModel.index < viewModel.newItems.count - 1 {
//                                CustomButton(type: .next, action: {
//                                    if index < viewModel.newItems.count - 1 {
//                                        withAnimation(.linear(duration: 0.3)) {
//                                            index += 1
//                                        }
//                                    }
//                                })
//                            } else {
//                                CustomButton(type: .done, action: {
//                                    viewModel.router.showMainScreen()
//                                })
//                            }
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
            .navigationTitle("What's New?")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing, content: {
                    Button(action: {
                        viewModel.router.showMainScreen()
                    }, label: {
                        Image(systemName: "xmark")
                            .foregroundColor(Theme.Colors.accentColor)
                    })
                })
            }
        }
    }
    
    // swiftlint:disable type_name
    class ___ {}
    // swiftlint:enable type_name
    
}

#if DEBUG
struct WhatsNewView_Previews: PreviewProvider {
    static var previews: some View {
        WhatsNewView(viewModel: WhatsNewViewModel(router: WhatsNewRouterMock()))
            .loadFonts()
    }
}
#endif
