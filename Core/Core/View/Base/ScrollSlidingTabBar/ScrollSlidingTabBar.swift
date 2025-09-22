//
//  SwiftUIView.swift
//
//
//  Created by Eugene Yatsenko on 06/11/2023.
//

import SwiftUI
import Theme

public struct ScrollSlidingTabBar: View {
    
    @Binding private var selection: Int
    @State private var buttonFrames: [Int: CGRect] = [:]
    private let containerWidth: CGFloat
    private let tabs: [(String, Image)]
    private let style: Style
    private let onTap: ((Int) -> Void)?
    
    private var containerSpace: String {
        return "container"
    }
    
    public init(
        selection: Binding<Int>,
        tabs: [(String, Image)],
        style: Style = .default,
        containerWidth: CGFloat,
        onTap: ((Int) -> Void)? = nil) {
            self._selection = selection
            self.tabs = tabs
            self.style = style
            self.onTap = onTap
            self.containerWidth = containerWidth
        }
    
    public var body: some View {
        ZStack(alignment: .bottomLeading) {
            ScrollViewReader { proxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 0) {
                        buttons()
                        
                        ZStack(alignment: .leading) {
                            indicatorContainer()
                        }
                    }
                    .coordinateSpace(name: containerSpace)
                }
                .onTapGesture {}
                // Fix button tapable area bug – https://forums.developer.apple.com/forums/thread/745059
                .onAppear {
                        proxy.scrollTo(selection, anchor: .center)
                }
                .onChange(of: selection) { newValue in
                    withAnimation {
                        proxy.scrollTo(newValue, anchor: .center)
                    }
                }
            }
            .frameLimit(width: containerWidth)
        }
    }
    
}

extension ScrollSlidingTabBar {
    private func buttons() -> some View {
        HStack(spacing: 0) {
            ForEach(Array(tabs.enumerated()), id: \.offset) { obj in
                Button(
                    action: {
                        selection = obj.offset
                        onTap?(obj.offset)
                    },
                    label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .foregroundStyle(
                                    isSelected(index: obj.offset)
                                    ? style.activeAccentColor
                                    : style.inactiveAccentColor
                                )
                                .onTapGesture {
                                    selection = obj.offset
                                    onTap?(obj.offset)
                                }
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(
                                            isSelected(index: obj.offset)
                                            ? .clear
                                            : style.borderColor,
                                            lineWidth: style.borderHeight
                                        )
                                )
                            HStack {
                                obj.element.1.renderingMode(.template)
                                    .padding(.leading, 12)
                                Text(obj.element.0)
                                    .padding(.trailing, 12)
                                    .font(isSelected(index: obj.offset) ? style.selectedFont : style.font)
                            }
                            .accentColor(
                                isSelected(index: obj.offset)
                                ? Theme.Colors.slidingSelectedTextColor
                                : Theme.Colors.slidingTextColor
                            )
                        }
                        .frame( height: 40)
                        .fixedSize(horizontal: true, vertical: true)
                    }
                )
                .padding(.leading, obj.offset == 0 ? style.buttonLeadingPadding : 0)
                .padding(.trailing, obj.offset == tabs.count - 1 ? style.buttonTrailingPadding : 0)
                .padding(.horizontal, style.buttonHInset)
                .padding(.vertical, style.buttonVInset)
                .readFrame(in: .named(containerSpace)) {
                    buttonFrames[obj.offset] = $0
                }
                .id(obj.offset)
            }
        }
    }
    
    private func indicatorContainer() -> some View {
        Rectangle()
            .fill(Color.clear)
            .frame(width: tabWidth(), height: style.indicatorHeight)
            .overlay(indicator(), alignment: .center)
            .offset(x: selectionBarXOffset(), y: 0)
            .animation(.default, value: selection)
    }
    
    private func indicator() -> some View {
        Rectangle()
            .fill(style.activeAccentColor)
            .frame(width: indicatorWidth(selection: selection), height: style.indicatorHeight)
    }
}

extension ScrollSlidingTabBar {
    private func sanitizedSelection() -> Int {
        return max(0, min(tabs.count - 1, selection))
    }
    
    private func isSelected(index: Int) -> Bool {
        return sanitizedSelection() == index
    }
    
    private func selectionBarXOffset() -> CGFloat {
        return buttonFrames[sanitizedSelection()]?.minX ?? .zero
    }
    
    private func indicatorWidth(selection: Int) -> CGFloat {
        return max(tabWidth() - style.buttonHInset * 2, .zero)
    }
    
    private func tabWidth() -> CGFloat {
        return buttonFrames[sanitizedSelection()]?.width ?? .zero
    }
}

@MainActor
extension ScrollSlidingTabBar {
    public struct Style: Sendable {
        public let font: Font
        public let selectedFont: Font
        
        public let activeAccentColor: Color
        public let inactiveAccentColor: Color
        
        public let indicatorHeight: CGFloat
        
        public let borderColor: Color
        public let borderHeight: CGFloat
        
        public let buttonHInset: CGFloat
        public let buttonVInset: CGFloat
        
        public let buttonLeadingPadding: CGFloat
        public let buttonTrailingPadding: CGFloat
        
        public init(
            font: Font,
            selectedFont: Font,
            activeAccentColor: Color,
            inactiveAccentColor: Color,
            indicatorHeight: CGFloat,
            borderColor: Color,
            borderHeight: CGFloat,
            buttonHInset: CGFloat,
            buttonVInset: CGFloat,
            buttonLeadingPadding: CGFloat,
            buttonTrailingPadding: CGFloat
        ) {
            self.font = font
            self.selectedFont = selectedFont
            self.activeAccentColor = activeAccentColor
            self.inactiveAccentColor = inactiveAccentColor
            self.indicatorHeight = indicatorHeight
            self.borderColor = borderColor
            self.borderHeight = borderHeight
            self.buttonHInset = buttonHInset
            self.buttonVInset = buttonVInset
            self.buttonLeadingPadding = buttonLeadingPadding
            self.buttonTrailingPadding = buttonTrailingPadding
        }
        
        public static let `default` = Style(
            font: Theme.Fonts.titleSmall,
            selectedFont: Theme.Fonts.titleSmall,
            activeAccentColor: Theme.Colors.accentXColor,
            inactiveAccentColor: Theme.Colors.background,
            indicatorHeight: 0,
            borderColor: Theme.Colors.slidingStrokeColor,
            borderHeight: 1,
            buttonHInset: 4,
            buttonVInset: 2,
            buttonLeadingPadding: 8,
            buttonTrailingPadding: 8
        )
        
    }
}

#if DEBUG
private struct SlidingTabConsumerView: View {
    @State
    private var selection: Int = 0
    
    var body: some View {
        VStack(alignment: .leading) {
            ScrollSlidingTabBar(
                selection: $selection,
                tabs: [
                    ("First", Image(systemName: "1.circle")),
                    ("Second", Image(systemName: "2.circle")),
                    ("Third", Image(systemName: "3.circle")),
                    ("Fourth", Image(systemName: "4.circle")),
                    ("Fifth", Image(systemName: "5.circle")),
                    ("Sixth", Image(systemName: "6.circle"))
                ],
                containerWidth: 300
            )
            TabView(selection: $selection) {
                HStack {
                    Spacer()
                    Text("First View")
                    Spacer()
                }
                .tag(0)
                
                HStack {
                    Spacer()
                    Text("Second View")
                    Spacer()
                }
                .tag(1)
                
                HStack {
                    Spacer()
                    Text("Third View")
                    Spacer()
                }
                .tag(2)
                
                HStack {
                    Spacer()
                    Text("Fourth View")
                    Spacer()
                }
                .tag(3)
                
                HStack {
                    Spacer()
                    Text("Fifth View")
                    Spacer()
                }
                .tag(4)
                
                HStack {
                    Spacer()
                    Text("Sixth View")
                    Spacer()
                }
                .tag(5)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .animation(.default, value: selection)
        }
    }
}

struct ScrollSlidingTabBar_Previews: PreviewProvider {
    static var previews: some View {
        SlidingTabConsumerView()
    }
}
#endif
