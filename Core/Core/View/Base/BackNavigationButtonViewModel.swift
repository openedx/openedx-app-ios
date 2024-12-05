//
//  BackNavigationButtonViewModel.swift
//  Core
//
//  Created by Vadim Kuznetsov on 3.04.24.
//

import Swinject
import UIKit
import OEXFoundation

@MainActor
public protocol BackNavigationProtocol {
    func getBackMenuItems() -> [BackNavigationMenuItem]
    func navigateTo(item: BackNavigationMenuItem)
}

public struct BackNavigationMenuItem: Identifiable {
    public var id: Int
    public var title: String
    
    public init(id: Int, title: String) {
        self.id = id
        self.title = title
    }
}

@MainActor
class BackNavigationButtonViewModel: ObservableObject {
    private let helper: BackNavigationProtocol
    @Published var items: [BackNavigationMenuItem] = []
    
    init() {
        self.helper = Container.shared.resolve(BackNavigationProtocol.self)!
    }
    
    func loadItems() {
        self.items = helper.getBackMenuItems()
    }
    
    func navigateTo(item: BackNavigationMenuItem) {
        helper.navigateTo(item: item)
    }
}
