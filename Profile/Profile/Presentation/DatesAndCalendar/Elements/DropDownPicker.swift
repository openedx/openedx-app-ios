//
//  DropDownPicker.swift
//  Profile
//
//  Created by  Stepanok Ivan on 08.05.2024.
//

import SwiftUI
import Core
import Theme

public enum DropDownPickerState {
    case top
    case bottom
}

public enum DropDownColor: String {
    case accent
    case red
    case orange
    case yellow
    case green
    case blue
    case purple
    case brown
    
    var title: String {
        switch self {
        case .accent:
            ProfileLocalization.Calendar.DropdownColor.accent
        case .red:
            ProfileLocalization.Calendar.DropdownColor.red
        case .orange:
            ProfileLocalization.Calendar.DropdownColor.orange
        case .yellow:
            ProfileLocalization.Calendar.DropdownColor.yellow
        case .green:
            ProfileLocalization.Calendar.DropdownColor.green
        case .blue:
            ProfileLocalization.Calendar.DropdownColor.blue
        case .purple:
            ProfileLocalization.Calendar.DropdownColor.purple
        case .brown:
            ProfileLocalization.Calendar.DropdownColor.brown
        }
    }
    
    var color: Color {
        switch self {
        case .accent:
                .accentColor
        case .red:
                .red
        case .orange:
                .orange
        case .yellow:
                .yellow
        case .green:
                .green
        case .blue:
                .blue
        case .purple:
                .purple
        case .brown:
                .brown
        }
    }
}

struct DropDownPicker: View {
        
    struct DownPickerOption: Hashable {
        let title: String
        let color: Color?
        let colorString: String?
        
        init(title: String) {
            self.title = title
            self.color = nil
            self.colorString = nil
        }
        
        init(color: DropDownColor) {
            self.title = color.title
            self.color = color.color
            self.colorString = color.rawValue
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(title)
        }
        
        static func == (lhs: DownPickerOption, rhs: DownPickerOption) -> Bool {
            lhs.title == rhs.title
        }
    }
    
    @Binding var selection: DownPickerOption?
    @EnvironmentObject var themeManager: ThemeManager
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
                        .foregroundStyle(themeManager.theme.colors.textPrimary)
                        .font(Theme.Fonts.bodyMedium)
                    Spacer(minLength: 0)
                    Image(systemName: state == .top ? "chevron.up" : "chevron.down")
                        .foregroundColor(themeManager.theme.colors.textPrimary)
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
                .background(themeManager.theme.colors.background)
                .overlay {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(themeManager.theme.colors.textInputStroke, lineWidth: 1)
                        .padding(1)
                }

                if state == .bottom && showDropdown {
                    optionsView()
                        .overlay {
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(themeManager.theme.colors.textInputStroke, lineWidth: 1)
                                .padding(1)
                        }
                        .padding(.top, 4)
                }
            }
            .clipped()
            .background(themeManager.theme.colors.background)
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
                                .foregroundStyle(themeManager.theme.colors.textPrimary)
                            Spacer()
                        }
                        VStack {
                            Spacer()
                            if option != options.last {
                                themeManager.theme.colors.textInputStroke
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
