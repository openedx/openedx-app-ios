//
//  PickerMenu.swift
//  Core
//
//  Created by  Stepanok Ivan on 24.10.2022.
//

import SwiftUI

public struct PickerItem: Hashable {
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
    @Environment (\.isHorizontal) private var isHorizontal
    private let ipadPickerWidth: CGFloat = 300
    private var items: [PickerItem]
    private let titleText: String
    private let router: BaseRouter
    private var idiom: UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    private var selected: ((PickerItem) -> Void) = { _ in }

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
            return items
        } else {
            return items.filter { $0.value.localizedCaseInsensitiveContains(search) }
        }
    }

    private var isSingleSelection: Bool {
        return filteredItems.count == 1
    }

    private var isItemSelected: Bool {
        return filteredItems.contains(selectedItem)
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
                        TextField(CoreLocalization.Picker.search, text: $search)
                            .padding(.all, 8)
                            .background(Theme.Colors.textInputStroke.cornerRadius(6))
                        Picker("", selection: $selectedItem) {
                            ForEach(filteredItems, id: \.self) { item in
                                Text(item.value)
                                    .foregroundColor(Theme.Colors.textPrimary)
                            }
                        }
                        .pickerStyle(.wheel)
                    }
                    .frame(minWidth: 0, 
                           maxWidth: (idiom == .pad || (idiom == .phone && isHorizontal))
                           ? ipadPickerWidth
                           : .infinity)

                    .padding()
                    .background(Theme.Colors.textInputBackground.cornerRadius(16))
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
                            .foregroundColor(Theme.Colors.textPrimary)
                            .frame(minWidth: 0,
                                   maxWidth: (idiom == .pad || (idiom == .phone && isHorizontal))
                                   ? ipadPickerWidth
                                   : .infinity)
                            .padding()
                            .background(Theme.Colors.textInputBackground.cornerRadius(16))
                            .padding(.horizontal, 16)
                    }
                    .padding(.bottom, 4)
                    .disabled(acceptButtonDisabled)

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
