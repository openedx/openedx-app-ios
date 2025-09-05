//
//  NavigationAppearanceManager.swift
//  OpenEdX
//
//  Created by Rawan Matar on 28/05/2025.
//

import UIKit

public class NavigationAppearanceManager {
    @MainActor public static let shared = NavigationAppearanceManager()
    
    private init() {}

    public var navigationController: UINavigationController?

    @MainActor public func updateAppearance(backgroundColor: UIColor, titleColor: UIColor = .white) {
        guard let nav = navigationController else {
            return
        }
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = backgroundColor
        appearance.titleTextAttributes = [.foregroundColor: titleColor]
        appearance.largeTitleTextAttributes = [.foregroundColor: titleColor]

        nav.navigationBar.standardAppearance = appearance
        nav.navigationBar.scrollEdgeAppearance = appearance
        nav.navigationBar.tintColor = titleColor
        
    }
}
