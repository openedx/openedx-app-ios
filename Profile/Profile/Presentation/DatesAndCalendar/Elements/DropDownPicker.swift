//
//  DropDownPicker.swift
//  Profile
//
//  Created by  Stepanok Ivan on 08.05.2024.
//

import SwiftUI
import Core
import Theme

enum DropDownPickerState {
    case top
    case bottom
}

struct DropDownPicker: View {
    
    struct DownPickerOption: Hashable {
        let title: String
        let color: Color?
        
        init(title: String, color: Color? = nil) {
            self.title = title
            self.color = color
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(title)
        }
        
        static func == (lhs: DownPickerOption, rhs: DownPickerOption) -> Bool {
            lhs.title == rhs.title
        }
    }
    
    @Binding var selection: DownPickerOption?
    var state: DropDownPickerState = .bottom
    var options: [DownPickerOption]
    
    @State var showDropdown = false
    
    @State private var index = 1000.0
    @State var zindex = 1000.0
    
    init(selection: Binding<DownPickerOption?>, state: DropDownPickerState, options: [DownPickerOption]) {
        self._selection = selection
        self.state = state
        self.options = options
    }
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            VStack(spacing: 0) {
                if state == .top && showDropdown {
                    optionsView()
                }
                HStack {
                    if let color = selection?.color {
                        Circle()
                            .frame(width: 18, height: 18)
                            .foregroundStyle(color)
                    }
                    Text(
                        selection == nil
                        ? ProfileLocalization.DropDownPicker.select
                        : selection!.title
                    )
                        .foregroundStyle(Theme.Colors.textPrimary)
                        .font(Theme.Fonts.bodyMedium)
                    Spacer(minLength: 0)
                    Image(systemName: state == .top ? "chevron.up" : "chevron.down")
                        .foregroundColor(Theme.Colors.textPrimary)
                        .rotationEffect(.degrees((showDropdown ? -180 : 0)))
                }
                .padding(.horizontal, 15)
                .contentShape(.rect)
                .onTapGesture {
                    index += 1
                    zindex = index
                    withAnimation(.bouncy(duration: 0.2)) {
                        showDropdown.toggle()
                    }
                }
                .zIndex(10)
                .frame(height: 48)
                .background(Theme.Colors.background)
                .overlay {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Theme.Colors.textInputStroke, lineWidth: 1)
                        .padding(1)
                }

                if state == .bottom && showDropdown {
                    optionsView()
                        .overlay {
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Theme.Colors.textInputStroke, lineWidth: 1)
                                .padding(1)
                        }
                        .padding(.top, 4)
                }
            }
            .clipped()
            .background(Theme.Colors.background)
            .cornerRadius(8)
            .frame(height: size.height, alignment: state == .top ? .bottom : .top)
            .onTapBackground(enabled: showDropdown, { showDropdown = false })
        }
        .frame(height: 48)
        .zIndex(zindex)
    }
    
    func optionsView() -> some View {
        
        func menuHeight() -> Double {
            if options.count < 3 {
                return Double(options.count * 56)
            } else {
                return 200.0
            }
        }
        
        return ScrollView {
            VStack(spacing: 0) {
                ForEach(options, id: \.self) { option in
                    ZStack {
                        HStack {
                            if let color = option.color {
                                Circle()
                                    .frame(width: 18, height: 18)
                                    .foregroundStyle(color)
                            }
                            Text(option.title)
                                .font(Theme.Fonts.bodyMedium)
                                .foregroundStyle(Theme.Colors.textPrimary)
                            Spacer()
//                        Image(systemName: "checkmark")
//                            .opacity(selection == option ? 1 : 0)
                        }
                        VStack {
                            Spacer()
                            if option != options.last {
                                Theme.Colors.textInputStroke
                                    .frame(height: 1)
                                    .padding(.top, 8)
                                    .frame(alignment: .bottom)
                            }
                        }
                    }
                    .foregroundStyle(selection == option ? Color.primary : Color.gray)
                    .animation(.easeIn(duration: 0.2), value: selection)
                    .frame(height: 56)
                    .contentShape(.rect)
                    .padding(.horizontal, 15)
                    .onTapGesture {
                        withAnimation(.easeIn(duration: 0.2)) {
                            selection = option
                            showDropdown.toggle()
                        }
                    }
                }
            }
            .padding(.top, 4)
        }.frame(height: menuHeight())
            .transition(.move(edge: state == .top ? .bottom : .top))
            .zIndex(1)
    }
}

#Preview {
    DropDownPicker(
        selection: .constant(.init(title: "Selected")),
        state: .bottom,
        options: [
            .init(title: "One"),
            .init(
                title: "Two"
            )
        ]
    )
    .loadFonts()
}
