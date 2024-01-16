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
    
    private let tabs: [String]
    private let style: Style
    private let onTap: ((Int) -> Void)?

    private var containerSpace: String {
        return "container"
    }
    
    public init(
        selection: Binding<Int>,
        tabs: [String],
        style: Style = .default,
        onTap: ((Int) -> Void)? = nil)
    {
        self._selection = selection
        self.tabs = tabs
        self.style = style
        self.onTap = onTap
    }
    
    public var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    buttons()
                    
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .fill(style.borderColor)
                            .frame(height: style.borderHeight, alignment: .leading)
                        indicatorContainer()
                    }
                }
                .coordinateSpace(name: containerSpace)
            }
            .onChange(of: selection) { newValue in
                withAnimation {
                    proxy.scrollTo(newValue, anchor: .center)
                }
            }
        }
    }
    
}

extension ScrollSlidingTabBar {
    private func buttons() -> some View {
        HStack(spacing: 0) {
            ForEach(Array(tabs.enumerated()), id: \.offset) { obj in
                Button {
                    selection = obj.offset
                    onTap?(obj.offset)
                } label: {
                    HStack {
                        Text(obj.element)
                            .font(isSelected(index: obj.offset) ? style.selectedFont : style.font)
                    }
                    .padding(.horizontal, style.buttonHInset)
                    .padding(.vertical, style.buttonVInset)
                }
                .accentColor(
                    isSelected(index: obj.offset) ? style.activeAccentColor : style.inactiveAccentColor
                )
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

extension ScrollSlidingTabBar {
    public struct Style {
        public let font: Font
        public let selectedFont: Font
        
        public let activeAccentColor: Color
        public let inactiveAccentColor: Color
        
        public let indicatorHeight: CGFloat
        
        public let borderColor: Color
        public let borderHeight: CGFloat
        
        public let buttonHInset: CGFloat
        public let buttonVInset: CGFloat
        
        public init(
            font: Font,
            selectedFont: Font,
            activeAccentColor: Color,
            inactiveAccentColor: Color,
            indicatorHeight: CGFloat,
            borderColor: Color,
            borderHeight: CGFloat,
            buttonHInset: CGFloat,
            buttonVInset: CGFloat
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
        }
        
        public static let `default` = Style(
            font: .body,
            selectedFont: .body.bold(),
            activeAccentColor: Theme.Colors.accentColor ,
            inactiveAccentColor: .black.opacity(0.4),
            indicatorHeight: 2,
            borderColor: .gray.opacity(0.2),
            borderHeight: 1,
            buttonHInset: 16,
            buttonVInset: 10
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
                tabs: ["First", "Second", "Third", "Fourth", "Fifth", "Sixth"]
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
