//
//  PickerMenu.swift
//  Core
//
//  Created by  Stepanok Ivan on 24.10.2022.
//

import SwiftUI
import Theme

public struct PickerItem: Hashable, Sendable {
    public let key: String
    public let value: String

    public static func == (lhs: PickerItem, rhs: PickerItem) -> Bool {
        return lhs.key == rhs.key
    }
    
    public init(key: String, value: String) {
        self.key = key
        self.value = value
    }
}

public struct PickerMenu: View {
    
    @State private var search: String = ""
    @State public var selectedItem: PickerItem = PickerItem(key: "", value: "")
    @Environment(\.isHorizontal) private var isHorizontal
    private let ipadPickerWidth: CGFloat = 300
    private var items: [PickerItem]
    private let titleText: String
    private let router: BaseRouter
    private var idiom: UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    private var selected: ((PickerItem) -> Void) = { _ in }
    private let emptyKey: String = "--empty--"

    public init(
        items: [PickerItem],
        titleText: String,
        router: BaseRouter,
        selectedItem: PickerItem? = nil,
        selected: @escaping (PickerItem) -> Void
    ) {
        self.items = items
        self.titleText = titleText
        self.router = router
        self._selectedItem = State(initialValue: selectedItem ?? items.first ?? PickerItem(key: "", value: ""))
        self.selected = selected
    }

    private var filteredItems: [PickerItem] {
        if search.isEmpty {
            return items.isEmpty ? [PickerItem(key: emptyKey, value: "")] : items
        } else {
            let filteredItems = items.filter { $0.value.localizedCaseInsensitiveContains(search) }
            return filteredItems.isEmpty ? [PickerItem(key: emptyKey, value: "")] : filteredItems
        }
    }

    private var isSingleSelection: Bool {
        return filteredItems.count == 1 && filteredItems.first?.key != emptyKey
    }

    private var isItemSelected: Bool {
        return filteredItems.contains(selectedItem) && selectedItem.key != emptyKey
    }

    private var acceptButtonDisabled: Bool {
        return !isItemSelected && !isSingleSelection
    }

    public var body: some View {
        VStack {
            ZStack(alignment: .bottom) {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        router.dismiss(animated: true)
                    }
                VStack {
                    Spacer()
                    VStack {
                        Text(titleText)
                            .foregroundColor(Theme.Colors.textPrimary)
                            .accessibilityIdentifier("picker_title_text")
                            .font(Theme.Fonts.bodyMedium)
                        TextField("", text: $search)
                            .padding(.all, 8)
                            .font(Theme.Fonts.bodySmall)
                            .overlay(
                                Theme.Shapes.textInputShape
                                    .stroke(lineWidth: 1)
                                    .fill(Theme.Colors.textInputStroke)
                            )
                            .background(
                                Theme.InputFieldBackground(
                                    placeHolder: CoreLocalization.Picker.search,
                                    text: search
                                )
                            )
                            .accessibilityIdentifier("picker_search_textfield")
                        Picker("", selection: $selectedItem) {
                            ForEach(filteredItems, id: \.self) { item in
                                Text(item.value)
                                    .foregroundColor(Theme.Colors.textPrimary)
                                    .font(Theme.Fonts.bodyMedium)
                            }
                        }
                        .pickerStyle(.wheel)
                        .accessibilityIdentifier("picker")
                    }
                    .frame(minWidth: 0,
                           maxWidth: (idiom == .pad || (idiom == .phone && isHorizontal))
                           ? ipadPickerWidth
                           : .infinity)

                    .padding()
                    .background(Theme.Colors.background.cornerRadius(16))
                    .padding(.horizontal, 16)
                    .onChange(of: search, perform: { _ in
                        if let first = filteredItems.first {
                            self.selectedItem = first
                        }
                    })
                    
                    Button(action: {
                        selected(selectedItem)
                        router.dismiss(animated: true)
                    }) {
                        Text(CoreLocalization.Picker.accept)
                            .font(Theme.Fonts.bodyMedium)
                            .foregroundColor(Theme.Colors.textPrimary)
                            .frame(minWidth: 0,
                                   maxWidth: (idiom == .pad || (idiom == .phone && isHorizontal))
                                   ? ipadPickerWidth
                                   : .infinity)
                            .padding()
                            .background(Theme.Colors.background.cornerRadius(16))
                            .padding(.horizontal, 16)
                    }
                    .padding(.bottom, 4)
                    .disabled(acceptButtonDisabled)
                    .accessibilityIdentifier("picker_accept_button")

                }
                .avoidKeyboard(dismissKeyboardByTap: true)
                .transition(.move(edge: .bottom))
            }
        }
         .transition(.opacity)
        
    }

}

#if DEBUG
struct PickerMenu_Previews: PreviewProvider {
    static var previews: some View {
        
        let items = [
        PickerItem(key: "Uk", value: "Ukraine"),
        PickerItem(key: "Us", value: "United States of America"),
        PickerItem(key: "En", value: "England")
        ]
        
        return PickerMenu(items: items,
                          titleText: "Select country",
                          router: BaseRouterMock(),
                          selectedItem: items.first,
                          selected: {_ in})
    }
}
#endif
