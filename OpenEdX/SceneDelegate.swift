//
//  SceneDelegate.swift
//  OpenEdX
//

import UIKit
import Core
import Theme

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene,
              let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }

        let window = UIWindow(windowScene: windowScene)
        window.tintColor = Theme.UIColors.accentColor
        self.window = window

        // window.tintColor isn't live-bound to Theme.UIColors.accentColor -- it's a one-time
        // snapshot, so anything relying on the inherited tint (nav bars, back buttons, bar
        // button items) needs this to pick up a later instance switch/logout.
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(accentColorDidChange),
            name: .accentColorDidChange,
            object: nil
        )

        // Wait for the instance catalog before showing anything, so routing happens
        // against the real catalog, not the bundled placeholder. The Launch Screen stays up
        // for the wait -- makeKeyAndVisible() is what ends it, so no extra UI is needed.
        let urlContexts = connectionOptions.urlContexts
        Task {
            await appDelegate.loadInstanceCatalog()
            window.rootViewController = RouteController()
            window.makeKeyAndVisible()

            for context in urlContexts {
                appDelegate.handleOpenURL(context)
            }
        }
    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        for context in URLContexts {
            appDelegate.handleOpenURL(context)
        }
    }

    @objc private func accentColorDidChange() {
        window?.tintColor = Theme.UIColors.accentColor
    }
}
