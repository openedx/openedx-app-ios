//
//  SceneDelegate.swift
//  OpenEdX
//

import UIKit
import Theme

/// Owns the app's window. App-wide setup (DI, plugins, Firebase, push, deep-link services)
/// stays in `AppDelegate`; this class only covers what the UIScene life cycle moved off it.
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else { return }

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
            await AppDelegate.shared.instanceCatalogLoading?.value
            window.rootViewController = RouteController()
            window.makeKeyAndVisible()
            // A URL that cold-launched the app arrives here instead of openURLContexts.
            handle(urlContexts)
        }
    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        handle(URLContexts)
    }

    func resetToRoot() {
        window?.rootViewController = RouteController()
    }

    private func handle(_ urlContexts: Set<UIOpenURLContext>) {
        for context in urlContexts {
            var options: [UIApplication.OpenURLOptionsKey: Any] = [
                .openInPlace: context.options.openInPlace
            ]
            options[.sourceApplication] = context.options.sourceApplication
            options[.annotation] = context.options.annotation
            _ = AppDelegate.shared.handleOpenURL(context.url, options: options)
        }
    }

    @objc private func accentColorDidChange() {
        window?.tintColor = Theme.UIColors.accentColor
    }
}
