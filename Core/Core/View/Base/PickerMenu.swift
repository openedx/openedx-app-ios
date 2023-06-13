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
        if let selectedItem {
            self._selectedItem = State(initialValue: selectedItem)
        }
        self.selected = selected
    }
    
    public var body: some View {
        VStack {
            ZStack(alignment: .bottom) {
                    Color.black.opacity(0.4)
                        .onTapGesture(perform: {
                            router.dismiss(animated: true)
                        })
                    VStack {
                        VStack {
                            Text(titleText)
                                .foregroundColor(CoreAssets.textPrimary.swiftUIColor)
                            TextField(CoreLocalization.Picker.search, text: $search)
                                .padding(.all, 8)
                                .background(
                                    CoreAssets.textInputStroke.swiftUIColor
                                        .cornerRadius(6))
                            Picker("", selection: $selectedItem) {
                                let filteredItems = items
                                    .filter({ $0.value.contains(search) })
                                ForEach(filteredItems.count != 0 ? filteredItems : items,
                                        id: \.self) {
                                    Text($0.value)
                                        .foregroundColor(CoreAssets.textPrimary.swiftUIColor)
                                }
                            }.pickerStyle(.wheel)
                            
                        }.frame(minWidth: 0, maxWidth: idiom == .pad ? ipadPickerWidth : .infinity)
                            .padding()
                            .background(
                                CoreAssets.textInputBackground.swiftUIColor
                                    .cornerRadius(16)
                            ).padding(.horizontal, 16)
                        
                        Button(action: {
                            if items
                                .filter({ $0.value.contains(search) }).count == 1 {
                                selectedItem = items
                                    .filter({ $0.value.contains(search) })[0]
                            }
                                selected(selectedItem)
                            router.dismiss(animated: true)
                        }, label: {
                            Text(CoreLocalization.Picker.accept)
                                .foregroundColor(CoreAssets.textPrimary.swiftUIColor)
                                .frame(minWidth: 0, maxWidth: idiom == .pad ? ipadPickerWidth : .infinity)
                                .padding()
                                .background(
                                    CoreAssets.textInputBackground.swiftUIColor
                                        .cornerRadius(16)
                                ).padding(.horizontal, 16)
                        })
                        .padding(.bottom, 50)
                        
                    }.transition(.move(edge: .bottom))
            }
        }.transition(.opacity)
            .ignoresSafeArea()
    }
}
